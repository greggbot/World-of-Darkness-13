//The human Numina spells.

/datum/action/cooldown/spell/numina_heal //This spell exists mainly for debugging purposes, and also to show how casting works
	name = "Touch of Peace"
	desc = "Heals a small amount of brute and burn damage."
	school = SCHOOL_HOLY
	cooldown_time = 10 SECONDS

	invocation = "Sancta Lux, corpus redintegra, animam sana."
	invocation_type = INVOCATION_WHISPER
	school = "Boni Spiritus"
	sound = 'sound/effects/magic/staff_healing.ogg'

/datum/action/cooldown/spell/numina_heal/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/numina_heal/cast(list/targets, mob/living/carbon/human/user) //Note the lack of "list/targets" here. Instead, use a "user" var depending on mob requirements.
	. = ..()
	user.visible_message("<span class='warning'>[user]'s wounds seem to heal on their own!</span>", "<span class='notice'>You give your flesh unto the lord, and your faith heals you.</span>")
	user.heal_overall_damage(brute = 10, burn = 10)

/datum/action/cooldown/spell/pointed/numina_freeze
	name = "Tears of the Martyr"
	desc = "Freezes a target in place as long as you do not move."
	school = SCHOOL_HOLY
	cooldown_time = 10 SECONDS

	invocation = "Lacrimae Martyris!"
	invocation_type = INVOCATION_WHISPER
	school = "Boni Spiritus"
	cast_range = 5

/datum/freeze_handler
	var/mob/living/carbon/human/user
	var/mob/living/carbon/human/target
	var/frozen = TRUE
	var/initial_loc

/datum/freeze_handler/New(mob/living/carbon/human/user, mob/living/carbon/human/target)
	src.user = user
	src.target = target
	src.initial_loc = user.loc
	RegisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(HandleUserClick))

/datum/freeze_handler/proc/HandleUserClick(mob/living/carbon/human/user, atom/what)
	target.AdjustStun(-15 SECONDS)
	to_chat(user, "<span class='notice'>You are no longer freezing [target].</span>")
	to_chat(target, "<span class='notice'>You are no longer frozen.</span>")
	Cleanup()

/datum/freeze_handler/proc/Cleanup()
	UnregisterSignal(user, COMSIG_MOB_CLICKON, PROC_REF(HandleUserClick))

/datum/action/cooldown/spell/pointed/numina_freeze/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(!targets.len)
		to_chat(user, "<span class='warning'>You need to target someone to freeze them!</span>")
		return

	var/mob/living/carbon/human/target = targets[1]
	if (!target)
		to_chat(user, "<span class='warning'>You need to target someone to freeze them!</span>")
		return

	var/datum/freeze_handler/freeze_handler = new(user, target)

	to_chat(target, "<span class='notice'>You witness [user] crying, and something deep inside you stops you from acting.</span>")
	to_chat(user, "<span class='notice'>You freeze [target] in place with your tears. Any movement or actions besides speech will free them.</span>")

	user.visible_message("<span class='warning'>[user] begins to cry tears of sorrow.</span>",
	"<span class='notice'>You feel tears streaming down your face as you stare into the soul of [target].</span>")
	user.emote("weeps at [target] with tears of sorrow.")

	target.Stun(15 SECONDS)
	if (user.loc != freeze_handler.initial_loc)
		target.AdjustStun(-15 SECONDS)
		to_chat(target, "<span class='notice'>You are no longer frozen.</span>")
		freeze_handler.Cleanup()
		return
	sleep(15 SECONDS)
	to_chat(user, "<span class='notice'>You are no longer freezing [target].</span>")
	to_chat(target, "<span class='notice'>You are no longer frozen.</span>")
	freeze_handler.Cleanup()
