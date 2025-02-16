/datum/job
	///Minimum vampire Generation necessary to do this job.
	var/minimal_generation = 13
	///Minimum Masquerade level necessary to do this job.
	var/minimal_masquerade = 1

	///List of species that are allowed to do this job.
	var/list/allowed_species = list("Vampire")
	///List of species that are limited to a certain amount of that species doing this job.
	var/list/species_slots = list()
	///List of Bloodlines that are allowed to do this job.
	var/list/allowed_bloodlines = list("Brujah", "Tremere", "Ventrue", "Nosferatu", "Gangrel", "Toreador", "Malkavian", "Banu Haqim", "Giovanni", "Ministry")

	// List for phone shit
	var/my_contact_is_important = FALSE
	// Only for display in memories
	var/list/known_contacts = list()

	var/duty
	var/v_duty

