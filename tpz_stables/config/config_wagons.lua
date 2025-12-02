-- The command to call a wagon from the nearest stable.
Config.CallWagonCommand = 'callwagon'

-- The command to call a wagon from the nearest stable.
Config.CallWagonKey = { Enabled = true, Key = 0xF3830D8E } -- J key by default.

-- How close should a player be to the nearest stable for calling a wagon?
-- This is also for storing the wagons.
-- (!) If player is too far from a stable, we should not allow wagon calling.
Config.CallWagonNearStableDistance = 100.0

Config.CallWagonCooldown = 5 -- time in seconds

-- Despawn the wagon when player is too far from the entity.
Config.WagonDespawnDistance = 200.0 -- (!) ALWAYS BIGGER RADIUS DISTANCE FROM @CallWagonNearStableDistance

-- Before despawning, we check if there are near players in case they are interacting with the wagon.
Config.WagonDespawnCheckNearPlayersDistance = 100.0

-- Every how often the SPAWNED owned wagon should it be saved?
Config.SaveWagonTime = 60 -- Time in seconds. (1 minute by default)

-- The distance between the player and the wagon to display actions.
Config.WagonActionDistance = 2.5

Config.WagonStorageSearching = {
	Key = 0x760A9C6F, -- DO NOT USE [F] OR [E]
	PromptDisplay = 'Open Storage', 
}

Config.WagonWardrobeOutfits = { 
	Enabled = true, 
	Key = 0xC7B5340A, -- DO NOT USE [F] OR [E]
	PromptDisplay = 'Open Wardrobe', 
	ClientEvent = "tpz_clothing:client:openWardrobeOutfits", -- the event to trigger client side for opening wardrobes.
}

-- The specified prompt is displayed when the wagon is destroyed or is undrivable (if enabled).
-- It is also displayed when the wagon is nearby a stable for storing.
Config.StoreWagonPrompt = { 
	Key = 0x4AF4D473, -- DO NOT USE [F] OR [E] OR ANY KEY THAT IS ALREADY USED FOR WARDROBE OR STORAGE ACCESS.
	PromptDisplay = 'Store Wagon', 
}

Config.WagonRepairs = {

	Key = 0x05CA7C52, -- DO NOT USE [F] OR [E] OR ANY KEY THAT IS ALREADY USED FOR STORING, WARDROBE OR STORAGE ACCESS.
	PromptDisplay = 'Repair Wagon', 

	Jobs = { 'carpenter' },

	Item = 'hammer', -- Player must be having this item on the inventory for repairs.

	-- (!) The required materials are per wheel, if a wagon has (2) broken wheels, the materials will be multiplied by (2).
	RepairMaterials = { -- Set @RepairMaterials to false or {} to disable.

		{ item = 'wooden_sticks', label = 'Wooden Sticks', required_quantity = 10 },
		{ item = 'copper',        label = 'Copper',        required_quantity = 4  },

	},

    ObjectAttachment = {
        Object     = "p_hammer04x", 
        Attachment = "skel_r_hand", 
        x = 0.08, y = -0.04, z = -0.05, xRot = -76.0, yRot = 10.0, zRot = 0.0
    },  

	RepairingAnimationDuration = 10, -- time in seconds.
	RepairingProgressTextDisplay = 'Repairing..',

	RepairingAnimation = {

		['MALE'] = {
			Dict = "amb_work@world_human_hammer_kneel_stakes@male@male_a@idle_a",
			Name = 'idle_a',
			Flag = 1
		},

		['FEMALE'] = {
			Dict = "amb_work@world_human_hammer_kneel_stakes@male@male_a@idle_a",
			Name = 'idle_a',
			Flag = 1
		},
	},
	
}


-- The specified feature for stow and take out is only for the huntercart01 model.
Config.HuntingWagonPrompts = { 
	Key = 0xE30CD707, -- R
	PromptDisplay = 'Stow', 
	TakeOutPromptDisplay = 'Take Out', 
}

-- (!) THE GOLD PRICES ARE NOT CORRECT FOR BUYING OR SELLING, THOSE ARE JUST EXAMPLES.
-- ALWAYS MODIFY THE PRICES BASED ON YOUR SERVER PREFERENCES AND MAKE SURE THE SELLING CASH AND GOLD ARE MODIFIED AFTER JOBS PARAMETER.

-- ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )

Config.Wagons = {

	{

	    Category = 'Carts',
		BackgroundImage = "carts",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"cart01", "Cart 1", 50, 15, 25, {}, 0, 0 },
			{"cart02", "Cart 2", 30, 15, 25, {}, 0, 0 },
			{"cart03", "Cart 3", 60, 15, 25, {}, 0, 0 },
			{"cart04", "Cart 4", 90, 20, 50, {}, 0, 0 },
			{"cart05", "Cart 5", 55, 15, 25, {}, 0, 0 },
			{"cart06", "Cart 6", 125, 25, 100, {}, 0, 0 },
			{"cart07", "Cart 7", 60, 15, 25, {}, 0, 0 },
			{"cart08", "Cart 8", 60, 15, 25, {}, 0, 0 },      
		},
	},

	{

	    Category = 'Coaches',
		BackgroundImage = "coaches",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"coach2", "Coach 1", 500, 60, 300, {}, 0, 0 },
			{"coach3", "Coach 2", 300, 40, 200, {}, 0, 0 },
			{"coach4", "Coach 3", 300, 40, 200, {}, 0, 0 },
			{"coach5", "Coach 4", 300, 40, 200, {}, 0, 0 },
			{"coach6", "Coach 6", 280, 35, 150, {}, 0, 0 },    
		},
	},

	{

	    Category = 'Stagecoach',
		BackgroundImage = "stagecoach",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"stagecoach001x", "Stagecoach 1", 275, 35, 150, {}, 0, 0 },
			{"stagecoach002x", "Stagecoach 2", 275, 35, 150, {}, 0, 0 },
			{"stagecoach004_2x", "Stagecoach 4", 275, 35, 150, {}, 0, 0 },
			{"stagecoach004x", "Stagecoach 5", 275, 35, 150, {}, 0, 0 },
			{"stagecoach006x", "Stagecoach 7",  275, 35, 150, {}, 0, 0 },    
		},
	},

	{

	    Category = 'Wagons',
		BackgroundImage = "wagons",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"chuckwagon000X", "Chuck Wagon 1", 160, 35, 150, {}, 0, 0 },
			{"chuckwagon002X", "Chuck Wagon 2", 160, 35, 150, {}, 0, 0 },
			{"wagon02x", "Wagon 1", 150, 35, 150, {}, 0, 0 },  
			{"wagon03x", "Wagon 2", 115, 35, 150, {}, 0, 0 },  
			{"wagon05x", "Wagon 4", 150, 35, 150, {}, 0, 0 },  
		},
	},

	
	{

	    Category = 'Buggy',
		BackgroundImage = "buggy",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"buggy01", "Buggy 1", 50, 15, 25, {}, 0, 0 },
			{"buggy02", "Buggy 2", 50, 15, 25, {}, 0, 0 },
			{"buggy03", "Buggy 3", 50, 15, 25, {}, 0, 0 },  
		},
	},

	{

	    Category = 'Utility',
		BackgroundImage = "other",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {

			{"huntercart01", "Hunter Cart", 175, 35, 150, {}, 0, 0 },  
			{"coal_wagon", "Coal Wagon", 130, 35, 150, { "miner"}, 0, 0 },  
			{"logwagon", "Log Wagon", 130, 35, 150, { "lumberjack" }, 0, 0 },  
			{"supplywagon", "Supply Wagon", 300, 40, 200, {}, 0, 0 },  

			{"WAGONDOC01X", "Doctor Wagon", 100, 35, 150, { "doctor", "medic" }, 0, 0 }, 

			{"bountywagon01x", "Bounty Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 0, 0 },
			{"ArmySupplyWagon", "Army Supply Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 0, 0  },
			{"policeWagon01x", "Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 0, 0  },  
			--{"policeWagongatling01x", "Gatling Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  },  
			{"wagonarmoured01x", "Armoured Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" }, 0, 0  },  
			{"wagonPrison01x", "Prison Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" }, 0, 0  }, 
			--{"warWagon2", "War Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  }, 
			{"gatchuck_2", "GatChuck 2", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 0, 0  }, 
		},
	},

}


-- How many items should the hunting wagon can carry.
Config.MaxHuntingWagonCargo = 10 

-- The specified models below are for hunting wagons only.
Config.StowableModels = {
    [`a_c_alligator_01`] = {label = "Alligator", size = 2},
    [`a_c_alligator_02`] = {label = "Alligator", size = 2},
    [`a_c_alligator_03`] = {label = "Alligator", size = 2},
    [`a_c_armadillo_01`] = {label = "Armadillo", size = 2},
    [`a_c_badger_01`] = {label = "Badger", size = 1},
    [`a_c_bat_01`] = {label = "Bat", size = 1},
    [`a_c_bearblack_01`] = {label = "Bearblack", size = 2},
    [`a_c_bear_01`] = {label = "Bear", size = 2},
    [`a_c_beaver_01`] = {label = "Beaver", size = 2},
    [`a_c_bighornram_01`] = {label = "Bighornram", size = 2},
    [`a_c_bluejay_01`] = {label = "Bluejay", size = 1},
    [`a_c_boarlegendary_01`] = {label = "Boarlegendary", size = 2},
    [`a_c_boar_01`] = {label = "Boar", size = 2},
    [`a_c_buck_01`] = {label = "Buck", size = 2},
    [`a_c_buffalo_01`] = {label = "Buffalo", size = 2},
    [`a_c_buffalo_tatanka_01`] = {label = "Buffalo Tatanka", size = 2},
    [`a_c_bull_01`] = {label = "Bull", size = 2},
    [`a_c_californiacondor_01`] = {label = "Californiacondor", size = 1},
    [`a_c_cardinal_01`] = {label = "Cardinal", size = 1},
    [`a_c_carolinaparakeet_01`] = {label = "Carolinaparakeet", size = 1},
    [`a_c_cedarwaxwing_01`] = {label = "Cedarwaxwing", size = 1},
    [`a_c_chicken_01`] = {label = "Chicken", size = 1},
    [`a_c_chipmunk_01`] = {label = "Chipmunk", size = 1},
    [`a_c_cormorant_01`] = {label = "Cormorant", size = 1},
    [`a_c_cougar_01`] = {label = "Cougar", size = 2},
    [`a_c_cow`] = {label = "Cow", size = 2},
    [`a_c_coyote_01`] = {label = "Coyote", size = 2},
    [`a_c_crab_01`] = {label = "Crab", size = 1},
    [`a_c_cranewhooping_01`] = {label = "Cranewhooping", size = 1},
    [`a_c_crawfish_01`] = {label = "Crawfish", size = 1},
    [`a_c_crow_01`] = {label = "Crow", size = 1},
    [`a_c_deer_01`] = {label = "Deer", size = 2},
    [`a_c_donkey_01`] = {label = "Donkey", size = 2},
    [`a_c_duck_01`] = {label = "Duck", size = 1},
    [`a_c_eagle_01`] = {label = "Eagle", size = 1},
    [`a_c_egret_01`] = {label = "Egret", size = 1},
    [`a_c_elk_01`] = {label = "Elk", size = 2},
    [`a_c_fishbluegil_01_ms`] = {label = "Bluegil", size = 1},
    [`a_c_fishbluegil_01_sm`] = {label = "Bluegil", size = 1},
    [`a_c_fishbullheadcat_01_ms`] = {label = "Bullheadcat", size = 1},
    [`a_c_fishbullheadcat_01_sm`] = {label = "Bullheadcat", size = 1},
    [`a_c_fishchainpickerel_01_ms`] = {label = "Chainpickerel", size = 1},
    [`a_c_fishchainpickerel_01_sm`] = {label = "Chainpickerel", size = 1},
    [`a_c_fishchannelcatfish_01_lg`] = {label = "Channelcatfish", size = 1},
    [`a_c_fishchannelcatfish_01_xl`] = {label = "Channelcatfish", size = 1},
    [`a_c_fishlakesturgeon_01_lg`] = {label = "Lakesturgeon", size = 1},
    [`a_c_fishlargemouthbass_01_lg`] = {label = "Largemouthbass", size = 1},
    [`a_c_fishlargemouthbass_01_ms`] = {label = "Largemouthbass", size = 1},
    [`a_c_fishlongnosegar_01_lg`] = {label = "Longnosegar", size = 1},
    [`a_c_fishmuskie_01_lg`] = {label = "Muskie", size = 1},
    [`a_c_fishnorthernpike_01_lg`] = {label = "Northernpike", size = 1},
    [`a_c_fishperch_01_ms`] = {label = "Perch", size = 1},
    [`a_c_fishperch_01_sm`] = {label = "Perch", size = 1},
    [`a_c_fishrainbowtrout_01_lg`] = {label = "Rainbowtrout", size = 1},
    [`a_c_fishrainbowtrout_01_ms`] = {label = "Rainbowtrout", size = 1},
    [`a_c_fishredfinpickerel_01_ms`] = {label = "Redfinpickerel", size = 1},
    [`a_c_fishredfinpickerel_01_sm`] = {label = "Redfinpickerel", size = 1},
    [`a_c_fishrockbass_01_ms`] = {label = "Rockbass", size = 1},
    [`a_c_fishrockbass_01_sm`] = {label = "Rockbass", size = 1},
    [`a_c_fishsalmonsockeye_01_lg`] = {label = "Salmonsockeye", size = 1},
    [`a_c_fishsalmonsockeye_01_ml`] = {label = "Salmonsockeye", size = 1},
    [`a_c_fishsalmonsockeye_01_ms`] = {label = "Salmonsockeye", size = 1},
    [`a_c_fishsmallmouthbass_01_lg`] = {label = "Smallmouthbass", size = 1},
    [`a_c_fishsmallmouthbass_01_ms`] = {label = "Smallmouthbass", size = 1},
    [`a_c_fox_01`] = {label = "Fox", size = 2},
    [`a_c_frogbull_01`] = {label = "Frogbull", size = 1},
    [`a_c_gilamonster_01`] = {label = "Gilamonster", size = 1},
    [`a_c_goat_01`] = {label = "Goat", size = 2},
    [`a_c_goosecanada_01`] = {label = "Goosecanada", size = 2},
    [`a_c_hawk_01`] = {label = "Hawk", size = 1},
    [`a_c_heron_01`] = {label = "Heron", size = 1},
    [`a_c_iguanadesert_01`] = {label = "Iguanadesert", size = 1},
    [`a_c_iguana_01`] = {label = "Iguana", size = 1},
    [`a_c_javelina_01`] = {label = "Javelina", size = 2},
    [`a_c_lionmangy_01`] = {label = "Lionmangy", size = 2},
    [`a_c_loon_01`] = {label = "Loon", size = 2},
    [`a_c_moose_01`] = {label = "Moose", size = 2},
    [`a_c_muskrat_01`] = {label = "Muskrat", size = 2},
    [`a_c_oriole_01`] = {label = "Oriole", size = 1},
    [`a_c_owl_01`] = {label = "Owl", size = 1},
    [`a_c_ox_01`] = {label = "Ox", size = 2},
    [`a_c_panther_01`] = {label = "Panther", size = 2},
    [`a_c_parrot_01`] = {label = "Parrot", size = 1},
    [`a_c_pelican_01`] = {label = "Pelican", size = 1},
    [`a_c_pheasant_01`] = {label = "Pheasant", size = 1},
    [`a_c_pigeon`] = {label = "Pigeon", size = 1},
    [`a_c_pig_01`] = {label = "Pig", size = 2},
    [`a_c_possum_01`] = {label = "Possum", size = 1},
    [`a_c_prairiechicken_01`] = {label = "Prairiechicken", size = 1},
    [`a_c_pronghorn_01`] = {label = "Pronghorn", size = 2},
    [`a_c_quail_01`] = {label = "Quail", size = 1},
    [`a_c_rabbit_01`] = {label = "Rabbit", size = 1},
    [`a_c_raccoon_01`] = {label = "Raccoon", size = 2},
    [`a_c_rat_01`] = {label = "Rat", size = 1},
    [`a_c_raven_01`] = {label = "Raven", size = 1},
    [`a_c_robin_01`] = {label = "Robin", size = 1},
    [`a_c_rooster_01`] = {label = "Rooster", size = 1},
    [`a_c_roseatespoonbill_01`] = {label = "Roseatespoonbill", size = 1},
    [`a_c_seagull_01`] = {label = "Seagull", size = 1},
    [`a_c_sharkhammerhead_01`] = {label = "Sharkhammerhead", size = 2},
    [`a_c_sharktiger`] = {label = "Sharktiger", size = 2},
    [`a_c_sheep_01`] = {label = "Sheep", size = 2},
    [`a_c_skunk_01`] = {label = "Skunk", size = 1},
    [`a_c_snakeblacktailrattle_01`] = {label = "Snakeblacktailrattle", size = 1},
    [`a_c_snakeblacktailrattle_pelt_01`] = {label = "Snakeblacktailrattle_pelt", size = 1},
    [`a_c_snakeferdelance_01`] = {label = "Snakeferdelance", size = 1},
    [`a_c_snakeferdelance_pelt_01`] = {label = "Snakeferdelance_pelt", size = 1},
    [`a_c_snakeredboa10ft_01`] = {label = "Snakeredboa10ft", size = 2},
    [`a_c_snakeredboa_01`] = {label = "Snakeredboa", size = 1},
    [`a_c_snakeredboa_pelt_01`] = {label = "Snakeredboa_pelt", size = 1},
    [`a_c_snakewater_01`] = {label = "Snakewater", size = 1},
    [`a_c_snakewater_pelt_01`] = {label = "Snakewater_pelt", size = 1},
    [`a_c_snake_01`] = {label = "Snake", size = 1},
    [`a_c_snake_pelt_01`] = {label = "Snake_pelt", size = 1},
    [`a_c_songbird_01`] = {label = "Songbird", size = 1},
    [`a_c_sparrow_01`] = {label = "Sparrow", size = 1},
    [`a_c_squirrel_01`] = {label = "Squirrel", size = 1},
    [`a_c_toad_01`] = {label = "Toad", size = 1},
    [`a_c_turkeywild_01`] = {label = "Turkeywild", size = 1},
    [`a_c_turkey_01`] = {label = "Turkey", size = 1},
    [`a_c_turkey_02`] = {label = "Turkey", size = 1},
    [`a_c_turtlesea_01`] = {label = "Turtlesea", size = 2},
    [`a_c_turtlesnapping_01`] = {label = "Turtlesnapping", size = 2},
    [`a_c_vulture_01`] = {label = "Vulture", size = 2},
    [`A_C_Wolf`] = {label = "Wolf", size = 2},
    [`a_c_wolf_medium`] = {label = "Wolf", size = 2},
    [`a_c_wolf_small`] = {label = "Wolf", size = 2},
    [`a_c_woodpecker_01`] = {label = "Woodpecker", size = 1},
    [`a_c_woodpecker_02`] = {label = "Woodpecker", size = 1},

    --LargePelt
    [`mp001_p_mp_pelt_xlarge_acbear01`] = {label = "acbear01", size = 2},
    [`p_cs_bearskin_xlarge_roll`] = {label = "Bear Skin", size = 2},
    [`p_cs_bfloskin_xlarge_roll`] = {label = "Buffalo Skin", size = 2},
    [`p_cs_bullgator_xlarge_roll`] = {label = "Bullgator Skin", size = 2},
    [`p_cs_cowpelt2_xlarge`] = {label = "Cow Pelt", size = 2},
    [`p_cs_pelt_xlarge`] = {label = "NoName Pelt", size = 2},
    [`p_cs_pelt_xlarge_alligator`] = {label = "Alligator Pelt", size = 2},
    [`p_cs_pelt_xlarge_bear`] = {label = "Bear Pelt", size = 2},
    [`p_cs_pelt_xlarge_bearlegendary`] = {label = "Legendary Bear Pelt", size = 2},
    [`p_cs_pelt_xlarge_buffalo`] = {label = "Bison Pelt", size = 2},
    [`p_cs_pelt_xlarge_elk`] = {label = "Elk Pelt", size = 2},
    [`p_cs_pelt_xlarge_tbuffalo`] = {label = "Tatanka Bison Pelt", size = 2},
    [`p_cs_pelt_xlarge_wbuffalo`] = {label = "White Bison Pelt", size = 2},
}
