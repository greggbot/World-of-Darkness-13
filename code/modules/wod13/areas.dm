/**
 * Trigger the fire alarm visual affects in an area
 *
 * Updates the fire light on fire alarms in the area and sets all lights to emergency mode
 */

/obj/effect/decal/firecontrol
	name = "fire shower"
	icon = 'code/modules/wod13/props.dmi'
	icon_state = "rain"
	plane = GAME_PLANE
	layer = CAR_LAYER
	alpha = 28
	var/last_fire_extinguish = 0

/obj/effect/decal/firecontrol/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/decal/firecontrol/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)

/obj/effect/decal/firecontrol/process(seconds_per_tick)
	if(last_fire_extinguish+30 < world.time)
		last_fire_extinguish = world.time
		for(var/mob/M in get_turf(src))
			if(M)
				SEND_SOUND(M, sound('code/modules/wod13/sounds/rain.ogg', 0, 0, CHANNEL_RAIN, 25))
		for(var/obj/effect/fire/F in get_turf(src))
			if(F)
				qdel(F)

/area/proc/fire_extinguishment()
	if(fire_controling)
		return
	fire_controling = TRUE
	playsound(src, 'sound/effects/alert.ogg', 100, FALSE)
	set_fire_effect(TRUE)
	for(var/turf/open/O in src)
		new /obj/effect/decal/firecontrol(O)
	spawn(300)
		set_fire_effect(FALSE)
		fire_controling = FALSE
		for(var/obj/effect/decal/firecontrol/F in src)
			if(F)
				qdel(F)
