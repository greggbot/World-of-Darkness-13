/datum/hallucination/dangerflash

/datum/hallucination/dangerflash/New(mob/living/carbon/C, forced = TRUE, danger_type)
	set waitfor = FALSE
	..()
	//Flashes of danger

	var/list/possible_points = list()
	for(var/turf/open/floor/F in view(hallucinator,world.view))
		possible_points += F
	if(possible_points.len)
		var/turf/open/floor/danger_point = pick(possible_points)
		if(!danger_type)
			danger_type = pick("lava","chasm","anomaly")
		switch(danger_type)
			if("lava")
				new /datum/hallucination/danger/lava(danger_point, hallucinator)
			if("chasm")
				new /datum/hallucination/danger/chasm(danger_point, hallucinator)
			if("anomaly")
				new /datum/hallucination/danger/anomaly(danger_point, hallucinator)

	qdel(src)

/datum/hallucination/danger
	var/image/image

/datum/hallucination/danger/proc/show_icon()
	return

/datum/hallucination/danger/proc/clear_icon()
	if(image && hallucinator.client)
		hallucinator.client.images -= image

/datum/hallucination/danger/New(mob/living/hallucinator)
	. = ..()
	show_icon()
	QDEL_IN(src, rand(200, 450))

/datum/hallucination/danger/Destroy()
	clear_icon()
	. = ..()

/datum/hallucination/danger/lava

/datum/hallucination/danger/lava/New(mob/living/hallucinator)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSS, PROC_REF(on_cross))

/datum/hallucination/danger/lava/show_icon()
	image = image('icons/turf/floors/lava.dmi', src, "lava-0")
	if(hallucinator.client)
		hallucinator.client.images += image

/datum/hallucination/danger/lava/proc/on_cross(atom/movable/AM)
	if(AM == hallucinator)
		hallucinator.adjustStaminaLoss(20)
		new /datum/hallucination/fire(hallucinator)

/datum/hallucination/danger/chasm

/datum/hallucination/danger/chasm/New(mob/living/hallucinator)
	. = ..()
	RegisterSignal(src, COMSIG_MOVABLE_CROSS, PROC_REF(on_cross))

/datum/hallucination/danger/chasm/show_icon()
	var/turf/hallucinator_loc = get_turf(hallucinator)
	image = image('icons/turf/floors/chasms.dmi', src, "chasms-[hallucinator_loc.smoothing_junction]")
	if(hallucinator.client)
		hallucinator.client.images += image

/datum/hallucination/danger/chasm/proc/on_cross(atom/movable/AM)
	if(AM == hallucinator)
		if(istype(hallucinator, /obj/effect/dummy/phased_mob))
			return
		to_chat(hallucinator, "<span class='userdanger'>You fall into the chasm!</span>")
		hallucinator.Paralyze(40)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), hallucinator, "<span class='notice'>It's surprisingly shallow.</span>"), 15)
		QDEL_IN(src, 30)

/datum/hallucination/danger/anomaly

/datum/hallucination/danger/anomaly/New()
	. = ..()
	START_PROCESSING(SSobj, src)
	RegisterSignal(src, COMSIG_MOVABLE_CROSS, PROC_REF(on_cross))

/datum/hallucination/danger/anomaly/process(seconds_per_tick)
	if(SPT_PROB(45, seconds_per_tick))
		step(src,pick(GLOB.alldirs))

/datum/hallucination/danger/anomaly/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/hallucination/danger/anomaly/show_icon()
	image = image('icons/effects/effects.dmi',src,"electricity2",OBJ_LAYER+0.01)
	if(hallucinator.client)
		hallucinator.client.images += image

/datum/hallucination/danger/anomaly/proc/on_cross(atom/movable/AM)
	if(AM == hallucinator)
		new /datum/hallucination/shock(hallucinator)
