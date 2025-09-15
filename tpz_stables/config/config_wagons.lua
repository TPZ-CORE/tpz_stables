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
	Key = 0xE30CD707, -- DO NOT USE [F] OR [E]
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

	Key = 0x760A9C6F, -- DO NOT USE [F] OR [E] OR ANY KEY THAT IS ALREADY USED FOR STORING, WARDROBE OR STORAGE ACCESS.
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
			{"cart02", "Cart 2", 50, 15, 25, {}, 0, 0 },
			{"cart03", "Cart 3", 50, 15, 25, {}, 0, 0 },
			{"cart04", "Cart 4", 100, 20, 50, {}, 0, 0 },
			{"cart05", "Cart 5", 50, 15, 25, {}, 0, 0 },
			{"cart06", "Cart 6", 200, 25, 100, {}, 0, 0 },
			{"cart07", "Cart 7", 50, 15, 25, {}, 0, 0 },
			{"cart08", "Cart 8", 50, 15, 25, {}, 0, 0 },      
		},
	},

	{

	    Category = 'Coaches',
		BackgroundImage = "coaches",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"coach2", "Coach 1", 50, 15, 25, {}, 0, 0 },
			{"coach3", "Coach 2", 50, 15, 10, {}, 0, 0 },
			{"coach4", "Coach 3", 50, 15, 10, {}, 0, 0 },
			{"coach5", "Coach 4", 50, 15, 10, {}, 0, 0 },
			{"coach6", "Coach 6", 50, 15, 25, {}, 0, 0 },    
		},
	},

	{

	    Category = 'Stagecoach',
		BackgroundImage = "stagecoach",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"stagecoach001x", "Stagecoach 1", 50, 15, 25, {}, 0, 0 },
			{"stagecoach002x", "Stagecoach 2", 50, 15, 25, {}, 0, 0 },
			{"stagecoach004_2x", "Stagecoach 4", 50, 15, 25, {}, 0, 0 },
			{"stagecoach004x", "Stagecoach 5", 50, 15, 25, {}, 0, 0 },
			{"stagecoach006x", "Stagecoach 7",  50, 15, 25, {}, 0, 0 },    
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

	    Category = 'Wagons',
		BackgroundImage = "wagons",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"chuckwagon000X", "Chuck Wagon 1", 300, 35, 150, {}, 0, 0 },
			{"chuckwagon002X", "Chuck Wagon 2", 300, 35, 150, {}, 0, 0 },
			{"wagon02x", "Wagon 1", 300, 35, 150, {}, 0, 0 },  
			{"wagon03x", "Wagon 2", 300, 35, 150, {}, 0, 0 },  
			{"wagon05x", "Wagon 4", 300, 35, 150, {}, 0, 0 },  
		},
	},

	{

	    Category = 'Utility',
		BackgroundImage = "other",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {

			{"huntercart01", "Hunter Cart", 100, 15, 50, {}, 0, 0 },  
			{"coal_wagon", "Coal Wagon", 100, 15, 50, { "miner"}, 0, 0 },  
			{"logwagon", "Log Wagon", 100, 15, 50, { "lumberjack" }, 0, 0 },  
			{"supplywagon", "Supply Wagon", 150, 20, 200, {}, 0, 0 },  

			{"WAGONDOC01X", "Doctor Wagon", 10, 35, 0, { "doctor", "medic" }, 0, 0 }, 

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
