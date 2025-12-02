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
    'a_c_alligator_01',
    'a_c_alligator_02',
    'a_c_alligator_03',
    'a_c_armadillo_01',
    'a_c_badger_01',
    'a_c_bat_01',
    'a_c_bearblack_01',
    'a_c_bear_01',
    'a_c_beaver_01',
    'a_c_bighornram_01',
    'a_c_bluejay_01',
    'a_c_boarlegendary_01',
    'a_c_boar_01',
    'a_c_buck_01',
    'a_c_buffalo_01',
    'a_c_buffalo_tatanka_01',
    'a_c_bull_01',
    'a_c_californiacondor_01',
    'a_c_cardinal_01',
    'a_c_carolinaparakeet_01',
    'a_c_cedarwaxwing_01',
    'a_c_chicken_01',
    'a_c_chipmunk_01',
    'a_c_cormorant_01',
    'a_c_cougar_01',
    'a_c_cow',
    'a_c_coyote_01',
    'a_c_crab_01',
    'a_c_cranewhooping_01',
    'a_c_crawfish_01',
    'a_c_crow_01',
    'a_c_deer_01',
    'a_c_donkey_01',
    'a_c_duck_01',
    'a_c_eagle_01',
    'a_c_egret_01',
    'a_c_elk_01',
    'a_c_fishbluegil_01_ms',
    'a_c_fishbluegil_01_sm',
    'a_c_fishbullheadcat_01_ms',
    'a_c_fishbullheadcat_01_sm',
    'a_c_fishchainpickerel_01_ms',
    'a_c_fishchainpickerel_01_sm',
    'a_c_fishchannelcatfish_01_lg',
    'a_c_fishchannelcatfish_01_xl',
    'a_c_fishlakesturgeon_01_lg',
    'a_c_fishlargemouthbass_01_lg',
    'a_c_fishlargemouthbass_01_ms',
    'a_c_fishlongnosegar_01_lg',
    'a_c_fishmuskie_01_lg',
    'a_c_fishnorthernpike_01_lg',
    'a_c_fishperch_01_ms',
    'a_c_fishperch_01_sm',
    'a_c_fishrainbowtrout_01_lg',
    'a_c_fishrainbowtrout_01_ms',
    'a_c_fishredfinpickerel_01_ms',
    'a_c_fishredfinpickerel_01_sm',
    'a_c_fishrockbass_01_ms',
    'a_c_fishrockbass_01_sm',
    'a_c_fishsalmonsockeye_01_lg',
    'a_c_fishsalmonsockeye_01_ml',
    'a_c_fishsalmonsockeye_01_ms',
    'a_c_fishsmallmouthbass_01_lg',
    'a_c_fishsmallmouthbass_01_ms',
    'a_c_fox_01',
    'a_c_frogbull_01',
    'a_c_gilamonster_01',
    'a_c_goat_01',
    'a_c_goosecanada_01',
    'a_c_hawk_01',
    'a_c_heron_01',
    'a_c_iguanadesert_01',
    'a_c_iguana_01',
    'a_c_javelina_01',
    'a_c_lionmangy_01',
    'a_c_loon_01',
    'a_c_moose_01',
    'a_c_muskrat_01',
    'a_c_oriole_01',
    'a_c_owl_01',
    'a_c_ox_01',
    'a_c_panther_01',
    'a_c_parrot_01',
    'a_c_pelican_01',
    'a_c_pheasant_01',
    'a_c_pigeon',
    'a_c_pig_01',
    'a_c_possum_01',
    'a_c_prairiechicken_01',
    'a_c_pronghorn_01',
    'a_c_quail_01',
    'a_c_rabbit_01',
    'a_c_raccoon_01',
    'a_c_rat_01',
    'a_c_raven_01',
    'a_c_robin_01',
    'a_c_rooster_01',
    'a_c_roseatespoonbill_01',
    'a_c_seagull_01',
    'a_c_sharkhammerhead_01',
    'a_c_sharktiger',
    'a_c_sheep_01',
    'a_c_skunk_01',
    'a_c_snakeblacktailrattle_01',
    'a_c_snakeblacktailrattle_pelt_01',
    'a_c_snakeferdelance_01',
    'a_c_snakeferdelance_pelt_01',
    'a_c_snakeredboa10ft_01',
    'a_c_snakeredboa_01',
    'a_c_snakeredboa_pelt_01',
    'a_c_snakewater_01',
    'a_c_snakewater_pelt_01',
    'a_c_snake_01',
    'a_c_snake_pelt_01',
    'a_c_songbird_01',
    'a_c_sparrow_01',
    'a_c_squirrel_01',
    'a_c_toad_01',
    'a_c_turkeywild_01',
    'a_c_turkey_01',
    'a_c_turkey_02',
    'a_c_turtlesea_01',
    'a_c_turtlesnapping_01',
    'a_c_vulture_01',
    'A_C_Wolf',
    'a_c_wolf_medium',
    'a_c_wolf_small',
    'a_c_woodpecker_01',
    'a_c_woodpecker_02',

    -- Large Pelts
    'mp001_p_mp_pelt_xlarge_acbear01',
    'p_cs_bearskin_xlarge_roll',
    'p_cs_bfloskin_xlarge_roll',
    'p_cs_bullgator_xlarge_roll',
    'p_cs_cowpelt2_xlarge',
    'p_cs_pelt_xlarge',
    'p_cs_pelt_xlarge_alligator',
    'p_cs_pelt_xlarge_bear',
    'p_cs_pelt_xlarge_bearlegendary',
    'p_cs_pelt_xlarge_buffalo',
    'p_cs_pelt_xlarge_elk',
    'p_cs_pelt_xlarge_tbuffalo',
    'p_cs_pelt_xlarge_wbuffalo',
}
