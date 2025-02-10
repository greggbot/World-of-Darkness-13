/* Self-handling datum that does most of the control for a given police pursuit, without us having to make a whole processing subsystem for it */
/datum/police_pursuit
	//	Changes at different levels to be helpful for admins to glance at
	var/name = ""
	//	Our (alleged) perpetrator
	var/mob/living/suspect = null
	//	Set to string defines
	var/pursuit_status = null
	//	List of NPCs specifically active in THIS pursuit
	var/list/mob/living/involved_officers
	//	timer to facilitate recursive calling of a given stage at a given step
	var/stage_timer
	//	For readability and sanity purposes, define how many steps a given stage typically has
	var/static/list/stage_status_steps = list(
		POLICE_PURSUIT_EN_ROUTE = 10,		//adjusted for a given crime
		POLICE_PURSUIT_SEARCHING = 10,		//the same, with the caveat that this can be -1 so the police WON'T stop searching if you stay in the area
		POLICE_PURSUIT_SUSPECT_ENGAGED = 2,	//only two stages: 2 means you're actively dusting up with the cops, 1 means you've broken line of sight (or killed all the cops)
	)
	var/PURSUIT_TIMER_FLAGS = TIMER_UNIQUE|TIMER_STOPPABLE

