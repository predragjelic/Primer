
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 11,059000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _brzina_servo_H=R6
	.DEF _brzina_servo_L=R9
	.DEF _ugao_servo_H=R8
	.DEF _ugao_servo_L=R11
	.DEF _sum=R10
	.DEF _checksum=R13
	.DEF _greska=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x1B:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x0A
	.DW  _0x1B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 8.11.2014.
;Author  : NeVaDa
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 11,059000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;/*********************Servo makroi*******************/
;#define START 0xFF
;#define ID1 0x01
;#define ID2 0x02
;#define ID3 0x03
;#define ID4 0x04
;#define LENGTH 0x07
;#define INSTR_WRITE 0x03
;#define ADDRESS 0x1E
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;
;#define TXC 6
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0058 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0059 char status,data;
; 0000 005A status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 005B data=UDR0;
	IN   R16,12
; 0000 005C if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 005D    {
; 0000 005E    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 005F #if RX_BUFFER_SIZE0 == 256
; 0000 0060    // special case for receiver buffer size=256
; 0000 0061    if (++rx_counter0 == 0)
; 0000 0062       {
; 0000 0063 #else
; 0000 0064    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0065    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0066       {
; 0000 0067       rx_counter0=0;
	CLR  R7
; 0000 0068 #endif
; 0000 0069       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 006A       }
; 0000 006B    }
_0x5:
; 0000 006C }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0073 {
_getchar:
; 0000 0074 char data;
; 0000 0075 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 0076 data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0077 #if RX_BUFFER_SIZE0 != 256
; 0000 0078 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0079 #endif
; 0000 007A #asm("cli")
_0x9:
	cli
; 0000 007B --rx_counter0;
	DEC  R7
; 0000 007C #asm("sei")
	sei
; 0000 007D return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 007E }
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;
;/****************Lokalne prom****************/
;unsigned char brzina_servo_H, brzina_servo_L, ugao_servo_H, ugao_servo_L;
;unsigned char sum=0;
;unsigned char checksum=0;
;char greska;
;char IdServoGreska;
;char paket1, paket2, paket4, paket6;
;
;/*************FUNKCIJE POTREBNE ZA RAD SERVOA*************/
;void prijem_paketa (void)
; 0000 0090 {
_prijem_paketa:
; 0000 0091     paket1=getchar();
	RCALL _getchar
	STS  _paket1,R30
; 0000 0092     paket2=getchar();
	RCALL _getchar
	STS  _paket2,R30
; 0000 0093 
; 0000 0094     IdServoGreska=getchar();
	RCALL _getchar
	STS  _IdServoGreska,R30
; 0000 0095 
; 0000 0096     paket4=getchar();
	RCALL _getchar
	STS  _paket4,R30
; 0000 0097 
; 0000 0098     greska=getchar();
	RCALL _getchar
	MOV  R12,R30
; 0000 0099 
; 0000 009A     paket6=getchar();
	RCALL _getchar
	STS  _paket6,R30
; 0000 009B }
	RET
;
;void blokiranje_predaje (void)                        //funkcija koja blokira predaju u trenutku kada
; 0000 009E {                                                      // posaljemo ceo paket
_blokiranje_predaje:
; 0000 009F     while ( !( UCSR0A & (1<<TXC)) )   ;    //kada se posalje ceo paket onda se bit 6 registra UCSRA
_0xA:
	SBIS 0xB,6
	RJMP _0xA
; 0000 00A0     UCSR0B.3=0;                            // setuje na 1, potom se UCSRB.3 stavlja na 0, a to je bit koji
	CBI  0xA,3
; 0000 00A1     UCSR0A.6=1;                            //iskljuci TxD i taj pin pinovo postaje PD1, a on je inicijalizovan
	SBI  0xB,6
; 0000 00A2 }
	RET
;
;void oslobadjanje_predaje (void)                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
; 0000 00A5 {
_oslobadjanje_predaje:
; 0000 00A6     UCSR0B.3=1;                            //TxD se opet ukljucuje tako sto se UCSRB.3 bit setuje
	SBI  0xA,3
; 0000 00A7 }
	RET
;                                                 //proizvodjaca mikrokontrolera (datasheet 148 strana)
;void oslobadjanje_prijema (void)
; 0000 00AA {
_oslobadjanje_prijema:
; 0000 00AB     UCSR0B.4=1;                         // bit koji kontrolise oslobadjanje i blokiranje prijema
	SBI  0xA,4
; 0000 00AC }
	RET
;
;void blokiranje_prijema (void)
; 0000 00AF {
_blokiranje_prijema:
; 0000 00B0     UCSR0B.4=0;
	CBI  0xA,4
; 0000 00B1 }
	RET
;
;void servoPosition(int pozicija3, int brzina3)
; 0000 00B4 {
_servoPosition:
; 0000 00B5     ugao_servo_H=(char)(pozicija3>>8);
;	pozicija3 -> Y+2
;	brzina3 -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL __ASRW8
	MOV  R8,R30
; 0000 00B6     ugao_servo_L=(char)(pozicija3&0x00FF);
	LDD  R30,Y+2
	MOV  R11,R30
; 0000 00B7 
; 0000 00B8     brzina_servo_H=(char)(brzina3>>8);
	LD   R30,Y
	LDD  R31,Y+1
	CALL __ASRW8
	MOV  R6,R30
; 0000 00B9     brzina_servo_L=(char)(brzina3&0x00FF);
	LD   R30,Y
	MOV  R9,R30
; 0000 00BA 
; 0000 00BB     sum=0x28 + ID1 + brzina_servo_H + brzina_servo_L + ugao_servo_H + ugao_servo_L; //0x28=LENGTH + INSTR_WRITE + ADDRESS
	MOV  R30,R6
	SUBI R30,-LOW(41)
	ADD  R30,R9
	ADD  R30,R8
	ADD  R30,R11
	MOV  R10,R30
; 0000 00BC     checksum=~sum;
	MOV  R30,R10
	COM  R30
	MOV  R13,R30
; 0000 00BD 
; 0000 00BE     blokiranje_prijema();
	RCALL _blokiranje_prijema
; 0000 00BF     oslobadjanje_predaje();
	RCALL _oslobadjanje_predaje
; 0000 00C0 
; 0000 00C1     putchar(START);
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C2     putchar(START);
	LDI  R30,LOW(255)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C3     putchar(ID1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C4     putchar(LENGTH);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C5     putchar(INSTR_WRITE);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C6     putchar(ADDRESS);
	LDI  R30,LOW(30)
	ST   -Y,R30
	RCALL _putchar
; 0000 00C7     putchar(ugao_servo_L);
	ST   -Y,R11
	RCALL _putchar
; 0000 00C8     putchar(ugao_servo_H);
	ST   -Y,R8
	RCALL _putchar
; 0000 00C9     putchar(brzina_servo_L);
	ST   -Y,R9
	RCALL _putchar
; 0000 00CA     putchar(brzina_servo_H);
	ST   -Y,R6
	RCALL _putchar
; 0000 00CB     putchar(checksum);
	ST   -Y,R13
	RCALL _putchar
; 0000 00CC 
; 0000 00CD     blokiranje_predaje();
	RCALL _blokiranje_predaje
; 0000 00CE     oslobadjanje_prijema();
	RCALL _oslobadjanje_prijema
; 0000 00CF 
; 0000 00D0     prijem_paketa();
	RCALL _prijem_paketa
; 0000 00D1 
; 0000 00D2     oslobadjanje_predaje();
	RCALL _oslobadjanje_predaje
; 0000 00D3 }
	ADIW R28,4
	RET
;
;
;void main(void)
; 0000 00D7 {
_main:
; 0000 00D8 
; 0000 00D9 // Input/Output Ports initialization
; 0000 00DA // Port A initialization
; 0000 00DB // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00DC // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00DD PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00DE DDRA=0x00;
	OUT  0x1A,R30
; 0000 00DF 
; 0000 00E0 // Port B initialization
; 0000 00E1 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E2 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E3 PORTB=0x00;
	OUT  0x18,R30
; 0000 00E4 DDRB=0x00;
	OUT  0x17,R30
; 0000 00E5 
; 0000 00E6 // Port C initialization
; 0000 00E7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00E8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00E9 PORTC=0x00;
	OUT  0x15,R30
; 0000 00EA DDRC=0x00;
	OUT  0x14,R30
; 0000 00EB 
; 0000 00EC // Port D initialization
; 0000 00ED // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00EE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00EF PORTD=0x00;
	OUT  0x12,R30
; 0000 00F0 DDRD=0x00;
	OUT  0x11,R30
; 0000 00F1 
; 0000 00F2 // Port E initialization
; 0000 00F3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00F4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00F5 PORTE=0x00;
	OUT  0x3,R30
; 0000 00F6 DDRE=0x00;
	OUT  0x2,R30
; 0000 00F7 
; 0000 00F8 // Port F initialization
; 0000 00F9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00FA // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00FB PORTF=0x00;
	STS  98,R30
; 0000 00FC DDRF=0x00;
	STS  97,R30
; 0000 00FD 
; 0000 00FE // Port G initialization
; 0000 00FF // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0100 // State4=T State3=T State2=T State1=T State0=T
; 0000 0101 PORTG=0x00;
	STS  101,R30
; 0000 0102 DDRG=0x00;
	STS  100,R30
; 0000 0103 
; 0000 0104 // Timer/Counter 0 initialization
; 0000 0105 // Clock source: System Clock
; 0000 0106 // Clock value: Timer 0 Stopped
; 0000 0107 // Mode: Normal top=0xFF
; 0000 0108 // OC0 output: Disconnected
; 0000 0109 ASSR=0x00;
	OUT  0x30,R30
; 0000 010A TCCR0=0x00;
	OUT  0x33,R30
; 0000 010B TCNT0=0x00;
	OUT  0x32,R30
; 0000 010C OCR0=0x00;
	OUT  0x31,R30
; 0000 010D 
; 0000 010E // Timer/Counter 1 initialization
; 0000 010F // Clock source: System Clock
; 0000 0110 // Clock value: Timer1 Stopped
; 0000 0111 // Mode: Normal top=0xFFFF
; 0000 0112 // OC1A output: Discon.
; 0000 0113 // OC1B output: Discon.
; 0000 0114 // OC1C output: Discon.
; 0000 0115 // Noise Canceler: Off
; 0000 0116 // Input Capture on Falling Edge
; 0000 0117 // Timer1 Overflow Interrupt: Off
; 0000 0118 // Input Capture Interrupt: Off
; 0000 0119 // Compare A Match Interrupt: Off
; 0000 011A // Compare B Match Interrupt: Off
; 0000 011B // Compare C Match Interrupt: Off
; 0000 011C TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 011D TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 011E TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 011F TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0120 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0121 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0122 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0123 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0124 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0125 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0126 OCR1CH=0x00;
	STS  121,R30
; 0000 0127 OCR1CL=0x00;
	STS  120,R30
; 0000 0128 
; 0000 0129 // Timer/Counter 2 initialization
; 0000 012A // Clock source: System Clock
; 0000 012B // Clock value: Timer2 Stopped
; 0000 012C // Mode: Normal top=0xFF
; 0000 012D // OC2 output: Disconnected
; 0000 012E TCCR2=0x00;
	OUT  0x25,R30
; 0000 012F TCNT2=0x00;
	OUT  0x24,R30
; 0000 0130 OCR2=0x00;
	OUT  0x23,R30
; 0000 0131 
; 0000 0132 // Timer/Counter 3 initialization
; 0000 0133 // Clock source: System Clock
; 0000 0134 // Clock value: Timer3 Stopped
; 0000 0135 // Mode: Normal top=0xFFFF
; 0000 0136 // OC3A output: Discon.
; 0000 0137 // OC3B output: Discon.
; 0000 0138 // OC3C output: Discon.
; 0000 0139 // Noise Canceler: Off
; 0000 013A // Input Capture on Falling Edge
; 0000 013B // Timer3 Overflow Interrupt: Off
; 0000 013C // Input Capture Interrupt: Off
; 0000 013D // Compare A Match Interrupt: Off
; 0000 013E // Compare B Match Interrupt: Off
; 0000 013F // Compare C Match Interrupt: Off
; 0000 0140 TCCR3A=0x00;
	STS  139,R30
; 0000 0141 TCCR3B=0x00;
	STS  138,R30
; 0000 0142 TCNT3H=0x00;
	STS  137,R30
; 0000 0143 TCNT3L=0x00;
	STS  136,R30
; 0000 0144 ICR3H=0x00;
	STS  129,R30
; 0000 0145 ICR3L=0x00;
	STS  128,R30
; 0000 0146 OCR3AH=0x00;
	STS  135,R30
; 0000 0147 OCR3AL=0x00;
	STS  134,R30
; 0000 0148 OCR3BH=0x00;
	STS  133,R30
; 0000 0149 OCR3BL=0x00;
	STS  132,R30
; 0000 014A OCR3CH=0x00;
	STS  131,R30
; 0000 014B OCR3CL=0x00;
	STS  130,R30
; 0000 014C 
; 0000 014D // External Interrupt(s) initialization
; 0000 014E // INT0: Off
; 0000 014F // INT1: Off
; 0000 0150 // INT2: Off
; 0000 0151 // INT3: Off
; 0000 0152 // INT4: Off
; 0000 0153 // INT5: Off
; 0000 0154 // INT6: Off
; 0000 0155 // INT7: Off
; 0000 0156 EICRA=0x00;
	STS  106,R30
; 0000 0157 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0158 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0159 
; 0000 015A // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 015B TIMSK=0x00;
	OUT  0x37,R30
; 0000 015C 
; 0000 015D ETIMSK=0x00;
	STS  125,R30
; 0000 015E 
; 0000 015F // USART0 initialization
; 0000 0160 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0161 // USART0 Receiver: On
; 0000 0162 // USART0 Transmitter: On
; 0000 0163 // USART0 Mode: Asynchronous
; 0000 0164 // USART0 Baud Rate: 115200
; 0000 0165 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 0166 UCSR0B=0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
; 0000 0167 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0168 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 0169 UBRR0L=0x05;
	LDI  R30,LOW(5)
	OUT  0x9,R30
; 0000 016A 
; 0000 016B // USART1 initialization
; 0000 016C // USART1 disabled
; 0000 016D UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  154,R30
; 0000 016E 
; 0000 016F // Analog Comparator initialization
; 0000 0170 // Analog Comparator: Off
; 0000 0171 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0172 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0173 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0174 
; 0000 0175 // ADC initialization
; 0000 0176 // ADC disabled
; 0000 0177 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0178 
; 0000 0179 // SPI initialization
; 0000 017A // SPI disabled
; 0000 017B SPCR=0x00;
	OUT  0xD,R30
; 0000 017C 
; 0000 017D // TWI initialization
; 0000 017E // TWI disabled
; 0000 017F TWCR=0x00;
	STS  116,R30
; 0000 0180 
; 0000 0181 // Global enable interrupts
; 0000 0182 #asm("sei")
	sei
; 0000 0183 
; 0000 0184 while (1)
_0x17:
; 0000 0185       {
; 0000 0186            servoPosition(500, 700);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(700)
	LDI  R31,HIGH(700)
	CALL SUBOPT_0x0
; 0000 0187            delay_ms(3500);
; 0000 0188 
; 0000 0189            servoPosition(23, 512);
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(512)
	LDI  R31,HIGH(512)
	CALL SUBOPT_0x0
; 0000 018A            delay_ms(3500);
; 0000 018B       }
	RJMP _0x17
; 0000 018C }
_0x1A:
	RJMP _0x1A
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_IdServoGreska:
	.BYTE 0x1
_paket1:
	.BYTE 0x1
_paket2:
	.BYTE 0x1
_paket4:
	.BYTE 0x1
_paket6:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	ST   -Y,R31
	ST   -Y,R30
	CALL _servoPosition
	LDI  R30,LOW(3500)
	LDI  R31,HIGH(3500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ASRW8:
	MOV  R30,R31
	CLR  R31
	SBRC R30,7
	SER  R31
	RET

;END OF CODE MARKER
__END_OF_CODE:
