/area/vtm
	name = "San Francisco"
	icon = 'code/modules/wod13/tiles.dmi'
	icon_state = "sewer"
	requires_power = FALSE
	has_gravity = STANDARD_GRAVITY
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	var/music
	var/upper = TRUE
	var/zone_type = "masquerade"
	var/zone_owner

/area/vtm/powered(chan)
	if(!requires_power)
		return TRUE
	return FALSE

/area/vtm/proc/break_elysium()
	if(zone_type == "masquerade")
		zone_type = "battle"
		spawn(1800)
			zone_type = "masquerade"
