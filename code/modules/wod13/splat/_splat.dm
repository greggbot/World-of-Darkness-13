#define SPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_APPLIED_TO, M, S)
#define UNSPLATTED(M, S) SEND_SIGNAL(SSsplats, COMSIG_SPLAT_SPLAT_REMOVED_FROM, M, S)

/datum/species
	var/animation_goes_up = FALSE	//PSEUDO_M i have no idea what this does

/datum/splat
	///We change this when applied to track people's splat assignments
	var/name = null
	///For record keeping and sanity
	var/splat_id = null
	/// Pretty much every splat has a power stat; vitae, gnosis, etc
	var/power_stat_name = null
	var/power_stat_max = 0
	var/power_stat_current = 0
	///Traits to apply/remove in their respective instances
	var/list/splat_traits = null
	///Signals and PROC_REFs to register for, respectively. Defined here for organization
	var/list/splat_signals = null
	var/integrity_name = "Integrity"
	var/integrity_level = 7
	///A bitflag that this splat will return in response to anything that splat checks us, which will usually be the helpers.
	var/splat_flag = null
	///Our very special lady, gentleman, theydie, gentlethem, or horrifying monstrosity that should not be
	var/mob/living/my_character = null
	///Artifacts of migrating splats from species, pending a rework of our damage system
	var/brutemod = null
	var/burnmod = null

/* Primarily for signal registration and a handle for SSsplats to make and apply a new splat, we want to do most of the effect
 * work of a splat application using my_character since it SHOULD be getting assigned.
 * my_character = who or whatever is getting the splat. Note that it is mob/living and not carbon or human; ghoul pets comes to mind.
 * splat_response is a signal handler for splat checking.
 * then we do all our important work in on_apply
*/
/datum/splat/proc/Apply(mob/living/character)
	SHOULD_CALL_PARENT(TRUE)
	my_character = character
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_CHECKED, PROC_REF(splat_response))
	on_apply(my_character)

/* In a perfect world this would have no args and function off of my_character but we want to future proof for whatever circumstance
 * may call for mass splat removal or something.
 * Unregisters the signals then does any heavy_lifting in on_remove
*/
/datum/splat/proc/Remove(mob/living/character)
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(character, COMSIG_SPLAT_SPLAT_CHECKED)
	on_remove(character)

/* Name the splat helpfully, apply splat inherent effects, signal the character for any possible listeners, then start tracking on the splat
 * subsystem.
*/
/datum/splat/proc/on_apply()
	SHOULD_CALL_PARENT(TRUE)
	name = "[my_character]'s [splat_id] splat"
	for(var/trait in splat_traits)
		ADD_TRAIT(my_character, trait, [splat_id])
	SEND_SIGNAL(my_character, COMSIG_SPLAT_SPLAT_APPLIED, src)
	SPLATTED(my_character, src)

/* Signal our removal, null out our character, null out the reference to us in SSsplats, then journey into the void. */
/datum/splat/proc/on_remove()
	SHOULD_CALL_PARENT(TRUE)
	for(var/trait in splat_traits)
		REMOVE_TRAIT(my_character, trait)
	SEND_SIGNAL(character, COMSIG_SPLAT_SPLAT_REMOVED, src)
	UNSPLATTED(my_character, src)
	my_character = null
	qdel(src)

#undef SPLATTED

/datum/splat/proc/splat_response(datum/source)
	SIGNAL_HANDLER

	return splat_flag

/datum/splat/human

/datum/splat/human/on_apply()
	. = ..()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED, PROC_REF(dehumanize))

/datum/splat/human/proc/dehumanize(datum/source, datum/splat/new_splat)
	SIGNAL_HANDLER

	if(!istype(new_splat, /datum/splat/supernatural))	//you don't belong in this world!
		return NONE
	log_game("[my_character] is no longer human as a result of gaining the [splat_id] splat.")
	Remove(my_character)

/datum/splat/human/on_remove()
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED)
	..()

/*
 * Should usually not be called by itself, but is instead meant
 * to be a helper proc for particular acts communicated via signals.
 * value - how much it's being adjusted
 * associated_level - the level of a given act we need to be over or under
 * admin_override - if we're disregarding having an associated_level
 */
/datum/splat/proc/_adjust_integrity(value, associated_level, admin_override = FALSE)
	if(!value)
		return
	if(!isnum(violation_level))
		if(!admin_override)
			CRASH("[src]/adjust_integrity needs to be called with a level correlated to a given sinful or virtuous act.")
		LOG_ADMIN("[usr] adjusted [my_character]'s [integrity_name] by [value].")
	if(value > 1 || value < -1)
		LOG_ADMIN("[my_character]'s [integrity_name] was adjusted by more than one level.")
	value > 0 ? _try_increase_integrity(value, associated_level) : _try_decrease_integrity(value, associated_level)

/// It seems an arbitrary distinction but these will be splats or splat-likes that don't render you technically not human while still giving
/// more(or less?) than human abilities or characteristics; Hunters, Immortals from CofD, Slashers, etc
/datum/splat/metahuman

/datum/splat/metahuman/on_apply()
	. = ..()
	RegisterSignal(my_character, COMSIG_SPLAT_SPLAT_REMOVED, PROC_REF(exclusive_to_humans))

/datum/splat/metahuman/proc/exclusive_to_humans(datum/source, datum/splat/removing_splat)
	SIGNAL_HANDLER

	if(!istype(removing_splat, /datum/splat/human))
		return NONE
	log_game("[my_character] lost the [splat_id] splat along with their humanity.")
	Remove(my_character)

/datum/splat/metahuman/on_remove()
	UnregisterSignal(my_character, COMSIG_SPLAT_SPLAT_APPLIED)
	..()


/// We'll use this for signals to fuck with supernaturals and whatever else
/datum/splat/supernatural


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
