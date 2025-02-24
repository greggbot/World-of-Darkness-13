/obj/item/organ/internal/heart/gland/slime
	abductor_hint = "gastric animation galvanizer. The abductee occasionally vomits slimes. Slimes will no longer attack the abductee."
	cooldown_low = 600
	cooldown_high = 1200
	uses = -1
	icon_state = "slime"
	mind_control_uses = 1
	mind_control_duration = 2400

<<<<<<< HEAD
/obj/item/organ/heart/gland/slime/Insert(mob/living/carbon/M, special = 0)
	..()
	owner.faction |= "slime"
//	owner.grant_language(/datum/language/slime, TRUE, TRUE, LANGUAGE_GLAND)

/obj/item/organ/heart/gland/slime/Remove(mob/living/carbon/M, special = 0)
	owner.faction -= "slime"
	//owner.remove_language(/datum/language/slime, TRUE, TRUE, LANGUAGE_GLAND)
	..()
=======
/obj/item/organ/internal/heart/gland/slime/on_mob_insert(mob/living/carbon/gland_owner)
	. = ..()
	gland_owner.faction |= FACTION_SLIME
	gland_owner.grant_language(/datum/language/slime, source = LANGUAGE_GLAND)

/obj/item/organ/internal/heart/gland/slime/on_mob_remove(mob/living/carbon/gland_owner)
	. = ..()
	gland_owner.faction -= FACTION_SLIME
	gland_owner.remove_language(/datum/language/slime, source = LANGUAGE_GLAND)
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441

/obj/item/organ/internal/heart/gland/slime/activate()
	to_chat(owner, span_warning("You feel nauseated!"))
	owner.vomit(VOMIT_CATEGORY_DEFAULT, lost_nutrition = 20)

	var/mob/living/basic/slime/new_baby_slime = new(get_turf(owner), /datum/slime_type/grey)
	new_baby_slime.befriend(owner)
