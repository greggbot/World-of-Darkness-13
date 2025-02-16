/mob/living/carbon
	//imported from other areas around the code
	var/last_moon_look = 0
	var/last_rage_from_attack = 0

	var/last_jump_time = 0
	var/jump_range = 1

	var/last_gnosis_buff = 0
	var/last_rage_gain = 0
	var/last_veil_restore = 0

	var/last_veil_adjusting = 0

	var/celerity_visual = FALSE
	var/potential = 0

	var/obfuscate_level = 0

	var/in_frenzy = FALSE
	var/frenzy_hardness = 1
	var/last_frenzy_check = 0
	var/atom/frenzy_target = null
	var/last_experience = 0

	var/last_rage_hit = 0

	var/datum/auspice/auspice
	var/obj/werewolf_holder/transformation/transformator

	var/list/beastmaster = list()

	var/datum/relationship/MyRelationships

	var/inspired = FALSE

	var/tox_damage_plus = 0
	var/agg_damage_plus = 0

	var/lock_on_by_mannequin = FALSE

	var/diablerist = FALSE
	var/antifrenzy = FALSE
