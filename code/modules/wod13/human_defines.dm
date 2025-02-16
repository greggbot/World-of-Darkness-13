/mob/living/carbon/human
	var/datum/vampireclane/clane

	var/last_repainted_mark

	//var/given_penis = FALSE

	///Performs CPR on the target after a delay. //[Lucia] what does this mean?
	var/last_cpr_exp = 0

	var/dementia = FALSE

	//[Lucia] I have no clue why this is necessary, TODO: remove
	var/mob/living/caster

	var/datum/job/JOB
	var/roundstart_vampire = FALSE
	var/last_loot_check = 0

	var/phonevoicetag = 10

	var/hided = FALSE
	var/additional_hands = FALSE
	var/additional_wings = FALSE
	var/additional_centipede = FALSE
	var/additional_armor = FALSE

	var/unique_body_sprite

	var/image/suckbar
	var/atom/suckbar_loc

	var/last_showed = 0
	var/last_raid = 0
	var/killed_count = 0

	var/base_body_mod = ""
	var/icon/body_sprite

	bloodquality = 2

	var/soul_state = SOUL_PRESENT

	var/can_be_embraced = TRUE

	yang_chi = 4
	max_yang_chi = 4
	yin_chi = 2
	max_yin_chi = 2
