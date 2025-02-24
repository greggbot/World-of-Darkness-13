/*
 * Film
 */
/obj/item/camera_film
	name = "film cartridge"
	icon = 'icons/obj/art/camera.dmi'
	desc = "A camera film cartridge. Insert it into a camera to reload it."
	icon_state = "film"
	inhand_icon_state = "electropack"
<<<<<<< HEAD
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	onflooricon = 'code/modules/wod13/onfloor.dmi'
=======
	lefthand_file = 'icons/mob/inhands/items/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items/devices_righthand.dmi'
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	custom_materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT*0.1, /datum/material/glass = SMALL_MATERIAL_AMOUNT*0.1)
