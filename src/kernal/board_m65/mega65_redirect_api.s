// #LAYOUT# M65 KERNAL_0 #TAKE
// #LAYOUT# *   *        #IGNORE

//
// ROM routine call redirect for Mega65 API routines
//

M65_MODE64:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_MODE64
	bra     m65_api_end

M65_MODE65:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_MODE65
	bra     m65_api_end

M65_SCRMODEGET:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_SCRMODEGET
	bra     m65_api_end

M65_SCRMODESET:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_SCRMODESET
	bra     m65_api_end

M65_CLRSCR:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_CLRSCR
	bra     m65_api_end

M65_CLRWIN:

	jsr     map_KERNAL_1
	jsr_ind VK1__M65_CLRWIN

	// FALLTROUGH

m65_api_end:

	jmp     map_NORMAL
