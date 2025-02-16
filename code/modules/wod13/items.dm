/obj/item
	//lombard.dm VARIABLES
	///Determines whether an item can be sold in the black market.
	var/illegal = FALSE

	//gridventory.dm VARIABLES
	///Width we occupy on the gridventory hud - Keep null to generate based on w_class
	var/grid_width = 1 GRID_BOXES
	///Height we occupy on the gridventory hud - Keep null to generate based on w_class
	var/grid_height = 1 GRID_BOXES

	///If this item is made out of "cold iron" and harms fairy creatures or yang-disbalanced cathayans
	var/is_iron = FALSE
	///If this item is made out of "wood" and harms yin-disbalanced cathayans
	var/is_wood = FALSE
	///If this item is magical and thus picked up on magic senses
	var/is_magic = FALSE
