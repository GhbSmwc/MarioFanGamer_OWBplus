@includefrom "Overworld_Border_Plus.asm"

if !Enable_Extended_Level_Names
freedata

table table.txt

; The level names are all the same width as without this patch,
; only the height has been doubled.
; Because of that, each line is consitent of 19 characters and such looks like this:
;	db "1234567890123456789"
;	db "1234567890123456789"
; Make sure that there are always at least 38 characters, else the names gets messed up.
;
; Special characters have to be entered directly in hex ($xx where xx is the tile number)
; and they cannot stand in quotes.
; For example db $38,$39,$3A,$3B,$3C," SWITCH PALACE" equals to "YELLOW SWITCH PALACE"
; Also, no funny names like original the extended level names had these, sorry. :(
;
; Big fat note: You still have to edit the level names in LM once to get the patch work.

Level_Names:
;Level 000
db "                   "
db "                   "
;Level 001
db "                   "
db "VANILLA SECRET 2   "
;Level 002
db "                   "
db "VANILLA SECRET 3   "
;Level 003
db "                   "
db "TOP SECRET AREA    "
;Level 004
db "                   "
db "DONUT GHOST HOUSE  "
;Level 005
db "                   "
db "DONUT PLAINS 3     "
;Level 006
db "                   "
db "DONUT PLAINS 4     "
;Level 007
db "                   "
db "#2 MORTON'S CASTLE "
;Level 008
db "                   "
db "GREEN SWITCH PALACE"
;Level 009
db "                   "
db "DONUT PLAINS 2     "
;Level 00A
db "                   "
db "DONUT SECRET 1     "
;Level 00B
db "                   "
db "VANILLA FORTRESS   "
;Level 00C
db "                   "
db "BUTTER BRIDGE 1    "
;Level 00D
db "                   "
db "BUTTER BRIDGE 2    "
;Level 00E
db "                   "
db "#4 LUDWIG'S CASTLE "
;Level 00F
db "                   "
db "CHEESE BRIDGE AREA "
;Level 010
db "                   "
db "COOKIE MOUNTAIN    "
;Level 011
db "                   "
db "SODA LAKE          "
;Level 012
db "                   "
db "STAR ROAD          "
;Level 013
db "                   "
db "DONUT SECRET HOUSE "
;Level 014
db "                   "
db $38,$39,$3A,$3B,$3C," SWITCH PALACE"
;Level 015
db "                   "
db "DONUT PLAINS 1     "
;Level 016
db "                   "
db "STAR ROAD          "
;Level 017
db "                   "
db "#2 MORTON'S PLAINS "
;Level 018
db "                   "
db "SUNKEN GHOST SHIP  "
;Level 019
db "                   "
db "#2 MORTON'S PLAINS "
;Level 01A
db "                   "
db "#6 WENDY'S CASTLE  "
;Level 01B
db "                   "
db "CHOCOLATE FORTRESS "
;Level 01C
db "                   "
db "CHOCOLATE ISLAND 5 "
;Level 01D
db "                   "
db "CHOCOLATE ISLAND 4 "
;Level 01E
db "                   "
db "STAR ROAD          "
;Level 01F
db "                   "
db "FOREST FORTRESS    "
;Level 020
db "                   "
db "#5 ROY'S CASTLE    "
;Level 021
db "                   "
db "CHOCO-GHOST HOUSE  "
;Level 022
db "                   "
db "CHOCOLATE ISLAND 1 "
;Level 023
db "                   "
db "CHOCOLATE ISLAND 3 "
;Level 024
db "                   "
db "CHOCOLATE ISLAND 2 "
;Level 101
db "                   "
db "#1 IGGY'S CASTLE   "
;Level 102
db "                   "
db "YOSHI'S ISLAND 4   "
;Level 103
db "                   "
db "YOSHI'S ISLAND 3   "
;Level 104
db "                   "
db "YOSHI'S HOUSE      "
;Level 105
db "                   "
db "YOSHI'S ISLAND 1   "
;Level 106
db "                   "
db "YOSHI'S ISLAND 2   "
;Level 107
db "                   "
db "VANILLA GHOST HOUSE"
;Level 108
db "                   "
db "STAR ROAD          "
;Level 109
db "                   "
db "VANILLA SECRET 1   "
;Level 10A
db "                   "
db "VANILLA DOME 3     "
;Level 10B
db "                   "
db "DONUT SECRET 2     "
;Level 10C
db "                   "
db "STAR ROAD          "
;Level 10D
db "                   "
db "FRONT DOOR         "
;Level 10E
db "                   "
db "BACK DOOR          "
;Level 10F
db "                   "
db "VALLEY OF BOWSER 4 "
;Level 110
db "                   "
db "#7 LARRY'S CASTLE  "
;Level 111
db "                   "
db "VALLEY FORTRESS    "
;Level 112
db "                   "
db "                   "
;Level 113
db "                   "
db "VALLEY OF BOWSER 3 "
;Level 114
db "                   "
db "VALLEY GHOST HOUSE "
;Level 115
db "                   "
db "VALLEY OF BOWSER 2 "
;Level 116
db "                   "
db "VALLEY OF BOWSER 1 "
;Level 117
db "                   "
db "CHOCOLATE SECRET   "
;Level 118
db "                   "
db "VANILLA DOME 3     "
;Level 119
db "                   "
db "VANILLA DOME 4     "
;Level 11A
db "                   "
db "VANILLA DOME 1     "
;Level 11B
db "                   "
db "RED SWITCH PALACE  "
;Level 11C
db "                   "
db "#3 LEMMY'S CASTLE  "
;Level 11D
db "                   "
db "FOREST GHOST HOUSE "
;Level 11E
db "                   "
db "FOREST OF",$32,$33,$34,$35,$36,$37,"ON 1"
;Level 11F
db "                   "
db "FOREST OF",$32,$33,$34,$35,$36,$37,"ON 4"
;Level 120
db "                   "
db "FOREST OF",$32,$33,$34,$35,$36,$37,"ON 2"
;Level 121
db "                   "
db "BLUE SWITCH PALACE "
;Level 122
db "                   "
db "FOREST SECRET AREA "
;Level 123
db "                   "
db "FOREST OF",$32,$33,$34,$35,$36,$37,"ON 3"
;Level 124
db "                   "
db "STAR ROAD          "
;Level 125
db "                   "
db "FUNKY              "
;Level 126
db "                   "
db "OUTRAGEOUS         "
;Level 127
db "                   "
db "MONDO              "
;Level 128
db "                   "
db "GROOVY             "
;Level 129
db "                   "
db "STAR ROAD          "
;Level 12A
db "                   "
db "GNARLY             "
;Level 12B
db "                   "
db "TUBULAR            "
;Level 12C
db "                   "
db "WAY COOL           "
;Level 12D
db "                   "
db "AWESOME            "
;Level 12E
db "                   "
db "STAR ROAD          "
;Level 12F
db "                   "
db "STAR ROAD          "
;Level 130
db "                   "
db "STAR WORLD 2       "
;Level 131
db "                   "
db "STAR ROAD          "
;Level 132
db "                   "
db "STAR WORLD 3       "
;Level 133
db "                   "
db "STAR ROAD          "
;Level 134
db "                   "
db "STAR WORLD 1       "
;Level 135
db "                   "
db "STAR WORLD 4       "
;Level 136
db "                   "
db "STAR WORLD 5       "
;Level 137
db "                   "
db "STAR ROAD          "
;Level 138
db "                   "
db "STAR ROAD          "
;Level 139
db "                   "
db "                   "
;Level 13A
db "                   "
db "                   "
;Level 13B
db "                   "
db "                   "
endif