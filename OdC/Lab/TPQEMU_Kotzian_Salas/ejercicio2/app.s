.equ SCREEN_WIDTH, 		640
.equ SCREEN_HEIGH, 		480
.equ BITS_PER_PIXEL,  	32


.globl main
main:
	// X0 contiene la direccion base del framebuffer


 	mov x25, x0	// Save framebuffer base address to x25	
	
	mov x17, 0x10 	// Multiplicador del delay (funciona con multiplicacion, por lo que 1 es el minimo, recomendamos el rango 0x0f - 0x1f) 

	//------------------ BACKGROUND --------------------------------
 
	// deep blue 0x ff 02 15 5d
	movz x15, 0xFF02, lsl 16	
	movk x15, 0x158d, lsl 00
	
	movz x14, 0x10, lsl 0	// # of rows with color
	mov x13, 0		// current rowCount	
	
	mov x2, SCREEN_HEIGH          
fondo1:
	mov x1, SCREEN_WIDTH
	add x13, x13, 1
	
	subs xzr, x13, x14	// sets flags 
	b.ne fondo0 		// branch if current rowCount is equal to #rowsWithColor
	
	mov x13, 0
	lsl x14, x14, 1
	sub x15, x15, 25
	
fondo0:
	stur w15,[x0]	   // Set color of pixel N
	add x0,x0,4	   // Next pixel
	sub x1,x1,1	   // decrement X counter
	cbnz x1,fondo0	   // If not end row jump
	sub x2,x2,1	   // Decrement Y counter
	cbnz x2,fondo1	   // if not last row, jump
	
	
	// conventions:
 
	//	x25 -> frameBuffer array start	(pixel zero)

	// 	x0  -> current pixel 		(in address)     <cp>
	//	x1  -> height of rectangle	(in pixel count) <h_rect>
	//	x2  -> width of rectangle	(in pixel count) <w_rect>
	// 	x3  -> horizontal offset	(in pixel count) <h_offset>
	//	x4  -> vertical offset		(in pixel count) <v_offset>
	//	x5  -> horizontal iterator 	(int)
	//	x6  -> vertical iterator 	(int)
	//	
	// 	x7 to x14 -> temp registers
	//	 	
	// 	x15 -> color			(hexa ARGB 32b)


	//-------------------------- RECTANGULO -------------------------------
	b RectangleEND


	// MUST be called with instruction:  bl RectangleSTART 
.globl r
r: 
	add x0, x25, xzr // initialize
	
	mov x7, SCREEN_WIDTH
	mul x7, x4, x7			// v_offset * SCREEN_WIDTH 
	add x0, x0, x7, lsl 2		// origin + ^^^	
	add x0, x0, x3, lsl 2		// x0 is now the position of the rectangle
	
	mov x6, x1
RectVERT:
	
	mov x5, x2 	
RectHoriz:
	stur w15,[x0]	   // set color of pixel N
	add x0, x0, 4 	   // next pixel
	sub x5, x5, 1      // horizontal counter -1 
	cbnz x5, RectHoriz
	
	sub x6, x6, 1		// v_counter -1

	mov x8, SCREEN_WIDTH
	sub x8, x8, x2
	lsl x8, x8, 2
 
	add x0, x0, x8		// adjust origin of next row
	//sub x0, x0, 4	
	
	cbnz x6, RectVERT

	br x30			// goes back to next instruction 
	//------------------------- RECTANGLE END ---------------------------------
RectangleEND:


	//--------- TEST ------------ 
	
	// movz x15, 0xff, lsl 0
	// mov x3, 130
	// mov x15, 0 // COLOR = NEGRO 	
	// mov x1, 100
	// mov x2, 100
	// mov x3, 30
	// mov x4, 600
		
	// bl r 
 
	// bl r
	// --------- END TEST -------

	// ------------- FOREGROUND ---------------

// floor: 
	movz x15, 0x36, lsl 16
	movk x15, 0x2816, lsl 0 
	
	mov x1, 80
	mov x2, SCREEN_WIDTH
	mov x3, 0
	mov x4, 400
	
	bl r

	movz x15, 0x45, lsl 16
	movk x15, 0x3626, lsl 0 
	
	mov x1, 30
	
	bl r
	
// corales: 
	
	// coral1: (magenta)	
	movz x16, 0x6b, lsl 16		// body coral 
	movk x16, 0x0042, lsl 0
	
	movz x9, 0x2b, lsl 16		// Dark part of fruit
	movk x9, 0x001a, lsl 0

	movz x10, 0xd6, lsl 16		// Light part of fruit
	movk x10, 0x0084, lsl 0

	mov x13, 20	// xPos universal
	mov x14, 330	// ypos universal
	

	bl coral


	//coral2 (yellow)
	movz x16, 0x6b, lsl 16		// body coral 
	movk x16, 0x5900, lsl 0
	
	movz x9, 0x2b, lsl 16		// Dark part of fruit
	movk x9, 0x2400, lsl 0

	movz x10, 0xd6, lsl 16		// Light part of fruit
	movk x10, 0xb200, lsl 0

	mov x13, 360
	mov x14, 320

	bl coral

	//coral3 (light blue)

	//movz x16, 0x00, lsl 16		// body coral 
	movz x16, 0x666b, lsl 0
	
	//movz x9, 0x00, lsl 16		// Dark part of fruit
	movz x9, 0x292b, lsl 0

	//movz x10, 0x00, lsl 16		// Light part of fruit
	movz x10, 0xcbd6, lsl 0

	mov x13, 500
	mov x14, 300

	bl coral


	//coral4 (orange)

	movz x16, 0x94, lsl 16		// body coral 
	movk x16, 0x3b00, lsl 0
	
	movz x9, 0x61, lsl 16		// Dark part of fruit
	movk x9, 0x2700, lsl 0

	movz x10, 0xe5, lsl 16		// Light part of fruit
	movk x10, 0x5a00, lsl 0

	mov x13, 150
	mov x14, 305

	bl coral

 Fishes: 

	mov x13, 400
	mov x14, 20

	// movz x16, 0xd4, lsl 16	// body yellow
	movk x16, 0xd4d4, lsl 0
	
	// movz x9, 0xb4, lsl 16 	// shadow yellow
	movk x9, 0xb4b4, lsl 0

	// movz x10, 0xd4, lsl 16	// brown details 
	movk x10, 0x7ad4, lsl 0	
	
	bl fish1


	bl fish1

	mov x13, 30
	mov x14, 40
	
	bl pufferfish

	mov x13, 400
	mov x14, 280

	//bl jaws

	mov x13, 210
	mov x14, 100

	movz x16, 0xd4, lsl 16	// body yellow
	movk x16, 0xd400, lsl 0
	
	movz x9, 0xb4, lsl 16 	// shadow yellow
	movk x9, 0xb400, lsl 0

	movz x10, 0xd4, lsl 16	// brown details 
	movk x10, 0x7a00, lsl 0	
	
	bl fish1

	mov x13, 170
	mov x14, 130

	movz x16, 0xd4, lsl 16	// body yellow
	movk x16, 0x00d4, lsl 0
	
	movz x9, 0xb4, lsl 16 	// shadow yellow
	movk x9, 0x00b4, lsl 0

	movz x10, 0xd4, lsl 16	// brown details 
	movk x10, 0x007a, lsl 0	
	
	bl fish1

	b endCoral	
coral:
	
	mov x29, x30 // save adress to come back 

	// pixel tam : 5x5px 
	
	mov x15, x16

	mov x1, 30
	mov x2, 5
	add x3, x13, 0
	add x4, x14, 50

	bl r

	mov x1, 60
	add x3, x13, 5
	add x4, x14, 25

	bl r

	mov x1, 70
	add x3, x13, 10
	add x4, x14, 20

 	bl r

	mov x1, 45
	add x3, x13, 15
	add x4, x14, 50

	bl r

	mov x1, 25
	add x3, x13, 20
	add x4, x14, 75

	bl r

	mov x2, 10
	add x3, x13, 25
	add x4, x14, 80

	bl r

	mov x1, 100
	mov x2, 5
	add x3, x13, 30
	add x4, x14, 10	

	bl r

	mov x1, 115
	mov x2, 10
	add x3, x13, 35
	add x4, x14, 0

	bl r

	mov x1, 55
	mov x2, 5
	add x3, x13, 45 
	add x4, x14, 60

	bl r

	mov x1, 45
	add x3, x13, 50
	add x4, x14, 65

	bl r

	mov x1, 30
	add x3, x13, 55
	add x4, x14, 20 
	
	bl r
	
	mov x1, 35
	add x4, x14, 60

	bl r

	mov x1, 80
	mov x2, 10
	add x3, x13, 60
	add x4, x14, 10

	bl r

	mov x1, 35
	mov x2, 5
	add x3, x13, 70
	add x4, x14, 50

	bl r

	mov x1, 15
	add x3, x13, 75
	add x4, x14, 70

	bl r

	mov x1, 20
	add x3, x13, 80
	add x4, x14, 65

	bl r 

	mov x1, 55
	add x3, x13, 85
	add x4, x14, 25

	bl r

	add x3, x13, 90
	add x4, x14, 20

	bl r

	mov x1, 35
	add x3, x13, 95
	add x4, x14, 40	

	bl r

	// fruit shadow 
	mov x15, x9
	
	mov x1, 10
	mov x2, 10 
	
	add x3, x13, 5
	add x4, x14, 65

	bl r

	add x3, x13, 10
	add x4, x14, 35

	bl r

	add x3, x13, 30
	add x4, x14, 20

	bl r

	add x3, x13, 40
	add x4, x14, 0

	bl r
	
	add x4, x14, 40

	bl r

	add x4, x14, 85

	bl r 

	add x3, x13, 55
	add x4, x14, 25

	bl r

	add x4, x14, 65

	bl r 

	add x3, x13, 70
	add x4, x14, 5
	
	bl r

	add x3, x13, 85
	add x4, x14, 70

	bl r 

	add x3, x13, 95
	add x4, x14, 20

	bl r

	// fruit higlight
	mov x15, x10
	
	mov x1, 5
	mov x2, 5
	
		
	add x3, x13, 10
	add x4, x14, 65

	bl r

	add x3, x13, 15
	add x4, x14, 35

	bl r

	add x3, x13, 35
	add x4, x14, 20

	bl r

	add x3, x13, 45
	add x4, x14, 0

	bl r
	
	add x4, x14, 40

	bl r

	add x4, x14, 85

	bl r 

	add x3, x13, 60
	add x4, x14, 25

	bl r

	add x4, x14, 65

	bl r 

	add x3, x13, 75
	add x4, x14, 5
	
	bl r

	add x3, x13, 90
	add x4, x14, 70

	bl r 

	add x3, x13, 100
	add x4, x14, 20

	bl r

	br x29
endCoral:


	// seaGrass:
	mov x13, 5
	mov x14, 400
	
	bl seagrass

	mov x13, 65
	mov x14, 380

	bl seagrass
	
	mov x13, 150
	mov x14, 390

	bl seagrass
	
	mov x13, 240
	mov x14, 390

	bl seagrass
	
	mov x13, 500
	mov x14, 380

	bl seagrass

	mov x13, 420 // nice
	mov x14, 375

	bl seagrass


	mov x13, 580
	mov x14, 415

	bl seagrass
	
	
	b endSG
seagrass:
	mov x29, x30

	// remove later 


	movz x15, 0x08, lsl 16	// Dark green shadow
	movk x15, 0x4d00, lsl 0 
	
	mov x1, 15
	mov x2, 5
	add x3, x13, 0
	add x4, x14, 55

	bl r

	mov x1, 45
	add x3, x13, 5
	add x4, x14, 40
	
	bl r 

	mov x1, 10
	add x3, x13, 10
	add x4, x14, 30

	bl r

	add x4, x14, 75

	bl r 
	
	mov x1, 20
	add x3, x13, 20
	add x4, x14, 60

	bl r

	mov x1, 35
	add x3, x13, 25
	add x4, x14, 50

	bl r

	mov x1, 20 
	add x3, x13, 30
	add x4, x14, 30

	bl r

	mov x1, 10
	add x4, x14, 75

	bl r 
	
	mov x1, 15
	add x3, x13, 45
	add x4, x14, 45

	bl r

	add x4, x14, 70

	bl r

	mov x1, 30
	add x3, x13, 50
	add x4, x14, 55 

	bl r

	mov x1, 10
	add x3, x13, 55
	add x4, x14, 30

	bl r

	add x4, x14, 75

	bl r


	// lighter green grass
	movz x15, 0x0b, lsl 16 
	movk x15, 0x6b00, lsl 0

	mov x1, 15
	add x3, x13, 0
	add x4, x14, 45

	bl r
	
	mov x1, 10
	add x3, x13, 5
	add x4, x14, 30
	
	bl r
	
	add x3, x13, 10
	add x4, x14, 20

	bl r

	add x3, x13, 20
	add x4, x14, 50

	bl r

	mov x1, 20
	add x3, x13, 25
	add x4, x14, 30

	bl r

	add x3, x13, 30
	add x4, x14, 10

	bl r

	mov x1, 25
	add x3, x13, 50
	add x4, x14, 30

	bl r

	mov x1, 10
	add x3, x13, 55
	add x4, x14, 20

	bl r

	add x4, x14, 55

	bl r


	// really bright green 
	movz x15, 0x1f, lsl 16
	movk x15, 0x8a13, lsl 0

	mov x1, 5
	add x3, x13, 0
	add x4, x14, 40

	bl r
		
	add x3, x13, 5
	add x4, x14, 25

	bl r

	mov x1, 10
	add x3, x13, 10
	add x4, x14, 10

	bl r 
	
	mov x1, 5
	add x3, x13, 20
	add x4, x14, 45

	bl r 
	
	mov x1, 10
	add x3, x13, 25
	add x4, x14, 20

	bl r

	add x3, x13, 30
	add x4, x14, 0

	bl r

	mov x1, 5
	add x3, x13, 45
	add x4, x14, 40

	bl r

	add x3, x13, 50
	add x4, x14, 25

	bl r 

	mov x1, 10
	add x3, x13, 55
	add x4, x14, 10

	bl r

	br x29
endSG:


	
	b endFish1	
fish1: 
	mov x29, x30
	

 
	
	//movz x16, 0xd4, lsl 16	// body yellow
	//movk x16, 0xd400, lsl 0
	//movz x9, 0xb4, lsl 16 	// shadow yellow
	//movk x9, 0xb400, lsl 0
	//movz x10, 0xd4, lsl 16	// brown details 
	//movk x10, 0x7a00, lsl 0


	// pixel tam : 2x2px 
	mov x15, x16	// body-----------------

	mov x1, 18
	mov x2, 4
	add x3, x13, 2
	add x4, x14, 6

	bl r

	mov x1, 14
	mov x2, 2
	add x3, x13, 6
	add x4, x14, 8

	bl r
	
	mov x1, 10
	add x3, x13, 8
	add x4, x14, 10

	bl r

	mov x1, 6
	mov x2, 4
	add x3, x13, 10
	add x4, x14, 12

	bl r 

	mov x1, 10
	mov x2, 2
	add x3, x13, 14
	add x4, x14, 10

	bl r

	mov x1, 14
	add x3, x13, 16
	add x4, x14, 8

	bl r
	
	mov x1, 18
	add x3, x13, 18
	add x4, x14, 6

	bl r

	mov x1, 20
	mov x2, 4
	add x3, x13, 20
	add x4, x14, 4

	bl r
	
	mov x1, 22
	mov x2, 2
	add x3, x13, 24
	add x4, x14, 2

	bl r 
	
	mov x1, 24
	mov x2, 14	
	add x3, x13, 26
	add x4, x14, 2

	bl r

	mov x1, 18
	mov x2, 2
	add x3, x13, 40
	add x4, x14, 6

	bl r 

	mov x1, 10
	add x3, x13, 42
	add x4, x14, 10

	bl r

	mov x15, x9	// shadow --------------
	
	mov x1, 2
	mov x2, 4
	add x3, x13, 2
	add x4, x14, 22

	bl r 

	mov x2, 2
	add x3, x13, 6
	add x4, x14, 20

	bl r

	add x3, x13, 8
	add x4, x14, 18
	
	bl r
	
	mov x2, 4
	add x3, x13, 10
	add x4, x14, 16

	bl r

	mov x2, 2
	add x3, x13, 14
	add x4, x14, 18
	
	bl r
	
	add x3, x13, 16
	add x4, x14, 20

	bl r

	mov x2, 8
	add x3, x13, 18 
	add x4, x14, 22 
	
	bl r

	mov x2, 14
	add x3, x13, 26
	add x4, x14, 24

	bl r

	mov x1, 4
	mov x2, 2
	add x3, x13, 40
	add x4, x14, 20

	bl r

	add x3, x13, 42
	add x4, x14, 16

	bl r

	mov x15, x10 	// Orange Detail -------

	mov x1, 6
	mov x2, 2
	add x3, x13, 8
	add x4, x14, 10

	bl r

	mov x1, 2
	mov x2, 2
	add x3, x13, 10
	add x4, x14, 12

	bl r

	mov x1, 6
	add x3, x13, 18
	add x4, x14, 6

	bl r
	
	mov x1, 10
	add x3, x13, 20
	add x4, x14, 4

	bl r

	mov x1, 2
	add x3, x13, 22

	bl r

	mov x1, 4
	add x3, x13, 28
	add x4, x14, 4

	bl r
	
	mov x1, 8
	add x3, x13, 30
	add x4, x14, 2
	
	bl r

	mov x1, 4
	add x3, x13, 32
	
	bl r

	mov x1, 2
	add x3, x13, 34
	
	bl r

	mov x15, 0 // blanco
	add x3, x13, 36
	add x4, x14, 12

	bl r

	mov x15, 0	// outline -------------
	
	add x3, x13, 38
	
	bl r
	
	mov x1, 22
	mov x2, 2
	add x3, x13, 0
	add x4, x14, 4
	
	bl r

	mov x1, 2
	mov x2, 4
	add x3, x13, 2
	add x4, x14, 4

	bl r

	add x4, x14, 24

	bl r 
	
	mov x1, 2
	mov x2, 2
	add x3, x13, 6		
	add x4, x14, 6
	
	bl r

	add x4, x14, 22
	
	bl r

	add x3, x13, 8
	add x4, x14, 8

	bl r

	add x4, x14, 20

	bl r 
	
	mov x2, 4
	add x3, x13, 10
	add x4, x14, 10

	bl r
	
	add x4, x14, 18

	bl r 
	
	mov x2, 2
	add x3, x13, 14
	add x4, x14, 8

	bl r

	add x4, x14, 20

	bl r 

	add x3, x13, 16		
	add x4, x14, 6
	
	bl r

	add x4, x14, 22
	
	bl r

	add x3, x13, 18
	add x4, x14, 4
	
	bl r

	mov x2, 4
	add x3, x13, 20
	add x4, x14, 2

	bl r
	
	mov x2, 8
	add x3, x13, 18
	add x4, x14, 24

	bl r

	mov x2, 12
	add x3, x13, 24
	add x4, x14, 0
	
	bl r
	
	mov x2, 14
	add x3, x13, 26
	add x4, x14, 26

	bl r 

	mov x2, 4
	add x3, x13, 36
	add x4, x14, 2

	bl r

	mov x2, 2
	add x3, x13, 40
	add x4, x14, 4

	bl r

	add x4, x14, 24
	
	bl r
	
	mov x1, 4
	add x3, x13, 42
	add x4, x14, 6

	bl r

	add x4, x14, 20

	bl r 

	mov x1, 10
	add x3, x13, 44
	add x4, x14, 10

	bl r


	br x29
endFish1:

	//bl pufferfish


   	 b endPF

pufferfish: 
    mov x29,x30

    movz x16, 0xFF, lsl 16
    movk x16, 0x5A00, lsl 0
	//lower body
    movz x9, 0xFF, lsl 16
    movk x9, 0x9961, lsl 0
	//tail
    movz x10, 0xFF, lsl 16
    movk x10, 0x9991, lsl 0
	//spikes
    movz x11, 0xAA, lsl 16
    movk x11, 0x4C00, lsl 0
	//bright
    movz x12, 0xFF, lsl 16
    movk x12, 0xBD99, lsl 0


    	// mov x13,0
   	// mov x14,0

    mov x15,0 //color

    mov x1, 5
    mov x2, 5

    add x3,x13,0 //horizantal
    add x4,x14,35 // vertical

    bl r

	add x3,x13,0
	add x4,x14,40

	bl r

	add x3,x13,5
	add x4,x14,45

	bl r

	add x3,x13,10
	add x4,x14,45

	bl r

	add x3,x13,15
	add x4,x14,50
	
	bl r

	add x3,x13,20
	add x4,x14,50

	bl r
	add x3,x13,10
	add x4,x14,55

	bl r

	add x3,x13,5
	add x4,x14,60

	bl r

	add x3,x13,10
	add x4,x14,65

	bl r

	add x3,x13,15
	add x4,x14,65

	bl r

	add x3,x13,20
	add x4,x14,65

	bl r

	add x3,x13,25
	add x4,x14,60

	bl r

	add x3,x13,30
	add x4,x14,65

	bl r

	add x3,x13,35
	add x4,x14,70

	bl r

	add x3,x13,35
	add x4,x14,75

	bl r

	add x3,x13,40
	add x4,x14,80

	bl r

	add x3,x13,45
	add x4,x14,85

	bl r

	add x3,x13,50
	add x4,x14,90

	bl r

	add x3,x13,55
	add x4,x14,95

	bl r

	add x3,x13,60
	add x4,x14,95

	bl r

	add x3,x13,65
	add x4,x14,100

	bl r

	add x3,x13,70
	add x4,x14,100

	bl r

	add x3,x13,75
	add x4,x14,100

	bl r

	add x3,x13,80
	add x4,x14,100

	bl r

	add x3,x13,85
	add x4,x14,100

	bl r

	add x3,x13,90
	add x4,x14,100

	bl r

	add x3,x13,95
	add x4,x14,100

	bl r

	add x3,x13,100
	add x4,x14,100

	bl r

	add x3,x13,105
	add x4,x14,95

	bl r

	add x3,x13,110
	add x4,x14,95

	bl r

	add x3,x13,115
	add x4,x14,90

	bl r

	add x3,x13,120
	add x4,x14,85

	bl r

	add x3,x13,125
	add x4,x14,80

	bl r

	add x3,x13,130
	add x4,x14,75

	bl r
	
	add x3,x13,130
	add x4,x14,70

	bl r

	add x3,x13,135
	add x4,x14,65

	bl r

	add x3,x13,135
	add x4,x14,60

	bl r

	add x3,x13,140
	add x4,x14,55

	bl r

	add x3,x13,140
	add x4,x14,50

	bl r

	add x3,x13,140
	add x4,x14,45

	bl r
	
	add x3,x13,135
	add x4,x14,40

	bl r
	
	add x3,x13,135
	add x4,x14,35

	bl r

	add x3,x13,130
	add x4,x14,30

	bl r

	add x3,x13,125
	add x4,x14,25

	bl r

	add x3,x13,120
	add x4,x14,20

	bl r

	add x3,x13,115
	add x4,x14,15

	bl r

	add x3,x13,110
	add x4,x14,10

	bl r


	add x3,x13,105
	add x4,x14,10

	bl r

	add x3,x13,100
	add x4,x14,5

	bl r

	add x3,x13,95
	add x4,x14,5

	bl r


	add x3,x13,90
	add x4,x14,5

	bl r

	add x3,x13,85
	add x4,x14,5

	bl r

	add x3,x13,80
	add x4,x14,5

	bl r

	add x3,x13,75
	add x4,x14,5

	bl r

	add x3,x13,70
	add x4,x14,5

	bl r

	add x3,x13,65
	add x4,x14,5

	bl r

	add x3,x13,60 //horizontal
	add x4,x14,10 //vertical

	bl r
	
	add x3,x13,55
	add x4,x14,10

	bl r
		
	add x3,x13,50
	add x4,x14,15

	bl r
		
	add x3,x13,45
	add x4,x14,20

	bl r
		
	add x3,x13,40
	add x4,x14,25

	bl r
		
	add x3,x13,35
	add x4,x14,30

	bl r
		
	add x3,x13,35
	add x4,x14,35

	bl r
	
		
	add x3,x13,30
	add x4,x14,40

	bl r
		
	add x3,x13,25
	add x4,x14,45

	bl r
	
	add x3,x13,20
	add x4,x14,40

	bl r

	add x3,x13,15
	add x4,x14,35

	bl r
    

	add x3,x13,10
	add x4,x14,30

	bl r
	
	add x3,x13,5
	add x4,x14,30 //fin outline puffer

	bl r

	//aleta

	add x3,x13,75
	add x4,x14,45

	bl r
	
	add x3,x13,70
	add x4,x14,50

	bl r

	add x3,x13,70
	add x4,x14,55

	bl r

	add x3,x13,75
	add x4,x14,60

	bl r

	add x3,x13,80
	add x4,x14,60

	bl r

	add x3,x13,85
	add x4,x14,60

	bl r

	add x3,x13,90
	add x4,x14,55

	bl r
	
	add x3,x13,90
	add x4,x14,50

	bl r
	add x3,x13,85
	add x4,x14,45

	bl r
	//ojo
	add x3,x13,110
	add x4,x14,35

	bl r//
 	
	mov x15,x10
	
	add x3,x13,5
    add x4,x14,35

    bl r

	add x3,x13,10
    add x4,x14,35

    bl r
	add x3,x13,5
    add x4,x14,40

    bl r
	
	add x3,x13,10 //horizantal
    add x4,x14,40 // vertical

    bl r

	add x3,x13,15
    add x4,x14,40

    bl r
	
	add x3,x13,15
    add x4,x14,45

    bl r

	add x3,x13,20
    add x4,x14,45

    bl r


	add x3,x13,25
    add x4,x14,50

    bl r

	add x3,x13,25
    add x4,x14,55

    bl r

	add x3,x13,20
    add x4,x14,55

    bl r

	add x3,x13,20
    add x4,x14,60

    bl r

	add x3,x13,15
    add x4,x14,60

    bl r

	add x3,x13,15
    add x4,x14,55

    bl r

	add x3,x13,10
    add x4,x14,60

    bl r

	mov x15,x16 //aleta naranja
	add x3,x13,80
	add x4,x14,45

	bl r
	
	add x3,x13,75
	add x4,x14,50

	bl r
		
	add x3,x13,75
	add x4,x14,55

	bl r
		
	add x3,x13,80
	add x4,x14,50

	bl r
		
	add x3,x13,80
	add x4,x14,55

	bl r
		
	add x3,x13,85
	add x4,x14,55

	bl r
	
	add x3,x13,85
	add x4,x14,50

	bl r//final aleta naranja
			
	add x3,x13,95
	add x4,x14,55

	bl r
			
	add x3,x13,100
	add x4,x14,55

	bl r
				
	add x3,x13,105
	add x4,x14,55

	bl r
				
	add x3,x13,110
	add x4,x14,50

	bl r
					
	add x3,x13,115
	add x4,x14,50

	bl r
					
	add x3,x13,120
	add x4,x14,45

	bl r
			
	add x3,x13,125
	add x4,x14,45

	bl r
					
	add x3,x13,130
	add x4,x14,45

	bl r
	//	
	add x3,x13,135
	add x4,x14,45
	
	bl r //linea media
	
	add x3,x13,65
	add x4,x14,55

	bl r
	
	add x3,x13,60
	add x4,x14,55

	bl r
	
	add x3,x13,55
	add x4,x14,55

	bl r
	
	mov x15,x16
	
	add x3,x13,40
	add x4,x14,50
	
	bl r
	
	add x3,x13,35
	add x4,x14,50
	
	bl r

	add x3,x13,30
	add x4,x14,50
	
	bl r//fin linea media

	//mitad superior
	mov x15, x16
	add x3,x13,30
	add x4,x14,45
	
	bl r
	
	add x3,x13,35
	add x4,x14,45
	
	bl r

	add x3,x13,40
	add x4,x14,45
	
	bl r

	add x3,x13,35
	add x4,x14,40
	
	bl r

	add x3,x13,40
	add x4,x14,40
	
	bl r

	add x3,x13,40
	add x4,x14,35
	
	bl r

	add x3,x13,40
	add x4,x14,30
	
	bl r

	add x3,x13,45
	add x4,x14,40
	
	bl r

	add x3,x13,50
	add x4,x14,45
	
	bl r

	add x3,x13,55
	add x4,x14,50
	
	bl r

	add x3,x13,55
	add x4,x14,45
	
	bl r
	
	add x3,x13,55
	add x4,x14,40
	
	bl r
	
	add x3,x13,55
	add x4,x14,35
	
	bl r
	
	add x3,x13,55
	add x4,x14,30
	
	bl r
	
	add x3,x13,55
	add x4,x14,25
	
	bl r
		
	add x3,x13,50
	add x4,x14,20
	
	bl r
			
	add x3,x13,50
	add x4,x14,25
	
	bl r
			
	add x3,x13,50
	add x4,x14,30
	
	bl r
			
	add x3,x13,50
	add x4,x14,35
	
	bl r
			
	add x3,x13,50
	add x4,x14,40
	
	bl r
			
	add x3,x13,40
	add x4,x14,35
	
	bl r
			
	add x3,x13,45
	add x4,x14,35
	
	bl r
			
	add x3,x13,45
	add x4,x14,30
	
	bl r
			
	add x3,x13,45
	add x4,x14,25
	
	bl r
	
	add x3,x13,60
	add x4,x14,20
	
	bl r		
	add x3,x13,60
	add x4,x14,25
	
	bl r
			
	add x3,x13,60
	add x4,x14,30
	
	bl r
			
	add x3,x13,60
	add x4,x14,35
	
	bl r
			
	add x3,x13,60
	add x4,x14,40
	
	bl r
			
	add x3,x13,60
	add x4,x14,45
	
	bl r
			
	add x3,x13,60
	add x4,x14,50
	
	bl r
			
	add x3,x13,65
	add x4,x14,50
	
	bl r
			
	add x3,x13,65
	add x4,x14,45
	
	bl r
			
	add x3,x13,65
	add x4,x14,40
	
	bl r
			
	add x3,x13,65
	add x4,x14,45
	
	bl r
			
	add x3,x13,65
	add x4,x14,35
	
	bl r
			
	add x3,x13,65
	add x4,x14,30
	
	bl r
			
	add x3,x13,65
	add x4,x14,25
	
	bl r
			
	add x3,x13,65
	add x4,x14,20
	
	bl r
			
	add x3,x13,65
	add x4,x14,15
	
	bl r
			
	add x3,x13,65
	add x4,x14,10
	
	bl r
			
	add x3,x13,70
	add x4,x14,10
	
	bl r
			
	add x3,x13,70
	add x4,x14,15
	
	bl r
			
	add x3,x13,70
	add x4,x14,20
	
	bl r
			
	add x3,x13,70
	add x4,x14,25
	
	bl r
			
	add x3,x13,70
	add x4,x14,35
	
	bl r
			
	add x3,x13,70
	add x4,x14,45
	
	bl r
			
	add x3,x13,75
	add x4,x14,40
	
	bl r
			
	add x3,x13,75
	add x4,x14,30
	
	bl r
			
	add x3,x13,75
	add x4,x14,25
	
	bl r
			
	add x3,x13,75
	add x4,x14,20
	
	bl r
			
	add x3,x13,75
	add x4,x14,15
	
	bl r
			
	add x3,x13,75
	add x4,x14,10
	
	bl r
			
	add x3,x13,80
	add x4,x14,10
	
	bl r
				
	add x3,x13,80
	add x4,x14,15
	
	bl r
				
	add x3,x13,80
	add x4,x14,20
	
	bl r
				
	add x3,x13,80
	add x4,x14,25
	
	bl r
				
	add x3,x13,80
	add x4,x14,30
	
	bl r
				
	add x3,x13,80
	add x4,x14,35
	
	bl r
				
	add x3,x13,80
	add x4,x14,40
	
	bl r
				
	add x3,x13,85
	add x4,x14,40
	
	bl r
				
	add x3,x13,85
	add x4,x14,35
	
	bl r
				
	add x3,x13,85
	add x4,x14,30
	
	bl r
				
	add x3,x13,85
	add x4,x14,25
	
	bl r
				
	add x3,x13,85
	add x4,x14,20
	
	bl r
				
	add x3,x13,85
	add x4,x14,15
	
	bl r
				
	add x3,x13,85
	add x4,x14,10
	
	bl r
				
	add x3,x13,90
	add x4,x14,10
	
	bl r
				
	add x3,x13,90
	add x4,x14,20
	
	bl r
				
	add x3,x13,90
	add x4,x14,25
	
	bl r
				
	add x3,x13,90
	add x4,x14,30
	
	bl r
				
	add x3,x13,90
	add x4,x14,35
	
	bl r
				
	add x3,x13,90
	add x4,x14,40
	
	bl r
				
	add x3,x13,90
	add x4,x14,45
	
	bl r
				
	add x3,x13,95
	add x4,x14,50
	
	bl r
	add x3,x13,95
	add x4,x14,45
	
	bl r
	add x3,x13,95
	add x4,x14,40
	
	bl r
	add x3,x13,95
	add x4,x14,35
	
	bl r
	add x3,x13,95
	add x4,x14,30
	
	bl r
	add x3,x13,95
	add x4,x14,25
	
	bl r
	add x3,x13,95
	add x4,x14,10
	
	bl r
	
	add x3,x13,100
	add x4,x14,10
	
	bl r
		
	add x3,x13,100
	add x4,x14,15
	
	bl r
		
	add x3,x13,100
	add x4,x14,20
	
	bl r
		
	add x3,x13,100
	add x4,x14,25
	
	bl r
		
	add x3,x13,100
	add x4,x14,30
	
	bl r
		
	add x3,x13,100
	add x4,x14,35
	
	bl r
		
	add x3,x13,100
	add x4,x14,40
	
	bl r
		
	add x3,x13,100
	add x4,x14,45
	
	bl r
		
	add x3,x13,100
	add x4,x14,50
	
	bl r
		
	add x3,x13,105
	add x4,x14,50
	
	bl r
		
	add x3,x13,105
	add x4,x14,45
	
	bl r
		
	add x3,x13,105
	add x4,x14,40
	
	bl r
		
	add x3,x13,105
	add x4,x14,35
	
	bl r
		
	add x3,x13,105
	add x4,x14,30
	
	bl r
		
	add x3,x13,105
	add x4,x14,25
	
	bl r
		
	add x3,x13,105
	add x4,x14,20
	
	bl r
		
	add x3,x13,105
	add x4,x14,15
	
	bl r
		
	add x3,x13,110
	add x4,x14,15
	
	bl r
		
	add x3,x13,110
	add x4,x14,25
	
	bl r
		
	add x3,x13,110
	add x4,x14,30
	
	bl r
		
	add x3,x13,110
	add x4,x14,40
	
	bl r
		
	add x3,x13,110
	add x4,x14,45
	
	bl r
		
	add x3,x13,110
	add x4,x14,50
	
	bl r
		
	add x3,x13,115
	add x4,x14,45
	
	bl r
		
	add x3,x13,115
	add x4,x14,40
	
	bl r
		
	add x3,x13,115
	add x4,x14,35
	
	bl r
		
	add x3,x13,115
	add x4,x14,30
	
	bl r
		
	add x3,x13,120
	add x4,x14,25
	
	bl r
		
	add x3,x13,120
	add x4,x14,30
	
	bl r
		
	add x3,x13,120
	add x4,x14,35
	
	bl r
		
	add x3,x13,120
	add x4,x14,40
	
	bl r
		
	add x3,x13,125
	add x4,x14,40
	
	bl r
		
	add x3,x13,125
	add x4,x14,35
	
	bl r
		
	add x3,x13,125
	add x4,x14,30
	
	bl r
		
	add x3,x13,130
	add x4,x14,35
	
	bl r
		
	add x3,x13,130
	add x4,x14,40
	
	bl r//fin mitad superior
	//mitad inferior
	mov x15, x9
	add x3,x13,30
	add x4,x14,55
	
	bl r
	
	add x3,x13,30
	add x4,x14,60
	
	bl r
		
	add x3,x13,35
	add x4,x14,55
	
	bl r
		
	add x3,x13,35
	add x4,x14,60
	
	bl r
			
	add x3,x13,35
	add x4,x14,65
	
	bl r
	
	add x3,x13,40
	add x4,x14,55
	
	bl r
	
	add x3,x13,40
	add x4,x14,60
	
	bl r
	
	add x3,x13,40
	add x4,x14,65
	
	bl r
	
	add x3,x13,40
	add x4,x14,70
	
	bl r
	
	add x3,x13,40
	add x4,x14,75
	
	bl r
	
	add x3,x13,45
	add x4,x14,55
	
	bl r
	
	add x3,x13,45
	add x4,x14,60
	
	bl r
	
	add x3,x13,45
	add x4,x14,65
	
	bl r
	
	mov x15,x9

	add x3,x13,45
	add x4,x14,75
	
	bl r

	add x3,x13,45
	add x4,x14,80
	
	bl r

	add x3,x13,50
	add x4,x14,55
	
	bl r

	add x3,x13,50
	add x4,x14,60
	
	bl r
	
	add x3,x13,50
	add x4,x14,65
	
	bl r
	
	add x3,x13,50
	add x4,x14,70
	
	bl r
	
	add x3,x13,50
	add x4,x14,80
	
	bl r
	
	add x3,x13,50
	add x4,x14,85
	
	bl r
	
	add x3,x13,55
	add x4,x14,60
	
	bl r
	
	add x3,x13,55
	add x4,x14,65
	
	bl r
	
	add x3,x13,55
	add x4,x14,70
	
	bl r
	
	add x3,x13,55
	add x4,x14,75
	
	bl r
	
	add x3,x13,55
	add x4,x14,85
	
	bl r
	
	add x3,x13,55
	add x4,x14,90
	
	bl r
	
	add x3,x13,60
	add x4,x14,60
	
	bl r
	
	add x3,x13,60
	add x4,x14,65
	
	bl r
	
	add x3,x13,60
	add x4,x14,70
	
	bl r
	
	add x3,x13,60
	add x4,x14,75
	
	bl r
	
	add x3,x13,60
	add x4,x14,80
	
	bl r
	
	add x3,x13,60
	add x4,x14,85
	
	bl r
	
	add x3,x13,60
	add x4,x14,90
	
	bl r
	
	add x3,x13,65
	add x4,x14,60
	
	bl r

	add x3,x13,65
	add x4,x14,60
	
	bl r
	
	add x3,x13,65
	add x4,x14,65
	
	bl r
	
	add x3,x13,65
	add x4,x14,70
	
	bl r
	
	add x3,x13,65
	add x4,x14,75
	
	bl r
	
	add x3,x13,65
	add x4,x14,80
	
	bl r
	
	add x3,x13,65
	add x4,x14,85
	
	bl r
	
	add x3,x13,65
	add x4,x14,90
	
	bl r
	
	add x3,x13,65
	add x4,x14,95
	
	bl r

	add x3,x13,70
	add x4,x14,60
	
	bl r
	
	add x3,x13,70
	add x4,x14,65
	
	bl r
	
	add x3,x13,70
	add x4,x14,70
	
	bl r
	
	add x3,x13,70
	add x4,x14,75
	
	bl r
	
	add x3,x13,70
	add x4,x14,80
	
	bl r
	
	add x3,x13,70
	add x4,x14,85
	
	bl r
	
	add x3,x13,70
	add x4,x14,90
	
	bl r
	
	add x3,x13,70
	add x4,x14,95
	
	bl r
	
	add x3,x13,75
	add x4,x14,65
	
	bl r
	
	add x3,x13,75
	add x4,x14,70
	
	bl r
	
	add x3,x13,75
	add x4,x14,75
	
	bl r
	
	add x3,x13,75
	add x4,x14,80
	
	bl r
	
	add x3,x13,75
	add x4,x14,85
	
	bl r
	
	add x3,x13,75
	add x4,x14,90
	
	bl r
	
	add x3,x13,75
	add x4,x14,95
	
	bl r
		
	add x3,x13,80
	add x4,x14,65
	
	bl r
		
	add x3,x13,80
	add x4,x14,70
	
	bl r
		
	add x3,x13,80
	add x4,x14,75
	
	bl r
		
	add x3,x13,80
	add x4,x14,80
	
	bl r
		
	add x3,x13,80
	add x4,x14,85
	
	bl r
		
	add x3,x13,80
	add x4,x14,90
	
	bl r
		
	add x3,x13,80
	add x4,x14,95
	
	bl r
		
	add x3,x13,85
	add x4,x14,65
	
	bl r
		
	add x3,x13,85
	add x4,x14,70
	
	bl r
		
	add x3,x13,85
	add x4,x14,75
	
	bl r
		
	add x3,x13,85
	add x4,x14,80
	
	bl r
		
	add x3,x13,85
	add x4,x14,85
	
	bl r
		
	add x3,x13,85
	add x4,x14,90
	
	bl r
		
	add x3,x13,85
	add x4,x14,95
	
	bl r
		
	add x3,x13,90
	add x4,x14,60
	
	bl r
		
	add x3,x13,90
	add x4,x14,65
	
	bl r
		
	add x3,x13,90
	add x4,x14,70
	
	bl r
		
	add x3,x13,90
	add x4,x14,75
	
	bl r
		
	add x3,x13,90
	add x4,x14,80
	
	bl r
		
	add x3,x13,90
	add x4,x14,85
	
	bl r
		
	add x3,x13,90
	add x4,x14,90
	
	bl r
		
	add x3,x13,90
	add x4,x14,95
	
	bl r
		
	add x3,x13,95
	add x4,x14,60
	
	bl r
			
	add x3,x13,95
	add x4,x14,65
	
	bl r
			
	add x3,x13,95
	add x4,x14,70
	
	bl r
			
	add x3,x13,95
	add x4,x14,75
	
	bl r
			
	add x3,x13,95
	add x4,x14,80
	
	bl r
			
	add x3,x13,95
	add x4,x14,85
	
	bl r
			
	add x3,x13,95
	add x4,x14,90
	
	bl r
			
	add x3,x13,95
	add x4,x14,95
	
	bl r
			
	add x3,x13,100
	add x4,x14,60
	
	bl r
			
	add x3,x13,100
	add x4,x14,65
	
	bl r
			
	add x3,x13,100
	add x4,x14,70
	
	bl r
			
	add x3,x13,100
	add x4,x14,75
	
	bl r
			
	add x3,x13,100
	add x4,x14,80
	
	bl r
			
	add x3,x13,100
	add x4,x14,85
	
	bl r
			
	add x3,x13,100
	add x4,x14,90
	
	bl r
			
	add x3,x13,100
	add x4,x14,95
	
	bl r
			
	add x3,x13,105
	add x4,x14,60
	
	bl r
				
	add x3,x13,105
	add x4,x14,65
	
	bl r
				
	add x3,x13,105
	add x4,x14,70
	
	bl r
				
	add x3,x13,105
	add x4,x14,75
	
	bl r
				
	add x3,x13,105
	add x4,x14,80
	
	bl r
	
	mov x15,x9
	add x3,x13,105
	add x4,x14,90
	
	bl r
				
	add x3,x13,110
	add x4,x14,55
	
	bl r
				
	add x3,x13,110
	add x4,x14,60
	
	bl r
				
	add x3,x13,110
	add x4,x14,65
	
	bl r
				
	add x3,x13,110
	add x4,x14,70
	
	bl r
				
	add x3,x13,110
	add x4,x14,85
	
	bl r
				
	add x3,x13,110
	add x4,x14,90
	
	bl r
					
	add x3,x13,115
	add x4,x14,55
	
	bl r
					
	add x3,x13,115
	add x4,x14,60
	
	bl r
					
	add x3,x13,115
	add x4,x14,65
	
	bl r
					
	add x3,x13,115
	add x4,x14,70
	
	bl r
					
	add x3,x13,115
	add x4,x14,75
	
	bl r
					
	add x3,x13,115
	add x4,x14,80
	
	bl r
					
	add x3,x13,115
	add x4,x14,85
	
	bl r
					
	add x3,x13,120
	add x4,x14,50
	
	bl r
						
	add x3,x13,120
	add x4,x14,55
	
	bl r
						
	add x3,x13,120
	add x4,x14,60
	
	bl r
						
	add x3,x13,120
	add x4,x14,65
	
	bl r
						
	add x3,x13,120
	add x4,x14,70
	
	bl r
						
	add x3,x13,120
	add x4,x14,75
	
	bl r
						
	add x3,x13,120
	add x4,x14,80
	
	bl r
						
	add x3,x13,125
	add x4,x14,50
	
	bl r
						
	add x3,x13,125
	add x4,x14,55
	
	bl r
						
	add x3,x13,125
	add x4,x14,60
	
	bl r
						
	add x3,x13,125
	add x4,x14,65
	
	bl r
						
	add x3,x13,125
	add x4,x14,70
	
	bl r
						
	add x3,x13,125
	add x4,x14,75
	
	bl r
						
	add x3,x13,130
	add x4,x14,50
	
	bl r
						
	add x3,x13,130
	add x4,x14,55
	
	bl r
	
	mov x15,x9					
	add x3,x13,130
	add x4,x14,50
	
	bl r
	
	add x3,x13,130
	add x4,x14,55
	
	bl r
	
	add x3,x13,130
	add x4,x14,65
	
	bl r
	
	add x3,x13,135
	add x4,x14,50
	
	bl r

	add x3,x13,135
	add x4,x14,50
	
	bl r
	
	//brillos
	//brillo1
	mov x15,x12
	add x3,x13,45
	add x4,x14,70
	
	bl r

	add x3,x13,50
	add x4,x14,75
	
	bl r

	add x3,x13,55
	add x4,x14,80
	
	bl r//fin brillo 1
	//brillo2
	mov x15,x12		
	add x3,x13,105
	add x4,x14,85
	
	bl r
				
	add x3,x13,110
	add x4,x14,80
	
	bl r
				
	add x3,x13,110
	add x4,x14,75
	
	bl r
	//fin brillo2
	//brillo3
	mov x15,x12					
	add x3,x13,130
	add x4,x14,60
	
	bl r//finbr1llo3
	//brillo4
	mov x15,x12
	add x3,x13,135
	add x4,x14,55
	
	bl r//fin brillo4
	//fin brillos
	
	//spikes
	//spike1
	mov x15,x11
	add x3,x13,50
	add x4,x14,50

	bl r
		
	add x3,x13,45
	add x4,x14,50

	bl r
	add x3,x13,45
	add x4,x14,45

	bl r//fin spike1
	//spike2
	add x3,x13,110
	add x4,x14,20

	bl r

	
	add x3,x13,115
	add x4,x14,20

	bl r
		
	add x3,x13,115
	add x4,x14,25

	bl r//fin spike2
	
	//spike3
	add x3,x13,95
	add x4,x14,15

	bl r
	
	add x3,x13,90
	add x4,x14,15

	bl r
	
	add x3,x13,95
	add x4,x14,20

	bl r//fin spike 3
	//spike4
	add x3,x13,70
	add x4,x14,30 

	bl r
	
	add x3,x13,75
	add x4,x14,35

	bl r
	
	add x3,x13,70
	add x4,x14,40

	bl r//fin spike4
	//spike5

	add x3,x13,60
	add x4,x14,15 

	bl r

	add x3,x13,55
	add x4,x14,15 

	bl r

	add x3,x13,55
	add x4,x14,20 

	bl r//fin sipke5
	//fin spikes
	br x29
endPF:
	b endJaws

jaws:
	mov x29, x30

	movz x16, 0x53, lsl 16	// x16 --> body shark
	movk x16, 0x5371, lsl 0
		
	movz x9, 0x3b, lsl 16	// x9 --> shadow
	movk x9, 0x3b47, lsl 0

	movz x10, 0x61, lsl 16	// x10 --> highlight
	movk x10, 0x6185, lsl 0 

	mov x15, x16 // body
	
	mov x1, 6
	mov x2, 4
	add x3, x13, 4
	add x4, x14, 24

	bl r

	mov x1, 10
	add x3, x13, 8
	add x4, x14, 22
	
	bl r

	mov x1, 12
	mov x2, 10
	add x3, x13, 12
	add x4, x14, 20

	bl r

	mov x1, 14
	mov x2, 8
	add x3, x13, 22
	add x4, x14, 18 

	bl r

	mov x1, 16
	mov x2, 4
	add x3, x13, 30
	add x4, x14, 14

	bl r 

	mov x1, 26
	mov x2, 10
	add x3, x13, 34
	add x4, x14, 8

	bl r

	mov x1, 38
	mov x2, 8
	add x3, x13, 44
	add x4, x14, 6
		
	bl r
	
	mov x1, 32
	add x3, x13, 52
	add x4, x14, 16

	bl r

	mov x1, 14
	mov x2, 18
 	add x3, x13, 60
	add x4, x14, 18

	bl r

	mov x1, 12
	mov x2, 24
	add x3, x13, 78
	add x4, x14, 20
	
	bl r 
	
	mov x1, 20
	mov x2, 4
	add x3, x13, 102
	add x4, x14, 12

	bl r 
	
	mov x1, 6
	mov x2, 4
	add x3, x13, 106
	add x4, x14, 30 

	bl r 

	mov x1, 16
	add x4, x14, 10

	bl r

	mov x1, 8
	add x3, x13, 110
	add x4, x14, 8

	bl r 
	
	mov x1, 2
	mov x2, 2
	add x3, x13, 104
	add x4, x14, 32

	bl r 

	
	mov x15, x9 	// shadow

	mov x1, 4
	mov x2, 2
	add x3, x13, 2
	add x4, x14, 26

	bl r
	
	add x3, x13, 4
	add x4, x14, 28
	
	bl r 
	
	mov x2, 4
	add x3, x13, 6
	add x4, x14, 30

	bl r

	add x3, x13, 10
	add x4, x14, 32
	
	bl r 	

	mov x1, 6
	mov x2, 18
	add x3, x13, 12
	
	bl r 

	mov x1, 8
	mov x2, 8
	add x3, x13, 30
	add x4, x14, 30

	bl r

	mov x1, 6
	mov x2, 2
	add x3, x13, 38
	add x4, x14, 32

	bl r 
	
	mov x1, 4
	mov x2, 6
	add x3, x13, 40
	add x4, x14, 34

	bl r 

	mov x1, 2
	mov x2, 12

	bl r 

	mov x1, 6 
	mov x2, 4
	add x4, x14, 38

	bl r 

	mov x1, 4
	mov x2, 2
	add x3, x13, 44
	add x4, x14, 42

	bl r 

	add x3, x13, 46
	add x4, x14, 44 

	bl r 
	
	add x3, x13, 48
	
	bl r

	mov x2, 6
	add x3, x13, 50
	add x4, x14, 46

	bl r 

	add x3, x13, 56
	add x4, x14, 48
	
	bl r 	

	mov x1, 8
	mov x2, 4
	add x3, x13, 60
	add x4, x14, 42

	bl r 

	add x3, x13, 58
	add x4, x14, 36
	
	bl r 

	mov x1, 2
	mov x2, 2
	add x3, x13, 50
	add x4, x14, 44

	bl r 

	mov x1, 4
	add x3, x13, 52
	add x4, x14, 32

	bl r

	mov x1, 6
	add x3, x13, 54
	
	bl r 

	mov x1, 8
	mov x2, 6
	add x3, x13, 56
	add x4, x14, 30

	bl r 

	mov x1, 6
	mov x2, 22
	add x3, x13, 62
	add x4, x14, 32

	bl r 

	mov x1, 2
	mov x2, 8
	add x3, x13, 76
	add x4, x14, 30
	
	bl r 

	mov x1, 8
	mov x2, 12
	add x3, x13, 84
	add x4, x14, 28

	bl r 

	mov x2, 4
	add x3, x13, 96
	add x4, x14, 30

	bl r 

	add x3, x13, 100
	add x4, x14, 32

	bl r 
	
	mov x1, 6
	mov x2, 2
	add x3, x13, 104
	add x4, x14, 34

	bl r 

	mov x1, 4
	mov x2, 6 
	add x3, x13, 106
	add x4, x14, 36

	bl r

	mov x15, x10 	// highlights ----------

	mov x1, 2
	mov x2, 2
	add x3, x13, 2
	add x4, x14, 24
	
	bl r 

	mov x2, 4
	add x3, x13, 4
	add x4, x14, 22
	
	bl r 

	add x3, x13, 8
	add x4, x14, 20
	
	bl r 

	mov x2, 10
	add x3, x13, 12
	add x4, x14, 18

	bl r 
	
	add x3, x13, 20
	add x4, x14, 16

	bl r 

	mov x1, 2
	mov x2, 2
	add x3, x13, 30
	add x4, x14, 14

	bl r 

	add x3, x13, 34
	add x4, x14, 8

	bl r 

	mov x1, 4
	add x3, x13, 32
	add x4, x14, 10

	bl r 

	mov x2, 8
	add x3, x13, 36
	add x4, x14, 4

	bl r 

	add x3, x13, 44
	add x4, x14, 2
	
	bl r
 	
	mov x1, 2
	mov x2, 2	
	add x3, x13, 52	
	add x4, x14, 2

	bl r 

	mov x2, 4
	add x3, x13, 58
	add x4, x14, 16

	bl r 

	mov x2, 16
	add x3, x13, 62
	add x4, x14, 18

	bl r 

	mov x2, 10
	add x3, x13, 78
	add x4, x14, 20

	bl r 

	add x3, x13, 88
	add x4, x14, 22

	bl r 
	
	mov x1, 4
	mov x2, 4
	add x3, x13, 96
	add x4, x14, 18

	bl r 

	add x3, x13, 110
	add x4, x14, 4
	
	bl r 

	add x3, x13, 106
	add x4, x14, 6
	
	bl r 

	add x3, x13, 102
	add x4, x14, 8

	bl r 

	add x3, x13, 100
	add x4, x14, 10

	bl r 
	
	mov x1, 6
	add x3, x13, 98
	add x4, x14, 14

	bl r 

	mov x15, 0 // outline 

	mov x2, 2
	mov x1, 6
	add x3, x13, 0
	add x4, x14, 24

	bl r 

	add x3, x13, 36
	add x4, x14, 34
	
	bl r 
	
	add x3, x13, 50
	add x4, x14, 8

	bl r 

	add x3, x13, 64
	add x4, x14, 46
	
	bl r 

	add x3, x13, 114
	add x4, x14, 6

	bl r 
	
	add x3, x13, 108
	add x4, x14, 20

	bl r

	mov x1, 2
	mov x2, 2
	add x3, x13, 2
	add x4, x14, 22

	bl r 

	add x4, x14, 30

	bl r 

	add x3, x13, 32
	add x4, x14, 8

	bl r 

	add x3, x13, 34
	add x4, x14, 6

	bl r

	add x3, x13, 40
	add x4, x14, 42

	bl r

	add x3, x13, 96
	add x4, x14, 18

	bl r

	add x3, x13, 112
	add x4, x14, 38

	bl r

	mov x1, 2
	mov x2, 4
	add x3, x13, 4
	add x4, x14, 20

	bl r 

	add x3, x13, 8
	add x4, x14, 18

	bl r 

	add x3, x13, 4
	add x4, x14, 32
	
	bl r

	add x3, x13, 8
	add x4, x14, 34

	bl r

	add x3, x13, 40
	add x4, x14, 44

	bl r 

	add x3, x13, 44
	add x4, x14, 46

	bl r

	add x3, x13, 100
	add x4, x14, 38
	
	bl r

	add x3, x13, 102
	add x4, x14, 8
	
	bl r 

	add x3, x13, 106
	add x4, x14, 6

	bl r 

	add x3, x13, 14
	add x4, x14, 24

	bl r
	
	add x3, x13, 36
	add x4, x14, 4

	bl r

	mov x1, 2
	mov x2, 8
	add x3, x13, 12
	add x4, x14, 16
	
	bl r 

	add x4, x14, 36

	bl r

	add x3, x13, 46
	add x4, x14, 0

	bl r

	add x3, x13, 88
	add x4, x14, 20

	bl r

	add x3, x13, 104
	add x4, x14, 40

	bl r

	mov x1, 4
	mov x2, 2
	add x3, x13, 30
	add x4, x14, 10

	bl r

	add x3, x13, 38
	add x4, x14, 38

	bl r

	add x3, x13, 52
	add x4, x14, 4

	bl r

	add x3, x13, 54
	add x4, x14, 0

	bl r

	add x3, x13, 58
	add x4,	x14, 34

	bl r 

	add x3, x13, 60
	add x4, x14, 38

	bl r

	add x3, x13, 62
	add x4, x14, 42

	bl r

	add x3, x13, 98
	add x4, x14, 14

	bl r

	add x3, x13, 100
	add x4, x14, 10

	bl r

	add x3, x13, 106
	add x4, x14, 26

	bl r

	add x3, x13, 108
	add x4, x14, 30

	bl r

	add x3, x13, 110
	add x4, x14, 34
	
	bl r

	add x4, x14, 16

	bl r

	add x3, x13, 112
	add x4, x14, 12

	bl r

	mov x1, 2
	mov x2, 6
	add x3, x13, 40
	add x4, x14, 2

	bl r

	add x3, x13, 48
	add x4, x14, 48

	bl r

	add x3, x13, 94
	add x4, x14, 36

	bl r

	add x3, x13, 110
	add x4, x14, 4

	bl r

	mov x2, 10
	add x3, x13, 20
	add x4, x14, 14
	
	bl r

	add x3, x13, 52
	add x4, x14, 14

	bl r

	add x3, x13, 54
	add x4, x14, 50

	bl r

	add x3, x13, 62
	add x4, x14, 38

	bl r

	add x3, x13, 84
	add x4, x14, 34
	
	bl r

	add x3, x13, 78
	add x4, x14, 18
	
	bl r

	mov x1, 2
	mov x2, 16
	add x3, x13, 20
	add x4, x14, 38

	bl r

	add x3, x13, 62
	add x4, x14, 16

	bl r

	mov x2, 12
	add x3, x13, 72
	add x4, x14, 36

	bl r	

	br x29
endJaws:



	// Moving fish initial x coord.
	mov x18, 300
	mov x20, 30
	mov x21, 250
	mov x22, 165
	mov x23, 195
	mov x24, 470
	mov x26, 375


// Infinite Loop
InfLoop:
    // deep blue 0x ff 02 15 5d
    movz x15, 0xFF02, lsl 16
    movk x15, 0x158d, lsl 00

    movz x16, 0x10, lsl 0    // # of rows with color
    mov x9, 0        // current rowCount
    mov x0, x25
    mov x2, 300
fondo2:
    mov x1, SCREEN_WIDTH
    add x9, x9, 1

    subs xzr, x9, x16    // sets flags 
    b.ne fondo3         // branch if current rowCount is equal to #rowsWithColor

    mov x9, 0
    lsl x16, x16, 1
    sub x15, x15, 25

fondo3:
    stur w15,[x0]       // Set color of pixel N
    add x0,x0,4       // Next pixel
    sub x1,x1,1       // decrement X counter
    cbnz x1,fondo3       // If not end row jump
    sub x2,x2,1       // Decrement Y counter
    cbnz x2,fondo2       // if not last row, jump

//

	mov x14, 30
	mov x13, x20
	sub x20, x20, 1

	bl jaws
//
	movz x16, 0xd4, lsl 16
	movk x16, 0xd4d4, lsl 0
	
	mov x14, 120
	mov x13, x22
	add x22, x22, 6

	bl fish1

//

	movz x10, 0xd4, lsl 16 
	movk x16, 0xd400, lsl 0

	mov x14, 195
	mov x13, x24
	add x24, x24, 12

	bl fish1

//

	movz x10, 0xff, lsl 16     
	movk x16, 0x00b4, lsl 0

	mov x14, 5
	mov x13, x26
	add x26, x26, 40

	bl fish1

// 
	
	mov x14, 210
	mov x13, x18
	sub x18, x18, 2

	bl jaws
//

	mov x14, 185
	mov x13, x23
	add x23, x23, 3

	bl pufferfish



// registros libres (que no se pisan) x19, x27, x28
	
	

	mov x0, 0
	add x0, x0, 0x1
	mul x0, x0, x17 // Offset para delay, default: 0x5, 
	lsl x0, x0, 20
DelayG:

    cbz x0, InfLoop
    ldur x1, [x25, 0]
    stur w1, [x25, 0]
    sub x0, x0, 1
    b DelayG


    b InfLoop
