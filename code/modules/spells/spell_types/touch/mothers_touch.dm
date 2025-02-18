/obj/item/melee/touch_attack/mothers_touch
	name = "\improper mother's touch"
	desc = "That's the bottom line, because Gaia said so!"
	hitsound = 'code/modules/wod13/sounds/restore_cast.ogg'
	icon_state = "fleshtostone"
	inhand_icon_state = "fleshtostone"

/obj/item/melee/touch_attack/mothers_touch/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity || target == user || !isliving(target) || !iscarbon(user)) //getting hard after touching yourself would also be bad
		return
	if(!(user.mobility_flags & MOBILITY_USE))
		to_chat(user, "<span class='warning'>You can't reach out!</span>")
		return
	var/mob/living/M = target
	if(HAS_TRAIT(M, TRAIT_ANTIMAGIC))
		to_chat(user, "<span class='warning'>The spell can't seem to affect [M]!</span>")
		to_chat(M, "<span class='warning'>You feel your flesh turn to stone for a moment, then revert back!</span>")
		..()
		return
	M.adjustBruteLoss(-100, TRUE)
	M.adjustFireLoss(-30, TRUE)
	M.adjustToxLoss(-50, TRUE)
	M.adjustOxyLoss(-50, TRUE)
	if(ishuman(M))
		var/mob/living/carbon/human/BD = M
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
		if(length(BD.all_wounds))
			var/datum/wound/W = pick(BD.all_wounds)
			W.remove_wound()
	return ..()

