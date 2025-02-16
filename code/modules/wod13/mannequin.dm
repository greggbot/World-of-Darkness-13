/datum/species/vamp_mannequin
	name = "mannequin"
	id = "mannequin"
	inherent_traits = list(TRAIT_GODMODE, TRAIT_NO_EYELIDS,TRAIT_NOBLOOD, TRAIT_NO_UNDERWEAR, TRAIT_VIRUSIMMUNE,TRAIT_NOHUNGER,TRAIT_NOBREATH,TRAIT_TOXIMMUNE,TRAIT_NOCRITDAMAGE,TRAIT_ADVANCEDTOOLUSER,TRAIT_RESISTHEAT,TRAIT_NOBREATH,TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_NOFIRE,TRAIT_CHUNKYFINGERS,TRAIT_RADIMMUNE,TRAIT_GENELESS,TRAIT_PIERCEIMMUNE)
	inherent_biotypes = MOB_HUMANOID
	payday_modifier = 0.75
	siemens_coeff = 0
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_PRIDE | MIRROR_MAGIC
	meat = /obj/item/food/meat/slab/human/mutant/golem
	sexes = 1

/datum/species/vamp_mannequin/on_species_gain(mob/living/carbon/human/human_who_gained_species, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	human_who_gained_species.skin_tone = "albino"
	human_who_gained_species.update_body_parts()
	human_who_gained_species.update_body()
	human_who_gained_species.update_icon()
	human_who_gained_species.dna.real_name = "mannequin"
	human_who_gained_species.real_name = "mannequin"
	human_who_gained_species.true_real_name = "mannequin"
	human_who_gained_species.real_name = "mannequin"

/datum/species/vamp_mannequin/check_roundstart_eligible()
	return FALSE

/datum/species/vamp_mannequin/spec_life(mob/living/carbon/human/H)
	. = ..()
	var/turf/T = get_turf(H)
	var/light_amount = T.get_lumcount()
	var/area/vtm/V = get_area(H)
	if(!V.upper)
		if(light_amount < 0.2)
			do_spooky(H)
		else
			walk_to(H, 0)
	else
		walk_to(H, 0)

/datum/species/vamp_mannequin/proc/do_spooky(var/mob/living/carbon/human/man)
	for(var/mob/living/L in range(7, man))
		if(L.client)
			man.face_atom(L)
			if(prob(50))
				step(man, L)

	for(var/mob/living/carbon/human/H in range(1, man))
		if(H.client)
			if(!H.lock_on_by_mannequin)
				H.lock_on_by_mannequin = TRUE
				man.forceMove(get_turf(H))
				if(get_dist(man, H) < 2)
					var/obj/item/bodypart/affected = H.get_bodypart(pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
					if(affected != null)
						man.visible_message("[man] slices off [H]'s [affected]!", "<span class='notice'>You slice [man]'s [affected] off.</span>")
						affected.dismember(BRUTE)
					H.lock_on_by_mannequin = FALSE

	if(prob(33))
		var/turf/T = get_step(man, pick(NORTH, SOUTH, WEST, EAST))
		step_to(man,T,0)
