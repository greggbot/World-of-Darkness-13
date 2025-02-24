/obj/structure/closet/secure_closet/personal
	desc = "It's a secure locker for personnel. The first person to swipe their ID gains control."
	name = "personal closet"
	req_access = list(ACCESS_ALL_PERSONAL_LOCKERS)
	card_reader_installed = TRUE

/obj/structure/closet/secure_closet/personal/Initialize(mapload)
	. = ..()
	var/static/list/choices
	if(isnull(choices))
		choices = list("Personal")
	access_choices = choices

/obj/structure/closet/secure_closet/personal/can_unlock(mob/living/user, obj/item/card/id/player_id, obj/item/card/id/registered_id)
	if(isnull(registered_id)) //first time anyone can unlock
		return TRUE
	else
		if(allowed(user)) //players with ACCESS_ALL_PERSONAL_LOCKERS can override your ID
			return TRUE
		return player_id == registered_id

/obj/structure/closet/secure_closet/personal/PopulateContents()
	..()
	if(prob(50))
		new /obj/item/storage/backpack/duffelbag(src)
	if(prob(50))
		new /obj/item/storage/backpack(src)
	else
		new /obj/item/storage/backpack/satchel(src)

/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/PopulateContents()
	new /obj/item/clothing/under/color/white( src )
	new /obj/item/clothing/shoes/sneakers/white( src )

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	icon = 'icons/obj/closet_high.dmi'
	resistance_flags = FLAMMABLE
	max_integrity = 70
	open_sound = 'sound/machines/wooden_closet_open.ogg'
	close_sound = 'sound/machines/wooden_closet_close.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	door_anim_time = 0 // no animation

<<<<<<< HEAD
/obj/structure/closet/secure_closet/personal/attackby(obj/item/W, mob/user, params)
	var/obj/item/card/id/I = W.GetID()
	if(istype(I))
		if(broken)
			to_chat(user, "<span class='danger'>It appears to be broken.</span>")
			return
		if(!I || !I.registered_name)
			return
		if(allowed(user) || !registered_name || (istype(I) && (registered_name == I.registered_name)))
			//they can open all lockers, or nobody owns this, or they own this locker
			locked = !locked
			update_icon()

			if(!registered_name)
				registered_name = I.registered_name
				desc = "Owned by [I.registered_name]."
		else
			to_chat(user, "<span class='danger'>Access Denied.</span>")
	else
		return ..()
=======
/obj/structure/closet/secure_closet/personal/cabinet/PopulateContents()
	new /obj/item/storage/backpack/satchel/leather/withwallet( src )
	new /obj/item/instrument/piano_synth(src)
	new /obj/item/radio/headset( src )
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
