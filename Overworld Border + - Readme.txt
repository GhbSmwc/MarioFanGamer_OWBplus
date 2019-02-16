                      Extended Message Box
                        by MarioFanGamer
                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

What does this patch do?
----------------------------------------------------------
This one changes the overworld border by having the top
part and, if desired, the bottom part of the overworld
border tiles determined by RAM and not a fixed stripe
image.
Think of the status bar for example: All tiles, save for
the item box top and bottom, are saved in RAM and the
Super Status Bar goes further by making the properties
editable too!
This patch also enables to edit the border's properties.
The number of uploaded rows are variable too.

How do I get the tile number?
----------------------------------------------------------
Just like the Super Status bar patch, the data are stored
like this:

	!TileRAM+$00 : Top-leftmost tile number
	!TileRAM+$01 : Same as above but tile properties
	!TileRAM+$02 : Topmost, 2nd-leftmost tile number
	!TileRAM+$03 : Same as above but tile properties
	!TileRAM+$04 : Topmost, 3rd-leftmost tile number
	!TileRAM+$05 : Same as above but tile properties
	;...

In an SNES screen, there can be up to 32 8x8 tiles per
line on a tilemap. As such, there is kind of a linebreak
at every 32nd tile. Because of that, the formula for the
tiles is (simplified):

	RAM_Offset = [(X + ($20 * Y)) * 2]
	X is the X position ranging from 0-31 ($00-$1F)
	Y is the Y position ranging from 0 to [TotalLines-1].

after finding the offset, then you do this:

	RAM_DisiredTile = !TileRAM + RAM_Offset

NOTE: A number without a "$" prefix means decimal number.

Example: position (30,4) (hex: ($1E,$04)):
	!TileRAM = $7FEC00	;>If you haven't changed this RAM and
				; are using a non-sa-1 ROM.

	RAM_Offset = [($1E + ($20 * $04)) * 2]
	RAM_Offset = [($1E + $80) * 2]
	RAM_Offset = [($1E + $80) * 2]
	RAM_Offset = [$9E * 2]
	RAM_Offset = $13C

	RAM_DisiredTile = $7FEC00 + $13C
	RAM_DisiredTile = $7FED3C		;>Tile number address of (30,4)

	If you want to find the address that it is the tile
	properties (YXPCCCTT), add 1 to the address, in this
	case, its $7FED3D.

For the bottom part, the X position stays the same, but as
you move down the next line past the last line on the top,
you are now on the bottom section right after, as data for
the top and bottom are contiguous to another (no gaps in
between), here is an example:

	!Top_Lines = 5		;\If you didn't change the values the number of rows.
	!Bottom_Lines = 2	;/

	Row 0 (Top part) Y = $00
	Row 1 (Top part) Y = $01
	Row 2 (Top part) Y = $02
	Row 3 (Top part) Y = $03
	Row 4 (Top part) Y = $04

	Row 5 (Bottom part) Y = $1A
	Row 6 (Bottom part) Y = $1B
	
Notice that the row number doesn't skip over, but the Y value does.
This means you have to convert the Y position to a "row number of Y":

	RowNumber = Y - ($1A - TopLines)
	;Formula explanation: Get Y being the top row of the bottom down
	;to zero via $1A-$1A, then add by the number of top rows to be
	;at a location after the top row's final row.

Here is an example, I want to edit a tile on the bottom
left corner of the screen, this is position (0,27)
(hex: ($00,$1B)):
	!TileRAM = $7FEC00	;>If you haven't changed this RAM and
				; are using a non-sa-1 ROM.
	!Top_Lines = 5		;\If you didn't change the values the number of rows.
	!Bottom_Lines = 2	;/

	RowNumber = $1B - ($1A - $05)
	RowNumber = $1B - ($1A - $05)
	RowNumber = $1B - $15
	RowNumber = $06
	
	;After converting Y, do the same step you would do for the
	;top part:
	
	RAM_Offset = [($00 + ($20 * $06)) * 2]
	RAM_Offset = [($00 + $C0) * 2]
	RAM_Offset = [$C0 * 2]
	RAM_Offset = $180
	
	RAM_DisiredTile = $7FEC00 + $180
	RAM_DisiredTile = $7FED80
	
GHB made a javascript HTML file that auto-calculates
the needed information as a table without having to
re-calculate for every tile manually. This is useful
for debugging and when creating an ASM file using the
OW+ patch that doesn't use the function like most
ASM resources that write to the status bar
(!Define = $7FA000, instead of 2 defines for each X
and Y axis (!Define_X = $01, !Define_Y = $03)).

Fortunately, I have added a function which does the
calculations for your including getting the correct RAM
address.
You are free to use that (and shared.asm in the folder
"shared" for that matter, see below).
As noted in the functions file, you must disable floating
point numbers ("math round off", without quotes) to make
them work properly, else they output a 16-bit number
(floating point aside), not to mention that you sometimes
have to turn the "STA" into the "STA.l".

What about custom borders?
----------------------------------------------------------
My patch uploads the already existing tilemap to RAM so
you shouldn't worry about these. That includes the top and
the bottom half.

I want to disable the life counter
----------------------------------------------------------
You can disable them on Border_Defs.asm. The X is part of
the main border, though, and not covered by my patch.

What about Ladida's overworld counters?
----------------------------------------------------------
You can find them at this patch's thread.
Why it's seperate code? Err... *runs*

Help, I get screen glichtes?
----------------------------------------------------------
If there black scanlines then it is a NMI overflow.
To keep it short, updating VRAM (where graphics and
tilemap lies) is limited if outside of a black screen.
The more tiles you upload, the more likely an overflow
happens.
My patch uploads each half alternating (quasi 30FPS) to
dam the overflow but that still doesn't mean that it won't
happen.

If it isn't that, check if the glitched part are affected
to an HDMA code which runs at that time. That's once again
an NMI overflow in a different form.

If it is neither of these, be sure you have set up
everything correctly and please contact me per PM if you
are sure you made everything correctly and still get
glitches.

In case that the screen glitches but you can't see the
border, you can simply set !EnableUpload to any non-zero
value. That stops the border to upload tiles and saves a
couple NMI time.

GHB notes: you can disable the VRAM write by setting !EnableUpload
to any nonzero number during events that would upload other
tiles to the tilemap, since the OW border display is mainly
a "heads-up-display" status bar for the OW, and that information
presented (such as displaying coins, score, bonus stars) for
most ASM hacks don't continuously change during the OW map, thus
you can disable that during the expected NMI overflow.

Help, I can't insert it!
----------------------------------------------------------
As in an error message with the word "assertion"? That's
the point. It is literally a patch which you can't insert
and I don't regret making a such one.

Unless you have edited the level names at least once. The
patch hijacks the portion of Lunar Magic's level names.
They only get inserted when you make changes to the level
names, obviously.
Keep in mind that Lunar Magic only inserts specific ASM
hacks when you edit the appropriate stuff or do stuff
which weren't existant in the original game.
While LM inserts some ASM hacks when you save it, the
level names aren't part of it. You have to save them at
least once to make this patch work.
And no, you still have to do these steps when using the
extended level names (hooray for unnecessary
inspirations!).

Have you have done it everything by yourself?
----------------------------------------------------------
Main patch: Why shouldn't I?
Yes, the extended level names too. Even though inspired by
Smarthacker's version, I still made it from scratch.
The shared functions: Nope. That was created by
RPG Hacker.
Source: https://github.com/RPGHacker/SMW-Workspace/tree/master/patches/shared
</advertisement>

Do I must give you credits?
----------------------------------------------------------
Not really (unless you want to upload them somewhere
else).
And I guess, RPG Hacker (who created the functions file)
wouldn't mind it either.

Why did you make this patch?
----------------------------------------------------------
It was a request by someone (GreenHammerBro), hence why
I made this.

I've got a question!
----------------------------------------------------------
Post it to the forums. In the worst case, you can PM me.

Is that really all?
----------------------------------------------------------
Since this patch uses RAM for the top and if desired the
bottom part of the the border, any codes which modifies
these parts should be thus adopted for this patch (I even
deliberately used the same NMI hijack as the overworld
counters, lol). One one side, this is mostly for practical
reasons. After all, why should one waste NMI time when
there is an alternative. :P
Another point for adopting the code is because of the
upload timing: The only tiles which ever gets updated are
these codes which runs after my hijack (stripe image for
example).
A similar case happened with the extended level names and
the extended extended version too. Both are unmodified
incompatible too but at least my patch includes the former
(or rather a recreation but what ever).

Changelog
----------------------------------------------------------
1.0 (C3 Winter 2017):
 - Initial release
 
1.1 (official release):
 - Added ability for a variable number of editable rows
 - Improvised tile function.

1.2 (GHB's 2/16/2019 edit)
 - Added a conversion "sheet" via a HTML javascript code.
 - Readme edited for better understanding on some math parts.