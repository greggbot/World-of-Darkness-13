/mob/living/carbon/human/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	. = ..()
	if(message)
//		if(istype(loc, /obj/effect/dummy/chameleon))
//			var/obj/effect/dummy/chameleon/C = loc
//			C.say("[message]")
//			return
		if(say_mod(message) == verb_yell)
			for(var/mob/living/carbon/human/hum in hearers(5, src))
				if(hum != src)
					if(iscathayan(hum))
						if(hum.mind?.dharma?.Po == "Legalist")
							hum.mind.dharma.roll_po(src, hum)
		if(length(GLOB.auspex_list))
			for(var/mob/living/carbon/human/H in GLOB.auspex_list)
				if(H)
					to_chat(H, "<span class='scream_away'><b>[name]</b> says, \"[sanitize_text(message)]\"</span>")
		if(prob(25))
			if(iskindred(src))
				if(clane)
					if(clane.name == "Malkavian")
						for(var/mob/living/carbon/human/H in GLOB.malkavian_list)
							if(H)
//							if(H != src)
								to_chat(H, "<span class='ghostalert'>[sanitize_text(message)]</span>")
//		var/ending = copytext_char(message, -1)
//		var/list/message_mods = list()
//		message = get_message_mods(message, message_mods)
//		if(message_mods[WHISPER_MODE] != MODE_WHISPER)
//			if(ending == "?")
//				if(gender == FEMALE)
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/female_ask1.ogg', 'code/modules/wod13/sounds/female_ask2.ogg'), 75, TRUE)
//				else
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/male_ask1.ogg', 'code/modules/wod13/sounds/male_ask2.ogg'), 75, TRUE)
//			else if(ending == "!")
//				if(gender == FEMALE)
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/female_yell1.ogg', 'code/modules/wod13/sounds/female_yell2.ogg'), 100, TRUE)
//				else
//					playsound(get_turf(src), pick('code/modules/wod13/sounds/male_yell1.ogg', 'code/modules/wod13/sounds/male_yell2.ogg'), 100, TRUE)
//			else
//				if(gender == FEMALE)
//					playsound(get_turf(src), 'code/modules/wod13/sounds/female_speak.ogg', 75, TRUE)
//				else
//					playsound(get_turf(src), 'code/modules/wod13/sounds/male_speak.ogg', 75, TRUE)

/obj/item/chameleon
<<<<<<< HEAD
	name = "Appearance Projector"
	desc = "Use on others to save their appearance, and use on yourself to copy it."
	icon = 'code/modules/wod13/icons.dmi'
	icon_state = "vicissitude"
	flags_1 = CONDUCT_1
	item_flags = ABSTRACT | NOBLUDGEON | DROPDEL
=======
	name = "chameleon projector"
	icon = 'icons/obj/devices/syndie_gadget.dmi'
	icon_state = "shield0"
	obj_flags = CONDUCTS_ELECTRICITY
	item_flags = NOBLUDGEON
	slot_flags = ITEM_SLOT_BELT
	inhand_icon_state = "electronic"
	worn_icon_state = "electronic"
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	w_class = WEIGHT_CLASS_SMALL
	var/can_use = 1
	var/obj/effect/dummy/chameleon/active_dummy = null
	var/saved_appearance = null
	var/generated = FALSE

/obj/item/chameleon/Initialize(mapload)
	. = ..()

/obj/item/chameleon/dropped()
	..()
	disrupt()

/obj/item/chameleon/equipped()
	..()
	disrupt()

/obj/item/chameleon/attack_self(mob/user)
	if(!generated)
		saved_appearance = user.appearance
		generated = TRUE
	if (isturf(user.loc) || active_dummy)
		toggle(user)
	else
		to_chat(user, span_warning("You can't use [src] while inside something!"))

<<<<<<< HEAD
/obj/item/chameleon/afterattack(atom/target, mob/user , proximity)
	. = ..()
	if(!proximity)
		return
	if(active_dummy)//I now present you the blackli(f)st
		return
	if(!isliving(target))
		return
=======
/obj/item/chameleon/interact_with_atom(atom/target, mob/living/user, list/modifiers)
	if(!check_sprite(target))
		return ITEM_INTERACT_BLOCKING
	if(active_dummy)//I now present you the blackli(f)st
		return ITEM_INTERACT_BLOCKING
	if(isturf(target))
		return ITEM_INTERACT_BLOCKING
	if(ismob(target))
		return ITEM_INTERACT_BLOCKING
	if(istype(target, /obj/structure/falsewall))
		return ITEM_INTERACT_BLOCKING
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	if(target.alpha != 255)
		return ITEM_INTERACT_BLOCKING
	if(target.invisibility != 0)
<<<<<<< HEAD
		return
	playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
	to_chat(user, "<span class='notice'>Scanned [target].</span>")
	saved_appearance = target.appearance
=======
		return ITEM_INTERACT_BLOCKING
	if(iseffect(target) && !istype(target, /obj/effect/decal)) //be a footprint
		return ITEM_INTERACT_BLOCKING
	make_copy(target, user)
	return ITEM_INTERACT_SUCCESS

/obj/item/chameleon/proc/make_copy(atom/target, mob/user)
	playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, TRUE, -6)
	to_chat(user, span_notice("Scanned [target]."))
	var/obj/temp = new /obj()
	temp.appearance = target.appearance
	temp.layer = initial(target.layer) // scanning things in your inventory
	SET_PLANE_EXPLICIT(temp, initial(plane), src)
	saved_appearance = temp.appearance

/obj/item/chameleon/proc/check_sprite(atom/target)
	if(target.icon_state in icon_states(target.icon))
		return TRUE
	return FALSE
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441

/obj/item/chameleon/proc/toggle(mob/user)
	if(!can_use || !saved_appearance)
		return
	if(active_dummy)
		eject_all()
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		qdel(active_dummy)
		active_dummy = null
<<<<<<< HEAD
		to_chat(user, "<span class='notice'>You deactivate \the [src].</span>")
=======
		to_chat(user, span_notice("You deactivate \the [src]."))
		new /obj/effect/temp_visual/emp/pulse(get_turf(src))
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	else
		playsound(get_turf(src), 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE, -6)
		var/obj/effect/dummy/chameleon/C = new/obj/effect/dummy/chameleon(user.drop_location())
		C.activate(user, saved_appearance, src)
<<<<<<< HEAD
		to_chat(user, "<span class='notice'>You activate \the [src].</span>")
=======
		to_chat(user, span_notice("You activate \the [src]."))
		new /obj/effect/temp_visual/emp/pulse(get_turf(src))
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	user.cancel_camera()

/obj/item/chameleon/proc/disrupt(delete_dummy = 1)
	if(active_dummy)
		for(var/mob/M in active_dummy)
<<<<<<< HEAD
			to_chat(M, "<span class='danger'>Your Appearance Projector deactivates.</span>")
=======
			to_chat(M, span_danger("Your chameleon projector deactivates."))
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread
		spark_system.set_up(5, 0, src)
		spark_system.attach(src)
		spark_system.start()
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
		eject_all()
		if(delete_dummy)
			qdel(active_dummy)
		active_dummy = null
		can_use = FALSE
		addtimer(VARSET_CALLBACK(src, can_use, TRUE), 5 SECONDS)

/obj/item/chameleon/proc/eject_all()
	for(var/atom/movable/A in active_dummy)
		A.forceMove(active_dummy.loc)
		if(ismob(A))
			var/mob/M = A
			M.reset_perspective(null)

/obj/effect/dummy/chameleon
	name = ""
	desc = ""
	density = TRUE
	var/can_move = 0
	var/obj/item/chameleon/master = null

/obj/effect/dummy/chameleon/proc/activate(mob/M, saved_appearance, obj/item/chameleon/C)
	appearance = saved_appearance
	if(istype(M.buckled, /obj/vehicle))
		var/obj/vehicle/V = M.buckled
		V.unbuckle_mob(M, force = TRUE)
	M.forceMove(src)
	master = C
	master.active_dummy = src

/obj/effect/dummy/chameleon/attackby()
	master.disrupt()

//ATTACK HAND IGNORING PARENT RETURN VALUE
/obj/effect/dummy/chameleon/attack_hand(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/chameleon/attack_animal(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/chameleon/attack_alien(mob/user, list/modifiers)
	master.disrupt()

/obj/effect/dummy/chameleon/ex_act(S, T)
	master.disrupt()
	return TRUE

/obj/effect/dummy/chameleon/bullet_act()
	. = ..()
	master.disrupt()

/obj/effect/dummy/chameleon/relaymove(mob/living/user, direction)
	if(!isturf(loc) || isspaceturf(loc) || !direction)
		return //No magical movement! Trust me, this bad boy can do things like leap out of pipes if you're not careful

	if(can_move < world.time)
<<<<<<< HEAD
		can_move = world.time + 10
		step(src, direction)
=======
		var/amount
		switch(user.bodytemperature)
			if(300 to INFINITY)
				amount = 10
			if(295 to 300)
				amount = 13
			if(280 to 295)
				amount = 16
			if(260 to 280)
				amount = 20
			else
				amount = 25

		can_move = world.time + amount
		try_step_multiz(direction)
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	return

/obj/effect/dummy/chameleon/Destroy()
	if(master)
		master.disrupt(0)
		master = null
	return ..()
