
ADMIN_VERB_AND_CONTEXT_MENU(possess, R_POSSESS, "Possess Obj", "Possess an object.", ADMIN_CATEGORY_OBJECT, obj/target in world)
	var/result = user.mob.AddComponent(/datum/component/object_possession, target)

	if(isnull(result)) // trigger a safety movement just in case we yonk
		user.mob.forceMove(get_turf(user.mob))
		return

	var/turf/target_turf = get_turf(target)
	var/message = "[key_name(user)] has possessed [target] ([target.type]) at [AREACOORD(target_turf)]"
	message_admins(message)
	log_admin(message)

	BLACKBOX_LOG_ADMIN_VERB("Possess Object")

<<<<<<< HEAD
	if(!usr.control_object) //If you're not already possessing something...
		usr.name_archive = usr.real_name

	usr.loc = O
	usr.real_name = O.name
	usr.name = O.name
	usr.reset_perspective(O)
	usr.control_object = O
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Possess Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/release()
	set name = "Release Obj"
	set category = "Object"
	//usr.loc = get_turf(usr)

	if(usr.control_object && usr.name_archive) //if you have a name archived and if you are actually relassing an object
		usr.real_name = usr.name_archive
		usr.name_archive = ""
		usr.name = usr.real_name
		if(ishuman(usr))
			var/mob/living/carbon/human/H = usr
			H.name = H.get_visible_name()


	usr.loc = get_turf(usr.control_object)
	usr.reset_perspective()
	usr.control_object = null
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Release Object") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/proc/givetestverbs(mob/M in GLOB.mob_list)
	set desc = "Give this guy possess/release verbs"
	set category = "Debug"
	set name = "Give Possessing Verbs"
	add_verb(M, GLOBAL_PROC_REF(possess))
	add_verb(M, GLOBAL_PROC_REF(release))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Give Possessing Verbs") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
=======
ADMIN_VERB(release, R_POSSESS, "Release Object", "Stop possessing an object.", ADMIN_CATEGORY_OBJECT)
	var/possess_component = user.mob.GetComponent(/datum/component/object_possession)
	if(!isnull(possess_component))
		qdel(possess_component)
	BLACKBOX_LOG_ADMIN_VERB("Release Object")
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441
