/// Fully randomizes everything in the character.
/datum/preferences/proc/randomise_appearance_prefs(randomize_flags = ALL)
	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (!preference.included_in_randomization_flags(randomize_flags))
			continue

<<<<<<< HEAD
	//The mob should have a gender you want before running this proc. Will run fine without H
/datum/preferences/proc/random_character(gender_override, antag_override = FALSE)
	if(randomise[RANDOM_SPECIES])
		random_species()
	else if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)
	if(gender_override && !(randomise[RANDOM_GENDER] || randomise[RANDOM_GENDER_ANTAG] && antag_override))
		gender = gender_override
	else
		gender = pick(MALE,FEMALE)
	if(randomise[RANDOM_AGE] || randomise[RANDOM_AGE_ANTAG] && antag_override)
		age = rand(AGE_MIN,AGE_MAX)
	if(randomise[RANDOM_UNDERWEAR])
		underwear = random_underwear(gender)
	if(randomise[RANDOM_UNDERWEAR_COLOR])
		underwear_color = random_short_color()
	if(randomise[RANDOM_UNDERSHIRT])
		undershirt = random_undershirt(gender)
	if(randomise[RANDOM_SOCKS])
		socks = random_socks()
	if(randomise[RANDOM_BACKPACK])
		backpack = random_backpack()
	if(randomise[RANDOM_JUMPSUIT_STYLE])
		jumpsuit_style = pick(GLOB.jumpsuitlist)
	if(randomise[RANDOM_HAIRSTYLE])
		if(clane.no_hair)
			hairstyle = "Bald"
		else if(clane.haircuts)
			hairstyle = pick(clane.haircuts)
		else
			hairstyle = random_hairstyle(gender)
	if(randomise[RANDOM_FACIAL_HAIRSTYLE])
		if(clane.no_facial)
			facial_hairstyle = "Shaved"
		else
			facial_hairstyle = random_facial_hairstyle(gender)
	if(randomise[RANDOM_HAIR_COLOR])
		hair_color = random_short_color()
	if(randomise[RANDOM_FACIAL_HAIR_COLOR])
		facial_hair_color = random_short_color()
	if(randomise[RANDOM_SKIN_TONE])
		skin_tone = random_skin_tone()
	if(randomise[RANDOM_EYE_COLOR])
		eye_color = random_eye_color()
	if(!pref_species)
		var/rando_race = pick(GLOB.roundstart_races)
		pref_species = new rando_race()
	features = random_features()
	if(gender in list(MALE, FEMALE))
		body_type = gender
	else
		body_type = pick(MALE, FEMALE)

/datum/preferences/proc/random_species()
	var/random_species_type = GLOB.species_list[pick(GLOB.roundstart_races)]
	pref_species = new random_species_type
	if(randomise[RANDOM_NAME])
		real_name = pref_species.random_name(gender,1)
	if(pref_species.id == "ghoul")
		discipline_types = list()
		discipline_levels = list()
	if(pref_species.id == "kindred")
		qdel(clane)
		clane = new /datum/vampireclane/brujah()
		discipline_types = list()
		discipline_levels = list()
		for (var/i in 1 to clane.clane_disciplines.len)
			discipline_types += clane.clane_disciplines[i]
			discipline_levels += 1
=======
		if (preference.is_randomizable())
			write_preference(preference, preference.create_random_value(src))

/// Randomizes the character according to preferences.
/datum/preferences/proc/apply_character_randomization_prefs(antag_override = FALSE)
	switch (read_preference(/datum/preference/choiced/random_body))
		if (RANDOM_ANTAG_ONLY)
			if (!antag_override)
				return
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441

		if (RANDOM_DISABLED)
			return

	for (var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if (should_randomize(preference, antag_override))
			write_preference(preference, preference.create_random_value(src))

///Setup the random hardcore quirks and give the character the new score prize.
/datum/preferences/proc/hardcore_random_setup(mob/living/carbon/human/character)
	var/next_hardcore_score = select_hardcore_quirks()
	character.hardcore_survival_score = next_hardcore_score ** 1.2  //30 points would be about 60 score
	log_game("[character] started hardcore random with [english_list(all_quirks)], for a score of [next_hardcore_score].")

	//Add a sixpack because honestly
	var/obj/item/bodypart/chest/chest = character.get_bodypart(BODY_ZONE_CHEST)
	chest.add_bodypart_overlay(new /datum/bodypart_overlay/simple/sixpack() )

/**
 * Goes through all quirks that can be used in hardcore mode and select some based on a random budget.
 * Returns the new value to be gained with this setup, plus the previously earned score.
 **/
/datum/preferences/proc/select_hardcore_quirks()
	. = 0

	var/quirk_budget = rand(8, 35)

	all_quirks = list() //empty it out

	var/list/available_hardcore_quirks = SSquirks.hardcore_quirks.Copy()

	while(quirk_budget > 0)
		for(var/i in available_hardcore_quirks) //Remove from available quirks if its too expensive.
			var/datum/quirk/available_quirk = i
			if(available_hardcore_quirks[available_quirk] > quirk_budget)
				available_hardcore_quirks -= available_quirk

		if(!available_hardcore_quirks.len)
			break

		var/datum/quirk/picked_quirk = pick(available_hardcore_quirks)

		var/picked_quirk_blacklisted = FALSE
		for(var/bl in GLOB.quirk_blacklist) //Check if the quirk is blacklisted with our current quirks. quirk_blacklist is a list of lists.
			var/list/blacklist = bl
			if(!(picked_quirk in blacklist))
				continue
			for(var/quirk_name in all_quirks) //Go through all the quirks we've already selected to see if theres a blacklist match
				var/selected_quirk = SSquirks.quirks[quirk_name]
				if((selected_quirk in blacklist) && !(selected_quirk == picked_quirk)) //two quirks have lined up in the list of the list of quirks that conflict with each other, so return (see quirks.dm for more details)
					picked_quirk_blacklisted = TRUE
					break
			if(picked_quirk_blacklisted)
				break

		if(picked_quirk_blacklisted)
			available_hardcore_quirks -= picked_quirk
			continue

		if((initial(picked_quirk.quirk_flags) & QUIRK_MOODLET_BASED) && CONFIG_GET(flag/disable_human_mood)) //check for moodlet quirks
			available_hardcore_quirks -= picked_quirk
			continue

		all_quirks += initial(picked_quirk.name)
		quirk_budget -= available_hardcore_quirks[picked_quirk]
		. += available_hardcore_quirks[picked_quirk]
		available_hardcore_quirks -= picked_quirk

/// Returns what job is marked as highest
/datum/preferences/proc/get_highest_priority_job()
	var/datum/job/preview_job
	var/highest_pref = 0

	for(var/job in job_preferences)
		if(job_preferences[job] > highest_pref)
			preview_job = SSjob.GetJob(job)
			highest_pref = job_preferences[job]
		if(job == SSjob.overflow_role)
			if(job_preferences[SSjob.overflow_role] == JP_LOW)
				previewJob = SSjob.GetJob(job)
				highest_pref = job_preferences[job]

	return preview_job

/datum/preferences/proc/render_new_preview_appearance(mob/living/carbon/human/dummy/mannequin, show_job_clothes = TRUE)
	var/datum/job/no_job = SSjob.GetJobType(/datum/job/unassigned)
	var/datum/job/preview_job = get_highest_priority_job() || no_job

	if(preview_job)
		// Silicons only need a very basic preview since there is no customization for them.
		if (istype(preview_job,/datum/job/ai))
			return image('icons/mob/silicon/ai.dmi', icon_state = resolve_ai_icon(read_preference(/datum/preference/choiced/ai_core_display)), dir = SOUTH)
		if (istype(preview_job,/datum/job/cyborg))
			return image('icons/mob/silicon/robots.dmi', icon_state = "robot", dir = SOUTH)

	// Set up the dummy for its photoshoot
<<<<<<< HEAD
	var/mob/living/carbon/human/dummy/mannequin = generate_or_wait_for_human_dummy(DUMMY_HUMAN_SLOT_PREFERENCES)
	var/mutable_appearance/MAMA = mutable_appearance('code/modules/wod13/64x32.dmi', "slot", layer = SPACE_LAYER)
	MAMA.pixel_x = -16
	mannequin.add_overlay(MAMA)
	copy_to(mannequin, 1, TRUE, TRUE)
	if(clane.alt_sprite)
		mannequin.dna.species.limbs_id = clane.alt_sprite
//	else
//		mannequin.dna.species.limbs_id = initial(pref_species.limbs_id)
	if(clane.no_hair)
		mannequin.facial_hairstyle = "Shaved"
		mannequin.hairstyle = "Bald"
		mannequin.update_hair()
	mannequin.update_body()
	mannequin.update_body_parts()
	mannequin.update_icon()
=======
	apply_prefs_to(mannequin, TRUE)
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441

	mannequin.job = preview_job.title
	mannequin.dress_up_as_job(
		equipping = show_job_clothes ? preview_job : no_job,
		visual_only = TRUE,
		player_client = parent,
		consistent = TRUE,
	)

	// Apply visual quirks
	// Yes we do it every time because it needs to be done after job gear
	if(SSquirks?.initialized)
		// And yes we need to clean all the quirk datums every time
		mannequin.cleanse_quirk_datums()
		for(var/quirk_name as anything in all_quirks)
			var/datum/quirk/quirk_type = SSquirks.quirks[quirk_name]
			if(!(initial(quirk_type.quirk_flags) & QUIRK_CHANGES_APPEARANCE))
				continue
			mannequin.add_quirk(quirk_type, parent)

	return mannequin.appearance
