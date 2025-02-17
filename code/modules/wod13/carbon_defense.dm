/**
 * Attempt to disarm the target mob.
 * Will shove the target mob back, and drop them if they're in front of something dense
 * or another carbon.
*/

/mob/living/carbon/proc/do_rage_from_attack(var/mob/living/target)
	if(isgarou(src) || iswerewolf(src))
		if(last_rage_from_attack == 0 || last_rage_from_attack+50 < world.time)
			last_rage_from_attack = world.time
			adjust_rage(1, src, TRUE)
	if(iscathayan(src))
		if(in_frenzy)
			if(!mind?.dharma?.Po_combat)
				mind?.dharma?.Po_combat = TRUE
				call_dharma("letpo", src)
		if(mind?.dharma?.Po == "Rebel")
			emit_po_call(src, "Rebel")
		if(target)
			if("judgement" in mind?.dharma?.tenets)
				if(target.lastattacker != src)
					mind?.dharma?.deserving |= target.real_name
