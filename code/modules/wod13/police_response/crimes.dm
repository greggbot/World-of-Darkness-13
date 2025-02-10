/*	Rapsheets! Primarily manipulated with signals, for down-the-line integration with people whose role
*	interacts with the justice system, public opinion, or for merits, etc etc	*/
/datum/rapsheet
	//Deliberately attached to mobs instead of minds or names
	var/mob/living
	var/list/crime/charges

/*	Datumized to facilitate more programmatic interaction with morality, derangements, and other possible systems
*	These are singletons, because there's really no need to have more than one instance of each, so don't try to make new ones
*	and instead use the SSjustice procs to attach crimes to people if you end up working with them. */
/datum/crime
	// Name of the crime for the rapsheet and for APB announcements
	var/name
	// If you get reported doing this, initial police response will be this level (see justice_subsystem.md)
	// Severity also determines initial response time, with severity *2 being a response time reduction (see subsystem.md in this directory)
	var/severity
	// Whether the person you committed it on was an officer; multiplies severity by this amount
	var/officer_involved

/// Snitches and suspect are, respectively, whatever reports the crime and whatever is being reported
/// We're using atoms instead of mobs because it may be that a car gets reported by a camera, for instance
/datum/crime/proc/report(atom/movable/snitch, atom/movable/suspect)
	//PSEUDO_M crime_reporting.report_crime(crime_args)

/datum/crime/assault
	name = "Assault"
	severity = 3
	officer_involved = 4

/datum/crime/assault_with_weapon
	name = "Assault with a deadly weapon"
	severity = 5
	officer_involved = 2

/datum/crime/break_n_enter
	name = "Burglary"
	severity = 6

/datum/crime/criminal_enterprise
	name = "Operation of a criminal enterprise"
	severity = 10

/datum/crime/disturbing_the_peace
	name = "Disturbing the peace"
	severity = 0.5

/datum/crime/murder/attempted
	name = "Attempted murder"
	severity = 5

/datum/crime/murder
	name = "Murder"
	severity = 7
	officer_involved = 10

/datum/crime/murder/report(atom/movable/snitch, atom/movable/suspect)
	//1st degree offic, 2nd degree other

/datum/crime/resisting
	name = "Resisting arrest"
	severity = 3

/datum/crime/theft
	name = "Theft"
	severity = 0 //when's the last time cops got your stolen shit back?

/datum/crime/theft/grand
	name = "Larceny"
	severity = 2

/datum/crime/grand_theft_auto	//VIBEO GAME!!!
	name = "Stolen vehicle"
	severity = 3

/datum/crime/possession/distro	//not how it's named IRL but type paths
	name = "Possession with intent to distribute"
	severity = 5

/datum/crime/possession/
	name = "Possession"
	severity = 2

/datum/crime/possession/major
	name = "Felony possession"
	severity = 4

/datum/crime/possession_major/report(atom/movable/snitch, atom/movable/suspect)

/// Reported if you get spotted in a private faction area
/datum/crime/tresspass
	name = "Criminal Tresspass"
	severity = 0.5
	// If this is officer involved, it means you're tresspassing in an area that is literally owned by the police
	// so, severity .5 * 20 = 10, erego, instant police repsonse
	officer_involved = 20

/// This is the crime you get if someone sets an APB but doesn't set a crime
/datum/crime/wanted_for_questioning
	name = "Wanted for Questioning"
	severity = 0
