/datum/language/hebrew
	name = "Hebrew"
	desc = "The language of the ancient Hebrews."
	key = "h"
	space_chance = 50
	syllables = list(
		"sha", "vu", "nah", "ha", "yom", "ma", "cha", "ar", "et", "mol", "lua",
		"ch", "na", "sh", "ni", "yah", "bes", "ol", "hish", "ev", "la", "ot", "la",
		"khe", "tza", "chak", "hak", "hin", "hok", "lir", "tov", "yef", "yfe",
		"cho", "ar", "kas", "kal", "ra", "lom", "im", "bok",
		"erev", "shlo", "lo", "ta", "im", "yom"
	)
<<<<<<< HEAD:code/modules/language/hebrew.dm
	icon_state = "hebrew"
=======
	special_characters = list("'")
	icon_state = "golem"
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441:code/modules/language/terrum.dm
	default_priority = 90

/datum/language/terrum/get_random_name(
	gender = NEUTER,
	name_count = default_name_count,
	syllable_min = default_name_syllable_min,
	syllable_max = default_name_syllable_max,
	force_use_syllables = FALSE,
)
	if(force_use_syllables)
		return ..()

	var/name = pick(GLOB.golem_names)
	// 3% chance to be given a human surname for "lore reasons"
	if (prob(3))
		name += " [pick(GLOB.last_names)]"
	return name
