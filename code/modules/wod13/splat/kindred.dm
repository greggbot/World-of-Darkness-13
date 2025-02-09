/datum/splat/supernatural/kindred
	name = "Vampire"
	splat_traits = list(
		TRAIT_VIRUSIMMUNE,	//PSEUDO_M_K kindred can spread disease, amend this
		TRAIT_NOBLEED,		//PSEUDO_M_K we need to account for losing vitae to massive damage
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCRITDAMAGE,
	)
	brutemod = 0.5
	burnmod = 2

	power_stat_name = "Vitae"
	power_stat_max = 5
	power_stat_current = 5
	integrity_name = "Humanity"
	integrity_level = 7

	var/generation = 13
	COOLDOWN_DECLARE(torpor_timer)
	COOLDOWN_DECLARE(violated_masquerade)


	var/bloodpower_time_plus = 0					//PSEUDO_M_SR
	var/thaum_damage_plus = 0						//
	var/discipline_time_plus = 0					//
	var/dust_anim = "dust-h"						//
	var/datum/vampireclane/clane					//
	var/list/datum/discipline/disciplines = list()	//
	var/last_drinkblood_click = 0					//
	var/masquerade = 5								//

/datum/action/vampireinfo
	name = "About Me"
	desc = "Check assigned role, clan, generation, humanity, masquerade, known disciplines, known contacts etc."
	button_icon_state = "masquerade"
	check_flags = NONE
	var/mob/living/carbon/human/host

/datum/action/vampireinfo/Trigger()
	if(host)
		var/dat = {"
			<style type="text/css">

			body {
				background-color: #090909; color: white;
			}

			</style>
			"}
		dat += "<center><h2>Memories</h2><BR></center>"
		dat += "[icon2html(getFlatIcon(host), host)]I am "
		if(host.real_name)
			dat += "[host.real_name],"
		if(!host.real_name)
			dat += "Unknown,"
		if(host.clane)
			dat += " the [host.clane.name]"
		if(!host.clane)
			dat += " the caitiff"

		if(host.mind)

			if(host.mind.assigned_role)
				if(host.mind.special_role)
					dat += ", carrying the [host.mind.assigned_role] (<font color=red>[host.mind.special_role]</font>) role."
				else
					dat += ", carrying the [host.mind.assigned_role] role."
			if(!host.mind.assigned_role)
				dat += "."
			dat += "<BR>"
			if(host.mind.enslaved_to)
				dat += "My Regnant is [host.mind.enslaved_to], I should obey their wants.<BR>"
		if(host.generation)
			dat += "I'm from [host.generation] generation.<BR>"
		if(host.mind.special_role)
			for(var/datum/antagonist/A in host.mind.antag_datums)
				if(A.objectives)
					dat += "[printobjectives(A.objectives)]<BR>"
		var/masquerade_level = " followed the Masquerade Tradition perfectly."
		switch(host.masquerade)
			if(4)
				masquerade_level = " broke the Masquerade rule once."
			if(3)
				masquerade_level = " made a couple of Masquerade breaches."
			if(2)
				masquerade_level = " provoked a moderate Masquerade breach."
			if(1)
				masquerade_level = " almost ruined the Masquerade."
			if(0)
				masquerade_level = "'m danger to the Masquerade and my own kind."
		dat += "Camarilla thinks I[masquerade_level]<BR>"
		var/humanity = "I'm out of my mind."
		var/enlight = FALSE
		if(host.clane)
			if(host.clane.enlightenment)
				enlight = TRUE

		if(!enlight)
			switch(host.humanity)
				if(8 to 10)
					humanity = "I'm saintly."
				if(7)
					humanity = "I feel as human as when I lived."
				if(5 to 6)
					humanity = "I'm feeling distant from my humanity."
				if(4)
					humanity = "I don't feel any compassion for the Kine anymore."
				if(2 to 3)
					humanity = "I feel hunger for <b>BLOOD</b>. My humanity is slipping away."
				if(1)
					humanity = "Blood. Feed. Hunger. It gnaws. Must <b>FEED!</b>"

		else
			switch(host.humanity)
				if(8 to 10)
					humanity = "I'm <b>ENLIGHTENED</b>, my <b>BEAST</b> and I are in complete harmony."
				if(7)
					humanity = "I've made great strides in co-existing with my beast."
				if(5 to 6)
					humanity = "I'm starting to learn how to share this unlife with my beast."
				if(4)
					humanity = "I'm still new to my path, but I'm learning."
				if(2 to 3)
					humanity = "I'm a complete novice to my path."
				if(1)
					humanity = "I'm losing control over my beast!"

		dat += "[humanity]<BR>"

		if(host.clane.name == "Brujah")
			if(GLOB.brujahname != "")
				if(host.real_name != GLOB.brujahname)
					dat += " My primogen is:  [GLOB.brujahname].<BR>"
		if(host.clane.name == "Malkavian")
			if(GLOB.malkavianname != "")
				if(host.real_name != GLOB.malkavianname)
					dat += " My primogen is:  [GLOB.malkavianname].<BR>"
		if(host.clane.name == "Nosferatu")
			if(GLOB.nosferatuname != "")
				if(host.real_name != GLOB.nosferatuname)
					dat += " My primogen is:  [GLOB.nosferatuname].<BR>"
		if(host.clane.name == "Toreador")
			if(GLOB.toreadorname != "")
				if(host.real_name != GLOB.toreadorname)
					dat += " My primogen is:  [GLOB.toreadorname].<BR>"
		if(host.clane.name == "Ventrue")
			if(GLOB.ventruename != "")
				if(host.real_name != GLOB.ventruename)
					dat += " My primogen is:  [GLOB.ventruename].<BR>"

		dat += "<b>Physique</b>: [host.physique] + [host.additional_physique]<BR>"
		dat += "<b>Dexterity</b>: [host.dexterity] + [host.additional_dexterity]<BR>"
		dat += "<b>Social</b>: [host.social] + [host.additional_social]<BR>"
		dat += "<b>Mentality</b>: [host.mentality] + [host.additional_mentality]<BR>"
		dat += "<b>Cruelty</b>: [host.blood] + [host.additional_blood]<BR>"
		dat += "<b>Lockpicking</b>: [host.lockpicking] + [host.additional_lockpicking]<BR>"
		dat += "<b>Athletics</b>: [host.athletics] + [host.additional_athletics]<BR>"
		if(host.hud_used)
			dat += "<b>Known disciplines:</b><BR>"
			for(var/datum/action/discipline/D in host.actions)
				if(D)
					if(D.discipline)
						dat += "[D.discipline.name] [D.discipline.level] - [D.discipline.desc]<BR>"
		if(host.Myself)
			if(host.Myself.Friend)
				if(host.Myself.Friend.owner)
					dat += "<b>My friend's name is [host.Myself.Friend.owner.true_real_name].</b><BR>"
					if(host.Myself.Friend.phone_number)
						dat += "Their number is [host.Myself.Friend.phone_number].<BR>"
					if(host.Myself.Friend.friend_text)
						dat += "[host.Myself.Friend.friend_text]<BR>"
			if(host.Myself.Enemy)
				if(host.Myself.Enemy.owner)
					dat += "<b>My nemesis is [host.Myself.Enemy.owner.true_real_name]!</b><BR>"
					if(host.Myself.Enemy.enemy_text)
						dat += "[host.Myself.Enemy.enemy_text]<BR>"
			if(host.Myself.Lover)
				if(host.Myself.Lover.owner)
					dat += "<b>I'm in love with [host.Myself.Lover.owner.true_real_name].</b><BR>"
					if(host.Myself.Lover.phone_number)
						dat += "Their number is [host.Myself.Lover.phone_number].<BR>"
					if(host.Myself.Lover.lover_text)
						dat += "[host.Myself.Lover.lover_text]<BR>"
		var/obj/keypad/armory/K = find_keypad(/obj/keypad/armory)
		if(K && (host.mind.assigned_role == "Prince" || host.mind.assigned_role == "Sheriff"))
			dat += "<b>The pincode for the armory keypad is: [K.pincode]</b><BR>"
		var/obj/structure/vaultdoor/pincode/bank/bankdoor = find_door_pin(/obj/structure/vaultdoor/pincode/bank)
		if(bankdoor && (host.mind.assigned_role == "Capo"))
			dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
		if(bankdoor && (host.mind.assigned_role == "La Squadra"))
			if(prob(50))
				dat += "<b>The pincode for the bank vault is: [bankdoor.pincode]</b><BR>"
			else
				dat += "<b>Unfortunately you don't know the vault code.</b><BR>"

		if(length(host.knowscontacts) > 0)
			dat += "<b>I know some other of my kind in this city. Need to check my phone, there definetely should be:</b><BR>"
			for(var/i in host.knowscontacts)
				dat += "-[i] contact<BR>"
		for(var/datum/vtm_bank_account/account in GLOB.bank_account_list)
			if(host.bank_id == account.bank_id)
				dat += "<b>My bank account code is: [account.code]</b><BR>"
		host << browse(dat, "window=vampire;size=400x450;border=1;can_resize=1;can_minimize=0")
		onclose(host, "vampire", src)

/datum/splat/supernatural/kindred/on_splat_gain(mob/living/carbon/human/C)
	. = ..()
	C.update_body(0)
	C.last_experience = world.time + 5 MINUTES
	var/datum/action/vampireinfo/infor = new()
	infor.host = C
	infor.Grant(C)
	var/datum/action/give_vitae/vitae = new()
	vitae.Grant(C)
	var/datum/action/blood_heal/bloodheal = new()
	bloodheal.Grant(C)
	var/datum/action/blood_power/bloodpower = new()
	bloodpower.Grant(C)
	add_verb(C, /mob/living/carbon/human/verb/teach_discipline)

	C.yang_chi = 0
	C.max_yang_chi = 0
	C.yin_chi = 6
	C.max_yin_chi = 6

	//vampires go to -200 damage before dying
	for (var/obj/item/bodypart/bodypart in C.bodyparts)
		bodypart.max_damage *= 1.5

	//vampires die instantly upon having their heart removed
	RegisterSignal(C, COMSIG_CARBON_LOSE_ORGAN, PROC_REF(lose_organ))

	//vampires don't die while in crit, they just slip into torpor after 2 minutes of being critted
	RegisterSignal(C, SIGNAL_ADDTRAIT(TRAIT_CRITICAL_CONDITION), PROC_REF(slip_into_torpor))

/datum/splat/supernatural/kindred/on_splat_loss(mob/living/carbon/human/C, datum/splat/new_splat, pref_load)
	. = ..()
	for(var/datum/action/vampireinfo/VI in C.actions)
		if(VI)
			VI.Remove(C)
	for(var/datum/action/A in C.actions)
		if(A)
			if(A.vampiric)
				A.Remove(C)

/datum/action/blood_power
	name = "Blood Power"
	desc = "Use vitae to gain supernatural abilities."
	button_icon_state = "bloodpower"
	button_icon = 'code/modules/wod13/UI/actions.dmi'
	background_icon_state = "discipline"
	icon_icon = 'code/modules/wod13/UI/actions.dmi'
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE

/datum/action/blood_power/ApplyIcon(atom/movable/screen/movable/action_button/current_button, force = FALSE)
	if(owner)
		if(owner.client)
			if(owner.client.prefs)
				if(owner.client.prefs.old_discipline)
					button_icon = 'code/modules/wod13/disciplines.dmi'
					icon_icon = 'code/modules/wod13/disciplines.dmi'
				else
					button_icon = 'code/modules/wod13/UI/actions.dmi'
					icon_icon = 'code/modules/wod13/UI/actions.dmi'
	. = ..()

/datum/action/blood_power/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		if (HAS_TRAIT(owner, TRAIT_TORPOR))
			return
		var/mob/living/carbon/human/BD = usr
		if(world.time < BD.last_bloodpower_use+110)
			return
		var/plus = 0
		if(HAS_TRAIT(BD, TRAIT_HUNGRY))
			plus = 1
		if(BD.bloodpool >= 2+plus)
			playsound(usr, 'code/modules/wod13/sounds/bloodhealing.ogg', 50, FALSE)
			button.color = "#970000"
			animate(button, color = "#ffffff", time = 20, loop = 1)
			BD.last_bloodpower_use = world.time
			BD.bloodpool = max(0, BD.bloodpool-(2+plus))
			to_chat(BD, "<span class='notice'>You use blood to become more powerful.</span>")
			BD.physiology.armor.melee = BD.physiology.armor.melee+15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet+15
			BD.dexterity = BD.dexterity+2
			BD.athletics = BD.athletics+2
			BD.update_blood_hud()
			addtimer(100+BD.discipline_time_plus+BD.bloodpower_time_plus)
				end_bloodpower()
		else
			SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
			to_chat(BD, "<span class='warning'>You don't have enough <b>BLOOD</b> to become more powerful.</span>")

/datum/action/blood_power/proc/end_bloodpower()
	if(owner && ishuman(owner))
		var/mob/living/carbon/human/BD = owner
		to_chat(BD, "<span class='warning'>You feel like your <b>BLOOD</b>-powers slowly decrease.</span>")
		if(BD.dna.species)
			BD.dna.species.punchdamagehigh = BD.dna.species.punchdamagehigh-5
			BD.physiology.armor.melee = BD.physiology.armor.melee-15
			BD.physiology.armor.bullet = BD.physiology.armor.bullet-15
			if(HAS_TRAIT(BD, TRAIT_IGNORESLOWDOWN))
				REMOVE_TRAIT(BD, TRAIT_IGNORESLOWDOWN, SPECIES_TRAIT)
		BD.dexterity = BD.dexterity-2
		BD.athletics = BD.athletics-2
		BD.lockpicking = BD.lockpicking-2

/datum/action/give_vitae
	name = "Give Vitae"
	desc = "Give your vitae to someone, make the Blood Bond."
	button_icon_state = "vitae"
	check_flags = AB_CHECK_HANDS_BLOCKED|AB_CHECK_IMMOBILE|AB_CHECK_LYING|AB_CHECK_CONSCIOUS
	vampiric = TRUE
	var/giving = FALSE

/datum/action/give_vitae/Trigger()
	if(istype(owner, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = owner
		if(H.bloodpool < 2)
			to_chat(owner, "<span class='warning'>You don't have enough <b>BLOOD</b> to do that!</span>")
			return
		if(istype(H.pulling, /mob/living/simple_animal))
			var/mob/living/L = H.pulling
			L.bloodpool = min(L.maxbloodpool, L.bloodpool+2)
			H.bloodpool = max(0, H.bloodpool-2)
			L.adjustBruteLoss(-25)
			L.adjustFireLoss(-25)
		if(istype(H.pulling, /mob/living/carbon/human))
			var/mob/living/carbon/human/BLOODBONDED = H.pulling
			if(iscathayan(BLOODBONDED))
				to_chat(owner, "<span class='warning'>[BLOODBONDED] vomits the vitae back!</span>")
				return
			if(!BLOODBONDED.client && !istype(H.pulling, /mob/living/carbon/human/npc))
				to_chat(owner, "<span class='warning'>You need [BLOODBONDED]'s attention to do that!</span>")
				return
			if(BLOODBONDED.stat == DEAD)
				if(!BLOODBONDED.key)
					to_chat(owner, "<span class='warning'>You need [BLOODBONDED]'s mind to Embrace!</span>")
					return
				message_admins("[ADMIN_LOOKUPFLW(H)] is Embracing [ADMIN_LOOKUPFLW(BLOODBONDED)]!")
			if(giving)
				return
			giving = TRUE
			owner.visible_message("<span class='warning'>[owner] tries to feed [BLOODBONDED] with their own blood!</span>", "<span class='notice'>You started to feed [BLOODBONDED] with your own blood.</span>")
			if(do_mob(owner, BLOODBONDED, 10 SECONDS))
				H.bloodpool = max(0, H.bloodpool-2)
				giving = FALSE

				var/new_master = FALSE
				BLOODBONDED.drunked_of |= "[H.dna.real_name]"

				if(BLOODBONDED.stat == DEAD && !is_kindred(BLOODBONDED))
					if (!BLOODBONDED.can_be_embraced)
						to_chat(H, "<span class='notice'>[BLOODBONDED.name] doesn't respond to your Vitae.</span>")
						return

					if((BLOODBONDED.timeofdeath + 5 MINUTES) > world.time)
						if (BLOODBONDED.auspice?.level) //here be Abominations
							if (BLOODBONDED.auspice.force_abomination)
								to_chat(H, "<span class='danger'>Something terrible is happening.</span>")
								to_chat(BLOODBONDED, "<span class='userdanger'>Gaia has forsaken you.</span>")
								message_admins("[ADMIN_LOOKUPFLW(H)] has turned [ADMIN_LOOKUPFLW(BLOODBONDED)] into an Abomination through an admin setting the force_abomination var.")
								log_game("[key_name(H)] has turned [key_name(BLOODBONDED)] into an Abomination through an admin setting the force_abomination var.")
							else
								switch(storyteller_roll(BLOODBONDED.auspice.level))
									if (ROLL_BOTCH)
										to_chat(H, "<span class='danger'>Something terrible is happening.</span>")
										to_chat(BLOODBONDED, "<span class='userdanger'>Gaia has forsaken you.</span>")
										message_admins("[ADMIN_LOOKUPFLW(H)] has turned [ADMIN_LOOKUPFLW(BLOODBONDED)] into an Abomination.")
										log_game("[key_name(H)] has turned [key_name(BLOODBONDED)] into an Abomination.")
									if (ROLL_FAILURE)
										BLOODBONDED.visible_message("<span class='warning'>[BLOODBONDED.name] convulses in sheer agony!</span>")
										BLOODBONDED.Shake(15, 15, 5 SECONDS)
										playsound(BLOODBONDED.loc, 'code/modules/wod13/sounds/vicissitude.ogg', 100, TRUE)
										BLOODBONDED.can_be_embraced = FALSE
										return
									if (ROLL_SUCCESS)
										to_chat(H, "<span class='notice'>[BLOODBONDED.name] does not respond to your Vitae...</span>")
										BLOODBONDED.can_be_embraced = FALSE
										return

						log_game("[key_name(H)] has Embraced [key_name(BLOODBONDED)].")
						message_admins("[ADMIN_LOOKUPFLW(H)] has Embraced [ADMIN_LOOKUPFLW(BLOODBONDED)].")
						giving = FALSE
						var/save_data_v = FALSE
						if(BLOODBONDED.revive(full_heal = TRUE, admin_revive = TRUE))
							BLOODBONDED.grab_ghost(force = TRUE)
							to_chat(BLOODBONDED, "<span class='userdanger'>You rise with a start, you're alive! Or not... You feel your soul going somewhere, as you realize you are embraced by a vampire...</span>")
							var/response_v = input(BLOODBONDED, "Do you wish to keep being a vampire on your save slot?(Yes will be a permanent choice and you can't go back!)") in list("Yes", "No")
							if(response_v == "Yes")
								save_data_v = TRUE
							else
								save_data_v = FALSE
						BLOODBONDED.roundstart_vampire = FALSE
						BLOODBONDED.set_species(/datum/splat/supernatural/kindred)
						BLOODBONDED.clane = null
						if(H.generation < 13)
							BLOODBONDED.generation = 13
							BLOODBONDED.skin_tone = get_vamp_skin_color(BLOODBONDED.skin_tone)
							BLOODBONDED.update_body()
							if (H.clane.whitelisted)
								if (!SSwhitelists.is_whitelisted(BLOODBONDED.ckey, H.clane.name))
									if(H.clane.name == "True Brujah")
										BLOODBONDED.clane = new /datum/vampireclane/brujah()
										to_chat(BLOODBONDED,"<span class='warning'> You don't got that whitelist! Changing to the non WL Brujah</span>")
									else if(H.clane.name == "Tzimisce")
										BLOODBONDED.clane = new /datum/vampireclane/old_clan_tzimisce()
										to_chat(BLOODBONDED,"<span class='warning'> You don't got that whitelist! Changing to the non WL Old Tzmisce</span>")
									else
										to_chat(BLOODBONDED,"<span class='warning'> You don't got that whitelist! Changing to a random non WL clan.</span>")
										var/list/non_whitelisted_clans = list(/datum/vampireclane/brujah,/datum/vampireclane/malkavian,/datum/vampireclane/nosferatu,/datum/vampireclane/gangrel,/datum/vampireclane/giovanni,/datum/vampireclane/ministry,/datum/vampireclane/salubri,/datum/vampireclane/toreador,/datum/vampireclane/tremere,/datum/vampireclane/ventrue)
										var/random_clan = pick(non_whitelisted_clans)
										BLOODBONDED.clane = new random_clan
								else
									BLOODBONDED.clane = new H.clane.type()
							else
								BLOODBONDED.clane = new H.clane.type()

							BLOODBONDED.clane.on_gain(BLOODBONDED)
							BLOODBONDED.clane.post_gain(BLOODBONDED)
							if(BLOODBONDED.clane.alt_sprite)
								BLOODBONDED.skin_tone = "albino"
								BLOODBONDED.update_body()

							//Gives the Childe the Sire's first three Disciplines

							var/list/disciplines_to_give = list()
							for (var/i in 1 to min(3, H.client.prefs.discipline_types.len))
								disciplines_to_give += H.client.prefs.discipline_types[i]
							BLOODBONDED.create_disciplines(FALSE, disciplines_to_give)

							BLOODBONDED.maxbloodpool = 10+((13-min(13, BLOODBONDED.generation))*3)
							BLOODBONDED.clane.enlightenment = H.clane.enlightenment
						else
							BLOODBONDED.maxbloodpool = 10+((13-min(13, BLOODBONDED.generation))*3)
							BLOODBONDED.generation = 14
							BLOODBONDED.clane = new /datum/vampireclane/caitiff()

						//Verify if they accepted to save being a vampire
						if (is_kindred(BLOODBONDED) && save_data_v)
							var/datum/preferences/BLOODBONDED_prefs_v = BLOODBONDED.client.prefs

							BLOODBONDED_prefs_v.pref_species.id = "kindred"
							BLOODBONDED_prefs_v.pref_species.name = "Vampire"
							if(H.generation < 13)

								BLOODBONDED_prefs_v.clane = BLOODBONDED.clane
								BLOODBONDED_prefs_v.generation = 13
								BLOODBONDED_prefs_v.skin_tone = get_vamp_skin_color(BLOODBONDED.skin_tone)
								BLOODBONDED_prefs_v.clane.enlightenment = H.clane.enlightenment


								//Rarely the new mid round vampires get the 3 brujah skil(it is default)
								//This will remove if it happens
								// Or if they are a ghoul with abunch of disciplines
								if(BLOODBONDED_prefs_v.discipline_types.len > 0)
									for (var/i in 1 to BLOODBONDED_prefs_v.discipline_types.len)
										var/removing_discipline = BLOODBONDED_prefs_v.discipline_types[1]
										if (removing_discipline)
											var/index = BLOODBONDED_prefs_v.discipline_types.Find(removing_discipline)
											BLOODBONDED_prefs_v.discipline_types.Cut(index, index + 1)
											BLOODBONDED_prefs_v.discipline_levels.Cut(index, index + 1)

								if(BLOODBONDED_prefs_v.discipline_types.len == 0)
									for (var/i in 1 to 3)
										BLOODBONDED_prefs_v.discipline_types += BLOODBONDED_prefs_v.clane.clane_disciplines[i]
										BLOODBONDED_prefs_v.discipline_levels += 1
								BLOODBONDED_prefs_v.save_character()

							else
								BLOODBONDED_prefs_v.generation = 13 // Game always set to 13 anyways, 14 is not possible.
								BLOODBONDED_prefs_v.clane = new /datum/vampireclane/caitiff()
								BLOODBONDED_prefs_v.save_character()

					else

						to_chat(owner, "<span class='notice'>[BLOODBONDED] is totally <b>DEAD</b>!</span>")
						giving = FALSE
						return
				else
					if(BLOODBONDED.has_status_effect(STATUS_EFFECT_INLOVE))
						BLOODBONDED.remove_status_effect(STATUS_EFFECT_INLOVE)
					BLOODBONDED.apply_status_effect(STATUS_EFFECT_INLOVE, owner)
					to_chat(owner, "<span class='notice'>You successfuly fed [BLOODBONDED] with vitae.</span>")
					to_chat(BLOODBONDED, "<span class='userlove'>You feel good when you drink this <b>BLOOD</b>...</span>")

					message_admins("[ADMIN_LOOKUPFLW(H)] has bloodbonded [ADMIN_LOOKUPFLW(BLOODBONDED)].")
					log_game("[key_name(H)] has bloodbonded [key_name(BLOODBONDED)].")

					if(H.reagents)
						if(length(H.reagents.reagent_list))
							H.reagents.trans_to(BLOODBONDED, min(10, H.reagents.total_volume), transfered_by = H, methods = VAMPIRE)
					BLOODBONDED.adjustBruteLoss(-25, TRUE)
					if(length(BLOODBONDED.all_wounds))
						var/datum/wound/W = pick(BLOODBONDED.all_wounds)
						W.remove_wound()
					BLOODBONDED.adjustFireLoss(-25, TRUE)
					BLOODBONDED.bloodpool = min(BLOODBONDED.maxbloodpool, BLOODBONDED.bloodpool+2)
					giving = FALSE

					if (is_kindred(BLOODBONDED))
						var/datum/splat/supernatural/kindred/splat = BLOODBONDED.dna.species
						if (HAS_TRAIT(BLOODBONDED, TRAIT_TORPOR) && COOLDOWN_FINISHED(species, torpor_timer))
							BLOODBONDED.untorpor()

					if(!is_ghoul(H.pulling) && istype(H.pulling, /mob/living/carbon/human/npc))
						var/mob/living/carbon/human/npc/NPC = H.pulling
						if(NPC.ghoulificate(owner))
							new_master = TRUE
//							if(NPC.hud_used)
//								var/datum/hud/human/HU = NPC.hud_used
//								HU.create_ghoulic()
							NPC.roundstart_vampire = FALSE
					if(BLOODBONDED.mind)
						if(BLOODBONDED.mind.enslaved_to != owner)
							BLOODBONDED.mind.enslave_mind_to_creator(owner)
							to_chat(BLOODBONDED, "<span class='userdanger'><b>AS PRECIOUS VITAE ENTER YOUR MOUTH, YOU NOW ARE IN THE BLOODBOND OF [H]. SERVE YOUR REGNANT CORRECTLY, OR YOUR ACTIONS WILL NOT BE TOLERATED.</b></span>")
							new_master = TRUE
					if(is_ghoul(BLOODBONDED))
						var/datum/splat/supernatural/ghoul/G = BLOODBONDED.dna.species
						G.master = owner
						G.last_vitae = world.time
						if(new_master)
							G.changed_master = TRUE
					else if(!is_kindred(BLOODBONDED) && !isnpc(BLOODBONDED))
						var/save_data_g = FALSE
						BLOODBONDED.set_species(/datum/splat/supernatural/ghoul)
						BLOODBONDED.clane = null
						var/response_g = input(BLOODBONDED, "Do you wish to keep being a ghoul on your save slot?(Yes will be a permanent choice and you can't go back)") in list("Yes", "No")
//						if(BLOODBONDED.hud_used)
//							var/datum/hud/human/HU = BLOODBONDED.hud_used
//							HU.create_ghoulic()
						BLOODBONDED.roundstart_vampire = FALSE
						var/datum/splat/supernatural/ghoul/G = BLOODBONDED.dna.species
						G.master = owner
						G.last_vitae = world.time
						if(new_master)
							G.changed_master = TRUE
						if(response_g == "Yes")
							save_data_g = TRUE
						else
							save_data_g = FALSE
						if(save_data_g)
							var/datum/preferences/BLOODBONDED_prefs_g = BLOODBONDED.client.prefs
							if(BLOODBONDED_prefs_g.discipline_types.len == 3)
								for (var/i in 1 to 3)
									var/removing_discipline = BLOODBONDED_prefs_g.discipline_types[1]
									if (removing_discipline)
										var/index = BLOODBONDED_prefs_g.discipline_types.Find(removing_discipline)
										BLOODBONDED_prefs_g.discipline_types.Cut(index, index + 1)
										BLOODBONDED_prefs_g.discipline_levels.Cut(index, index + 1)
							BLOODBONDED_prefs_g.pref_species.name = "Ghoul"
							BLOODBONDED_prefs_g.pref_species.id = "ghoul"
							BLOODBONDED_prefs_g.save_character()
			else
				giving = FALSE

/**
 * Initialises Disciplines for new vampire mobs, applying effects and creating action buttons.
 *
 * If discipline_pref is true, it grabs all of the source's Disciplines from their preferences
 * and applies those using the give_discipline() proc. If false, it instead grabs a given list
 * of Discipline typepaths and initialises those for the character. Only works for ghouls and
 * vampires, and it also applies the Clan's post_gain() effects
 *
 * Arguments:
 * * discipline_pref - Whether Disciplines will be taken from preferences. True by default.
 * * disciplines - list of Discipline typepaths to grant if discipline_pref is false.
 */
/mob/living/carbon/human/proc/create_disciplines(discipline_pref = TRUE, list/disciplines)	//EMBRACE BASIC
	if(client)
		client.prefs.slotlocked = TRUE
		client.prefs.save_preferences()
		client.prefs.save_character()

	if((dna.species.id == "kindred") || (dna.species.id == "ghoul")) //only splats that have Disciplines qualify
		var/list/datum/discipline/adding_disciplines = list()

		if (discipline_pref) //initialise character's own disciplines
			for (var/i in 1 to client.prefs.discipline_types.len)
				var/type_to_create = client.prefs.discipline_types[i]
				var/datum/discipline/discipline = new type_to_create

				//prevent Disciplines from being used if not whitelisted for them
				if (discipline.clane_restricted)
					if (!can_access_discipline(src, type_to_create))
						qdel(discipline)
						continue

				discipline.level = client.prefs.discipline_levels[i]
				adding_disciplines += discipline
		else if (disciplines.len) //initialise given disciplines
			for (var/i in 1 to disciplines.len)
				var/type_to_create = disciplines[i]
				var/datum/discipline/discipline = new type_to_create
				adding_disciplines += discipline

		for (var/datum/discipline/discipline in adding_disciplines)
			give_discipline(discipline)

		if(clane)
			clane.post_gain(src)

	if((dna.species.id == "kuei-jin")) //only splats that have Disciplines qualify
		var/list/datum/chi_discipline/adding_disciplines = list()

		if (discipline_pref) //initialise character's own disciplines
			for (var/i in 1 to client.prefs.discipline_types.len)
				var/type_to_create = client.prefs.discipline_types[i]
				var/datum/chi_discipline/discipline = new type_to_create
				discipline.level = client.prefs.discipline_levels[i]
				adding_disciplines += discipline

		for (var/datum/chi_discipline/discipline in adding_disciplines)
			give_chi_discipline(discipline)

/**
 * Creates an action button and applies post_gain effects of the given Discipline.
 *
 * Arguments:
 * * discipline - Discipline datum that is being given to this mob.
 */
/mob/living/carbon/human/proc/give_discipline(datum/discipline/discipline)
	if (discipline.level > 0)
		var/datum/action/discipline/action = new
		action.discipline = discipline
		action.Grant(src)
	discipline.post_gain(src)
	var/datum/splat/supernatural/kindred/splat = dna.species
	species.disciplines += discipline

/mob/living/carbon/human/proc/give_chi_discipline(datum/chi_discipline/discipline)
	if (discipline.level > 0)
		var/datum/action/chi_discipline/action = new
		action.discipline = discipline
		action.Grant(src)
	discipline.post_gain(src)

/**
 * Accesses a certain Discipline that a Kindred has. Returns false if they don't.
 *
 * Arguments:
 * * searched_discipline - Name or typepath of the Discipline being searched for.
 */
/datum/splat/supernatural/kindred/proc/get_discipline(searched_discipline)
	for(var/datum/discipline/discipline in disciplines)
		if (ispath(searched_discipline, /datum/discipline))
			if (istype(discipline, searched_discipline))
				return discipline
		else if (istext(searched_discipline))
			if (discipline.name == searched_discipline)
				return discipline

	return FALSE

/datum/splat/supernatural/kindred/check_roundstart_eligible()
	return TRUE

/datum/splat/supernatural/kindred/handle_body(mob/living/carbon/human/H)
	if (!H.clane)
		return ..()

	//deflate people if they're super rotten
	if ((H.clane.alt_sprite == "rotten4") && (H.base_body_mod == "f"))
		H.base_body_mod = ""

	if(H.clane.alt_sprite)
		H.dna.species.limbs_id = "[H.base_body_mod][H.clane.alt_sprite]"

	if (H.clane.no_hair)
		H.hairstyle = "Bald"

	if (H.clane.no_facial)
		H.facial_hairstyle = "Shaved"

	..()


/**
 * Signal handler for lose_organ to near-instantly kill Kindred whose hearts have been removed.
 *
 * Arguments:
 * * source - The Kindred whose organ has been removed.
 * * organ - The organ which has been removed.
 */
/datum/splat/supernatural/kindred/proc/lose_organ(var/mob/living/carbon/human/source, var/obj/item/organ/organ)
	SIGNAL_HANDLER

	if (istype(organ, /obj/item/organ/heart))
		spawn()
			if (!source.getorganslot(ORGAN_SLOT_HEART))
				source.death()

/datum/splat/supernatural/kindred/proc/slip_into_torpor(var/mob/living/carbon/human/source)
	SIGNAL_HANDLER

	to_chat(source, "<span class='warning'>You can feel yourself slipping into Torpor. You can use succumb to immediately sleep...</span>")
	spawn(2 MINUTES)
		if (source.stat >= SOFT_CRIT)
			source.torpor("damage")

/**
 * Verb to teach your Disciplines to vampires who have drank your blood by spending 10 experience points.
 *
 * Disciplines can be taught to any willing vampires who have drank your blood in the last round and do
 * not already have that Discipline. True Brujah learning Celerity or Old Clan Tzimisce learning Vicissitude
 * get kicked out of their bloodline and made into normal Brujah and Tzimisce respectively. Disciplines
 * are taught at the 0th level, unlocking them but not actually giving the Discipline to the student.
 * Teaching Disciplines takes 10 experience points, then the student can buy the 1st rank for another 10.
 * The teacher must have the Discipline at the 5th level to teach it to others.
 *
 * Arguments:
 * * student - human who this Discipline is being taught to.
 */
/mob/living/carbon/human/verb/teach_discipline(mob/living/carbon/human/student in (range(1, src) - src))
	set name = "Teach Discipline"
	set category = "IC"
	set desc ="Teach a Discipline to a Kindred who has recently drank your blood. Costs 10 experience points."

	var/mob/living/carbon/human/teacher = src
	var/datum/preferences/teacher_prefs = teacher.client.prefs
	var/datum/splat/supernatural/kindred/teacher_species = teacher.dna.species

	if (!student.client)
		to_chat(teacher, "<span class='warning'>Your student needs to be a player!</span>")
		return
	var/datum/preferences/student_prefs = student.client.prefs

	if (!is_kindred(student))
		to_chat(teacher, "<span class='warning'>Your student needs to be a vampire!</span>")
		return
	if (student.stat >= SOFT_CRIT)
		to_chat(teacher, "<span class='warning'>Your student needs to be conscious!</span>")
		return
	if (teacher_prefs.true_experience < 10)
		to_chat(teacher, "<span class='warning'>You don't have enough experience to teach them this Discipline!</span>")
		return
	//checks that the teacher has blood bonded the student, this is something that needs to be reworked when blood bonds are made better
	if (student.mind.enslaved_to != teacher)
		to_chat(teacher, "<span class='warning'>You need to have fed your student your blood to teach them Disciplines!</span>")
		return

	var/possible_disciplines = teacher_prefs.discipline_types - student_prefs.discipline_types
	var/teaching_discipline = input(teacher, "What Discipline do you want to teach [student.name]?", "Discipline Selection") as null|anything in possible_disciplines

	if (teaching_discipline)
		var/datum/discipline/teacher_discipline = teacher_species.get_discipline(teaching_discipline)
		var/datum/discipline/giving_discipline = new teaching_discipline

		//if a Discipline is clan-restricted, it must be checked if the student has access to at least one Clan with that Discipline
		if (giving_discipline.clane_restricted)
			if (!can_access_discipline(student, teaching_discipline))
				to_chat(teacher, "<span class='warning'>Your student is not whitelisted for any Clans with this Discipline, so they cannot learn it.</span>")
				qdel(giving_discipline)
				return

		//ensure the teacher's mastered it, also prevents them from teaching with free starting experience
		if (teacher_discipline.level < 5)
			to_chat(teacher, "<span class='warning'>You do not know this Discipline well enough to teach it. You need to master it to the 5th rank.</span>")
			qdel(giving_discipline)
			return

		var/restricted = giving_discipline.clane_restricted
		if (restricted)
			if (alert(teacher, "Are you sure you want to teach [student] [giving_discipline], one of your Clan's most tightly guarded secrets? This will cost 10 experience points.", "Confirmation", "Yes", "No") != "Yes")
				qdel(giving_discipline)
				return
		else
			if (alert(teacher, "Are you sure you want to teach [student] [giving_discipline]? This will cost 10 experience points.", "Confirmation", "Yes", "No") != "Yes")
				qdel(giving_discipline)
				return

		var/alienation = FALSE
		if (student.clane.restricted_disciplines.Find(teaching_discipline))
			if (alert(student, "Learning [giving_discipline] will alienate you from the rest of the [student.clane], making you just like the false Clan. Do you wish to continue?", "Confirmation", "Yes", "No") != "Yes")
				visible_message("<span class='warning'>[student] refuses [teacher]'s mentoring!</span>")
				qdel(giving_discipline)
				return
			else
				alienation = TRUE
				to_chat(teacher, "<span class='notice'>[student] accepts your mentoring!</span>")

		if (get_dist(student.loc, teacher.loc) > 1)
			to_chat(teacher, "<span class='warning'>Your student needs to be next to you!</span>")
			qdel(giving_discipline)
			return

		visible_message("<span class='notice'>[teacher] begins mentoring [student] in [giving_discipline].</span>")
		if (do_after(teacher, 30 SECONDS, student))
			teacher_prefs.true_experience -= 10

			student_prefs.discipline_types += teaching_discipline
			student_prefs.discipline_levels += 0

			if (alienation)
				var/datum/vampireclane/main_clan
				switch(student.clane.type)
					if (/datum/vampireclane/true_brujah)
						main_clan = new /datum/vampireclane/brujah
					if (/datum/vampireclane/old_clan_tzimisce)
						main_clan = new /datum/vampireclane/tzimisce

				student_prefs.clane = main_clan
				student.clane = main_clan

			student_prefs.save_character()
			teacher_prefs.save_character()

			to_chat(teacher, "<span class='notice'>You finish teaching [student] the basics of [giving_discipline]. [student.p_they(TRUE)] seem[student.p_s()] to have absorbed your mentoring.[restricted ? " May your Clanmates take mercy on your soul for spreading their secrets." : ""]</span>")
			to_chat(student, "<span class='nicegreen'>[teacher] has taught you the basics of [giving_discipline]. You may now spend experience points to learn its first level in the character menu.</span>")

			message_admins("[ADMIN_LOOKUPFLW(teacher)] taught [ADMIN_LOOKUPFLW(student)] the Discipline [giving_discipline.name].")
			log_game("[key_name(teacher)] taught [key_name(student)] the Discipline [giving_discipline.name].")

		qdel(giving_discipline)


//Vampires take 4% of their max health in burn damage every tick they are on fire. Very potent against lower-gens.
//Set at 0.02 because they already take twice as much burn damage.
/datum/species/kindred/handle_fire(mob/living/carbon/human/H, no_protection)
	if(!..())
		H.adjustFireLoss(H.maxHealth * 0.02)

/**
 * Checks a vampire for whitelist access to a Discipline.
 *
 * Checks the given vampire to see if they have access to a certain Discipline through
 * one of their selectable Clans. This is only necessary for "unique" or Clan-restricted
 * Disciplines, as those have a chance to only be available to a certain Clan that
 * the vampire may or may not be whitelisted for.
 *
 * Arguments:
 * * vampire_checking - The vampire mob being checked for their access.
 * * discipline_checking - The Discipline type that access to is being checked.
 */
/proc/can_access_discipline(mob/living/carbon/human/vampire_checking, discipline_checking)
	if (isghoul(vampire_checking))
		return TRUE
	if (!iskindred(vampire_checking))
		return FALSE
	if (!vampire_checking.client)
		return FALSE

	//make sure it's actually restricted and this check is necessary
	var/datum/discipline/discipline_object_checking = new discipline_checking
	if (!discipline_object_checking.clane_restricted)
		qdel(discipline_object_checking)
		return TRUE
	qdel(discipline_object_checking)

	//first, check their Clan Disciplines to see if that gives them access
	if (vampire_checking.clane.clane_disciplines.Find(discipline_checking))
		return TRUE

	//next, go through all Clans to check if they have access to any with the Discipline
	for (var/clan_type in subtypesof(/datum/vampireclane))
		var/datum/vampireclane/clan_checking = new clan_type

		//skip this if they can't access it due to whitelists
		if (clan_checking.whitelisted)
			if (!SSwhitelists.is_whitelisted(checked_ckey = vampire_checking.ckey, checked_whitelist = clan_checking.name))
				qdel(clan_checking)
				continue

		if (clan_checking.clane_disciplines.Find(discipline_checking))
			qdel(clan_checking)
			return TRUE

		qdel(clan_checking)

	//nothing found
	return FALSE

/datum/preferences
	var/last_torpor = 0

/mob/living/carbon/human/death()
	. = ..()

	if(iskindred(src))
		SSmasquerade.dead_level = min(1000, SSmasquerade.dead_level+50)
	else
		if(istype(get_area(src), /area/vtm))
			var/area/vtm/V = get_area(src)
			if(V.zone_type == "masquerade")
				SSmasquerade.dead_level = max(0, SSmasquerade.dead_level-25)

	if(bloodhunted)
		SSbloodhunt.hunted -= src
		bloodhunted = FALSE
		SSbloodhunt.update_shit()
	var/witness_count
	for(var/mob/living/carbon/human/npc/NEPIC in viewers(7, usr))
		if(NEPIC && NEPIC.stat != DEAD)
			witness_count++
		if(witness_count > 1)
			for(var/obj/item/police_radio/radio in GLOB.police_radios)
				radio.announce_crime("murder", get_turf(src))
			for(var/obj/item/p25radio/police/radio in GLOB.p25_radios)
				if(radio.linked_network == "police")
					radio.announce_crime("murder", get_turf(src))
	GLOB.masquerade_breakers_list -= src
	GLOB.sabbatites -= src

	//So upon death the corpse is filled with yin chi
	yin_chi = min(max_yin_chi, yin_chi+yang_chi)
	yang_chi = 0

	if(iskindred(src) || iscathayan(src))
		can_be_embraced = FALSE
		var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN) //NO REVIVAL EVER
		if (brain)
			brain.organ_flags |= ORGAN_FAILING

		if(in_frenzy)
			exit_frenzymod()
		SEND_SOUND(src, sound('code/modules/wod13/sounds/final_death.ogg', 0, 0, 50))

		//annoying code that depends on clan doesn't work for Kuei-jin
		if (iscathayan(src))
			return

		var/years_undead = chronological_age - age
		switch (years_undead)
			if (-INFINITY to 10) //normal corpse
				return
			if (10 to 50)
				clane.rot_body(1) //skin takes on a weird colouration
				visible_message("<span class='notice'>[src]'s skin loses some of its colour.</span>")
				update_body()
				update_body() //this seems to be necessary due to stuff being set on update_body() and then only refreshing with a new call
			if (50 to 100)
				clane.rot_body(2) //looks slightly decayed
				visible_message("<span class='notice'>[src]'s skin rapidly decays.</span>")
				update_body()
				update_body()
			if (100 to 150)
				clane.rot_body(3) //looks very decayed
				visible_message("<span class='warning'>[src]'s body rapidly decomposes!</span>")
				update_body()
				update_body()
			if (150 to 200)
				clane.rot_body(4) //mummified skeletonised corpse
				visible_message("<span class='warning'>[src]'s body rapidly skeletonises!</span>")
				update_body()
				update_body()
			if (200 to INFINITY)
				if (iskindred(src))
					playsound(src, 'code/modules/wod13/sounds/burning_death.ogg', 80, TRUE)
				else if (iscathayan(src))
					playsound(src, 'code/modules/wod13/sounds/vicissitude.ogg', 80, TRUE)
				lying_fix()
				dir = SOUTH
				spawn(1 SECONDS)
					dust(TRUE, TRUE) //turn to ash

/datum/keybinding/human/bite // PSEUDO_M_K need to add vampire section to controls
	hotkey_keys = list("F")
	name = "bite"
	full_name = "Bite"
	description = "Bite whoever you're aggressively grabbing, and feed on them if possible."
	keybind_signal = COMSIG_KB_HUMAN_BITE_DOWN

/datum/keybinding/human/bite/down(client/user)
	. = ..()
	if(.)
		return
	//the code below is directly imported from onyxcombat.dm's /atom/movable/screen/drinkblood/Click() proc
	//turning all of this into one centralised proc would be preferable, but it requires more effort than I'm willing to put in right now
	if(ishuman(user.mob))
		var/mob/living/carbon/human/BD = user.mob
		BD.update_blood_hud()
		if(world.time < BD.last_drinkblood_use+30)
			return
		if(world.time < BD.last_drinkblood_click+10)
			return
		BD.last_drinkblood_click = world.time
		if(BD.grab_state > GRAB_PASSIVE)
			if(ishuman(BD.pulling))
				var/mob/living/carbon/human/PB = BD.pulling
				if(isghoul(user.mob))
					if(!iskindred(PB))
						SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
						to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
						return
				if(!isghoul(user.mob) && !iskindred(user.mob) && !iscathayan(user.mob))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				if(PB.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(user.mob))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				if(PB.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(BD.clane)
					var/special_clan = FALSE
					if(BD.clane.name == "Salubri")
						if(!PB.IsSleeping())
							to_chat(BD, "<span class='warning'>You can't drink from aware targets!</span>")
							return
						special_clan = TRUE
						PB.emote("moan")
					if(BD.clane.name == "Giovanni")
						PB.emote("scream")
						special_clan = TRUE
					if(!special_clan)
						PB.emote("groan")
				PB.add_bite_animation()
			if(isliving(BD.pulling))
				if(!iskindred(BD) && !iscathayan(BD))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>Eww, that is <b>GROSS</b>.</span>")
					return
				var/mob/living/LV = BD.pulling
				if(LV.bloodpool <= 0 && (!iskindred(BD.pulling) || !iskindred(BD)))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>There is no <b>BLOOD</b> in this creature.</span>")
					return
				if(LV.stat == DEAD && !HAS_TRAIT(BD, TRAIT_GULLET) && !iscathayan(user.mob))
					SEND_SOUND(BD, sound('code/modules/wod13/sounds/need_blood.ogg', 0, 0, 75))
					to_chat(BD, "<span class='warning'>This creature is <b>DEAD</b>.</span>")
					return
				var/skipface = (BD.wear_mask && (BD.wear_mask.flags_inv & HIDEFACE)) || (BD.head && (BD.head.flags_inv & HIDEFACE))
				if(!skipface)
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						playsound(BD, 'code/modules/wod13/sounds/drinkblood1.ogg', 50, TRUE)
						LV.visible_message("<span class='warning'><b>[BD] bites [LV]'s neck!</b></span>", "<span class='warning'><b>[BD] bites your neck!</b></span>")
					if(!HAS_TRAIT(BD, TRAIT_BLOODY_LOVER))
						if(BD.CheckEyewitness(LV, BD, 7, FALSE))
							BD.AdjustMasquerade(-1)
					else
						playsound(BD, 'code/modules/wod13/sounds/kiss.ogg', 50, TRUE)
						LV.visible_message("<span class='italics'><b>[BD] kisses [LV]!</b></span>", "<span class='userlove'><b>[BD] kisses you!</b></span>")
					if(iskindred(LV))
						var/mob/living/carbon/human/HV = BD.pulling
						if(HV.stakeimmune)
							to_chat(BD, "<span class='warning'>There is no <b>HEART</b> in this creature.</span>")
							return
					BD.drinksomeblood(LV)
	return TRUE

/mob/living/carbon/human/Life()
	if(!iskindred(src) && !iscathayan(src))
		if(prob(5))
			adjustCloneLoss(-5, TRUE)
	update_blood_hud()
	update_zone_hud()
	update_rage_hud()
	update_shadow()
	handle_vampire_music()
	update_auspex_hud()
	if(warrant)
		last_nonraid = world.time
		if(key)
			if(stat != DEAD)
				if(istype(get_area(src), /area/vtm))
					var/area/vtm/V = get_area(src)
					if(V.upper)
						last_showed = world.time
						if(last_raid+600 < world.time)
							last_raid = world.time
							for(var/turf/open/O in range(1, src))
								if(prob(25))
									new /obj/effect/temp_visual/desant(O)
							playsound(loc, 'code/modules/wod13/sounds/helicopter.ogg', 50, TRUE)
				if(last_showed+9000 < world.time)
					to_chat(src, "<b>POLICE STOPPED SEARCHING</b>")
					SEND_SOUND(src, sound('code/modules/wod13/sounds/humanity_gain.ogg', 0, 0, 75))
					killed_count = 0
					warrant = FALSE
			else
				warrant = FALSE
		else
			warrant = FALSE
	else
		if(last_nonraid+1800 < world.time)
			last_nonraid = world.time
			killed_count = max(0, killed_count-1)

	..()

/mob/living/proc/update_blood_hud()
	if(!client || !hud_used)
		return
	maxbloodpool = 10+((13-generation)*3)
	if(hud_used.blood_icon)
		var/emm = round((bloodpool/maxbloodpool)*10)
		if(emm > 10)
			hud_used.blood_icon.icon_state = "blood10"
		if(emm < 0)
			hud_used.blood_icon.icon_state = "blood0"
		else
			hud_used.blood_icon.icon_state = "blood[emm]"
