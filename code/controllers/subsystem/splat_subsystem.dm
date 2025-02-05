/* A subsystem for handling splats when putting behavior on the splat itself would be too constrained (a list of vampires, for example)
 * Also handles generating a new splat to apply to someone
 * Doesn't process.
*/
SUBSYSTEM_DEF(splats)
	name = "splats"
	init_order = INIT_ORDER_SPLATS
	flags = SS_NO_FIRE

	///To save a headache on contributors trying to remember the paths
	var/list/splat_types = list(
		"human"		=	/datum/splat/human,
		"kindred"	=	/datum/splat/supernatural/kindred,
		"garou"		=	/datum/splat/supernatural/garou,
		"ghoul"		=	/datum/splat/supernatural/ghoul,
		"kuei-jin"	=	/datum/splat/supernatural/kuei-jin,
	)
	///An associated list of lazy lists for splats applied for admins and debugging
	var/list/applied_splats = list(
		"human"		= null
		"kindred"	= null
		"garou"		= null
		"ghoul"		= null
		"kuei-jin"	= null
	)

/datum/controller/subsystem/splats/proc/give_new_splat(mob/living/target, splat)
	if(ispath(splat, /datum/splat))
		var/datum/splat/new_splat = new()
		new_splat.Apply(target)
		return splat
	if(!istext(splat))
		CRASH("Tried to splat [target] with an undefined value: [splat]")
	var/splat_type = splat_types[splat]
	var/datum/splat/new_splat = splat_type/new()
	new_splat.Apply(target)
	return splat

/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
/datum/controller/subsystem/splats/proc/
