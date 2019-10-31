
//
// Helper functions for various LOAD/VERIVY/SAVE routine variants (IEC / U64 / etc.)
//


lvs_handle_byte_load_verify:

	ldy VERCKK
	bne lvs_handle_byte_verify

	// As with our BASIC, we want to enable LOADing
	// anywhere in memory, including over the IO space.
	// Thus we have to use a helper routine in low memory
	// to do the memory access

#if CONFIG_MEMORY_MODEL_60K

	// Save byte under ROMs and IO if required
	php
	sei
	ldx #$33
	stx $01
	ldy #0
	sta (STAL),y
	ldx #$37
	stx $01
	plp

#else

	ldy #0
	sta (STAL),y

#endif

	// FALLTROUGH

lvs_handle_byte_load_verify_end:

	clc
	rts


lvs_handle_byte_verify:

#if CONFIG_MEMORY_MODEL_60K

	// Store byte for comparing
	sta TBTCNT

	// Retrieve byte from under ROMs and IO if required
	php
	sei
	ldx #$33
	stx $01
	ldy #0
	lda (STAL),y
	ldx #$37
	stx $01
	plp
	
	// Compare with stored byte
	cmp TBTCNT

#else

	ldy #0
	cmp (STAL),y

#endif

	beq lvs_handle_byte_load_verify_end

	sec
	rts


lvs_advance_pointer:

	// Advance pointer
	inc STAL
	beq !+
	jmp lvs_success_end
!:
	inc STAL+1
	// If we wrap around to $0000, then this is bad.
	bne !+
	jmp lvs_error_end
!:
	clc
	rts


lvs_display_searching_for:

	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_SEARCHING_FOR
	jsr print_kernal_message

	ldy #$00
!:
	cpy FNLEN
	beq lvs_display_end

#if CONFIG_MEMORY_MODEL_60K
	ldx #<FNADDR+0
	jsr peek_under_roms
#else // CONFIG_MEMORY_MODEL_38K
	lda (FNADDR),y
#endif

	jsr JCHROUT
	iny
	jmp !-

lvs_display_end:
	rts


lvs_display_loading_verifying:

	// Display LOADING / VERIFYING and start address
	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_LOADING
	lda VERCKK
	beq !+
	ldx #__MSG_KERNAL_VERIFYING
!:
	jsr print_kernal_message

	// FALLTHROUGH

lvs_display_start_addr:

	ldx #__MSG_KERNAL_FROM_HEX
!:
	jsr print_kernal_message

	lda STAL+1
	jsr print_hex_byte
	lda STAL+0
	jmp print_hex_byte

lvs_display_done:

	// Display end address
	lda MSGFLG
	bpl lvs_display_end

	ldx #__MSG_KERNAL_TO_HEX
	jmp !-

lvs_wrap_around_error:

	// This error is probably not even detected by C64 Kernal;
	// report BASIC error code that looks the most sane
	lda #B_ERR_OVERFLOW

lvs_error_end:

	sec
	rts

lvs_return_last_address:

	// Return last address - Compute's Mapping the 64 says without the '+1',
	// checked (short test program) on original ROMs that this is really the case
	ldx STAL+0
	ldy STAL+1
	// FALLTHROUGH

lvs_success_end:

	clc
	rts

lvs_device_not_found_error:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_DEVICE_NOT_FOUND

lvs_illegal_device_number:

	jsr kernalstatus_DEVICE_NOT_FOUND
	jmp kernalerror_ILLEGAL_DEVICE_NUMBER

lvs_load_verify_error:
	// XXX should we really return BASIC error code here?
	lda VERCKK
	bne lvs_verify_error
	lda #B_ERR_LOAD
	bne lvs_error_end
	// FALLTHROUGH

lvs_verify_error:
	lda #B_ERR_VERIFY
	sec
	rts
