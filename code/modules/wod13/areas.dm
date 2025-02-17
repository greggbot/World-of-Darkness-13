/area/proc/fire_extinguishment()
	if(fire_controling)
		return
	fire_controling = TRUE
	playsound(src, 'sound/effects/alert.ogg', 100, FALSE)
	set_fire_alarm_effect()
	for(var/turf/open/O in src)
		new /obj/effect/decal/firecontrol(O)
	spawn(300)
		unset_fire_alarm_effects()
		fire_controling = FALSE
		for(var/obj/effect/decal/firecontrol/F in src)
			if(F)
				qdel(F)
