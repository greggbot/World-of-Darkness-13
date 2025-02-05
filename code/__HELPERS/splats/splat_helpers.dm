/proc/can_learn_disciplines(mob/living/target)
	if(!iskindred(target) && !isghoul(target))
		return FALSE
	return TRUE
