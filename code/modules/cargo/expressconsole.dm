/obj/machinery/computer/cargo/express
	name = "Cargo Computer" //was named express supply console
	desc = "A computer used by the cargo staff to order supplies via a train."
	icon_screen = "supply_express"
	circuit = /obj/item/circuitboard/computer/cargo/express
	blockade_warning = "Bluespace instability detected. Delivery impossible."
	req_access = list(ACCESS_CARGO)
	is_express = TRUE
	interface_type = "CargoExpress"

	var/list/order_queue = list()
	var/message
	var/printed_beacons = 0 //number of beacons printed. Used to determine beacon names.
	var/list/meme_pack_data
	var/list/supply_packs = list()
	var/obj/item/supplypod_beacon/beacon //the linked supplypod beacon
	var/area/landingzone = /area/station/cargo/storage //where we droppin boys
	var/podType = /obj/structure/closet/supplypod
	var/cooldown = 0 //cooldown to prevent printing supplypod beacon spam
	var/locked = FALSE //is the console locked? unlock with ID
	var/usingBeacon = TRUE //is the console in beacon mode? exists to let beacon know when a pod may come in
	var/account_balance = 100
	var/max_orders = 10

/obj/machinery/computer/cargo/express/Initialize(mapload)
	. = ..()
	packin_up()
	for(var/obj/item/supplypod_beacon/sb in range(20, src))
		if(sb)
			if(sb.express_console != src)
				sb.altlink_console(src)
				sb.anchored = TRUE

/obj/machinery/computer/cargo/express/on_construction(mob/user)
	. = ..()
	packin_up()

/obj/machinery/computer/cargo/express/Destroy()
	if(beacon)
		beacon.unlink_console()
	return ..()

/obj/machinery/computer/cargo/express/take_damage(damage_amount, damage_type = BRUTE, damage_flag =0, sound_effect =1)
	return
/obj/machinery/computer/cargo/express/deconstruct(disassembled = TRUE)
	return

/obj/machinery/computer/cargo/express/attackby(obj/item/W, mob/living/user, params)
	if(W.GetID() && allowed(user))
		locked = !locked
		to_chat(user, span_notice("You [locked ? "lock" : "unlock"] the interface."))
		return
	else if(istype(W, /obj/item/stack/dollar))
		var/obj/item/stack/dollar/D = W
		if(D.amount)
			to_chat(user, "<span class='notice'>You insert [W] in [src].</span>")
			account_balance += D.amount
			qdel(W)
			to_chat(user, "[src]'s balance now contains [account_balance] credits.")
	else if(istype(W, /obj/item/disk/cargo/bluespace_pod))
		podType = /obj/structure/closet/supplypod/bluespacepod//doesnt effect circuit board, making reversal possible
		to_chat(user, span_notice("You insert the disk into [src], allowing for advanced supply delivery vehicles."))
		qdel(W)
		return TRUE
	else if(istype(W, /obj/item/supplypod_beacon))
		var/obj/item/supplypod_beacon/sb = W
		if (sb.express_console != src)
			sb.link_console(src, user)
			return TRUE
		else
			to_chat(user, span_alert("[src] is already linked to [sb]."))
	..()

/obj/machinery/computer/cargo/express/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(obj_flags & EMAGGED)
		return FALSE
	if(user)
		if (emag_card)
			user.visible_message(span_warning("[user] swipes [emag_card] through [src]!"))
		to_chat(user, span_notice("You change the routing protocols, allowing the Supply Pod to land anywhere on the station."))
	obj_flags |= EMAGGED
	contraband = TRUE
	// This also sets this on the circuit board
	var/obj/item/circuitboard/computer/cargo/board = circuit
	board.obj_flags |= EMAGGED
	board.contraband = TRUE
	packin_up()
	return TRUE

/obj/machinery/computer/cargo/express/proc/packin_up() // oh shit, I'm sorry
	meme_pack_data = list() // sorry for what?
	for(var/pack in subtypesof(/datum/supply_pack/vampire))
		var/datum/supply_pack/vampire/P = new pack()
		if(!P.contains)
			continue
		supply_packs[P.type] = P
	for(var/pack in supply_packs) // our quartermaster taught us not to be ashamed of our supply packs
		var/datum/supply_pack/vampire/P = supply_packs[pack]  // specially since they're such a good price and all
		if(!meme_pack_data[P.group]) // yeah, I see that, your quartermaster gave you good advice
			meme_pack_data[P.group] = list( // it gets cheaper when I return it
				"name" = P.group, // mmhm
				"packs" = list()  // sometimes, I return it so much, I rip the manifest
			) // see, my quartermaster taught me a few things too
		meme_pack_data[P.group]["packs"] += list(list(
			"name" = P.name,
			"cost" = P.get_cost(),
			"id" = pack,
			"desc" = P.desc || P.name // If there is a description, use it. Otherwise use the pack's name.
		))

/obj/machinery/computer/cargo/express/ui_interact(mob/living/user, datum/tgui/ui)
	if(iskindred(user))
		var/mob/living/carbon/human/H = user
		if(H.clane)
			if(H.clane.name == "Lasombra")
				return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CargoExpress", name)
		ui.open()

/obj/machinery/computer/cargo/express/ui_data(mob/user)
	var/canBeacon = beacon && (isturf(beacon.loc) || ismob(beacon.loc))//is the beacon in a valid location?
	var/list/data = list()
	var/datum/bank_account/D = SSeconomy.get_dep_account(cargo_account)
	if(D)
		data["points"] = D.account_balance
	data["locked"] = locked//swipe an ID to unlock
	data["siliconUser"] = HAS_SILICON_ACCESS(user)
	data["beaconzone"] = beacon ? get_area(beacon) : ""//where is the beacon located? outputs in the tgui
	data["usingBeacon"] = usingBeacon //is the mode set to deliver to the beacon or the cargobay?
	data["canBeacon"] = !usingBeacon || canBeacon //is the mode set to beacon delivery, and is the beacon in a valid location?
	data["canBuyBeacon"] = FALSE
	data["beaconError"] = usingBeacon && !canBeacon ? "(BEACON ERROR)" : ""//changes button text to include an error alert if necessary
	data["hasBeacon"] = beacon != null//is there a linked beacon?
	data["beaconName"] = beacon ? beacon.name : "No Beacon Found"
	data["printMsg"] = cooldown > 0 ? "Print Beacon for [BEACON_COST] credits ([cooldown])" : "Print Beacon for [BEACON_COST] credits"//buttontext for printing beacons
	data["supplies"] = list()
	data["total_order_cost"] = total_order_cost()
	data["order_queue"] = json_encode(serialized_order_queue)
	message = "Sales are near-instantaneous - please choose carefully."
	if(SSshuttle.supply_blocked)
		message = blockade_warning
	if(usingBeacon && !beacon)
		message = "BEACON ERROR: BEACON MISSING"//beacon was destroyed
	else if (usingBeacon && !canBeacon)
		message = "BEACON ERROR: MUST BE EXPOSED"//beacon's loc/user's loc must be a turf
	if(obj_flags & EMAGGED)
		message = "(&!#@ERROR: R0UTING_#PRO7O&OL MALF(*CT#ON. $UG%ESTE@ ACT#0N: !^/PULS3-%E)ET CIR*)ITB%ARD."
	data["message"] = message
	if(!meme_pack_data)
		packin_up()
		stack_trace("There was no pack data for [src]")
	data["supplies"] = meme_pack_data
	if (cooldown > 0)//cooldown used for printing beacons
		cooldown--
	return data

/obj/machinery/computer/cargo/express/ui_act(action, params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
//		if("LZCargo")
//			usingBeacon = FALSE
//			if (beacon)
//				beacon.update_status(SP_UNREADY) //ready light on beacon will turn off

		if("add_to_queue")
			var/id = text2path(params["id"])
			var/datum/supply_pack/vampire/pack = supply_packs[id]
			if(!istype(pack))
				return
			order_queue += list(pack)
			to_chat(usr, "Added [pack.name] to the order queue.")
			return TRUE

		if("remove_from_queue")
			var/id = text2path(params["id"])
			var/datum/supply_pack/vampire/pack = supply_packs[id]
			if(pack in order_queue)
				order_queue -= list(pack)
				to_chat(usr, "Removed [pack.name] from the order queue.")
			else
				to_chat(usr, "Could not find [pack.name] in the order queue.")
			return TRUE
		if("reset_queue")
			order_queue = list()
			to_chat(usr, "Order queue reset.")
			return TRUE
		if("finalize_order")
			if(!order_queue.len)
				to_chat(usr, "Order queue is empty.")
				return
			if(order_queue.len > max_orders)
				to_chat(usr, "You can only make 10 orders at a time!")
				return
			if(account_balance < total_order_cost())
				to_chat(usr, "Insufficient funds.")
				return
			account_balance -= total_order_cost()
			var/LZ
			if(istype(beacon) && usingBeacon)
				LZ = get_turf(beacon)
				beacon.update_status(SP_LAUNCH)
				TIMER_COOLDOWN_START(src, COOLDOWN_EXPRESSPOD_CONSOLE, 5 SECONDS)
				var/obj/cargotrain/train = new(get_nearest_free_turf(LZ))
				train.starter = usr
				train.glide_size = (32 / 3) * world.tick_lag
				walk_to(train, LZ, 1, 3)
				playsound(train, 'code/modules/wod13/sounds/train_arrive.ogg', 50, FALSE)
				var/trackLength = get_dist(get_nearest_free_turf(LZ), LZ)*5
				spawn(trackLength)
					var/obj/structure/closet/crate/crate = new(get_turf(train))
					crate.name = "Supply Crate"
					for(var/datum/supply_pack/vampire/pack in order_queue)
						for(var/item_path in pack.contains)
							var/obj/item/item_instance = new item_path
							item_instance.forceMove(crate)
					playsound(train, 'code/modules/wod13/sounds/train_depart.ogg', 50, FALSE)
					walk_to(train, get_nearest_free_turf(LZ), 1, 3)
					spawn(trackLength)
						qdel(train)
					order_queue = list()
				return

/obj/machinery/computer/cargo/express/proc/total_order_cost()
	var/total = 0
	for(var/datum/supply_pack/vampire/pack in order_queue)
		total += pack.cost
	return total
