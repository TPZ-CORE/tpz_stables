Config = {}

Config.DevMode = false
Config.Debug   = true

Config.Keys = {
    ['G'] = 0x760A9C6F,["B"] = 0x4CC0E2FE,['S'] = 0xD27782E3,['W'] = 0x8FD015D8,['H'] = 0x24978A28,
    ['U'] = 0xD8F73058,["R"] = 0xE30CD707,["ENTER"] = 0xC7B5340A,['E'] = 0xCEFD9220,["J"] = 0xF3830D8E,
    ['F'] = 0xB2F377E8, ['C'] = 0x9959A6F0,
    ['L'] = 0x80F28E95, ['BACKSPACE'] = 0x156F7119,["DOWN"] = 0x05CA7C52,["UP"] = 0x6319DB71,["LEFT"] = 0xA65EBAB4,
    ["RIGHT"] = 0xDEB34313, ["SPACEBAR"] = 0xD9D0E1C0, ["DEL"] = 0x4AF4D473,
}

Config.PromptAction = { Key = 'G', HoldMode = 1000 } 

Config.HorseTrainingPromptAction = { Key = 'G', HoldMode = 1000, Label = 'Press' }

-----------------------------------------------------------
--[[ General ]]--
-----------------------------------------------------------

-- Properly saving data before server restarts (Suggested 2-3 minutes before restart).
Config.RestartHours = { "7:57" , "13:57", "19:57", "1:57"}

-- The following option is saving all the data every x minutes.
Config.SavingDurationDelay = 15 -- The time in minutes (15 as default).

Config.Year = 1890

-- Set to Config.EnableOutfits = false to disable opening a wardrobe.
Config.EnableOutfits = "tpz_clothing:openWardrobe"

-- Set to false if you don't want the horses to be lassoed.
Config.CanLassoHorses = true

-- Set to true to disable horse kicking.
Config.DisableHorseKicking = false

-- Every how often the SPAWNED owned horse should it be saved? (ONLY WHEN PLAYER IS ON MOUNT)
Config.SaveHorseTime = 60 -- Time in seconds. (1 minute by default)

-- Load properly a horse or a wagon components (outfits) based on the player rendering distance.
--Config.LoadComponentsRendering = 50.0 !!!!!!!!!!!!!!! DELETE???

-- How close should the target player be for transferring a horse or a wagon?
Config.TransferMaximumDistance = 3.0 -- in distance.

Config.HorseCalling = {
	
	CallOnlyNearStables = false, -- Call the horses only near stables?
	CallOnlyNearStablesDistance = 50.0, -- Call the horses only near stables distance between your player and closest stable.

	CallDistance = 200.0, -- In case the horse is further than the expected distance, it will despawn and a new horse will go to your player.
	CallCooldown = 2, -- In seconds.

	PreventCallOnTowns = false, -- Set false if you don't want the horse to not be able to be called when player is located on any towns @BannedTowns.

	BannedTowns = {
		'Annesburg', 
		'Armadillo', 
		'Blackwater', 
		'Rhodes', 
		'Siska', 
		'StDenis', 
		'Strawberry', 
		'Tumbleweed', 
		'Valentine', 
		'Vanhorn'
	},
}

Config.OwnedLimitations = {
	MaxHorses = 3, -- DEFAULT LIMIT FOR ALL EXCEPT HORSE TRAINERS.
	HorseTrainerMaxHorses = 10, -- LIMIT FOR HORSE TRAINERS.

	-- BYPASS FOR STEAM HEX IDENTIFIERS.
	SteamHexIdentifiers = {
		["steam:000000000x00000000x"] = 10,
	},

	-- BYPASS FOR GROUP ROLES (MAKE SURE SOMEONE WHO IS ON BYPASS GROUP TO NOT BE ON BYPASS IDENTIFIER! )
	Groups = {
		['admin']     = 15,
		['moderator'] = 7,
		['mod']       = 7
	},
	
}

-- @param UpdateTime    : Time in minutes (every how long should it update the ageing for each horse)
-- @param StartAdultAge : When purchasing a horse, it will select a random age between 5 - 10 years old (days) as default.
-- (!) FOR MAXIMUM AGE AND DELETION AGE, CHECKOUT CONFIG.HORSES, EVERY BREED CAN HAVE ITS OWN MAXIMUM AND DELETION AGE.
Config.Ageing = { 
	UpdateTime    = 10, -- UPDATING (NOT SAVING).

	StartAdultAge = { min = 5, max = 10 }, 
}

-- @param Destroy : To destroy (remove) the item permanently when reaching <= 0 durability.
Config.HorseBrushItem = { Item = 'horsebrush', RemoveDurability = true, Value = 15, Destroy = true } -- Takes (removes) 15% of each horse brush use.

-- Horse Shoes, you can create as many horse shoe types you want based on @MaxKilometers, the highest is the strongest (lasts more).
-- If a horse is wearing horse shoes, there will NOT be any stamina consumption.
-- (!) DO NOT ADD [0], THIS INDEX IS WHEN NOT HAVING ANY SHOES, ADD FROM >= 1 AS THE DEFAULTS.
Config.HorseShoes = { 
    { Item = 'regular_horseshoes',  Label = "Regular Horse Shoes",  MaxKilometers = 4000  }, -- LABEL: USE DIFFERENT NAME FOR EACH HORSE SHOE (!)
    { Item = 'improved_horseshoes', Label = "Improved Horse Shoes", MaxKilometers = 16000 }, -- LABEL: USE DIFFERENT NAME FOR EACH HORSE SHOE (!)
    { Item = 'premium_horseshoes',  Label = "Premium Horse Shoes",  MaxKilometers = 32000 }, -- LABEL: USE DIFFERENT NAME FOR EACH HORSE SHOE (!)
}

Config.HorseFeedItems = { 
    ["horse_adrenaline_shot"]  = { Label = "Horse Adrenaline Shot", Health = 100,  Stamina = 100 }, -- maximum values are 100.
    ["unique_brad_horsesugar"] = { Label = "Brad Horse Sugar",      Health = 45,   Stamina = 50  }, -- maximum values are 100.
    ["consumable_haycube"]     = { Label = "Hay Cube",              Health = 30,   Stamina = 40  }, -- maximum values are 100.
    ["horsemeal"]              = { Label = "Horse Meal",            Health = 30,   Stamina = 35  }, -- maximum values are 100.
    ["wild_carrot"]            = { Label = "Wild Carrot",           Health = 45,   Stamina = 30  }, -- maximum values are 100.
    ["corn"]                   = { Label = "Corn",                  Health = 25,   Stamina = 20  }, -- maximum values are 100.
}

Config.HorseDeath = {

	-- THE USED ITEM TO REVIVE THE HORSES (IF ENABLED).
	Reviving = { 
		Enabled = true, 
		Item = "horse_syringe", 
		Radius = 1.2,
		Jobs = {"wapiti", "wapitishaman", "comanche", "horsetrainer", "anneshorsetrainer", 'blackhorsetrainer', 'strhorsetrainer', 'sdhorsetrainer', 'thieveshorsetrainer'},

		AnimationDict = "mech_revive@unapproved", 
		Animation = "revive", 
		ApplyDuration = 10000,
		Applying = "Injecting syringe..."
	},

	-- IN CASE THERE ARE NO HORSE TRAINERS OR REVIVE ITEM IS DISABLED, ALLOW THE PLAYER TO PAY FOR REVIVE ON ANY STABLE LOCATIONS?
	PayToRevive = { Enabled = true, Cost = 20, OptionTitle = "Would you like to pay 20 dollars to let the stable horse trainers take care of your horse?" } -- IN CASH 
}

Config.Storages = {

	Horses = {

		MaxWeightCapacity = 50.0, -- IN KG (THIS IS FOR ALL HORSE MODELS, THERE ARE NO EXCEPTIONS).
		SearchByJobs = { Enabled = true, Jobs = { 'police' } },

		InventoryStorageHeader = 'Horse Bag Storage',
	},

}

-----------------------------------------------------------
--[[ Horse Taming ]]--
-----------------------------------------------------------

Config.Taming = {

	Enabled = true,

	-- Set Jobs = false if you wan't all the players to be able to tame horses.
	Jobs = false,
	--Jobs = {"wapiti", "wapitishaman", "comanche", "horsetrainer", "anneshorsetrainer", 'blackhorsetrainer', 'strhorsetrainer', 'sdhorsetrainer', 'thieveshorsetrainer'},

	-- Spawn horse models for taming on the selected coords.
	-- For the taming, difficulty, stages, tpz_skillcheck is required.
	-- @param difficulties : easy, normal, hard
	Horses = {
		{ model = "a_c_horse_morgan_bay",                              difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = -1958.06, y = 434.6420, z = 119.93, h = 315.64672851 }, spawn_chance = 100 },
		{ model = "a_c_horse_morgan_bayroan",                          difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_morgan_flaxenchestnut",                   difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_Horse_morgan_liverchestnut_pc",                 difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_morgan_palomino",                         difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
 
		{ model = "a_c_horse_kentuckysaddle_black",                    difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_kentuckysaddle_buttermilkbuckskin_pc",    difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_kentuckysaddle_chestnutpinto",            difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_kentuckysaddle_grey",                     difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_kentuckysaddle_silverbay",                difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		
		{ model = "a_c_horse_tennesseewalker_blackrabicano",           difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_chestnut",                difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_dapplebay",               difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_flaxenroan",              difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_goldpalomino_pc",         difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_mahoganybay",             difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_tennesseewalker_redroan",                 difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },

		{ model = "a_c_horse_suffolkpunch_redchestnut",                difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_suffolkpunch_sorrel",                     difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },

		{ model = "a_c_horse_shire_darkbay",                           difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_shire_lightgrey",                         difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_shire_ravenblack",                        difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		
		{ model = "a_c_horse_belgian_blondchestnut",                   difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_belgian_mealychestnut",                   difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },

		{ model = "a_c_horse_hungarianhalfbred_darkdapplegrey",        difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_hungarianhalfbred_flaxenchestnut",        difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_hungarianhalfbred_liverchestnut",         difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_hungarianhalfbred_piebaldtobiano",        difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },

		{ model = "a_c_horse_americanpaint_greyovero",                 difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanpaint_overo",                     difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanpaint_splashedwhite",             difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanpaint_tobiano",                   difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },

		{ model = "a_c_horse_americanstandardbred_silvertailbuckskin", difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanstandardbred_palominodapple",     difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanstandardbred_buckskin",           difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
		{ model = "a_c_horse_americanstandardbred_black",              difficulties = { 'easy', 'normal', 'normal', 'normal'}, coords = { x = 0, y = 0, z = 0 }, spawn_chance = 100  },
	},

	-- Every how many seconds should the system check for nearby players to spawn a horse based on @SpawnDistance ?
	CheckEvery    = 5, -- time in seconds

	SpawnDistance = 75.0,

	-- If the horse spawned and there are no players nearby within the selected despawn distance, we remove the horse after a minute.
	DespawnDistance = 100.0,

	-- If a spawned horse has been tamed, after how many minutes should it be able to spawn and tamed again on the same position?
	RespawnHorses = false, -- time in minutes (false = after server restart)

	-- When does the taming starts? after how many seconds to prepare the player?
	StartTamingCountdown = 10, -- time in seconds

	-- What should be the aged of the tamed horse in case the player wants for his ownership?
	OwnershipTamedHorseAge = { min = 20, max = 30 },
}

-----------------------------------------------------------
--[[ Horse Training ]]--
-----------------------------------------------------------

-- (!) WOULD YOU LIKE TO HAVE TRAINING OBJECTS?
-- > CHECKOUT tpz_objectloader (https://github.com/TPZ-CORE/tpz_objectloader) to add objects on the desired locations with perfect rendering and loading / unloading objects.
Config.Trainers = {
	Jobs = {"wapiti", "wapitishaman", "comanche", "horsetrainer", "anneshorsetrainer", 'blackhorsetrainer', 'strhorsetrainer', 'sdhorsetrainer', 'thieveshorsetrainer'},

    UntrainedHorse = {

        -- Decrease horse model statistics when not trained.
        -- @param Modify : Set to false to not modify the statistic when untrained. 
        -- @param DivideBy : Decrease the model statistic value by the selected value (ex: 50 / 2).
        -- That means, if the speed was at 50%, it will be at 25% when untrained. 
        DecreaseHorseStatistics = { 
    
            ["speed"]        = { Modify = true, DivideBy = 2 },
            ["stamina"]      = { Modify = true, DivideBy = 2 },
            ["health"]       = { Modify = true, DivideBy = 2 },
            ["acceleration"] = { Modify = true, DivideBy = 2 },
            ["handling"]     = { Modify = true, DivideBy = 2 },
        },

        -- @param Enabled : Set to false to not let the horses stamina consumption run out faster. 
        -- @param DecreaseBy : The extra decreasing stamina value for faster consumption. 
        FasterStaminaConsumption = { Enabled = true, DecreaseBy = 5 }, -- EVERY SECOND CHECK.
    },

    HorseTraining = { 

		-- How many seconds will it take to cancel the training when someone is outside from the training pos or not in mount?
		CancelDuration = 10, -- time in seconds.
		
        MaxLevelUpExperience = 1000,

		Stages = {

			[1] = {
				Type = "BRUSH", -- Brush the horse.
				Experience = 50,
				Description = "Brush the horse.",
				-- No duration
			},

			[2] = {
				Type = "FEED", -- Feed the horse any food from @Config.HorseFeedItems.
				Experience = 50,
				Description = "Feed the horse.",
				-- No duration
			},

			[3] = {
				Type = "LEAD", -- Lead the horse for x seconds / minutes.
				Experience = 125,
				Description = "Lead the horse for %s seconds.", -- %s required, returns the countdown (@duration)
				Duration = 60, -- The horse leading total duration to go to the next stage.
			},

			[4] = {
				Type = "WALK", -- Mount on the horse and walk slowly.
				Experience = 125,
				Description = "Walk slowly while mounted on the horse for %s seconds.", -- %s required, returns the countdown (@duration)
				Duration = 120, -- The horse walking total duration to go to the next stage.
			},

			[5] = {
				Type = "RUN", -- Mount on the horse and run or sprint.
				Experience = 125,
				Description = "Run or sprint while mounted on the horse for %s seconds.", -- %s required, returns the countdown (@duration)
				Duration = 120, -- The horse running / sprinting total duration to go to the next stage.
			},

		},

    }, 
}

-----------------------------------------------------------
--[[ Stable Locations ]]--
-----------------------------------------------------------

Config.Locations = {

	["VALENTINE"] = {

		Name = 'Stable Of Valentine',

		Coords = { x = -368.513, y = 787.2302, z = 116.1}, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.5,

		MainCameraCoords = { x = -367.542, y = 787.6141, z = 117.16, rotx = 0.0, roty = 0.0, rotz = 338.438446, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = -369.6344299316406, y = 791.5049438476562, z = 115.08021545410156, h = -175.34},
			CameraCoords = { x = -370.560,           y = 788.125,           z = 117.16,             rotx = -15.0, roty = 0.0, rotz = 345.9746, fov = 45.0},

			Training = {
				Enabled = true,

				TrainingCoords = { x = -381.209, y = 785.9589, z = 115.97}, -- START / STOP.

				TrainingCoordsMarker = { -- START / STOP CIRCULAR MARKER DISPLAY.
					Enabled = true,
		
					Distance = 5.0,
					RGBA = {r = 255, g = 255, b = 255, a = 55},
				},

				Debug = false, -- Set to true if you want to see the zone on the map.

				MinZ = 114.00, -- Minimum Z coordinate for the zone. aka the lowest point of the zone.
				MaxZ = 125.00, -- Maximum Z coordinate for the zone. aka the highest point of the zone.(Recommended to use the PolyZone Editor to get the correct values (https://github.com/mkafrin/PolyZone https://github.com/mkafrin/PolyZone/wiki/Using-the-creation-script) This is not needed for the Script to work, but it is recommended for setting the correct values.)
			   
				Coords = { -- Polyzone.
					vector2(-405.0909729003906, 792.3719482421875),
					vector2(-376.98272705078125, 795.5293579101562 ),
					vector2(-375.3771667480469, 764.8612670898438),
					vector2(-403.12054443359375, 765.0199584960938),
				}

			},

		},

		Wagons = {
			SpawnCoords  = { x = -363.7694396972656, y = 775.3441772460938, z = 116.27066040039062, h = -85.7157},
			CameraCoords = { x = -351.24,            y = 779.73,            z = 120.42,             rotx = -20.0, roty = 0.0, rotz = 114.52, fov = 45.0},
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},

	},

	["BLACKWATER"] = {

		Name = 'Stable Of Blackwater',

		Coords = { x = -872.421, y = -1366.77, z = 43.530 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 3.0,

		MainCameraCoords = { x = -877.864, y = -1366.36, z = 43.528, rotx = 0.0, roty = 0.0, rotz = 209.6557, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = -867.5707397460938, y = -1370.5565185546875, z = 42.81821060180664, h = 0.0946},
			CameraCoords = { x = -869.077,           y = -1366.55,            z = 43.530,            rotx = 0.0, roty = 0.0, rotz = 204.424, fov = 45.0 },

			Training = {
				Enabled = true,

				TrainingCoords = { x = -863.532, y = -1382.62, z = 43.615}, -- START / STOP.

				TrainingCoordsMarker = { -- START / STOP CIRCULAR MARKER DISPLAY.
					Enabled = true,
		
					Distance = 5.0,
					RGBA = {r = 255, g = 255, b = 255, a = 55},
				},

				Debug = false, -- Set to true if you want to see the zone on the map.

				MinZ = 35.00, -- Minimum Z coordinate for the zone. aka the lowest point of the zone.
				MaxZ = 50.00, -- Maximum Z coordinate for the zone. aka the highest point of the zone.(Recommended to use the PolyZone Editor to get the correct values (https://github.com/mkafrin/PolyZone https://github.com/mkafrin/PolyZone/wiki/Using-the-creation-script) This is not needed for the Script to work, but it is recommended for setting the correct values.)
			   
				Coords = { -- Polyzone.
					vector2(-850.45263671875, -1402.158203125),
					vector2(-850.6724853515625, -1355.578369140625),
					vector2(-918.4435424804688, -1355.5570068359375),
					vector2(-917.1760864257812, -1405.5513916015625),
				}

			},

		},

		Wagons = {
			SpawnCoords  = { x = -892.8502807617188, y = -1370.4193115234375, z = 42.29966354370117, h = 2.659},
			CameraCoords = { x = -885.14,            y = -1360.08,            z = 47.77,             rotx = -20.0, roty = 0.0, rotz = 131.27, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	}, 

	["RHODES"] = {

		Name = 'Stable Of Rhodes',

		Coords = { x = 1431.004, y = -1295.71, z = 77.82 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 3.0,

		MainCameraCoords = { x = 1432.956, y = -1292.09, z = 78.821, rotx = 0.0, roty = 0.0, rotz = 35.0342, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = 1440.130126953125,  y = -1299.832275390625,  z = 76.9581298828125,  h = 99.97},
			CameraCoords = { x = 1436.463,           y = -1302.85,            z = 78.816,            rotx = -20.0, roty = 0.0, rotz = 313.0792, fov = 45.0 },

			Training = {
				Enabled = false, -- NO TRAINING SPOT
			},
		},

		Wagons = {
			SpawnCoords  = { x = 1448.527587890625,  y = -1280.5701904296875, z = 77.71709442138672, h = -162.727},
			CameraCoords = { x = 1445.57,            y = -1292.33,            z = 82.21,            rotx = -20.0, roty = 0.0, rotz = -26.83, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},

	["VANHORN"] = {

		Name = 'Stable Of Vanhorn',

		Coords = { x = 2968.190, y = 796.2608, z = 51.40 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.0,

		MainCameraCoords = { x = 2970.566, y = 796.7901, z = 52.402, rotx = 0.0, roty = 0.0, rotz = 161.2318572, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = 2961.482666015625,  y = 801.2601318359375,   z = 50.60737991333008, h = 178.452},
			CameraCoords = { x = 2962.581,           y = 797.3046,            z = 52.402,            rotx = 0.0, roty = 0.0, rotz = 14.651041, fov = 45.0 },

			Training = {
				Enabled = true,

				TrainingCoords = { x = 2962.085, y = 779.7634, z = 51.369}, -- START / STOP.

				TrainingCoordsMarker = { -- START / STOP CIRCULAR MARKER DISPLAY.
					Enabled = true,
		
					Distance = 5.0,
					RGBA = {r = 255, g = 255, b = 255, a = 55},
				},

				Debug = false, -- Set to true if you want to see the zone on the map.

				MinZ = 35.00, -- Minimum Z coordinate for the zone. aka the lowest point of the zone.
				MaxZ = 60.00, -- Maximum Z coordinate for the zone. aka the highest point of the zone.(Recommended to use the PolyZone Editor to get the correct values (https://github.com/mkafrin/PolyZone https://github.com/mkafrin/PolyZone/wiki/Using-the-creation-script) This is not needed for the Script to work, but it is recommended for setting the correct values.)
			   
				Coords = { -- Polyzone.
					vector2(2954.000244140625, 812.0416259765625 ),
					vector2(2950.690673828125, 750.4906005859375),
					vector2(2976.803955078125, 747.7428588867188),
					vector2(2977.570068359375, 767.4178466796875),
					vector2(3003.672119140625, 768.7509155273438),
					vector2(3003.576171875, 810.7088012695312),
					vector2(2954.000244140625, 812.0416259765625),
				},

			},
		},

		Wagons = {
			SpawnCoords  = { x = 2957.07080078125,   y = 808.7708129882812,   z = 51.39369583129883, h = 178.807},
			CameraCoords = { x = 2950.75,            y = 798.78,              z = 54.97,            rotx = -20.0, roty = 0.0, rotz = -47.25, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},

	["SAINTDENIS"] = {

		Name = 'Stable Of Saint Denis',

		Coords = { x = 2502.488, y = -1458.83, z = 46.312 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 3.5,

		MainCameraCoords = { x = 2508.978, y = -1460.32, z = 47.316, rotx = -15.0, roty = 0.0, rotz = 308.476135, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = 2508.5751953125,  y = -1450.6090087890625,   z = 45.57754135131836, h = 103.277},
			CameraCoords = { x = 2504.397,         y = -1448.40,              z = 48.513,            rotx = -20.0, roty = 0.0, rotz = 235.2450256, fov = 45.0 },

			Training = {
				Enabled = false, -- NO TRAINING SPOT
			},
		},

		Wagons = {
			SpawnCoords  = { x = 2483.1103515625,    y = -1441.0220947265625, z = 45.1094741821289, h = -179.43212890625},
			CameraCoords = { x = 2477.28,            y = -1451.43,            z = 50.02,            rotx = -15.0, roty = 0.0, rotz = -45.83, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},

	["STRAWBERRY"] = {

		Name = 'Stable Of Strawberry',

		Coords = { x = -1820.42, y = -561.534, z = 156.05 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.0,

		MainCameraCoords = {x = -1816.79, y = -564.914, z = 157.06, rotx = 0.0, roty = 0.0, rotz = 5.83352, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = -1825.1441650390625, y = -565.1942138671875, z = 155.26583862304688, h = -15.152},
			CameraCoords = { x = -1823.08,            y = -561.568,           z = 156.05,             rotx = 0.0, roty = 0.0, rotz = 145.3800 , fov = 45.0 },

			Training = {
				Enabled = true,

				TrainingCoords = { x = -1803.20, y = -564.308, z = 155.99}, -- START / STOP.

				TrainingCoordsMarker = { -- START / STOP CIRCULAR MARKER DISPLAY.
					Enabled = true,
		
					Distance = 5.0,
					RGBA = {r = 255, g = 255, b = 255, a = 55},
				},

				Debug = false, -- Set to true if you want to see the zone on the map.

				MinZ = 140.00, -- Minimum Z coordinate for the zone. aka the lowest point of the zone.
				MaxZ = 170.00, -- Maximum Z coordinate for the zone. aka the highest point of the zone.(Recommended to use the PolyZone Editor to get the correct values (https://github.com/mkafrin/PolyZone https://github.com/mkafrin/PolyZone/wiki/Using-the-creation-script) This is not needed for the Script to work, but it is recommended for setting the correct values.)
			   
				Coords = { -- Polyzone.
					vector2(-1805.637939453125, -640.2822265625 ),
					vector2(-1771.049072265625, -548.5028076171875),
					vector2(-1797.5489501953125, -510.0735778808594),
					vector2(-1862.13720703125, -619.0802001953125),
				},
			},
		},

		Wagons = {
			SpawnCoords  = { x = -1786.7723388671875, y = -548.4891967773438, z = 155.98793029785156, h = 124.589},
			CameraCoords = { x = -1791.76,            y = -559.01,            z = 159.68,             rotx = -20.0, roty = 0.0, rotz = -16.78, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	}, 

	["TUMBLEWEED"] = {

		Name = 'Stable Of Tumbleweed',

		Coords = { x = -5519.10, y = -3044.47, z = -2.387, h = 273.2991 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.5,

		MainCameraCoords = { x = -5517.88, y = -3043.13, z = -1.387, rotx = 0.0, roty = 0.0, rotz = 321.91110, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = -5525.21,            y = -3038.95,           z = -3.286,               h = 187.08},
			CameraCoords = { x = -5523.98,            y = -3042.75,           z = -1.187,               rotx = -20.0, roty = 0.0, rotz = 17.6548614, fov = 45.0 },

			Training = {
				Enabled = true,

				TrainingCoords = { x = -5519.08, y = -3028.10, z = -2.386}, -- START / STOP.

				TrainingCoordsMarker = { -- START / STOP CIRCULAR MARKER DISPLAY.
					Enabled = true,
		
					Distance = 5.0,
					RGBA = {r = 255, g = 255, b = 255, a = 55},
				},

				Debug = false, -- Set to true if you want to see the zone on the map.

				MinZ = -1.00, -- Minimum Z coordinate for the zone. aka the lowest point of the zone.
				MaxZ = -5.00, -- Maximum Z coordinate for the zone. aka the highest point of the zone.(Recommended to use the PolyZone Editor to get the correct values (https://github.com/mkafrin/PolyZone https://github.com/mkafrin/PolyZone/wiki/Using-the-creation-script) This is not needed for the Script to work, but it is recommended for setting the correct values.)
			   
				Coords = { -- Polyzone.
					vector2(-5508.7548828125, -3056.1494140625),
					vector2(-5507.390625, -3036.147705078125),
					vector2(-5510.94091796875, -3035.05517578125),
					vector2(-5518.4853515625, -3011.917724609375),
					vector2(-5552.97802734375, -3027.270263671875),
					vector2(-5548.67822265625, -3055.322998046875),
					vector2(-5544.52197265625, -3059.75146484375),
				},

			},
		},

		Wagons = {
			SpawnCoords  = { x = -5509.44,            y = -3061.79,           z = -2.506,               h = 8.04},
			CameraCoords = { x = -5503.32,            y = -3051.75,           z = 1.94,                 rotx = -20.0, roty = 0.0, rotz = 130.37, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},
	
	["THIEVES_LANDING"] = {

		Name = 'Stable Of Thieves Landing',
		
		Coords = { x = -1414.83, y = -2199.96, z = 43.402, h = 63.906455 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.0,

		MainCameraCoords = { x = -1417.15, y = -2199.69, z = 44.389, rotx = 0.0, roty = 0.0, rotz = 1.09940, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = -1416.284912109375,  y = -2189.870849609375, z = 42.32751083374023,  h = -128.53},
			CameraCoords = { x = -1413.96,            y = -2193.61,           z = 43.399,             rotx = 0.0, roty = 0.0, rotz = 30.9404, fov = 45.0 },

			Training = {
				Enabled = false, -- NO TRAINING SPOT
			},
		},

		Wagons = {
			SpawnCoords  = { x = -1428.40,            y = -2208.49,           z = 42.317,             h = 240.3992},
			CameraCoords = { x = -1422.09,            y = -2218.74,           z = 48.03,             rotx = -20.0, roty = 0.0, rotz = 15.22, fov = 45.0 },
		},

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},

}

-----------------------------------------------------------
--[[ Commands  ]]--
-----------------------------------------------------------

Config.Commands = {

    ["ADD_HORSE"] = { -- Ace Permission: tpzcore.stables.addhorse or tpzcore.stables.all or tpzcore.all

        Label = "Add a horse on the ownership of the selected player.",

        Suggestion = "Execute this command to add a horse on the ownership of the selected player.",

        PermittedDiscordRoles  = { 11111111111111111, 222222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'addhorse',
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Model", help = "Horse Entity Model Name" }, { name = "Sex", help = "Sex (0 = male, 1 = female)" } },

    },

    
    ["ADD_WAGON"] = { -- Ace Permission: tpzcore.stables.addwagon or tpzcore.stables.all or tpzcore.all

        Label = "Add a wagon on the ownership of the selected player.",

        Suggestion = "Execute this command to add a wagon on the ownership of the selected player.",

        PermittedDiscordRoles  = { 11111111111111111, 222222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'addwagon',
        CommandHelpTips = { { name = "Id", help = 'Player ID' }, { name = "Model", help = "Wagon Vehicle Model Name" } },

    },

	["FLEE"] = { 
		Suggestion = "Execute this command to flee your horse when unconscious.",
		Command = 'fleehorse',
	},
}

---------------------------------------------------------------
--[[ Discord Webhooking ]]--
---------------------------------------------------------------

Config.Webhooks = {

    ["COMMANDS"] = { -- Related only to Config.Commands for giving horses or wagons. 
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

    ["BOUGHT"] = { -- Buying horses or wagons from the stables. 
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

	['SOLD'] = { -- Selling horses or wagons from the stables.
		Enabled = false, 
        Url = "", 
        Color = 10038562,
	},

    ["TRANSFERRED"] = { -- When transferred a horse or a wagon to another player. 
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },
}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source : The source always null when called from client.
-- @param type   : returns "error", "success", "info"
-- @param duration : the notification duration in milliseconds
function SendNotification(source, message, type, duration)

	if not duration then
		duration = 3000
	end

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, duration)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, duration)
    end
  
end
