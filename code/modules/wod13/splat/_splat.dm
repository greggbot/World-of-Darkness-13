/datum/species
	var/animation_goes_up = FALSE	//PSEUDO_M i have no idea what this does

/datum/splat
	var/power_stat_name = null
	/// Pretty much every splat has a power stat.
	var/power_stat_max = 0
	var/power_stat_current = 0
	/// And they all have special snowflake names.
	var/list/splat_traits = null
	var/integrity_name = "Integrity" //PSEUDO_M move this to minds instead and have splats
	var/integrity_level = 7			 //or other things modify when necessary


/datum/splat/Initialize()
	. = ..()

/datum/splat/proc/Apply()
	SHOULD_CALL_PARENT(TRUE)

/datum/splat/proc/Remove()
	SHOULD_CALL_PARENT(TRUE)

/// We'll use this for signals to fuck with supernaturals and whatever else
/datum/splat/supernatural

/mob/living/carbon/human/proc/AdjustHumanity(var/value, var/limit, var/forced = FALSE)
	if(!iskindred(src))
		return
	if(!GLOB.canon_event)
		return
	var/special_role_name
	if(mind)
		if(mind.special_role)
			var/datum/antagonist/A = mind.special_role
			special_role_name = A.name
	if(!is_special_character(src) || special_role_name == "Ambitious" || forced)
		if(!in_frenzy || forced)
			var/mod = 1
			var/enlight = FALSE
			if(clane)
				mod = clane.humanitymod
				enlight = clane.enlightenment
			if(enlight)
				if(value < 0)
					if(humanity < 10)
						if (forced)
							humanity = max(0, humanity-(value * mod))
						else
							humanity = max(limit, humanity-(value*mod))
						SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
						to_chat(src, "<span class='userhelp'><b>ENLIGHTENMENT INCREASED!</b></span>")
				if(value > 0)
					if(humanity > 0)
						if (forced)
							humanity = min(10, humanity-(value * mod))
						else
							humanity = min(limit, humanity-(value*mod))
						SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
						to_chat(src, "<span class='userdanger'><b>ENLIGHTENMENT DECREASED!</b></span>")
			else
				if(value < 0)
					if((humanity > limit) || forced)
						if (forced)
							humanity = max(0, humanity+(value * mod))
						else
							humanity = max(limit, humanity+(value*mod))
						SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_loss.ogg', 0, 0, 75))
						to_chat(src, "<span class='userdanger'><b>HUMANITY DECREASED!</b></span>")
						if(humanity == limit)
							to_chat(src, "<span class='userdanger'><b>If I don't stop, I will succumb to the Beast.</b></span>")
					else
						var/msgShit = pick("<span class='userdanger'><b>I can barely control the Beast!</b></span>", "<span class='userdanger'><b>I SHOULD STOP.</b></span>", "<span class='userdanger'><b>I'm succumbing to the Beast!</b></span>")
						to_chat(src, msgShit) // [ChillRaccoon] - I think we should make's players more scared
				if(value > 0)				  // so please, do not say about that, they're in safety after they're humanity drops to limit
					if((humanity < limit) || forced)
						if (forced)
							humanity = min(10, humanity+(value * mod))
						else
							humanity = min(limit, humanity+(value*mod))
						SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
						to_chat(src, "<span class='userhelp'><b>HUMANITY INCREASED!</b></span>")

/mob/living/carbon/human/proc/AdjustMasquerade(var/value, var/forced = FALSE)
	if(!iskindred(src) && !isghoul(src))
		return
	if(!GLOB.canon_event)
		return
	if (!forced)
		if(value > 0)
			if(HAS_TRAIT(src, TRAIT_VIOLATOR))
				return
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type != "masquerade")
				return
	var/special_role_name
	if(mind)
		if(mind.special_role)
			var/datum/antagonist/A = mind.special_role
			special_role_name = A.name
	if(!is_special_character(src) || special_role_name == "Ambitious" || forced)
		if(((last_masquerade_violation + 10 SECONDS) < world.time) || forced)
			last_masquerade_violation = world.time
			if(value < 0)
				if(masquerade > 0)
					masquerade = max(0, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/masquerade_violation.ogg', 0, 0, 75))
					to_chat(src, "<span class='userdanger'><b>MASQUERADE VIOLATION!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire - 2 MINUTES)
			if(value > 0)
				if(clane?.enlightenment && !forced)
					AdjustHumanity(1, 10)
				for(var/mob/living/carbon/human/H in GLOB.player_list)
					H.voted_for -= dna.real_name
				if(masquerade < 5)
					masquerade = min(5, masquerade+value)
					SEND_SOUND(src, sound('code/modules/wod13/sounds/general_good.ogg', 0, 0, 75))
					to_chat(src, "<span class='userhelp'><b>MASQUERADE REINFORCED!</b></span>")
				SSbad_guys_party.next_fire = max(world.time, SSbad_guys_party.next_fire + 1 MINUTES)

	if(src in GLOB.masquerade_breakers_list)
		if(masquerade > 2)
			GLOB.masquerade_breakers_list -= src
	else if(masquerade < 3)
		GLOB.masquerade_breakers_list |= src

/mob/living/proc/CheckEyewitness(var/mob/living/source, var/mob/attacker, var/range = 0, var/affects_source = FALSE)
	var/actual_range = max(1, round(range*(attacker.alpha/255)))
	var/list/seenby = list()
	if(source.ignores_warrant)
		return
	else
		for(var/mob/living/carbon/human/npc/NPC in oviewers(1, source))
			if(!NPC.CheckMove())
				if(get_turf(src) != turn(NPC.dir, 180))
					seenby |= NPC
					NPC.Aggro(attacker, FALSE)
		for(var/mob/living/carbon/human/npc/NPC in viewers(actual_range, source))
			if(!NPC.CheckMove())
				if(affects_source)
					if(NPC == source)
						NPC.Aggro(attacker, TRUE)
						seenby |= NPC
				if(!NPC.pulledby)
					var/turf/LC = get_turf(attacker)
					if(LC.get_lumcount() > 0.25 || get_dist(NPC, attacker) <= 1)
						if(NPC.backinvisible(attacker))
							seenby |= NPC
							NPC.Aggro(attacker, FALSE)
		if(length(seenby) >= 1)
			return TRUE
		return FALSE
