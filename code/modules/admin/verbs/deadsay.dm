
ADMIN_VERB(dsay, R_NONE, "DSay", "Speak to the dead.", ADMIN_CATEGORY_GAME, message as text)
	if(user.prefs.muted & MUTE_DEADCHAT)
		to_chat(user, span_danger("You cannot send DSAY messages (muted)."), confidential = TRUE)
		return

	if (user.handle_spam_prevention(message,MUTE_DEADCHAT))
		return

	message = copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN)
	user.mob.log_talk(message, LOG_DSAY)

	if (!message)
		return
	var/rank_name = user.holder.rank_names()
	var/admin_name = user.key
	if(user.holder.fakekey)
		rank_name = pick(strings("admin_nicknames.json", "ranks", "config"))
		admin_name = pick(strings("admin_nicknames.json", "names", "config"))
<<<<<<< HEAD
	var/rendered = "<span class='game deadsay'><span class='name'>[rank_name]([admin_name])</span> says, <span class='message'>\"[emoji_parse(msg)]\"</span></span>" //<span class='prefix'>DEAD:</span> [ChillRaccoon] - removed due to a maggot developer
=======
	var/name_and_rank = "[span_tooltip(rank_name, "STAFF")] ([admin_name])"
>>>>>>> d1ccb530b21a3c41ef5ec37ef5f9330d6e562441

	deadchat_broadcast("[span_prefix("DEAD:")] [name_and_rank] says, <span class='message'>\"[emoji_parse(message)]\"</span>")

	BLACKBOX_LOG_ADMIN_VERB("Dsay")

/client/proc/get_dead_say()
	var/msg = input(src, null, "dsay \"text\"") as text|null
	if (isnull(msg))
		return
	SSadmin_verbs.dynamic_invoke_verb(src, /datum/admin_verb/dsay, msg)
