// #LAYOUT# STD *       #TAKE
// #LAYOUT# X16 BASIC_0 #TAKE
// #LAYOUT# *   *       #IGNORE


// Routine is too long to fit in the original location


initmsg_real:

	// Clear the screen first, some cartridges (like IEEE-488) are leaving a mess on the screen
	lda #147
	jsr JCHROUT

#if CONFIG_BANNER_SIMPLE

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

#if !CONFIG_BRAND_CUSTOM_BUILD

	ldx #$01
	ldy #$04
	jsr plot_set

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

#endif // no CONFIG_BRAND_CUSTOM_BUILD

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$03
#else
	ldx #$02
#endif
	ldy #$04
	jsr plot_set

	jsr initmsg_bytes_free

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$06
#else
	ldx #$05
#endif
	ldy #$00
#if CONFIG_SHOW_FEATURES
	jsr plot_set
	jmp print_features
#else
	jmp plot_set
#endif

#elif CONFIG_BANNER_FANCY
	
	lda #<rainbow_logo
	ldy #>rainbow_logo
	jsr STROUT

	ldx #$00
	ldy #$0A
	jsr plot_set

	lda #<startup_banner
	ldy #>startup_banner
	jsr STROUT

#if !CONFIG_BRAND_CUSTOM_BUILD

	ldx #$01
	ldy #$0A
	jsr plot_set

	ldx #IDX__STR_PRE_REV
	jsr print_packed_misc_str

	lda #<rom_revision_basic_string
	ldy #>rom_revision_basic_string
	jsr STROUT

#endif // no CONFIG_BRAND_CUSTOM_BUILD

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$03
#else
	ldx #$02
#endif
	ldy #$0A
	jsr plot_set

	jsr initmsg_bytes_free

#if !CONFIG_BRAND_CUSTOM_BUILD
	ldx #$06
#else
	ldx #$05
#endif
	ldy #$00
#if CONFIG_SHOW_FEATURES
	jsr plot_set
	jmp print_features
#else
	jmp plot_set
#endif

#endif
