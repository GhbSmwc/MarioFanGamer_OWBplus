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
In an SNES screen, there can be up to 32 8x8 tiles per
line on a tilemap.
As such, there is kind of a linebreak at every 32nd tile.
Because of that, the formula for the tiles is (simplified)
(X + $20 * Y) * 2. If you want to get it from e.g.
position (30|4) then you get ($1E + $04 * $20) * 2
= ($1E + $80) * 2 = $9E * 2 = $13C.
For the bottom part, you have to add to Y the number of
bottom lines and then subract the value by 28 or $1C.
Fortunatelly, I have added a function which does the
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
Not really (unless you want to uploed them somewhere
else).
And I guess, RPG Hacker (who created the functions file)
wouldn't mind it either.

Why did you make this patch?
----------------------------------------------------------
It was a request by someone, hence why I made this.

I've got a question!
----------------------------------------------------------
Post it to the forums. In the worst case, you can PM me.

Is that really all?
----------------------------------------------------------
Since this patch uses RAM for the top and if desired the
bottom part of the the border, any codes which modifies
these parts should be thus adopted for this patch (I even
delebritely used the same NMI hijack as the overworld
counters, lol). One one side, this is mostly for practical
reasons. After all, why should one waste NMI time when
there is an alternative. :P
Another point for adopting the code is because of the
upload timing: The only tiles which ever gets updated are
these codes which runs after my hijack (stripe image for
example).
A similar case happened with the extended level names and
the extended extened version too. Both are unmodified
incompatible too but at least my patch includes the former
(or rather a recreation but what ever).

Changelog
----------------------------------------------------------
1.0 (C3 Winter 2017):
 - Initial release
 
1.1 (official release):
 - Added ability for a variable number of editable rows
 - Improvised tile function.