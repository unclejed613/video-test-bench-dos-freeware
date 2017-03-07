
REM $INCLUDE: 'qlib58a.bi'
REM $INCLUDE: 'qb.bi'

REM CLEAR , , 6000

'there were several naming conventions i used while writing the subroutines
'in this program some began with V, X8, or X10 which denote VGA, 800x600
'or 1024x768. these were routines i wrote later. routines with XH in the name
'are crosshatch patterns, CB for color bars, FOC for focus, PUR for purity,
'and several others. routine names ending with CGA, EGA, or with MONO or HERC
'in the name are for the various TTL modes. since this program was written
'over the span of several years, the routine naming conventions varied a
'bit, so may not seem consistent at times. this program began as a series
'of separate BASIC programs to test various functions in monitors. eventually
'i began changing the separate programs into subroutines called by a menu.
' the spaghetti code got quite long and confusing, so i began cutting and
'pasting subroutines into a set of external modules and compiling them
'into a library. i told a service manual supplier what i was doing after
'they asked me if i wanted to buy a $3000.00 test pattern generator.
'it was about this time Trident released their multifunction VGA card
'that also had mono,CGA and EGA outputs, and was configurable by a DIP
'switch. the service manual supplier asked me if i had considered selling
'my software package, and if i could send them a demo. i compiled all of
'the code into a single executable, and made a demo copy which only allowed
'a selected test pattern on the screen for about 20 seconds and sent it to them.
'they began buying copies of VTB and packaging it with Trident cards. then
'another company got wind of it, and wanted to sell the software and card
' as part of an integrated package along with their parts search, service
'database, and service manual lookup software. within a few years we had
'all made some money from the idea, but suddenly the cost of new VGA and
'SVGA monitors dropped from an average of $300-500 to $100-150. this
'happened within the space of two or three months, and the bottom fell out
'of the monitor repair business. i had to find something else to do other
'than repairing monitors and developing test pattern software. fast forward
'to 2010 and questions asked in internet forums about how to repair
'CRT monitors and if there were any way of generating test patterns.
'i decided to release VTB as freeware. fortunately i still have all of
'the code and copies of the Qbasic 4.5 i compiled it with.

'so enough about the history of VTB... let's get coding...
'my notes are sparse, as i didn't keep notes when i wrote VTB but relied on
'the subroutine names to keep straight what they did, and i am only
'now adding the notes.

'main menu intro screen
SCREEN 0
COLOR 15, 1
CLS
COLOR 15, 7
LOCATE 9, 30
PRINT "ษออออออออออออออออออออป"
LOCATE 10, 30
PRINT "บ  VIDEO TEST BENCH  บ"
LOCATE 11, 30
PRINT "บ        V4.5F       บ"
LOCATE 12, 30
PRINT "บ    FREEWARE COPY   บ"
LOCATE 13, 30
PRINT "บ                    บ"
LOCATE 14, 30
PRINT "บ                    บ"
LOCATE 15, 30
PRINT "บ      (c) 2011      บ"
LOCATE 16, 30
PRINT "บ  WARREN C. MARTIN  บ";
LOCATE 17, 30
PRINT "ศออออออออออออออออออออผ"
SLEEP 5

CardTst:
'figure out which video card is installed
ON ERROR GOTO Whoa
DEF SEG = 0
vid1 = PEEK(1123) + 256 * PEEK(1124)
vid2 = PEEK(1159)
DIM reg AS RegType
reg.ax = &H1A00
CALL INTERRUPT(&H10, reg, reg)
vid3 = reg.bx AND &HFF
'read bios video card ID and branch to whatever
'menu matches the installed card
IF vid1 = 948 THEN GOTO MonoMenu
IF vid1 = 980 AND vid2 = 0 THEN GOTO CgaMenu
IF vid1 = 980 AND vid2 = 96 AND vid3 = 0 THEN GOTO EgaMenu
IF vid1 = 980 AND vid2 = 96 AND vid3 = 8 THEN GOTO VgaMenu

MainMenu:
'if card test doesnt match anything default to main menu
SCREEN 0
COLOR 15, 1
c$ = ""
k$ = ""
CLS
PRINT "VIDEO TEST BENCH V 4.5F ---VTB FREEWARE INC. "
COLOR 15, 7
LOCATE 10, 32
PRINT "ษออออออออออออออป"
LOCATE 11, 32
PRINT "บ 1> CGA MENU  บ";
LOCATE 12, 32
PRINT "บ 2> EGA MENU  บ";
LOCATE 13, 32
PRINT "บ 3> VGA MENU  บ";
LOCATE 14, 32
PRINT "บ 4> MONO MENU บ";
LOCATE 15, 32
PRINT "บ 5> HELP      บ";
LOCATE 16, 32
PRINT "บ 0> EXIT      บ";
LOCATE 17, 32
PRINT "ศออออออออออออออผ";
DO WHILE k$ = ""
k$ = INKEY$
LOOP
ON VAL(k$) GOTO CgaMenu, EgaMenu, VgaMenu, MonoMenu, Help
IF k$ = CHR$(27) OR k$ = "0" THEN GOTO ExitMenu ELSE GOTO MainMenu
GOTO MainMenu

CgaMenu:
'if a cga card was detected we land here
SCREEN 0
WIDTH 80
COLOR 15, 2
CLS
PRINT "VIDEO TEST BENCH V 4.5F ---CGA MENU"
COLOR 15, 7
k$ = ""
LOCATE 7, 29
PRINT "ษอออออออออออออออออออออออป";
LOCATE 8, 29
PRINT "บ  1> COLOR BARS        บ";
LOCATE 9, 29
PRINT "บ  2> CENTERING         บ";
LOCATE 10, 29
PRINT "บ  3> HV REGULATION     บ";
LOCATE 11, 29
PRINT "บ  4> CROSSHATCH        บ";
LOCATE 12, 29
PRINT "บ  5> FOCUS             บ";
LOCATE 13, 29
PRINT "บ  6> PURITY            บ";
LOCATE 14, 29
PRINT "บ  7> MULTIBURST        บ";
LOCATE 15, 29
PRINT "บ  8> LUMINANCE WINDOW  บ";
LOCATE 16, 29
PRINT "บ  9> COLOR BALANCE     บ";
LOCATE 17, 29
PRINT "บ  A> CGA TEST LOOP     บ";
LOCATE 18, 29
PRINT "บ  B> HELP SCREEN       บ";
LOCATE 19, 29
PRINT "บ  0> EXIT              บ";
LOCATE 20, 29
PRINT "ศอออออออออออออออออออออออผ";
k$ = ""
c$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB ColorBarCga, CenCga, BalCga, XhCga, FocCga, Pur, MultCga, LumCga, Cbal1
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO MainMenu
IF c$ = "A" OR c$ = "a" THEN GOSUB Cloop
IF c$ = "B" OR c$ = "b" THEN GOTO Help
c$ = ""
GOTO CgaMenu


EgaMenu:
'if an ega card was detected we land here
SCREEN 0
WIDTH 80
COLOR 15, 5
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- EGA MENU"
COLOR 15, 7
k$ = ""
LOCATE 7, 29
PRINT "ษออออออออออออออออออออป";
LOCATE 8, 29
PRINT "บ  1> COLOR BARS     บ";
LOCATE 9, 29
PRINT "บ  2> MODE SWITCH    บ";
LOCATE 10, 29
PRINT "บ  3> CROSSHATCH     บ";
LOCATE 11, 29
PRINT "บ  4> FOCUS          บ";
LOCATE 12, 29
PRINT "บ  5> MULTIBURST     บ";
LOCATE 13, 29
PRINT "บ  6> RGBI PATTERN   บ";
LOCATE 14, 29
PRINT "บ  7> PURITY         บ";
LOCATE 15, 29
PRINT "บ  8> EGA TEST LOOP  บ";
LOCATE 16, 29
PRINT "บ  9> HELP SCREEN    บ"
LOCATE 17, 29
PRINT "ศออออออออออออออออออออผ";
c$ = ""
k$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB EColrBar, Emode, Exh, Efoc, Emult, Ergbi, Pur2, Eloop, Help
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO MainMenu
c$ = ""
GOTO EgaMenu

VgaMenu:
'if a vga card was detected we land here
SCREEN 0
WIDTH 80
COLOR 1, 15
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- VGA MENU"
c$ = ""
COLOR 15, 7
k$ = ""
LOCATE 9, 27
PRINT "ษออออออออออออออออออออออออป";
LOCATE 10, 27
PRINT "บ  1> COLOR BAR MENU     บ";
LOCATE 11, 27
PRINT "บ  2> CROSSHATCH MENU    บ";
LOCATE 12, 27
PRINT "บ  3> MISC ADJ MENU      บ";
LOCATE 13, 27
PRINT "บ  4> VGA UTILITIES MENU บ";
LOCATE 14, 27
PRINT "บ  5> SVGA MENU          บ";
LOCATE 15, 27
PRINT "บ  6> HELP SCREEN        บ";
LOCATE 16, 27
PRINT "บ  0> EXIT               บ";
LOCATE 17, 27
PRINT "ศออออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOTO VbarM, VxhM, VmiscM, VutilM, SvgaM, Help
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO MainMenu
c$ = ""
GOTO VgaMenu


MonoMenu:
'if a mono or herc card was detected we land here
SCREEN 0
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- MONO MENU"
PRINT "PLEASE BE SURE YOU HAVE LOADED QBHERC.COM BEFORE USING THESE PATTERNS"
LOCATE 8, 27
PRINT "ษอออออออออออออออออออออออป";
LOCATE 9, 27
PRINT "บ  1> FOCUS             บ";
LOCATE 10, 27
PRINT "บ  2> CROSSHATCH        บ";
LOCATE 11, 27
PRINT "บ  3> MULTIBURST        บ";
LOCATE 12, 27
PRINT "บ  4> BRIGHT SCREEN     บ";
LOCATE 13, 27
PRINT "บ  5> SPLIT SCREEN      บ";
LOCATE 14, 27
PRINT "บ  6> TEXT              บ";
LOCATE 15, 27
PRINT "บ  7> MONO TEST LOOP    บ";
LOCATE 16, 27
PRINT "บ  0> EXIT              บ";
LOCATE 17, 27
PRINT "ศอออออออออออออออออออออออผ";
k$ = ""
k$ = ""
c$ = ""
c$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB Hefoc, Hexh, Hemult, Hescr, ColorBarCga, Montxt, Mloop
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO MainMenu
GOTO MonoMenu

VbarM:
'most of the vga subs begin with V

c$ = ""
SCREEN 0
WIDTH 80
COLOR 1, 15
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- VGA COLORBAR MENU"
COLOR 15, 1
LOCATE 8, 27
PRINT "ษอออออออออออออออออออออออออออป";
LOCATE 9, 27
PRINT "บ  1> 15 COLOR              บ";
LOCATE 10, 27
PRINT "บ  2> 256 COLOR             บ";
LOCATE 11, 27
PRINT "บ  3> IRGB SCALE            บ";
LOCATE 12, 27
PRINT "บ  4> SATURATED COLORS      บ";
LOCATE 13, 27
PRINT "บ  5> 480 LINE BARS         บ";
LOCATE 14, 27
PRINT "บ  6> NTSC BARS             บ";
LOCATE 15, 27
PRINT "บ  7> COMBINED BARS         บ";
LOCATE 16, 27
PRINT "บ  8> 16 STEP GREY SCALE    บ";
LOCATE 17, 27
PRINT "บ  9> 64 STEP GREY SCALE    บ";
LOCATE 18, 27
PRINT "บ  A> RGB STRIPES           บ";
LOCATE 19, 27
PRINT "บ  B> GREY SCALE REFERENCE  บ";
LOCATE 20, 27
PRINT "บ  0> EXIT TO VGA MENU      บ";
LOCATE 21, 27
PRINT "ศอออออออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB Fcol, FFcol, Vrgbi, Vsat, V480, Vntsc, Vcomb, Vgrey, V64
IF c$ = "a" OR c$ = "A" THEN GOSUB Rgbs
IF c$ = "b" OR c$ = "B" THEN GOSUB Grybox
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO VgaMenu
c$ = ""
GOTO VbarM

VxhM:
SCREEN 0
WIDTH 80
COLOR 1, 15
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- VGA CROSSHATCH MENU"
COLOR 15, 2
c$ = ""
LOCATE 8, 27
PRINT "ษอออออออออออออออออออออออออออป";
LOCATE 9, 27
PRINT "บ  1> 350 LINE              บ"
LOCATE 10, 27
PRINT "บ  2> 400 LINE              บ";
LOCATE 11, 27
PRINT "บ  3> 480 LINE              บ";
LOCATE 12, 27
PRINT "บ  4> CENTERING             บ";
LOCATE 13, 27
PRINT "บ  5> 400 LINE SPECIAL      บ";
LOCATE 14, 27
PRINT "บ  6> COLOR GRID            บ";
LOCATE 15, 27
PRINT "บ  0> EXIT                  บ";
LOCATE 16, 27
PRINT "ศอออออออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB X350V, X400V, X480V, Vctr, S400, Cgrid
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO VgaMenu
c$ = ""
GOTO VxhM


VmiscM:
c$ = ""
SCREEN 0
WIDTH 80
COLOR 1, 15
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- VGA MISCELLANEOUS MENU"
COLOR 15, 3
LOCATE 5, 25
PRINT "ษอออออออออออออออออออออออออออป";
LOCATE 6, 25
PRINT "บ  1> MULTIBURST            บ";
LOCATE 7, 25
PRINT "บ  2> PURITY                บ";
LOCATE 8, 25
PRINT "บ  3> HVREG                 บ";
LOCATE 9, 25
PRINT "บ  4> COLOR BALANCE         บ";
LOCATE 10, 25
PRINT "บ  5> TEXT                  บ";
LOCATE 11, 25
PRINT "บ  6> COLOR CONTRAST        บ";
LOCATE 12, 25
PRINT "บ  7> VGA FOCUS             บ";
LOCATE 21, 25
PRINT "บ  0> EXIT                  บ";
LOCATE 13, 25
PRINT "บ  8> ANALOG ECHO           บ";
LOCATE 14, 25
PRINT "บ  9> VID AMP OVERLOAD      บ";
LOCATE 15, 25
PRINT "บ  A> VGA FOCUS #2          บ";
LOCATE 16, 25
PRINT "บ  B> VGA FOCUS #3          บ";
LOCATE 17, 25
PRINT "บ  C> DYNAMIC HV REG        บ";
LOCATE 18, 25
PRINT "บ  D> STANDARD LUM WINDOWS  บ";
LOCATE 19, 25
PRINT "บ  E> CENTERING CROSSHAIRS  บ";
LOCATE 20, 25
PRINT "บ  F> PHOSPHOR IONIZATION   บ";
LOCATE 22, 25
PRINT "ศอออออออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB Vmult, Pur2, BalCga, Vbal, Vtxt, Vcc, Vfoc, Echo, Smear
IF c$ = "A" OR c$ = "a" THEN GOSUB Foc2
IF c$ = "B" OR c$ = "b" THEN GOSUB Foc3

IF c$ = "C" OR c$ = "c" THEN GOSUB Dynhv
IF c$ = "D" OR c$ = "d" THEN GOSUB Lumwin
IF c$ = "E" OR c$ = "e" THEN GOSUB Vctr2
IF c$ = "F" OR c$ = "f" THEN GOSUB Phos1
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO VgaMenu
c$ = ""
GOTO VmiscM


VutilM:
k$ = ""
c$ = ""
SCREEN 0
WIDTH 80
COLOR 1, 15
CLS
PRINT "VIDEO TEST BENCH V 4.5F --- VGA UTILITIES MENU"
COLOR 15, 4
LOCATE 9, 28
PRINT "ษออออออออออออออออออออออป";
LOCATE 10, 28
PRINT "บ  1> VGA TEST LOOP    บ";
LOCATE 11, 28
PRINT "บ  2> MODE SWITCHING   บ";
LOCATE 12, 28
PRINT "บ  0> EXIT             บ";
LOCATE 13, 28
PRINT "ศออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
ON VAL(c$) GOSUB Vloop, Vmode
IF c$ = "0" OR c$ = CHR$(27) THEN GOTO VgaMenu
c$ = ""
GOTO VutilM

SvgaM:
SCREEN 0
COLOR 15, 1
CLS
PRINT "VTB FREEWARE - SVGA MENU"
CALL XModeClear
COLOR 9, 15
c$ = ""
LOCATE 6, 25
PRINT "ษอออออออออออออออออออออออออออออป";
LOCATE 7, 25
PRINT "บ 1> 800x600 crosshatch       บ";
LOCATE 8, 25
PRINT "บ 2> 800x600 multiburst       บ";
LOCATE 9, 25
PRINT "บ 3> 800x600 focus            บ";
LOCATE 10, 25
PRINT "บ 4> 800x600 focus #2         บ";
LOCATE 12, 25
PRINT "บ 6> mode 13a color palette   บ"
LOCATE 11, 25
PRINT "บ 5> 800x600 text             บ";
COLOR 9, 8
LOCATE 13, 25
PRINT "บ 7> 1024x768 crosshatch      บ";
LOCATE 14, 25
PRINT "บ 8> 1024x768 multiburst      บ";
LOCATE 15, 25
PRINT "บ 9> 1024x768 focus #1        บ";
LOCATE 16, 25
PRINT "บ A> 1024x768 focus #2        บ";
LOCATE 17, 25
PRINT "บ B> 1024x768 text            บ";
LOCATE 18, 25
PRINT "บ 0> exit                     บ";
LOCATE 19, 25
PRINT "ศอออออออออออออออออออออออออออออผ";
DO WHILE c$ = ""
c$ = INKEY$
LOOP
'most of the svga subs are identified with X8 for 800x600
'and X10 for 1024x768

IF c$ = "1" THEN GOTO X8xh
IF c$ = "2" THEN GOTO X8mult
IF c$ = "3" THEN GOTO X8foc
IF c$ = "4" THEN GOTO X8foc2
IF c$ = "5" THEN GOTO X8txt
IF c$ = "6" THEN GOTO X813p
IF c$ = "7" THEN GOTO X10xh
IF c$ = "8" THEN GOTO X10mult
IF c$ = "9" THEN GOTO X10foc1
IF c$ = "a" OR c$ = "A" THEN GOTO X10foc2
IF c$ = "b" OR c$ = "B" THEN GOTO X10txt

IF c$ = CHR$(27) OR c$ = "0" THEN GOTO VgaMenu
c$ = ""
GOTO SvgaM

ExitMenu:
c$ = ""
k$ = ""
SCREEN 0
COLOR 15, 4
CLS
PRINT "DO YOU WANT TO EXIT? Y/N"
DO WHILE c$ = ""
c$ = INKEY$
LOOP
IF c$ = "Y" OR c$ = "y" THEN GOTO Gone ELSE GOTO MainMenu

Help:

'tell the user what keys do what in certain test patterns

SCREEN 0
WIDTH 80
COLOR 15, 1
CLS
PRINT "HELP FILE"
PRINT "COMMAND KEYS FOR CROSSHATCH PATTERNS"
PRINT "   (R) FOR RED LINES     (G) FOR GREEN LINES"
PRINT "   (B) FOR BLUE LINES    (M) FOR MAGENTA LINES"
PRINT "   (C) FOR CYAN LINES    (Y) FOR YELLOW LINES"
PRINT "   (W) FOR WHITE LINES   (Z) FOR REVERSE VIDEO (W FOR NORMAL VIDEO)"
PRINT "   (ESC) TO EXIT"
PRINT " USE R,G,B, AND W FOR PURITY TEST COLORS"
PRINT
PRINT "VGA COLOR BALANCE WINDOW COMMANDS:"
PRINT "   COLORS ARE CONTINUOUSLY VARIABLE WITH INDICATORS SHOWN IN "
PRINT "   UPPER LEFT CORNER OF THE SCREEN."
PRINT "  (E) DECREASES RED       (R) INCREASES RED      (ESC) TO EXIT"
PRINT "  (F) DECREASED GREEN     (G) INCREASES GREEN"
PRINT "  (V) DECREASES BLUE      (B) INCREASES BLUE"
PRINT
PRINT "VGA UTILITIES- THESE TWO PROGRAMS ARE LOOPS, PRESS ANY KEY AND WAIT"
PRINT "FOR END OF LOOP TO EXIT."
PRINT "**SVGA MODES** SEE DOCUMENTATION UPDATE FOR COMPATIBLE CHIPSET LIST"
PRINT " SVGA TEST PATTERNS WILL WORK WITH MOST VIDEO CARDS WITH 1MEG OF MEMORY"
PRINT " INCLUDING VESA STANDARD CARDS, HOWEVER A CARD PROGRAMMED BY JUMPER OR"
PRINT " DIP SWITCHES IS PREFERRED BECAUSE THERE ARE SO MANY DIFFERENT SVGA SYNC"
PRINT " STANDARDS IN USE (FOR 800x600 AND 1024x768 THERE ARE AT LEAST 3 OF EACH)"
DO WHILE INKEY$ = ""
LOOP
k$ = ""
c$ = ""
GOTO MainMenu

ColorBarCga:
'most of the cga routines end with cga in the name
CALL Cbcga
RETURN

CenCga:
CALL Centcga
RETURN

BalCga:
CALL Balacga
RETURN

XhCga:
'xh.bas wcm feb 93
CALL Xh1cga
RETURN

FocCga:
CALL Focuscga
RETURN

Pur:
CALL Purcga
RETURN

MultCga:
CALL Multicga
RETURN

LumCga:
CALL Lumicga
RETURN


EColrBar:

CALL Cbega
RETURN

Emode:

CALL Modeega
RETURN

Exh:
'xh designates crosshatch patterns
'most of the ega routines begin with E or end with ega
CALL Xh1ega
RETURN

Efoc:
CALL Focusega
RETURN

Emult:
CALL Multiega
RETURN

Ergbi:
'red green blue and white fade scales
SCREEN 9
FOR x = 0 TO 639 STEP 40
Z = INT(x / 40)
PALETTE Z, 0
LINE (x, 0)-(x + 40, 174), Z, BF
LINE (639 - x, 175)-((329 - x) + 40, 349), Z, BF
NEXT x
FOR x = 0 TO 15
READ y
PALETTE x, y
NEXT x
DATA 0,56,7,63,0,8,1,9,0,16,2,18,0,32,4,36
DO WHILE INKEY$ = ""
LOOP
RESTORE
SCREEN 0
CLS

RETURN

Fcol:
CALL Vfcolr
RETURN

FFcol:
CALL Vffcolr
RETURN

Vrgbi:


CALL Vgargbi
RETURN

Vsat:
CALL Vgasat
RETURN

V480:
CALL Cb480
RETURN

Vntsc:
CALL Vgantsc
RETURN

Vcomb:
CALL Vgacombo
RETURN

Vgrey:
CALL Vgrey16
RETURN

V64:
CALL Vgrey64
RETURN
X350V:
GOSUB Exh
RETURN

X400V:
'crosshatch 400 line vga
CALL Vga13x(2)
CALL ClearView
CALL GraphColor(15)
FOR x% = 0 TO 800
xa% = INT(25 * (SIN(x%)))
ya% = INT(45 * (COS(x%)))
xb% = INT(50 * (SIN(x%)))
yb% = INT(90 * (COS(x%)))
xc% = INT(100 * (SIN(x%)))
yc% = INT(180 * (COS(x%)))
CALL PutDot(xa% + 160, ya% + 200, 1)
CALL PutDot(xb% + 160, yb% + 200, 1)
CALL PutDot(xc% + 160, yc% + 200, 1)
NEXT x%
FOR x% = 0 TO 319 STEP 20
CALL DrawLine(x%, 0, x%, 399, 1)
NEXT x%
FOR x% = 0 TO 360 STEP 40
CALL DrawLine(0, x%, 319, x%, 1)
NEXT x%
CALL DrawBox(0, 0, 319, 399, 1)
r& = Color256(63, 0, 0)
g& = Color256(0, 63, 0)
b& = Color256(0, 0, 63)
m& = Color256(63, 0, 63)
c& = Color256(0, 63, 63)
y& = Color256(63, 63, 0)
w& = Color256(63, 63, 63)
k& = Color256(0, 0, 0)
colx:
c$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
IF c$ = "r" OR c$ = "R" THEN GOTO r400
IF c$ = "g" OR c$ = "G" THEN GOTO g400
IF c$ = "b" OR c$ = "B" THEN GOTO b400
IF c$ = "m" OR c$ = "M" THEN GOTO m400
IF c$ = "c" OR c$ = "C" THEN GOTO c400
IF c$ = "y" OR c$ = "Y" THEN GOTO y400
IF c$ = "z" OR c$ = "Z" THEN GOTO z400
IF c$ = "w" OR c$ = "W" THEN GOTO w400
IF c$ = CHR$(27) THEN GOTO bye400
GOTO colx
bye400:
a = ModeColor
CALL XModeClear
GOTO VxhM
r400:
CALL Palette256(15, r&)
GOTO colx
g400:
CALL Palette256(15, g&)
GOTO colx
b400:
CALL Palette256(15, b&)
GOTO colx
m400:
CALL Palette256(15, m&)
GOTO colx
c400:
CALL Palette256(15, c&)
GOTO colx
y400:
CALL Palette256(15, y&)
GOTO colx
w400:
CALL Palette256(15, w&)
CALL Palette256(0, k&)
GOTO colx
z400:
CALL Palette256(15, k&)
CALL Palette256(0, w&)
GOTO colx

X480V:

CALL Vxh1
RETURN

Vctr:
CALL Vgactr
RETURN

S400:
GOTO S400A
S400B:
RETURN

Cgrid:
CALL Vgacnv
RETURN

Vmult:
CALL Vgamulti

RETURN

Vpur:
GOTO Pur

Vbal:
CALL Vgacbal


RETURN

Vtxt:
CALL Vgatext

RETURN

Vcc:
CALL Vgacc
RETURN

Vfoc:
CALL Vgafoc
RETURN

Vloop:
CALL Vgaloop1
RETURN

Vmode:
CALL Vgamode1
RETURN
Gone:
'exit screen with release info and a basic freeware statement
SCREEN 0
CLS
PRINT "VIDEO TEST BENCH V 4.5F (C) 2011 BY WARREN C. MARTIN"
PRINT "                                                "
PRINT "RELEASED AS FREEWARE 01FEB10 BUGFIX 04JUL11"
PRINT "DISTRIBUTION UNLIMITED"
PRINT "PERMISSION GRANTED FOR PRIVATE AND COMMERCIAL USE"
PRINT "FOR THE TESTING AND TROUBLESHOOTING OF VIDEO "
PRINT "MONITORS AND PROJECTORS"
PRINT " "
PRINT "FOR ANY QUESTIONS EMAIL unclejed613c@yahoo.com"
PRINT "SOFTWARE OPERATES ON ANY MICROSOFT VERSION OF DOS (UP TO WIN98'S DOS)"
PRINT "AS WELL AS FREEDOS AND DOSBOX"


SYSTEM

CgaWarn:
'if a cga card is installed and you try using ega or vga
'modes you can crash the program or fry the FBT in the monitor
BEEP
LOCATE 10, 1
COLOR 15, 4
PRINT "WARNING!!! CGA CARD INSTALLED-DO NOT USE EGA OR VGA MODES!"
RETURN
Echo:
CALL Vgaecho
RETURN
Cbal1:
CALL Cgabalan
RETURN
Smear:
CALL Vgavidov

RETURN

Foc2:
CALL Vgafoc2
RETURN

Foc3:
CALL Vgafoc3
RETURN
Dynhv:
CALL Dynhvreg
RETURN
Lumwin:
CALL Vgalumi
RETURN

Vctr2:
CALL Vgactr2
RETURN

Hefoc:
CALL Hgcfoc
RETURN

Hexh:
CALL Hgcxh1
RETURN

Hemult:
CALL Hgcmulti
RETURN

Hescr:
CALL Hgcscr
RETURN

Montxt:
CALL Hgctxt
RETURN

Phos1:
CALL Beamcur
RETURN

Herand:
RETURN

Rgbs:
CALL Rgbstrip
RETURN

Cloop:
CALL Cgaloop1
RETURN

Eloop:
CALL egaloop1
RETURN


Mloop:
CALL Hgcloop1
RETURN

Pur2:
CALL Evpur
RETURN

Grybox:
CALL Vgaref
RETURN


Whoa:
'something bad has happened. we want to trap the error and save it
'so we can figure out what happened
xmb = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
SCREEN 0
CLS
COLOR 15, 4
LOCATE 12, 25
PRINT "WARNING! AN ERROR HAS OCCURRED"
LOCATE 13, 25
PRINT " PRESS ANY KEY TO CONTINUE    "
PRINT ERR;
OPEN "tviderr.lst" FOR OUTPUT AS #1
PRINT #1, STR$(ERR);
CLOSE #1

BEEP
CLEAR
DO WHILE INKEY$ = ""
LOOP
GOTO CardTst

X8xh:
'800x600 crosshatch
c$ = ""
vga1 = SVGA16(0)
CALL GraphColor(15)
CALL ClearView
CALL DrawBox(0, 0, 799, 599, 1)
FOR x% = 0 TO 799 STEP 50
CALL DrawBox(0, 0, x%, 599, 1)
NEXT x%
FOR y% = 0 TO 599 STEP 50
CALL DrawBox(0, 0, 799, y%, 1)
NEXT y%

FOR cr% = 0 TO 540
REM CALL drawcircle(400, 299, cr%, 1)
x1% = INT(50 * SIN(cr%))
y1% = INT(50 * COS(cr%))
x2% = INT(100 * SIN(cr%))
y2% = INT(100 * COS(cr%))
x3% = INT(150 * SIN(cr%))
y3% = INT(150 * COS(cr%))
x4% = INT(200 * SIN(cr%))
y4% = INT(200 * COS(cr%))
CALL PutDot(x1% + 400, y1% + 300, 1)
CALL PutDot(x2% + 400, y2% + 300, 1)
CALL PutDot(x3% + 400, y3% + 300, 1)
CALL PutDot(x4% + 400, y4% + 300, 1)
s1% = INT(20 * SIN(cr%))
s2% = INT(40 * SIN(cr%))
s3% = INT(60 * SIN(cr%))
s4% = INT(80 * SIN(cr%))
s5% = INT(100 * SIN(cr%))
t1% = INT(20 * COS(cr%))
t2% = INT(40 * COS(cr%))
t3% = INT(60 * COS(cr%))
t4% = INT(80 * COS(cr%))
t5% = INT(100 * COS(cr%))
CALL PutDot(s1% + 100, t1% + 100, 1)
CALL PutDot(s2% + 100, t2% + 100, 1)
CALL PutDot(s3% + 100, t3% + 100, 1)
CALL PutDot(s4% + 100, t4% + 100, 1)
CALL PutDot(s5% + 100, t5% + 100, 1)
CALL PutDot(s1% + 700, t1% + 100, 1)
CALL PutDot(s2% + 700, t2% + 100, 1)
CALL PutDot(s3% + 700, t3% + 100, 1)
CALL PutDot(s4% + 700, t4% + 100, 1)
CALL PutDot(s5% + 700, t5% + 100, 1)
CALL PutDot(s1% + 100, t1% + 500, 1)
CALL PutDot(s2% + 100, t2% + 500, 1)
CALL PutDot(s3% + 100, t3% + 500, 1)
CALL PutDot(s4% + 100, t4% + 500, 1)
CALL PutDot(s5% + 100, t5% + 500, 1)
CALL PutDot(s1% + 700, t1% + 500, 1)
CALL PutDot(s2% + 700, t2% + 500, 1)
CALL PutDot(s3% + 700, t3% + 500, 1)
CALL PutDot(s4% + 700, t4% + 500, 1)
CALL PutDot(s5% + 700, t5% + 500, 1)
NEXT cr%
FOR x% = 0 TO 20 STEP 2
xa% = x% - 10
xb% = xa% * 2
xc1% = xa% + 100
xd1% = xb% + 100
xc2% = xa% + 700
xd2% = xb% + 700
CALL DrawLine(xd1%, 0, xc1%, 80, 1)
CALL DrawLine(xd1%, 200, xc1%, 120, 1)
CALL DrawLine(xd2%, 0, xc2%, 80, 1)
CALL DrawLine(xd2%, 200, xc2%, 120, 1)
CALL DrawLine(xd1%, 600, xc1%, 520, 1)
CALL DrawLine(xd1%, 400, xc1%, 480, 1)
CALL DrawLine(xd2%, 400, xc2%, 480, 1)
CALL DrawLine(xd2%, 600, xc2%, 520, 1)
NEXT x%
FOR x% = 0 TO 20 STEP 2
xa% = x% - 10
xb% = xa% * 2
xc1% = xa% + 100
xd1% = xb% + 100
xc2% = xa% + 500
xd2% = xb% + 500
CALL DrawLine(0, xd1%, 80, xc1%, 1)
CALL DrawLine(200, xd1%, 120, xc1%, 1)
CALL DrawLine(600, xd1%, 680, xc1%, 1)
CALL DrawLine(800, xd1%, 720, xc1%, 1)
CALL DrawLine(0, xd2%, 80, xc2%, 1)
CALL DrawLine(200, xd2%, 120, xc2%, 1)
CALL DrawLine(600, xd2%, 680, xc2%, 1)
CALL DrawLine(800, xd2%, 720, xc2%, 1)
NEXT x%

FOR x% = 0 TO 799 STEP 5
CALL DrawLine(x%, 295, x%, 305, 1)
NEXT x%
FOR y% = 0 TO 599 STEP 5
CALL DrawLine(395, y%, 405, y%, 1)
NEXT y%
FOR y% = 0 TO 30 STEP 2
ya% = y% - 15
yb% = ya% * 3
yc% = ya% + 300
yd% = yb% + 300
CALL DrawLine(0, yd%, 350, yc%, 1)
CALL DrawLine(450, yc%, 799, yd%, 1)
NEXT y%
FOR x% = 0 TO 30 STEP 2
xa% = x% - 15
xb% = xa% * 3
xc% = xa% + 400
xd% = xb% + 400
CALL DrawLine(xd%, 0, xc%, 250, 1)
CALL DrawLine(xc%, 350, xd%, 599, 1)
NEXT x%
CALL GraphColor(0)
CALL fillbox(460, 451, 468, 577, 1)
FOR y% = 0 TO 15
x% = 0
Z% = INT(x% / 16)
CALL GraphColor(x% + y%)
CALL fillbox((Z% * 8) + 460, (y% * 8) + 451, (Z% * 8) + 466, (y% * 8) + 457, 1)
NEXT y%
r& = Color16(3, 0, 0)
g& = Color16(0, 3, 0)
b& = Color16(0, 0, 3)
m& = Color16(3, 0, 3)
c& = Color16(0, 3, 3)
y& = Color16(3, 3, 0)
w& = Color16(3, 3, 3)
bk& = Color16(0, 0, 0)
Scap:
c$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
'the keys change the colors of the lines and background
IF c$ = "R" OR c$ = "r" THEN GOTO Sr
IF c$ = "G" OR c$ = "g" THEN GOTO Sg
IF c$ = "B" OR c$ = "b" THEN GOTO Sb
IF c$ = "M" OR c$ = "m" THEN GOTO Sm
IF c$ = "C" OR c$ = "c" THEN GOTO Sc
IF c$ = "Y" OR c$ = "y" THEN GOTO Sy
IF c$ = "W" OR c$ = "w" THEN GOTO Sw
IF c$ = "Z" OR c$ = "z" THEN GOTO Sz
IF c$ = CHR$(27) OR c$ = "0" THEN GOTO X8ex
GOTO Scap
X8ex:
GOTO bye99
Sr:
CALL PALETTE16(15, r&)
GOTO Scap
Sg:
CALL PALETTE16(15, g&)
GOTO Scap
Sb:
CALL PALETTE16(15, b&)
GOTO Scap
Sm:
CALL PALETTE16(15, m&)
GOTO Scap
Sc:
CALL PALETTE16(15, c&)
GOTO Scap
Sy:
CALL PALETTE16(15, y&)
GOTO Scap
Sw:
CALL PALETTE16(15, w&)
CALL PALETTE16(0, bk&)
GOTO Scap
Sz:
CALL PALETTE16(15, bk&)
CALL PALETTE16(0, w&)
GOTO Scap
bye99:
a = ModeColor

CALL XModeClear
GOTO SvgaM

X8mult:

'800x600 multiburst
'for testing video amp bandwidth

c$ = ""
vga2 = SVGA16(0)
CALL GraphColor(15)
CALL ClearView
Main8:

x% = 0
p% = 2
Lp8:
x% = x% + p%
CALL DrawBox(x%, 0, (x% + INT(p% / 2.2)), 599, 1)
CALL fillbox(x%, 0, (x% + INT(p% / 2.2)), 599, 0)
p% = 1 + INT(x% / 40)
IF x% < 800 THEN GOTO Lp8
DO WHILE INKEY$ = ""
LOOP
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
SCREEN 0
GOTO SvgaM

X8foc:
'800x600 focus pattern
c$ = ""
vga1 = SVGA16(0)
CALL GraphColor(15)
CALL ClearView
FOR x% = 0 TO 799 STEP 2
CALL DrawLine(x%, 0, x%, 599, 0)
NEXT x%
FOR x% = 0 TO 599 STEP 2
CALL DrawLine(0, x%, 799, x%, 0)
NEXT x%
DO WHILE INKEY$ = ""
LOOP
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
SCREEN 0
GOTO SvgaM
X8foc2:
'another 800x600 focus pattern
c$ = ""
vga1 = SVGA16(0)

CALL GraphColor(15)
CALL ClearView
CALL DrawBox(0, 0, 799, 599, 1)
FOR x% = 0 TO 799 STEP 4
CALL DrawBox(0, 0, x%, 599, 1)
NEXT x%
FOR y% = 0 TO 599 STEP 4
CALL DrawBox(0, 0, 799, y%, 1)
NEXT y%
FOR cr% = 5 TO 795 STEP 5
REM CALL drawcircle(400, 300, cr%, 0)
CALL DrawLine(400, 300, cr%, 0, 0)
CALL DrawLine(400, 300, cr%, 599, 0)
REM CALL drawline(400, 300, 0, cr%, 0)
REM CALL drawline(400, 300, 799, cr%)
NEXT cr%
FOR cr% = 5 TO 595 STEP 5
CALL DrawLine(400, 300, 0, cr%, 0)
CALL DrawLine(400, 300, 799, cr%, 0)
NEXT cr%
DO WHILE INKEY$ = ""
LOOP
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
SCREEN 0
GOTO SvgaM

X8txt:
'800x600 text screen
vga1 = SVGA16(0)
CALL ClearView
CALL GraphColor(15)
st$ = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ~!@#$%^&*()_+|`{}[];:'<>.,/?abcdefghi"
FOR y% = 1 TO 590 STEP 12
CALL gprint(st$, 1, y%, 1)
NEXT y%
DO WHILE INKEY$ = ""
LOOP
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
SCREEN 0
GOTO SvgaM
X813p:
'mode 13x is a special 800x600 mode with a different refresh rate
CALL Vga13x(3)
CALL ClearView
u% = 0
FOR y% = 0 TO 7
FOR x% = 341 TO 0 STEP -11
Z% = y% * 20
s% = x% + 9
t% = Z% + 18
CALL GraphColor(u%)
CALL fillbox(x%, Z%, s%, t%, 1)
CALL fillbox(x%, Z% + 240, s%, t% + 240, 1)
u% = u% + 1
NEXT x%
NEXT y%
u% = 0
FOR x% = 0 TO 341 STEP 11
CALL GraphColor(u%)
CALL fillbox(x%, 160, x% + 9, 235, 1)
CALL fillbox(x%, 400, x% + 9, 480, 1)
u% = u% + 1
NEXT x%
DO WHILE INKEY$ = ""
LOOP
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor
GOTO SvgaM
S400A:
CALL Vga13x(2)
CALL ClearView
CALL GraphColor(15)
CALL DrawBox(0, 0, 319, 399, 1)
FOR x% = -1 TO 479 STEP 32
CALL DrawLine(x%, 0, x%, 479, 1)
REM CALL drawline(x%, 329, x%, 329, 1)
NEXT x%
CALL DrawLine(0, 26, 319, 26, 1)
CALL DrawLine(0, 80, 319, 80, 1)
CALL DrawLine(0, 200, 319, 200, 1)
CALL DrawLine(159, 0, 159, 479, 1)
CALL DrawBox(78, 80, 240, 307, 1)
CALL DrawLine(0, 137, 319, 137, 1)
CALL DrawLine(0, 253, 319, 253, 1)
FOR cr% = 0 TO 1024
x1% = INT(12 * SIN(cr%))
y1% = INT(20 * COS(cr%))
CALL PutDot(x1% + 16, y1% + 52, 1)
CALL PutDot(x1% + 16, y1% + 336, 1)
CALL PutDot(x1% + 303, y1% + 52, 1)
CALL PutDot(x1% + 303, y1% + 336, 1)

REM CALL circleaspect(9, 1)
REM CALL drawcircle(16, 52, 12, 1)

REM CALL drawcircle(16, 336, 12, 1)
REM CALL drawcircle(303, 52, 12, 1)
REM CALL drawcircle(303, 336, 12, 1)
NEXT cr%
CALL DrawLine(0, 307, 319, 307, 1)
CALL DrawLine(0, 365, 319, 365, 1)
FOR x% = 0 TO 78
f% = INT(x% / 5)
CALL GraphColor(f% + 16)
CALL fillbox(x% + 79, 136, x% + 80, 199, 1)
CALL GraphColor(f%)
CALL fillbox(x% + 160, 136, x% + 161, 199, 1)
CALL GraphColor(f% + 32)
CALL fillbox(x% + 79, 201, x% + 80, 253, 1)
CALL GraphColor(f% + 48)
CALL fillbox(x% + 160, 201, x% + 161, 253, 1)
NEXT x%
CALL GraphColor(17)
CALL fillbox(81, 83, 155, 133, 1)
CALL GraphColor(23)
CALL fillbox(163, 83, 237, 133, 1)
CALL GraphColor(27)
CALL fillbox(163, 256, 237, 302, 1)
CALL GraphColor(15)
CALL fillbox(81, 256, 155, 302, 1)
FOR x% = 2 TO 318 STEP 2
CALL DrawLine(x%, 198, x%, 202, 0)
NEXT x%
FOR y% = 1 TO 398 STEP 4
CALL DrawLine(158, y%, 160, y%, 0)
NEXT y%
DO WHILE INKEY$ = ""
LOOP
CALL circleaspect(1, 1)
a = ModeColor
a = SVGA16(0)
CALL ClearView
a = ModeColor

GOTO VxhM

X10xh:

'1924x768 crosshatch

CALL XModeClear
x10 = IsSEVGA
mode1 = SVGA16(1)
CALL ClearView
CALL setview(0, 0, 1023, 767)
CALL GraphColor(15)
CALL DrawBox(0, 0, 1023, 767, 1)
REM CIRCLE (512, 348), 200
REM CALL circleaspect(9, 2)
REM CALL drawcircle(512, 384, 44, 1)
FOR x% = 0 TO 1024
x1% = INT(64 * SIN(x%))
y1% = INT(64 * COS(x%))
zx% = INT(128 * SIN(x%))
zy% = INT(128 * COS(x%))

y% = INT(256 * SIN(x%))
Z% = INT(256 * COS(x%))
CALL PutDot(zx% + 128, zy% + 128, 1)
CALL PutDot(zx% + 896, zy% + 128, 1)
CALL PutDot(zx% + 128, zy% + 640, 1)
CALL PutDot(zx% + 896, zy% + 640, 1)

CALL PutDot(Z% + 512, y% + 384, 1)
CALL PutDot(x1% + 512, y1% + 384, 1)
CALL PutDot(x1% + 128, y1% + 128, 1)
CALL PutDot(x1% + 896, y1% + 128, 1)
CALL PutDot(x1% + 128, y1% + 640, 1)
CALL PutDot(x1% + 896, y1% + 640, 1)
NEXT x%
CALL DrawLine(0, 0, 1024, 768, 1)
CALL DrawLine(0, 768, 1024, 0, 1)
FOR x% = 0 TO 1023 STEP 32
CALL DrawLine(x%, 0, x%, 767, 1)
NEXT x%
FOR y% = 0 TO 767 STEP 32
CALL DrawLine(0, y%, 1023, y%, 1)
NEXT y%
Z% = 1
FOR y% = 0 TO 30 STEP 2
ya% = y% - 15
yb% = ya% * 4
yc% = ya% + 384
yd% = yb% + 384
CALL DrawLine(0, yd%, 448, yc%, 1)
CALL DrawLine(576, yc%, 1023, yd%, 1)
NEXT y%
FOR x% = 0 TO 30 STEP 2
xa% = x% - 15
xb% = xa% * 4
xc% = xa% + 512
xd% = xb% + 512
CALL DrawLine(xd%, 0, xc%, 320, 1)
CALL DrawLine(xc%, 448, xd%, 767, 1)
NEXT x%
FOR x% = 0 TO 64 STEP 4
CALL DrawLine(128, 128, 0, x% + 96, 1)
CALL DrawLine(128, 128, 256, x% + 96, 1)
CALL DrawLine(896, 128, 1023, x% + 96, 1)
CALL DrawLine(896, 128, 768, x% + 96, 1)
CALL DrawLine(128, 640, 0, x% + 608, 1)
CALL DrawLine(128, 640, 256, x% + 608, 1)
CALL DrawLine(896, 640, 1023, x% + 608, 1)
CALL DrawLine(896, 640, 768, x% + 608, 1)
CALL DrawLine(128, 128, x% + 96, 0, 1)
CALL DrawLine(128, 128, x% + 96, 256, 1)
CALL DrawLine(896, 128, x% + 864, 256, 1)
CALL DrawLine(896, 128, x% + 864, 0, 1)
CALL DrawLine(128, 640, x% + 96, 512, 1)
CALL DrawLine(128, 640, x% + 96, 768, 1)
CALL DrawLine(896, 640, x% + 864, 768, 1)
CALL DrawLine(896, 640, x% + 864, 512, 1)

NEXT x%
r% = Color16(3, 0, 0)
g% = Color16(0, 3, 0)
b% = Color16(0, 0, 3)
m% = Color16(3, 0, 3)
c% = Color16(0, 3, 3)
y% = Color16(3, 3, 0)
w% = Color16(3, 3, 3)
bk% = Color16(0, 0, 0)
Scap1:
c$ = ""
DO WHILE c$ = ""
c$ = INKEY$
LOOP
IF c$ = "R" OR c$ = "r" THEN GOTO Sr1
IF c$ = "G" OR c$ = "g" THEN GOTO Sg1
IF c$ = "B" OR c$ = "b" THEN GOTO Sb1
IF c$ = "M" OR c$ = "m" THEN GOTO Sm1
IF c$ = "C" OR c$ = "c" THEN GOTO Sc1
IF c$ = "Y" OR c$ = "y" THEN GOTO Sy1
IF c$ = "W" OR c$ = "w" THEN GOTO Sw1
IF c$ = "Z" OR c$ = "z" THEN GOTO Sz1
IF c$ = CHR$(27) OR c$ = "0" THEN GOTO X10ex
GOTO Scap
X10ex:
GOTO bye3
Sr1:
CALL PALETTE16(15, r%)
GOTO Scap1
Sg1:
CALL PALETTE16(15, g%)
GOTO Scap1
Sb1:
CALL PALETTE16(15, b%)
GOTO Scap1
Sm1:
CALL PALETTE16(15, m%)
GOTO Scap1
Sc1:
CALL PALETTE16(15, c%)
GOTO Scap1
Sy1:
CALL PALETTE16(15, y%)
GOTO Scap1
Sw1:
CALL PALETTE16(15, w%)
CALL PALETTE16(0, bk%)
GOTO Scap1
Sz1:
CALL PALETTE16(15, bk%)
CALL PALETTE16(0, w%)
GOTO Scap1
bye3:
a = ModeColor
CALL XModeClear
GOTO SvgaM

X10mult:
'1024x768 multiburst
SCREEN 12
x = IsSEVGA
mode1 = SVGA16(1)
CALL ClearView
CALL setview(0, 0, 1023, 767)
CALL GraphColor(15)
X10mu:
c$ = ""
Main10:

x% = 0
p% = 2
Lp10:
x% = x% + p%
CALL DrawBox(x%, 0, (x% + INT(p% / 2.2)), 767, 1)
CALL fillbox(x%, 0, (x% + INT(p% / 2.2)), 767, 0)
p% = 1 + INT(x% / 40)
IF x% < 1024 THEN GOTO Lp10
DO WHILE INKEY$ = ""
LOOP
bye4:
a = ModeColor
CALL XModeClear
GOTO SvgaM
X10foc1:

'1024x768 focus pattern

SCREEN 12
x = IsSEVGA
mode1 = SVGA16(1)
CALL ClearView
CALL setview(0, 0, 1023, 767)
CALL GraphColor(15)
FOR x% = 0 TO 1023 STEP 3
CALL DrawLine(x%, 0, x%, 767, 0)
NEXT x%
FOR x% = 0 TO 767 STEP 3
CALL DrawLine(0, x%, 1023, x%, 0)
NEXT x%
DO WHILE INKEY$ = ""
LOOP
bye5:

CALL XModeClear
a = ModeColor
GOTO SvgaM
X10foc2:

'1024x768 focus windowed version
SCREEN 12
x = IsSEVGA
mode1 = SVGA16(1)
CALL ClearView
CALL setview(0, 0, 1023, 767)
CALL GraphColor(15)
FOR x% = 0 TO 1023 STEP 5
CALL DrawLine(x%, 0, x%, 767, 1)
NEXT x%
FOR x% = 0 TO 767 STEP 5
CALL DrawLine(0, x%, 1023, x%, 1)
NEXT x%
FOR x% = 0 TO 767 STEP 5
CALL DrawLine(511, 384, 0, x%, 0)
CALL DrawLine(511, 384, 1023, x%, 0)
NEXT x%
FOR x% = 0 TO 1023 STEP 5
CALL DrawLine(511, 384, x%, 0, 0)
CALL DrawLine(511, 384, x%, 767, 0)
NEXT x%
DO WHILE INKEY$ = ""
LOOP
bye6:
a = ModeColor
CALL XModeClear

GOTO SvgaM


X10txt:

'1024x768 text screen

SCREEN 12
x = IsSEVGA
mode1 = SVGA16(1)
CALL ClearView
CALL setview(0, 0, 1023, 767)
CALL GraphColor(15)
a$ = "abcdefghijklmnopqrstuvwxyz1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZฎฏฐฑฒณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะัาำิีึืฺุูÛÜÞÝÞ฿Þโใไๅๆ็่้๊๐๑๒๓๕เ"
CALL smalltext
FOR y% = 8 TO 767 STEP 8
CALL gprint(a$, 0, y%, 1)
NEXT y%
DO WHILE INKEY$ = ""
LOOP
bye9:
a = ModeColor
CALL XModeClear
GOTO SvgaM

