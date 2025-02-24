/mob/living/carbon/can_speak(allow_mimes = FALSE)
	// If we're not a nobreath species, and we don't have lungs, we can't talk
	if(dna?.species && !HAS_TRAIT_FROM(src, TRAIT_NOBREATH, SPECIES_TRAIT) && !get_organ_slot(ORGAN_SLOT_LUNGS))
		// How do species that don't breathe, talk? Magic, that's what.
		return FALSE

	return ..()

<<<<<<< HEAD
/mob/living/carbon/could_speak_language(datum/language/language)
	var/obj/item/organ/tongue/T = getorganslot(ORGAN_SLOT_TONGUE)
	if(T)
		return T.could_speak_language(language)
	else
		return initial(language.flags) & TONGUELESS_SPEECH

/mob/living/carbon/input_say()
	if(overlays_standing[SAY_LAYER])
		return
	var/mutable_appearance/say_overlay = mutable_appearance('icons/mob/talk.dmi', "default0", -SAY_LAYER)
	overlays_standing[SAY_LAYER] = say_overlay
	apply_overlay(SAY_LAYER)
	..()

/mob/living/carbon/say_verb(message as text|null)
	remove_overlay(SAY_LAYER)
	..()
=======
/mob/living/carbon/could_speak_language(datum/language/language_path)
	var/obj/item/organ/internal/tongue/spoken_with = get_organ_slot(ORGAN_SLOT_TONGUE)
	if(spoken_with)
		// the tower of babel needs to bypass the tongue language restrictions without giving omnitongue
		return HAS_MIND_TRAIT(src, TRAIT_TOWER_OF_BABEL) || spoken_with.could_speak_language(language_path)

	return initial(language_path.flags) & TONGUELESS_SPEECH
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
