#define adjust_gnosis(num, mob/living/M) (SEND_SIGNAL(M, COMSIG_ADJUST_GNOSIS, num))

/proc/can_learn_disciplines(mob/living/target)
	if(!iskindred(target) && !isghoul(target))
		return FALSE
	return TRUE
