#define PURSUIT_TIMER_FLAGS TIMER_UNIQUE | TIMER_STOPPABLE
/// APB 0 means you had an active APB deactivated
#define APB0_OFFICERS 0
/// two officers will spawn nearby and engage you nonlethally
#define APB1_OFFICERS 2
/// you're fleeing the police and they're shooting for center mass
#define APB2_OFFICERS 4
/// "all units be advised, tactical response has been deployed, patrol officers stand down" you're that guy that needs to send out the hostages
#define APB3_OFFICERS 10
/// APB 4 is just perma APB 3 with no pursuit breaking
#define APB4_OFFICERS OFFICERS_RESPONDING_APB_3


/* Self-handling datum that does most of the control for a given police pursuit, without us having to make a whole processing subsystem for it */
/datum/police_pursuit
	//	Changes at different levels to be helpful for admins to glance at
	var/name = ""
	//	Our (alleged) perpetrator
	var/atom/movable/suspect = null
	//	Set to string defines
	var/pursuit_status = null
	//	List of NPCs specifically active in THIS pursuit
	var/list/mob/living/involved_officers
	//	timer to facilitate recursive calling of a given stage at a given step
	var/stage_timer
	//	For readability and sanity purposes, define how many steps a given stage typically has, and for convenience,
	//	how long each stage is in seconds. So every stage of en_route is 10, every stage of searching is 10, every stage of suspect_engaged
	//	is 2
	var/static/list/stage_status_steps = list(
		POLICE_PURSUIT_EN_ROUTE = 10,		//adjusted for a given crime
		POLICE_PURSUIT_SEARCHING = 10,		//the same, with the caveat that this can be -1 so the police WON'T stop searching if you stay in the area
		POLICE_PURSUIT_SUSPECT_ENGAGED = 2,	//only two stages: 2 means you're actively dusting up with the cops, 1 means you've broken line of sight (or killed all the cops)
	)
	//	Typically affects en_route by reducing how many stages it has before police arrive to search the area or
	//	open a can of whoopass if you haven't had the sense to hide
	//	or flee, will otherwise increase the number of searching stages
	var/severity
	//	The extra effort the cops are putting into this particular pursuit
	//	So don't be shocked it'll usually be 0
	//	But also don't be shocked if being a copkiller gets you in a world of shit
	//	Affects the extra cops that show up with the APB level for a stage with the following:
	//	x = APB level, n = espirit_de_corps
	//	x((n+1)^2)
	//	APB levels, espirit 1, extra cops: 0 = rapsheet(cops know you on examine), 1 = arrest, 2 = shoot-on-sight, 3+ = motherfucking SWAT
	//	0(2^2) = 0 extra, 1(2^2) = 4 extra, 2(2^2) = 8 extra, 3(2^2) = 24 extra fucking swat officers
	//	use carefully, anything higher than espirit 1 is usually an absolute shitstorm such as the police chief being attacked, masquerade being thoroughly broken
	//	rampaging werewolves, etc, espirit 1 would be something like someone having attacked a cop or the chief calling in an APB personally
	//	Will also determine how much longer they'll search an area before a pursuit is considered "broken"
	var/espirit_de_corps

/datum/police_pursuit/New(atom/movable/suspect, initial_pursuit_status = POLICE_PURSUIT_EN_ROUTE, severity_modifier = 0, extra_effort_modifier = 0)
	severity = severity_modifier
	espirit_de_corps = extra_effort_modifier
	pursuit_status = initial_pursuit_status

/// The initial setup for our pursuit object after we're made brand new
/datum/police_pursuit/proc/pursuit_initialized()
	if(!pursuit_status)
		CRASH("Police pursuit initialized without an initial status.")
	var/pursuit_stage_to_initiate = stage_status_steps.Find(pursuit_status)
	if(!pursuit_stage_to_initiate)
		CRASH("Failed to properly initiate a police pursuit with a valid intial status.")
	switch(pursuit_stage_to_initiate)
		if(1)
			begin_enroute()
			return TRUE
		if(2)
			begin_searching()
			return TRUE
		if(3)
			begin_engaging()
			return TRUE
		else
			CRASH("Pursuit stage was an invalid index for static pursuit stages.")

/datum/police_pursuit/proc/begin_enroute()
	var/en_route_value = stage_status_steps[POLICE_PURSUIT_ENROUTE]
	if(severity)
		en_route_value -= severity
	var/area/vtm/suspect_area = get_area(suspect)
	if(suspect_area.police_presence == POLICE_PRESENCE_UNRELIABLE)
		en_route_value += rand(5)
	var/list/APBs = SSjustice.all_points_bulletins
	if(APBs.Find(suspect) && (APBs[suspect] >= 2))
		en_route_value -= (APBs[suspect] * 2)
	handle_enroute(en_route_value, get_turf(suspect))

/datum/police_pursuit/proc/handle_enroute(en_route_value = 10, turf/last_known_location)
	if(en_route_value == 0)	// officer arriving on the scene
		pursuit_status = POLICE_PURSUIT_SEARCHING
		begin_searching(last_known_location)
	addtimer(CALLBACK(src, PROC_REF(handle_enroute), en_route_value - 1), 10 SECONDS)
	if(en_route_value <= 5)
		//PSEUDO_M play police noises in the area


/datum/police_pursuit/proc/begin_searching()


/datum/police_pursuit/proc/begin_engaging()
