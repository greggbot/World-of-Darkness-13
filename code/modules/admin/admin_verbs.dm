/client/proc/add_admin_verbs()
	control_freak = CONTROL_FREAK_SKIN | CONTROL_FREAK_MACROS
	SSadmin_verbs.assosciate_admin(src)

/client/proc/remove_admin_verbs()
	control_freak = initial(control_freak)
	SSadmin_verbs.deassosciate_admin(src)

ADMIN_VERB(hide_verbs, R_NONE, "Adminverbs - Hide All", "Hide most of your admin verbs.", ADMIN_CATEGORY_MAIN)
	user.remove_admin_verbs()
	add_verb(user, /client/proc/show_verbs)

	to_chat(user, span_interface("Almost all of your adminverbs have been hidden."), confidential = TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Hide All Adminverbs")

ADMIN_VERB(admin_ghost, R_ADMIN, "AGhost", "Become a ghost without DNR.", ADMIN_CATEGORY_GAME)
	. = TRUE
	if(isobserver(user.mob))
		//re-enter
		var/mob/dead/observer/ghost = user.mob
		if(!ghost.mind || !ghost.mind.current) //won't do anything if there is no body
			return FALSE
		if(!ghost.can_reenter_corpse)
			log_admin("[key_name(user)] re-entered corpse")
			message_admins("[key_name_admin(user)] re-entered corpse")
		ghost.can_reenter_corpse = 1 //force re-entering even when otherwise not possible
		ghost.reenter_corpse()
		BLACKBOX_LOG_ADMIN_VERB("Admin Reenter")
	else if(isnewplayer(user.mob))
		to_chat(user, "<font color='red'>Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.</font>", confidential = TRUE)
		return FALSE
	else
		//ghostize
		log_admin("[key_name(user)] admin ghosted.")
		message_admins("[key_name_admin(user)] admin ghosted.")
		var/mob/body = user.mob
		body.ghostize(TRUE)
		user.init_verbs()
		if(body && !body.key)
			body.key = "@[user.key]" //Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		BLACKBOX_LOG_ADMIN_VERB("Admin Ghost")

ADMIN_VERB(invisimin, R_ADMIN, "Invisimin", "Toggles ghost-like invisibility.", ADMIN_CATEGORY_GAME)
	if(HAS_TRAIT(user.mob, TRAIT_INVISIMIN))
		REMOVE_TRAIT(user.mob, TRAIT_INVISIMIN, ADMIN_TRAIT)
		user.mob.add_to_all_human_data_huds()
		user.mob.RemoveInvisibility(INVISIBILITY_SOURCE_INVISIMIN)
		to_chat(user, span_adminnotice(span_bold("Invisimin off. Invisibility reset.")), confidential = TRUE)
		return

	ADD_TRAIT(user.mob, TRAIT_INVISIMIN, ADMIN_TRAIT)
	user.mob.remove_from_all_data_huds()
	user.mob.SetInvisibility(INVISIBILITY_OBSERVER, INVISIBILITY_SOURCE_INVISIMIN, INVISIBILITY_PRIORITY_ADMIN)
	to_chat(user, span_adminnotice(span_bold("Invisimin on. You are now as invisible as a ghost.")), confidential = TRUE)

ADMIN_VERB(check_antagonists, R_ADMIN, "Check Antagonists", "See all antagonists for the round.", ADMIN_CATEGORY_GAME)
	user.holder.check_antagonists()
	log_admin("[key_name(user)] checked antagonists.")
	if(!isobserver(user.mob) && SSticker.HasRoundStarted())
		message_admins("[key_name_admin(user)] checked antagonists.")
	BLACKBOX_LOG_ADMIN_VERB("Check Antagonists")

ADMIN_VERB(list_bombers, R_ADMIN, "List Bombers", "Look at all bombs and their likely culprit.", ADMIN_CATEGORY_GAME)
	user.holder.list_bombers()
	BLACKBOX_LOG_ADMIN_VERB("List Bombers")

ADMIN_VERB(list_signalers, R_ADMIN, "List Signalers", "View all signalers.", ADMIN_CATEGORY_GAME)
	user.holder.list_signalers()
	BLACKBOX_LOG_ADMIN_VERB("List Signalers")

ADMIN_VERB(list_law_changes, R_ADMIN, "List Law Changes", "View all AI law changes.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_law_changes()
	BLACKBOX_LOG_ADMIN_VERB("List Law Changes")

ADMIN_VERB(show_manifest, R_ADMIN, "Show Manifest", "View the shift's Manifest.", ADMIN_CATEGORY_DEBUG)
	user.holder.show_manifest()
	BLACKBOX_LOG_ADMIN_VERB("Show Manifest")

ADMIN_VERB(list_dna, R_ADMIN, "List DNA", "View DNA.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_dna()
	BLACKBOX_LOG_ADMIN_VERB("List DNA")

ADMIN_VERB(list_fingerprints, R_ADMIN, "List Fingerprints", "View fingerprints.", ADMIN_CATEGORY_DEBUG)
	user.holder.list_fingerprints()
	BLACKBOX_LOG_ADMIN_VERB("List Fingerprints")

ADMIN_VERB(ban_panel, R_BAN, "Banning Panel", "Ban players here.", ADMIN_CATEGORY_MAIN)
	user.holder.ban_panel()
	BLACKBOX_LOG_ADMIN_VERB("Banning Panel")

ADMIN_VERB(unban_panel, R_BAN, "Unbanning Panel", "Unban players here.", ADMIN_CATEGORY_MAIN)
	user.holder.unban_panel()
	BLACKBOX_LOG_ADMIN_VERB("Unbanning Panel")

ADMIN_VERB(game_panel, R_ADMIN, "Game Panel", "Look at the state of the game.", ADMIN_CATEGORY_GAME)
	user.holder.Game()
	BLACKBOX_LOG_ADMIN_VERB("Game Panel")

ADMIN_VERB(poll_panel, R_POLL, "Server Poll Management", "View and manage polls.", ADMIN_CATEGORY_MAIN)
	user.holder.poll_list_panel()
	BLACKBOX_LOG_ADMIN_VERB("Server Poll Management")

/// Returns this client's stealthed ckey
/client/proc/getStealthKey()
	return GLOB.stealthminID[ckey]

/// Takes a stealthed ckey as input, returns the true key it represents
/proc/findTrueKey(stealth_key)
	if(!stealth_key)
		return
	for(var/potentialKey in GLOB.stealthminID)
		if(GLOB.stealthminID[potentialKey] == stealth_key)
			return potentialKey

/// Hands back a stealth ckey to use, guarenteed to be unique
/proc/generateStealthCkey()
	var/guess = rand(0, 1000)
	var/text_guess
	var/valid_found = FALSE
	while(valid_found == FALSE)
		valid_found = TRUE
		text_guess = "@[num2text(guess)]"
		// We take a guess at some number, and if it's not in the existing stealthmin list we exit
		for(var/key in GLOB.stealthminID)
			// If it is in the list tho, we up one number, and redo the loop
			if(GLOB.stealthminID[key] == text_guess)
				guess += 1
				valid_found = FALSE
				break

ADMIN_VERB(toggle_canon, R_ADMIN, "Toggle Canon", "Toggle whether the round is canon or not.", ADMIN_CATEGORY_MAIN)
	GLOB.canon_event = !GLOB.canon_event
	SEND_SOUND(world, sound('code/modules/wod13/sounds/canon.ogg'))
	if(GLOB.canon_event)
		to_chat(world, "<b>THE ROUND IS NOW CANON. ALL ROLEPLAY AND ESCALATION RULES ARE IN EFFECT.</b>")
	else
		to_chat(world, "<b>THE ROUND IS NO LONGER CANON. DATA WILL NO LONGER SAVE, AND ROLEPLAY AND ESCALATION RULES ARE NO LONGER IN EFFECT.</b>")
	message_admins("[key_name_admin(usr)] toggled the round's canonicity. The round is [GLOB.canon_event ? "now canon." : "no longer canon."]")
	log_admin("[key_name(usr)] toggled the round's canonicity. The round is [GLOB.canon_event ? "now canon." : "no longer canon."]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Toggle Canon") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(cmd_admin_global_adjust_masquerade, R_ADMIN, "Adjust Global Masquerade", "Change the level of the Masquerade.", ADMIN_CATEGORY_MAIN)
	var/last_global_mask = SSmasquerade.total_level

	var/value = input(usr, "Enter the Global Masquerade adjustment values(- will decrease, + will increase) :", "Global Masquerade Adjustment", 0) as num|null
	if(value == null)
		return

	SSmasquerade.manual_adjustment = value

	var/changed_mask = max(0,min(1000,last_global_mask + value))

	SSmasquerade.fire()

	var/msg = "<span class='adminnotice'><b>Global Masquerade Adjustment: [key_name_admin(usr)] has adjusted Global masquerade from [last_global_mask] to [changed_mask] with the value of : [value]. Real Masquerade Value with the other possible variables : [SSmasquerade.total_level]</b></span>"
	log_admin("Global MasqAdjust: [key_name(usr)] has adjusted Global masquerade from [last_global_mask] to [changed_mask] with the value of : [value]. Real Masquerade Value with the other possible variables : [SSmasquerade.total_level]")
	message_admins(msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Global Adjust Masquerade")

ADMIN_VERB(cmd_admin_adjust_humanity, R_ADMIN, "Adjust Humanity", "Adjust the humanity level for a single mob.", ADMIN_CATEGORY_MAIN)
	if(!ismob(M))
		return

	var/is_enlightenment = FALSE
	if (M.client?.prefs?.enlightenment)
		is_enlightenment = TRUE

	var/value = input(usr, "Enter the [is_enlightenment ? "Enlightenment" : "Humanity"] adjustment value for [M.key]:", "Humanity Adjustment", 0) as num|null
	if(value == null)
		return
	if (is_enlightenment)
		value = -value

	M.AdjustHumanity(value, 0, forced = TRUE)

	var/msg = "<span class='adminnotice'><b>Humanity Adjustment: [key_name_admin(usr)] adjusted [key_name(M)]'s [is_enlightenment ? "Enlightenment" : "Humanity"] by [is_enlightenment ? -value : value] to [M.humanity]</b></span>"
	log_admin("HumanityAdjust: [key_name_admin(usr)] has adjusted [key_name(M)]'s [is_enlightenment ? "Enlightenment" : "Humanity"] by [is_enlightenment ? -value : value] to [M.humanity]")
	message_admins(msg)
	admin_ticket_log(M, msg)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Adjust Humanity")

ADMIN_VERB(reward_exp, R_ADMIN, "Reward Experience", "Reward experience for a single mob.", ADMIN_CATEGORY_MAIN)
	var/list/explist = list()
	for(var/client/C in GLOB.clients)
		explist |= "[C.ckey]"
	var/exper = input("Rewarding:") as null|anything in explist
	if(exper)
		var/amount = input("Amount:") as null|num
		if(amount)
			var/reason = input("Reason:") as null|text
			if(reason)
				for(var/client/C in GLOB.clients)
					if("[C.ckey]" == "[exper]")
						to_chat(C, "<b>You've been rewarded with [amount] experience points. Reason: \"[reason]\"</b>")

						C.prefs.add_experience(amount)
						C.prefs.save_character()

						message_admins("[ADMIN_LOOKUPFLW(usr)] rewarded [ADMIN_LOOKUPFLW(exper)] with [amount] experience points. Reason: [reason]")
						log_admin("[key_name(usr)] rewarded [key_name(exper)] with [amount] experience points. Reason: [reason]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Reward Experience") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(grant_whitelist, R_ADMIN, "Grant Whitelist", "Grant whitelist for a single user.", ADMIN_CATEGORY_MAIN)
	if (!SSwhitelists.whitelists_enabled)
		to_chat(usr, "<span class='warning'>Whitelisting isn't enabled!</span>")
		return

	var/whitelistee = input("CKey to whitelist:") as null|text
	if (whitelistee)
		whitelistee = ckey(whitelistee)
		var/list/whitelist_pool = (SSwhitelists.possible_whitelists - SSwhitelists.get_user_whitelists(whitelistee))
		if (whitelist_pool.len == 0)
			to_chat(usr, "<span class='warning'>[whitelistee] already has all whitelists!</span>")
			return
		var/whitelist = input("Whitelist to give:") as null|anything in whitelist_pool
		if (whitelist)
			var/ticket_link = input("Link to whitelist request ticket:") as null|text
			if (ticket_link)
				var/approval_reason = input("Reason for whitelist approval:") as null|text
				if (approval_reason)
					SSwhitelists.add_whitelist(whitelistee, whitelist, usr.ckey, ticket_link, approval_reason)
					message_admins("[key_name_admin(usr)] gave [whitelistee] the [whitelist] whitelist. Reason: [approval_reason]")
					log_admin("[key_name(usr)] gave [whitelistee] the [whitelist] whitelist. Reason: [approval_reason]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Grant Whitelist") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(grant_discipline, R_ADMIN, "Grant Discipline", "Grant discipline for a single mob.", ADMIN_CATEGORY_MAIN)
	var/client/player = input("What player do you want to give a Discipline?") as null|anything in GLOB.clients
	if (player)
		if (!player.prefs)
			to_chat(usr, "<span class='warning'>Could not find preferences for [player].")
			return
		var/datum/preferences/preferences = player.prefs
		if ((preferences.pref_species.id != "kindred") && (preferences.pref_species.id != "ghoul"))
			to_chat(usr, "<span class='warning'>Your target is not a vampire or a ghoul.</span>")
			return
		var/giving_discipline = input("What Discipline do you want to give [player]?") as null|anything in (subtypesof(/datum/discipline) - preferences.discipline_types)
		if (giving_discipline)
			var/giving_discipline_level = input("What rank of this Discipline do you want to give [player]?") as null|anything in list(0, 1, 2, 3, 4, 5)
			if (!isnull(giving_discipline_level))
				if ((giving_discipline_level > 1) && (preferences.pref_species.id == "ghoul"))
					to_chat(usr, "<span class='warning'>Giving Discipline at level 1 because ghouls cannot have Disciplines higher.</span>")
					giving_discipline_level = 1
				var/reason = input("Why are you giving [player] this Discipline?") as null|text
				if (reason)
					preferences.discipline_types += giving_discipline
					preferences.discipline_levels += giving_discipline_level
					preferences.save_character()

					var/datum/discipline/discipline = new giving_discipline
					discipline.level = giving_discipline_level

					message_admins("[ADMIN_LOOKUPFLW(usr)] gave [ADMIN_LOOKUPFLW(player)] the Discipline [discipline.name] at rank [discipline.level]. Reason: [reason]")
					log_admin("[key_name(usr)] gave [key_name(player)] the Discipline [discipline.name] at rank [discipline.level]. Reason: [reason]")

					if ((giving_discipline_level > 0) && player.mob)
						if (ishuman(player.mob))
							var/mob/living/carbon/human/human = player.mob
							human.give_discipline(discipline)
						else
							qdel(discipline)
					else
						qdel(discipline)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Grant Discipline") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(remove_discipline, R_ADMIN, "Remove Discipline", "Remove discipline from a single mob.", ADMIN_CATEGORY_MAIN)
	var/client/player = input("What player do you want to remove a Discipline from?") as null|anything in GLOB.clients
	if (player)
		if (!player.prefs)
			to_chat(usr, "<span class='warning'>Could not find preferences for [player].")
			return
		var/datum/preferences/preferences = player.prefs
		if ((preferences.pref_species.id != "kindred") && (preferences.pref_species.id != "ghoul"))
			to_chat(usr, "<span class='warning'>Your target is not a vampire or a ghoul.</span>")
			return
		var/removing_discipline = input("What Discipline do you want to give [player]?") as null|anything in preferences.discipline_types
		if (removing_discipline)
			var/reason = input("Why are you removing this Discipline from [player]?") as null|text
			if (reason)
				var/datum/discipline/discipline = new removing_discipline

				var/i = preferences.discipline_types.Find(removing_discipline)
				preferences.discipline_types.Cut(i, i + 1)
				preferences.discipline_levels.Cut(i, i + 1)
				preferences.save_character()

				message_admins("[ADMIN_LOOKUPFLW(usr)] removed the Discipline [discipline.name] from [ADMIN_LOOKUPFLW(player)]. Reason: [reason]")
				log_admin("[key_name(usr)] removed the Discipline [discipline.name] from [key_name(player)]. Reason: [reason]")

				qdel(discipline)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Remove Discipline") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(whitelist_panel, R_ADMIN, "Whitelist Management", "Open the whitelist management panel.", ADMIN_CATEGORY_MAIN)
	holder.whitelist_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Whitelist Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(poll_panel, R_POLL, "Server Poll Management", "Open the server poll panel.", ADMIN_CATEGORY_MAIN)
	holder.poll_list_panel()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Server Poll Management") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	GLOB.stealthminID["[ckey]"] = generateStealthCkey()

ADMIN_VERB(stealth, R_STEALTH, "Stealth Mode", "Toggle stealth.", ADMIN_CATEGORY_MAIN)
	if(user.holder.fakekey)
		user.disable_stealth_mode()
	else
		user.enable_stealth_mode()

	BLACKBOX_LOG_ADMIN_VERB("Stealth Mode")

#define STEALTH_MODE_TRAIT "stealth_mode"

/client/proc/enable_stealth_mode()
	var/new_key = ckeyEx(stripped_input(usr, "Enter your desired display name.", "Fake Key", key, 26))
	if(!new_key)
		return
	holder.fakekey = new_key
	createStealthKey()
	if(isobserver(mob))
		mob.SetInvisibility(INVISIBILITY_ABSTRACT, INVISIBILITY_SOURCE_STEALTHMODE, INVISIBILITY_PRIORITY_ADMIN)
		mob.alpha = 0 //JUUUUST IN CASE
		mob.name = " "
		mob.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	ADD_TRAIT(mob, TRAIT_ORBITING_FORBIDDEN, STEALTH_MODE_TRAIT)
	QDEL_NULL(mob.orbiters)

	log_admin("[key_name(usr)] has turned stealth mode ON")
	message_admins("[key_name_admin(usr)] has turned stealth mode ON")

/client/proc/disable_stealth_mode()
	holder.fakekey = null
	if(isobserver(mob))
		mob.RemoveInvisibility(INVISIBILITY_SOURCE_STEALTHMODE)
		mob.alpha = initial(mob.alpha)
		if(mob.mind)
			if(mob.mind.ghostname)
				mob.name = mob.mind.ghostname
			else
				mob.name = mob.mind.name
		else
			mob.name = mob.real_name
		mob.mouse_opacity = initial(mob.mouse_opacity)

	REMOVE_TRAIT(mob, TRAIT_ORBITING_FORBIDDEN, STEALTH_MODE_TRAIT)

	log_admin("[key_name(usr)] has turned stealth mode OFF")
	message_admins("[key_name_admin(usr)] has turned stealth mode OFF")

#undef STEALTH_MODE_TRAIT

ADMIN_VERB(drop_bomb, R_FUN, "Drop Bomb", "Cause an explosion of varying strength at your location", ADMIN_CATEGORY_FUN)
	var/list/choices = list("Small Bomb (1, 2, 3, 3)", "Medium Bomb (2, 3, 4, 4)", "Big Bomb (3, 5, 7, 5)", "Maxcap", "Custom Bomb")
	var/choice = tgui_input_list(user, "What size explosion would you like to produce? NOTE: You can do all this rapidly and in an IC manner (using cruise missiles!) with the Config/Launch Supplypod verb. WARNING: These ignore the maxcap", "Drop Bomb", choices)
	if(isnull(choice))
		return
	var/turf/epicenter = user.mob.loc

	switch(choice)
		if("Small Bomb (1, 2, 3, 3)")
			explosion(epicenter, devastation_range = 1, heavy_impact_range = 2, light_impact_range = 3, flash_range = 3, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Medium Bomb (2, 3, 4, 4)")
			explosion(epicenter, devastation_range = 2, heavy_impact_range = 3, light_impact_range = 4, flash_range = 4, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Big Bomb (3, 5, 7, 5)")
			explosion(epicenter, devastation_range = 3, heavy_impact_range = 5, light_impact_range = 7, flash_range = 5, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Maxcap")
			explosion(epicenter, devastation_range = GLOB.MAX_EX_DEVESTATION_RANGE, heavy_impact_range = GLOB.MAX_EX_HEAVY_RANGE, light_impact_range = GLOB.MAX_EX_LIGHT_RANGE, flash_range = GLOB.MAX_EX_FLASH_RANGE, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
		if("Custom Bomb")
			var/range_devastation = input(user, "Devastation range (in tiles):") as null|num
			if(range_devastation == null)
				return
			var/range_heavy = input(user, "Heavy impact range (in tiles):") as null|num
			if(range_heavy == null)
				return
			var/range_light = input(user, "Light impact range (in tiles):") as null|num
			if(range_light == null)
				return
			var/range_flash = input(user, "Flash range (in tiles):") as null|num
			if(range_flash == null)
				return
			if(range_devastation > GLOB.MAX_EX_DEVESTATION_RANGE || range_heavy > GLOB.MAX_EX_HEAVY_RANGE || range_light > GLOB.MAX_EX_LIGHT_RANGE || range_flash > GLOB.MAX_EX_FLASH_RANGE)
				if(tgui_alert(user, "Bomb is bigger than the maxcap. Continue?",,list("Yes","No")) != "Yes")
					return
			epicenter = get_turf(user.mob) //We need to reupdate as they may have moved again
			explosion(epicenter, devastation_range = range_devastation, heavy_impact_range = range_heavy, light_impact_range = range_light, flash_range = range_flash, adminlog = TRUE, ignorecap = TRUE, explosion_cause = user.mob)
	message_admins("[ADMIN_LOOKUPFLW(user.mob)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(user)] created an admin explosion at [epicenter.loc].")
	BLACKBOX_LOG_ADMIN_VERB("Drop Bomb")

ADMIN_VERB(drop_bomb_dynex, R_FUN, "Drop DynEx Bomb", "Cause an explosion of varying strength at your location.", ADMIN_CATEGORY_FUN)
	var/ex_power = input(user, "Explosive Power:") as null|num
	var/turf/epicenter = get_turf(user.mob)
	if(!ex_power || !epicenter)
		return
	dyn_explosion(epicenter, ex_power)
	message_admins("[ADMIN_LOOKUPFLW(user.mob)] creating an admin explosion at [epicenter.loc].")
	log_admin("[key_name(user)] created an admin explosion at [epicenter.loc].")
	BLACKBOX_LOG_ADMIN_VERB("Drop Dynamic Bomb")

ADMIN_VERB(get_dynex_range, R_FUN, "Get DynEx Range", "Get the estimated range of a bomb using explosive power.", ADMIN_CATEGORY_DEBUG)
	var/ex_power = input(user, "Explosive Power:") as null|num
	if (isnull(ex_power))
		return
	var/range = round((2 * ex_power)**GLOB.DYN_EX_SCALE)
	to_chat(user, "Estimated Explosive Range: (Devastation: [round(range*0.25)], Heavy: [round(range*0.5)], Light: [round(range)])", confidential = TRUE)

ADMIN_VERB(get_dynex_power, R_FUN, "Get DynEx Power", "Get the estimated required power of a bomb to reach the given range.", ADMIN_CATEGORY_DEBUG)
	var/ex_range = input(user, "Light Explosion Range:") as null|num
	if (isnull(ex_range))
		return
	var/power = (0.5 * ex_range)**(1/GLOB.DYN_EX_SCALE)
	to_chat(user, "Estimated Explosive Power: [power]", confidential = TRUE)

ADMIN_VERB(set_dynex_scale, R_FUN, "Set DynEx Scale", "Set the scale multiplier on dynex explosions. Default 0.5.", ADMIN_CATEGORY_DEBUG)
	var/ex_scale = input(user, "New DynEx Scale:") as null|num
	if(!ex_scale)
		return
	GLOB.DYN_EX_SCALE = ex_scale
	log_admin("[key_name(user)] has modified Dynamic Explosion Scale: [ex_scale]")
	message_admins("[key_name_admin(user)] has  modified Dynamic Explosion Scale: [ex_scale]")

ADMIN_VERB(atmos_control, R_DEBUG|R_SERVER, "Atmos Control Panel", "Open the atmospherics control panel.", ADMIN_CATEGORY_DEBUG)
	SSair.ui_interact(user.mob)

ADMIN_VERB(reload_cards, R_DEBUG, "Reload Cards", "Reload all TCG cards.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	SStrading_card_game.reloadAllCardFiles()

ADMIN_VERB(validate_cards, R_DEBUG, "Validate Cards", "Validate the card settings.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/message = SStrading_card_game.check_cardpacks(SStrading_card_game.card_packs)
	message += SStrading_card_game.check_card_datums()
	if(message)
		message_admins(message)
	else
		message_admins("No errors found in card rarities or overrides.")

ADMIN_VERB(test_cardpack_distribution, R_DEBUG, "Test Cardpack Distribution", "Test the distribution of a card pack.", ADMIN_CATEGORY_DEBUG)
	if(!SStrading_card_game.loaded)
		message_admins("The card subsystem is not currently loaded")
		return
	var/pack = tgui_input_list(user, "Which pack should we test?", "You fucked it didn't you", sort_list(SStrading_card_game.card_packs))
	if(!pack)
		return
	var/batch_count = tgui_input_number(user, "How many times should we open it?", "Don't worry, I understand")
	var/batch_size = tgui_input_number(user, "How many cards per batch?", "I hope you remember to check the validation")
	var/guar = tgui_input_number(user, "Should we use the pack's guaranteed rarity? If so, how many?", "We've all been there. Man you should have seen the old system")
	SStrading_card_game.check_card_distribution(pack, batch_size, batch_count, guar)

ADMIN_VERB(print_cards, R_DEBUG, "Print Cards", "Print all cards to chat.", ADMIN_CATEGORY_DEBUG)
	SStrading_card_game.printAllCards()

ADMIN_VERB(give_mob_action, R_FUN, "Give Mob Action", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/ability_recipient)
	var/static/list/all_mob_actions = sort_list(subtypesof(/datum/action/cooldown/mob_cooldown), GLOBAL_PROC_REF(cmp_typepaths_asc))
	var/static/list/actions_by_name = list()
	if (!length(actions_by_name))
		for (var/datum/action/cooldown/mob_cooldown as anything in all_mob_actions)
			actions_by_name["[initial(mob_cooldown.name)] ([mob_cooldown])"] = mob_cooldown

	var/ability = tgui_input_list(user, "Choose an ability", "Ability", actions_by_name)
	if(isnull(ability))
		return

	var/ability_type = actions_by_name[ability]
	var/datum/action/cooldown/mob_cooldown/add_ability

	var/make_sequence = tgui_alert(user, "Would you like this action to be a sequence of multiple abilities?", "Sequence Ability", list("Yes", "No"))
	if(make_sequence == "Yes")
		add_ability = new /datum/action/cooldown/mob_cooldown(ability_recipient)
		add_ability.sequence_actions = list()
		while(!isnull(ability_type))
			var/ability_delay = tgui_input_number(user, "Enter the delay in seconds before the next ability in the sequence is used", "Ability Delay", 2)
			if(isnull(ability_delay) || ability_delay < 0)
				ability_delay = 0
			add_ability.sequence_actions[ability_type] = ability_delay * 1 SECONDS
			ability = tgui_input_list(user, "Choose a new sequence ability", "Sequence Ability", actions_by_name)
			ability_type = actions_by_name[ability]
		var/ability_cooldown = tgui_input_number(user, "Enter the sequence abilities cooldown in seconds", "Ability Cooldown", 2)
		if(isnull(ability_cooldown) || ability_cooldown < 0)
			ability_cooldown = 2
		add_ability.cooldown_time = ability_cooldown * 1 SECONDS
		var/ability_melee_cooldown = tgui_input_number(user, "Enter the abilities melee cooldown in seconds", "Melee Cooldown", 2)
		if(isnull(ability_melee_cooldown) || ability_melee_cooldown < 0)
			ability_melee_cooldown = 2
		add_ability.melee_cooldown_time = ability_melee_cooldown * 1 SECONDS
		add_ability.name = tgui_input_text(user, "Choose ability name", "Ability name", "Generic Ability")
		add_ability.create_sequence_actions()
	else
		add_ability = new ability_type(ability_recipient)

	if(isnull(ability_recipient))
		return
	add_ability.Grant(ability_recipient)

	message_admins("[key_name_admin(user)] added mob ability [ability_type] to mob [ability_recipient].")
	log_admin("[key_name(user)] added mob ability [ability_type] to mob [ability_recipient].")
	BLACKBOX_LOG_ADMIN_VERB("Add Mob Ability")

ADMIN_VERB(remove_mob_action, R_FUN, "Remove Mob Action", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/removal_target)
	var/list/target_abilities = list()
	for(var/datum/action/cooldown/mob_cooldown/ability in removal_target.actions)
		target_abilities[ability.name] = ability

	if(!length(target_abilities))
		return

	var/chosen_ability = tgui_input_list(user, "Choose the spell to remove from [removal_target]", "Depower", sort_list(target_abilities))
	if(isnull(chosen_ability))
		return
	var/datum/action/cooldown/mob_cooldown/to_remove = target_abilities[chosen_ability]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the ability [chosen_ability] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the ability [chosen_ability] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Mob Ability")

ADMIN_VERB(give_spell, R_FUN, "Give Spell", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/spell_recipient)
	var/which = tgui_alert(user, "Chose by name or by type path?", "Chose option", list("Name", "Typepath"))
	if(!which)
		return
	if(QDELETED(spell_recipient))
		to_chat(user, span_warning("The intended spell recipient no longer exists."))
		return

	var/list/spell_list = list()
	for(var/datum/action/cooldown/spell/to_add as anything in subtypesof(/datum/action/cooldown/spell))
		var/spell_name = initial(to_add.name)
		if(spell_name == "Spell") // abstract or un-named spells should be skipped.
			continue

		if(which == "Name")
			spell_list[spell_name] = to_add
		else
			spell_list += to_add

	var/chosen_spell = tgui_input_list(user, "Choose the spell to give to [spell_recipient]", "ABRAKADABRA", sort_list(spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/spell_path = which == "Typepath" ? chosen_spell : spell_list[chosen_spell]
	if(!ispath(spell_path))
		return

	var/robeless = (tgui_alert(user, "Would you like to force this spell to be robeless?", "Robeless Casting?", list("Force Robeless", "Use Spell Setting")) == "Force Robeless")

	if(QDELETED(spell_recipient))
		to_chat(user, span_warning("The intended spell recipient no longer exists."))
		return

	BLACKBOX_LOG_ADMIN_VERB("Give Spell")
	log_admin("[key_name(user)] gave [key_name(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")
	message_admins("[key_name_admin(user)] gave [key_name_admin(spell_recipient)] the spell [chosen_spell][robeless ? " (Forced robeless)" : ""].")

	var/datum/action/cooldown/spell/new_spell = new spell_path(spell_recipient.mind || spell_recipient)

	if(robeless)
		new_spell.spell_requirements &= ~SPELL_REQUIRES_WIZARD_GARB

	new_spell.Grant(spell_recipient)

	if(!spell_recipient.mind)
		to_chat(user, span_userdanger("Spells given to mindless mobs will belong to the mob and not their mind, \
			and as such will not be transferred if their mind changes body (Such as from Mindswap)."))

ADMIN_VERB(remove_spell, R_FUN, "Remove Spell", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/removal_target)
	var/list/target_spell_list = list()
	for(var/datum/action/cooldown/spell/spell in removal_target.actions)
		target_spell_list[spell.name] = spell

	if(!length(target_spell_list))
		return

	var/chosen_spell = tgui_input_list(user, "Choose the spell to remove from [removal_target]", "ABRAKADABRA", sort_list(target_spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/action/cooldown/spell/to_remove = target_spell_list[chosen_spell]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the spell [chosen_spell] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the spell [chosen_spell] from [key_name_admin(removal_target)].")
	BLACKBOX_LOG_ADMIN_VERB("Remove Spell")

ADMIN_VERB(give_disease, R_FUN, "Give Disease", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/living/victim)
	var/datum/disease/D = input(user, "Choose the disease to give to that guy", "ACHOO") as null|anything in sort_list(SSdisease.diseases, GLOBAL_PROC_REF(cmp_typepaths_asc))
	if(!D)
		return
	victim.ForceContractDisease(new D, FALSE, TRUE)
	BLACKBOX_LOG_ADMIN_VERB("Give Disease")
	log_admin("[key_name(user)] gave [key_name(victim)] the disease [D].")
	message_admins(span_adminnotice("[key_name_admin(user)] gave [key_name_admin(victim)] the disease [D]."))

ADMIN_VERB_AND_CONTEXT_MENU(object_say, R_FUN, "OSay", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, obj/speaker in world)
	var/message = tgui_input_text(user, "What do you want the message to be?", "Make Sound", encode = FALSE)
	if(!message)
		return
	speaker.say(message, sanitize = FALSE)
	log_admin("[key_name(user)] made [speaker] at [AREACOORD(speaker)] say \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(user)] made [speaker] at [AREACOORD(speaker)]. say \"[message]\""))
	BLACKBOX_LOG_ADMIN_VERB("Object Say")

ADMIN_VERB(build_mode_self, R_BUILD, "Toggle Build Mode Self", "Toggle build mode for yourself.", ADMIN_CATEGORY_EVENTS)
	togglebuildmode(user.mob) // why is this a global proc???
	BLACKBOX_LOG_ADMIN_VERB("Toggle Build Mode")

ADMIN_VERB(set_late_party, R_ADMIN, "Set Late Party", "Select the late party type.", ADMIN_CATEGORY_GAME)
	var/setting = input(usr, "Choose the bad guys party setting:", "Set Late Party") in list("caitiff", "sabbat", "hunter", "random")
	if(setting == "random")
		SSbad_guys_party.setting = null
		SSbad_guys_party.get_badguys()
	else
		SSbad_guys_party.set_badguys(setting)
		SSbad_guys_party.get_badguys()

	log_admin("[key_name(usr)] set the bad guys party setting to [setting]")
	message_admins("<span class='adminnotice'>[key_name_admin(usr)] set the bad guys party setting to [setting]</span>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Late Party")

/client/proc/deadmin()
	set name = "Deadmin"
	set category = "Admin"
	set desc = "Shed your admin powers."

	if(!holder)
		return

	if(has_antag_hud())
		toggle_combo_hud()

	holder.deactivate()

	to_chat(src, "<span class='interface'>You are now a normal player.</span>")
	log_admin("[src] deadminned themselves.")
	message_admins("[src] deadminned themselves.")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Deadmin")

/client/proc/readmin()
	set name = "Readmin"
	set category = "Admin"
	set desc = "Regain your admin powers."

//	if(GLOB.canon_event)
//		if(istype(mob, /mob/living))
//			var/cool_guy = FALSE
//			for(var/i in GLOB.psychokids)
//				if(i == "[ckey]")
//					cool_guy = TRUE
//			if(!cool_guy)
//				return

	var/datum/admins/A = GLOB.deadmins[ckey]

	if(!A)
		A = GLOB.admin_datums[ckey]
		if (!A)
			var/msg = " is trying to readmin but they have no deadmin entry"
			message_admins("[key_name_admin(src)][msg]")
			log_admin_private("[key_name(src)][msg]")
			return

	var/static/list/choices = list()
	if (!length(choices))
		choices["nothing"] = null
		for(var/datum/religion_sect/sect as anything in subtypesof(/datum/religion_sect))
			choices[initial(sect.name)] = sect
	var/choice = tgui_input_list(user, "Set new Chaplain sect", "God Picker", choices)
	if(isnull(choice))
		return
	if(choice == "nothing")
		reset_religious_sect()
		return
	set_new_religious_sect(choices[choice], reset_existing = TRUE)

ADMIN_VERB(deadmin, R_NONE, "DeAdmin", "Shed your admin powers.", ADMIN_CATEGORY_MAIN)
	user.holder.deactivate()
	to_chat(user, span_interface("You are now a normal player."))
	log_admin("[key_name(user)] deadminned themselves.")
	message_admins("[key_name_admin(user)] deadminned themselves.")
	BLACKBOX_LOG_ADMIN_VERB("Deadmin")

ADMIN_VERB(populate_world, R_DEBUG, "Populate World", "Populate the world with test mobs.", ADMIN_CATEGORY_DEBUG, amount = 50 as num)
	for (var/i in 1 to amount)
		var/turf/tile = get_safe_random_station_turf()
		var/mob/living/carbon/human/hooman = new(tile)
		hooman.equipOutfit(pick(subtypesof(/datum/outfit)))
		testing("Spawned test mob at [get_area_name(tile, TRUE)] ([tile.x],[tile.y],[tile.z])")

ADMIN_VERB(toggle_ai_interact, R_ADMIN, "Toggle Admin AI Interact", "Allows you to interact with most machines as an AI would as a ghost.", ADMIN_CATEGORY_GAME)
	user.AI_Interact = !user.AI_Interact
	if(user.mob && isAdminGhostAI(user.mob))
		user.mob.has_unlimited_silicon_privilege = user.AI_Interact

	log_admin("[key_name(user)] has [user.AI_Interact ? "activated" : "deactivated"] Admin AI Interact")
	message_admins("[key_name_admin(user)] has [user.AI_Interact ? "activated" : "deactivated"] their AI interaction")

ADMIN_VERB(debug_statpanel, R_DEBUG, "Debug Stat Panel", "Toggles local debug of the stat panel", ADMIN_CATEGORY_DEBUG)
	user.stat_panel.send_message("create_debug")

ADMIN_VERB(display_sendmaps, R_DEBUG, "Send Maps Profile", "View the profile.", ADMIN_CATEGORY_DEBUG)
	user << link("?debug=profile&type=sendmaps&window=test")

ADMIN_VERB(spawn_debug_full_crew, R_DEBUG, "Spawn Debug Full Crew", "Creates a full crew for the station, flling datacore and assigning minds and jobs.", ADMIN_CATEGORY_DEBUG)
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(user, "You should only be using this after a round has setup and started.")
		return

	// Two input checks here to make sure people are certain when they're using this.
	if(tgui_alert(user, "This command will create a bunch of dummy crewmembers with minds, job, and datacore entries, which will take a while and fill the manifest.", "Spawn Crew", list("Yes", "Cancel")) != "Yes")
		return

	if(tgui_alert(user, "I sure hope you aren't doing this on live. Are you sure?", "Spawn Crew (Be certain)", list("Yes", "Cancel")) != "Yes")
		return

	// Find the observer spawn, so we have a place to dump the dummies.
	var/obj/effect/landmark/observer_start/observer_point = locate(/obj/effect/landmark/observer_start) in GLOB.landmarks_list
	var/turf/destination = get_turf(observer_point)
	if(!destination)
		to_chat(user, "Failed to find the observer spawn to send the dummies.")
		return

	// Okay, now go through all nameable occupations.
	// Pick out all jobs that have JOB_CREW_MEMBER set.
	// Then, spawn a human and slap a person into it.
	var/number_made = 0
	for(var/rank in SSjob.name_occupations)
		var/datum/job/job = SSjob.GetJob(rank)

		// JOB_CREW_MEMBER is all jobs that pretty much aren't silicon
		if(!(job.job_flags & JOB_CREW_MEMBER))
			continue

		// Create our new_player for this job and set up its mind.
		var/mob/dead/new_player/new_guy = new()
		new_guy.mind_initialize()
		new_guy.mind.name = "[rank] Dummy"

		// Assign the rank to the new player dummy.
		if(!SSjob.AssignRole(new_guy, job, do_eligibility_checks = FALSE))
			qdel(new_guy)
			to_chat(user, "[rank] wasn't able to be spawned.")
			continue

		// It's got a job, spawn in a human and shove it in the human.
		var/mob/living/carbon/human/character = new(destination)
		character.name = new_guy.mind.name
		new_guy.mind.transfer_to(character)
		qdel(new_guy)

		// Then equip up the human with job gear.
		SSjob.EquipRank(character, job)
		job.after_latejoin_spawn(character)

		// Finally, ensure the minds are tracked and in the manifest.
		SSticker.minds += character.mind
		if(ishuman(character))
			GLOB.manifest.inject(character)

		number_made++
		CHECK_TICK

	to_chat(user, "[number_made] crewmembers have been created.")

ADMIN_VERB(debug_spell_requirements, R_DEBUG, "Debug Spell Requirements", "View all spells and their requirements.", ADMIN_CATEGORY_DEBUG)
	var/header = "<tr><th>Name</th> <th>Requirements</th>"
	var/all_requirements = list()
	for(var/datum/action/cooldown/spell/spell as anything in typesof(/datum/action/cooldown/spell))
		if(initial(spell.name) == "Spell")
			continue

		var/list/real_reqs = list()
		var/reqs = initial(spell.spell_requirements)
		if(reqs & SPELL_CASTABLE_AS_BRAIN)
			real_reqs += "Castable as brain"
		if(reqs & SPELL_REQUIRES_HUMAN)
			real_reqs += "Must be human"
		if(reqs & SPELL_REQUIRES_MIME_VOW)
			real_reqs += "Must be miming"
		if(reqs & SPELL_REQUIRES_MIND)
			real_reqs += "Must have a mind"
		if(reqs & SPELL_REQUIRES_NO_ANTIMAGIC)
			real_reqs += "Must have no antimagic"
		if(reqs & SPELL_REQUIRES_STATION)
			real_reqs += "Must be on the station z-level"
		if(reqs & SPELL_REQUIRES_WIZARD_GARB)
			real_reqs += "Must have wizard clothes"

		all_requirements += "<tr><td>[initial(spell.name)]</td> <td>[english_list(real_reqs, "No requirements")]</td></tr>"

	var/page_style = "<style>table, th, td {border: 1px solid black;border-collapse: collapse;}</style>"
	var/page_contents = "[page_style]<table style=\"width:100%\">[header][jointext(all_requirements, "")]</table>"
	var/datum/browser/popup = new(user.mob, "spellreqs", "Spell Requirements", 600, 400)
	popup.set_content(page_contents)
	popup.open()

ADMIN_VERB(load_lazy_template, R_ADMIN, "Load/Jump Lazy Template", "Loads a lazy template and/or jumps to it.", ADMIN_CATEGORY_EVENTS)
	var/list/choices = LAZY_TEMPLATE_KEY_LIST_ALL()
	var/choice = tgui_input_list(user, "Key?", "Lazy Loader", choices)
	var/teleport_to_template = tgui_input_list(user, "Jump to template after loading?", "Where to?", list("Yes", "No"))
	if(!choice)
		return

	choice = choices[choice]
	if(!choice)
		to_chat(user, span_warning("No template with that key found, report this!"))
		return

	var/already_loaded = LAZYACCESS(SSmapping.loaded_lazy_templates, choice)
	var/force_load = FALSE
	if(already_loaded && (tgui_alert(user, "Template already loaded.", "", list("Jump", "Load Again")) == "Load Again"))
		force_load = TRUE

	var/datum/turf_reservation/reservation = SSmapping.lazy_load_template(choice, force = force_load)
	if(!reservation)
		to_chat(user, span_boldwarning("Failed to load template!"))
		return

	if(teleport_to_template == "Yes")
		if(!isobserver(user.mob))
			SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)
		user.mob.forceMove(reservation.bottom_left_turfs[1])
		to_chat(user, span_boldnicegreen("Template loaded, you have been moved to the bottom left of the reservation."))

	message_admins("[key_name_admin(user)] has loaded lazy template '[choice]'")

ADMIN_VERB(library_control, R_BAN, "Library Management", "List and manage the Library.", ADMIN_CATEGORY_MAIN)
	if(!user.holder.library_manager)
		user.holder.library_manager = new
	user.holder.library_manager.ui_interact(user.mob)
	BLACKBOX_LOG_ADMIN_VERB("Library Management")

ADMIN_VERB(create_mob_worm, R_FUN, "Create Mob Worm", "Attach a linked list of mobs to your marked mob.", ADMIN_CATEGORY_FUN)
	if(!isliving(user.holder.marked_datum))
		to_chat(user, span_warning("Error: Please mark a mob to attach mobs to."))
		return
	var/mob/living/head = user.holder.marked_datum

	var/attempted_target_path = tgui_input_text(
		user,
		"Enter typepath of a mob you'd like to make your chain from.",
		"Typepath",
		"[/mob/living/basic/pet/dog/corgi/ian]",
	)

	if (isnull(attempted_target_path))
		return //The user pressed "Cancel"

	var/desired_mob = text2path(attempted_target_path)
	if(!ispath(desired_mob))
		desired_mob = pick_closest_path(attempted_target_path, make_types_fancy(subtypesof(/mob/living)))
	if(isnull(desired_mob) || !ispath(desired_mob) || QDELETED(head))
		return //The user pressed "Cancel"

	var/amount = tgui_input_number(user, "How long should our tail be?", "Worm Configurator", default = 3, min_value = 1)
	if (isnull(amount) || amount < 1 || QDELETED(head))
		return
	head.AddComponent(/datum/component/mob_chain)
	var/mob/living/previous = head
	for (var/i in 1 to amount)
		var/mob/living/segment = new desired_mob(head.drop_location())
		if (QDELETED(segment)) // ffs mobs which replace themselves with other mobs
			i--
			continue
		ADD_TRAIT(segment, TRAIT_PERMANENTLY_MORTAL, INNATE_TRAIT)
		QDEL_NULL(segment.ai_controller)
		segment.AddComponent(/datum/component/mob_chain, front = previous)
		previous = segment
