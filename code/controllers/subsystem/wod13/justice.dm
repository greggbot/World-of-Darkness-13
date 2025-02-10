DECLARE_SUBSYSTEM(justice)
	name = "justice"
	init_order = INIT_ORDER_JUSTICE
	flags = SS_NO_FIRE
	//List of APBs, either active or past; once you're on here you stay on here, though your APB may be deactivated
	//Associated list, with the mob being the key and a number (0-3) of your wanted level
	/*	Levels:
	*	0 - Had APB deactivated, kept on this list for records
	*	1 - Active APB, aggro cops, cops spawn and try to arrest you (nonlethally) if a cop NPC sees you, cop PCs get a HUD icon for you
	*	2 - Armed & Dangerous, set to this if you kill any of the cop NPCs or break Masquerade, cops shoot you instead, all NPCs except your faction's, homeless, and thugs trigger cop spawns now
	*	3 - Active Tactical Response, set to this if you are witnessed attacking the police chief, can be requested by Sergeants, can be approved by admins, chief, or agreement of another Sergeant
	*		SWAT deploys on you kind like how it does now; can only break pursuit in areas specifically mean to do so
	*	4 - Admin only, means that even going into areas that would break pursuit, doesn't
	*	Normal cops can set APB up to 2
	*	Chief, two Sergeants, admins, or too-low Masquerade can set to 3
	*	APBs don't expire because it's not grand theft auto, but police players can disable them
	*	Only DA CHIEF (or admins) can disable an Active Tactical Response
	*	If spotted committing a crime by a cop, instantly receive an APB because they radioed your description for backup
	*	If spotted by NPCs, determine based on the crime and the NPC, eventually offer opportunities to utilize skills to manage the situation
	*/
	var/list/all_points_bulletins

	/*	Rapsheets:
	*	List of rapsheets
	*/
	var/list/rapsheet/rapsheets
	//PSEUDO_M add admin logging
	//PSEUDO_M this system will be utilized by police dispatcher PCs, too
	/*	Active pursuits:
	*	A list of police pursuit datum objects specific to the purpose. */
	var/list/datum/police_pursuit/active_pursuits
	//An assoc list of areas for if an admin wants to change the police presence in an area from what would typically be determined by their type
	var/list/area/vtm/police_presence_modified_areas
	var/list/datum/crime/crime_types = list()

/*	Rapsheets! Primarily manipulated with signals, for down-the-line integration with people whose role
*	interacts with the justice system, public opinion, or for merits, etc etc	*/
/datum/rapsheet
	//Deliberately attached to mobs instead of minds or names
	var/mob/living
	var/list/datum/crime/charges

/*	Datumized to facilitate more programmatic interaction with morality, derangements, and other possible systems
*	These are singletons, because there's really no need to have more than one instance of each, so don't try to make new ones
*	and instead use the SSjustice procs to attach crimes to people if you end up working with them. */

//from COMSIG_AREA_ENTERED, for if they enter an area that breaks pursuit, has like a shitton of cops, etc
//if they have an active pursuit we dereg this so no need to worry about checking for that, and if they don't have
//an active APB they also won't be registered for this
/datum/controller/subsystem/justice/proc/check_should_pursue_suspect(datum/source, area/vtm/entered_area)
	SIGNAL_HANDLER
	//specifying this here for future coders to maybe learn something about signals :)
	var/atom/movable/suspect = source
	if(!all_points_bulletins.Find(suspect) || !all_points_bulletins[suspect])
		//they shouldn't be registered with us....
		UnregisterSignal(suspect, COMSIG_AREA_ENTERED)
		return NONE
	if(all_points_bulletins[suspect] == 4 || entered_area.police_presence == POLICE_IMMEDIATELY_PRESENT)
		SSjustice.start_pursuit(suspect, entered_area, /*start_at*/POLICE_PURSUIT_SUSPECT_ENGAGED)
	return TRUE

/*	Args:
*	datum/source: 		like all signals, whatever sent it
*	suspect:			the proud owner of a (possibly new) criminal record
*	crime:				crime datum singleton type path, IF YOU USE THIS USE THE DEFINES TO SAVE EVERYONE THE HEADACHE
*	damning_evidence:	whatever the thing is they took/broke/killed/etc, can be null, but can also be helpful for investigation
*	stalwart_enforcer:	null if automated systems stick the crime on them, otherwise the PC adding the charge
*/																				//legally speaking, anyway, but also consistent vars!
/datum/controller/subsystem/justice/proc/charge_with_crime(datum/source, mob/living/suspect, datum/crime/charged_with, atom/damning_evidence, mob/living/stalwart_enforcer = null)
	SIGNAL_HANDLER

/datum/controller/subsystem/justice/proc/declare_APB(datum/source, atom/movable/stalwart_enforcer, atom/movable/suspect, APB_level)
	SIGNAL_HANDLER

