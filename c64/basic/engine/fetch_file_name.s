// #LAYOUT# STD *       #TAKE
// #LAYOUT# *   BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE

//
// Fetches file name, Carry set if not found
//


fetch_filename:

	// Check if end of statement

	jsr end_of_statement_check
	bcs fetch_filename_rts

	// Search for opening quote

	jsr basic_fetch_and_consume_character
	cmp #$22
	bne_16 do_SYNTAX_error

	// Filename starts here so set pointer

	lda TXTPTR+0
	sta FNADDR+0
	lda TXTPTR+1
	sta FNADDR+1

	// Now search for end of line or closing quote
	// so that we know the length of the filename

	lda #$00
	sta FNLEN
!:
	jsr basic_fetch_and_consume_character
	cmp #$22
	beq fetch_filename_done
	cmp #$00
	beq !+

	inc FNLEN
	bne !-

!:
	jsr basic_unconsume_character

	// FALLTROUGH

fetch_filename_done:

	clc

	// FALLTROUGH

fetch_filename_rts:

	rts
