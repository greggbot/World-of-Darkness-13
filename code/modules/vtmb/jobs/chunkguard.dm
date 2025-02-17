
/datum/job/vamp/chunkguard
	title = "Chantry chunkguard"
	department_head = list("Prince")
	faction = "Vampire"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Traditions and the Regent"

	outfit = /datum/outfit/job/chunkguard

	paycheck = PAYCHECK_CREW
	paycheck_department = ACCOUNT_SRV
	exp_granted_type = EXP_TYPE_LIVING

	display_order = JOB_DISPLAY_ORDER_CHUNKGUARD

/datum/outfit/job/chunkguard
	name = "chunkguard"
	jobtype = /datum/job/vamp/chunkguard

	id = /obj/item/card/id/archive
	glasses = /obj/item/clothing/glasses/vampire/perception
	shoes = /obj/item/clothing/shoes/vampire
	gloves = /obj/item/clothing/gloves/vampire/latex
	uniform = /obj/item/clothing/under/vampire/guard
	r_pocket = /obj/item/vamp/keys/archive
	l_pocket = /obj/item/vamp/phone
	accessory = /obj/item/clothing/accessory/pocketprotector/full
	backpack_contents = list(/obj/item/passport=1, /obj/item/cockclock=1, /obj/item/flashlight=1, /obj/item/arcane_tome=1, /obj/item/vamp/creditcard=1, /obj/item/melee/vampirearms/katana/kosa=1)

/datum/outfit/job/chunkguard/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.gender == FEMALE)
		shoes = /obj/item/clothing/shoes/vampire/heels

/obj/effect/landmark/start/chunkguard
	name = "chunkguard"
	icon_state = "chunkguard"
