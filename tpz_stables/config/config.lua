Config = {}

Config.DevMode = true
Config.Debug   = true

Config.Keys = {
    ['G'] = 0x760A9C6F,["B"] = 0x4CC0E2FE,['S'] = 0xD27782E3,['W'] = 0x8FD015D8,['H'] = 0x24978A28,
    ['U'] = 0xD8F73058,["R"] = 0xE30CD707,["ENTER"] = 0xC7B5340A,['E'] = 0xCEFD9220,["J"] = 0xF3830D8E,
    ['F'] = 0xB2F377E8, ['C'] = 0x9959A6F0,
    ['L'] = 0x80F28E95, ['BACKSPACE'] = 0x156F7119,["DOWN"] = 0x05CA7C52,["UP"] = 0x6319DB71,["LEFT"] = 0xA65EBAB4,
    ["RIGHT"] = 0xDEB34313, ["SPACEBAR"] = 0xD9D0E1C0, ["DEL"] = 0x4AF4D473,
}

Config.PromptAction = { Key = 'G', HoldMode = 1000 } 


-----------------------------------------------------------
--[[ General ]]--
-----------------------------------------------------------

-- Set to Config.EnableOutfits = false to disable opening a wardrobe.
Config.EnableOutfits = "tpz_clothing:openWardrobe"

-- Set to false if you don't want the horses to be lassoed.
Config.CanLassoHorses = true

Config.HorseCalling = {
	InJail              = false, -- Call when player is jailed? (tpz_police support only).
	Swimming            = false, -- Call when player is swimming?
	Unconsious          = false, -- Call when dead - unconsious?

	CallOnlyNearStables = false, -- Call the horses only near stables?
	CallOnlyNearStablesDistance = 50.0, -- Call the horses only near stables distance between your player and closest stable.

	CallDistance = 200.0, -- In case the horse is further than the expected distance, it will despawn and a new horse will go to your player.
	CallCooldown = 10, -- In seconds.

	CallOnTowns = true, -- Set false if you don't want the horse to be called inside the towns where @BannedTowns option is located, including the configured towns.

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

Config.HorseFeedItems = { 
    ["horse_adrenaline_shot"]  = { label = "Horse Adrenaline Shot", boost = true,  health = 50,  stamina = 55}, -- maximum values are 100.
    ["unique_brad_horsesugar"] = { label = "Brad Horse Sugar",      boost = true,  health = 45,  stamina = 50}, -- maximum values are 100.
    ["consumable_haycube"]     = { label = "Hay Cube",              boost = false, health = 30,  stamina = 35}, -- maximum values are 100.
    ["horsemeal"]              = { label = "Horse Meal",            boost = false, health = 30,  stamina = 30}, -- maximum values are 100.
    ["Wild_Carrot"]            = { label = "Wild Carrot",           boost = false, health = 45,  stamina = 30}, -- maximum values are 100.
    ["corn"]                   = { label = "Corn",                  boost = false, health = 45,  stamina = 30}, -- maximum values are 100.
}

Config.OwnedLimitations = {
	MaxHorses = 3, -- DEFAULT LIMIT FOR ALL EXCEPT HORSE TRAINERS.
	HorseTrainerMaxHorses = 10, -- LIMIT FOR HORSE TRAINERS.

	-- BYPASS FOR STEAM HEX IDENTIFIERS.
	ByPassIdentifiers = {
		["steam:000000000x00000000x"] = 10,
	},

	-- BYPASS FOR GROUP ROLES.
	ByPassGroups = {
		['admin']     = 15,
		['moderator'] = 7,
		['mod']       = 7
	},
	
}

--Config.Storages = {
--
--}
--Config.searchhorses = true 
--Config.searchwagons = true 
--Config.policeonly = false
--Config.searchjobs = {"police"}

----------------------------------



--HorseSellPrice = 25 -- % HOW MUCH SELL BACK THE HORSE
---Config.horsehealcost = 5 -- cost to heal horse after its dead 
--Config.deadtimer = 150000 -- time until horse can be called again, set to 2.5 minutes 

-----------------------------------------------------------
--[[ Training ]]--
-----------------------------------------------------------

Config.Trainers = {
	Jobs = {"wapiti", "wapitishaman", "comanche", "horsetrainer", "anneshorsetrainer", 
	'blackhorsetrainer', 'strhorsetrainer', 'sdhorsetrainer', 'thieveshorsetrainer'},

    Whip = "horse_training_whip", -- THE WHIP ITEM TO START TRAINING THE HORSES

    MinStamina = -1000, -- IF THE HORSE REACH LESS THAN MINSTAMINA WILL BREAK TRAINING AND DROP DOWN THE TRAINER !
    ExpWhenWalking = 0.02, -- EXP TO ADD WHEN THE TRAINER IS WALKING WITH THE HORSE ( IS 0.01 EVERY MILISECONDS, SUGGEST TO HAVE IT LOW )
	ExpWhenRunning = 0.04, -- EXP TO ADD WHEN THE TRAINER IS RUNNING WITH THE HORSE ( IS 0.01 EVERY MILISECONDS, SUGGEST TO HAVE IT LOW )
	ExpWhenRearUp = 30, -- EXP TO ADD WHEN THE TRAINER IS REARUP WITH THE HORSE ( IS 15 EVERY TRICK )
	ExpWhenSkid = 60, -- EXP TO ADD WHEN THE TRAINER IS SKID WITH THE HORSE ( IS 30 EVERY TRICK )

	ReviveItem = "horse_syringe" -- THE PILL/SYRYNGE TO REVIVE THE HORSES !
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
			CameraCoords = { x = -370.473,           y = 786.7376,          z = 117.16,             rotx = 0.0, roty = 0.0, rotz = 345.9746, fov = 45.0},
		},

		Wagons = {
			SpawnCoords  = { x = -363.7694396972656, y = 775.3441772460938, z = 116.27066040039062, h = -85.7157},
			CameraCoords = { x = -359.422,           y = 774.4885,          z = 117.38,             rotx = 0.0, roty = 0.0, rotz = 72.3957, fov = 45.0},
		},

		TrainingCoords         = { x = -392.7306213378906, y = 778.4085693359375, z = 114.70181274414062},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = -892.8502807617188, y = -1370.4193115234375, z = 42.29966354370117, h = 2.659},
			CameraCoords = { x = -887.593,           y = -1361.88,            z = 43.496,            rotx = 0.0, roty = 0.0, rotz = 133.932769, fov = 45.0 },
		},

	
		TrainingCoords         = { x = -876.697, y = -1377.77, z = 43.599},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = 1448.527587890625,  y = -1280.5701904296875, z = 77.71709442138672, h = -162.727},
			CameraCoords = { x = 1445.263,           y = -1290.35,            z = 78.826,            rotx = 0.0, roty = 0.0, rotz = 336.424, fov = 45.0 },
		},

		TrainingCoords         = { x = 1429.839, y = -1296.06, z = 77.821},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.
		
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
		},

		Wagons = {
			SpawnCoords  = { x = 2957.07080078125,   y = 808.7708129882812,   z = 51.39369583129883, h = 178.807},
			CameraCoords = { x = 2949.108,           y = 800.5772,            z = 52.402,            rotx = 0.0, roty = 0.0, rotz = 301.946838, fov = 45.0 },
		},

		TrainingCoords         = { x = 2976.165771484375, y = 785.5613403320312, z = 51.24640274047851},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = 2496.293212890625,  y = -1437.5345458984375, z = 46.24652862548828, h = -179.836},
			CameraCoords = { x = 2490.712,           y = -1432.49,            z = 47.296,            rotx = 0.0, roty = 0.0, rotz = 227.71409, fov = 45.0 },
		},

		TrainingCoords         = { x = 2502.4794921875, y = -1450.6439208984375, z = 46.4422492980957},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = -1786.7723388671875, y = -548.4891967773438, z = 155.98793029785156, h = 124.589},
			CameraCoords = { x = -1787.20,            y = -558.548,           z = 156.98,             rotx = 0.0, roty = 0.0, rotz = 7.4465613, fov = 45.0 },
		},

		TrainingCoords         = { x = -1828.0577392578125, y = -576.6152954101562, z = 156.09359741210938}, 
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = -5509.44,            y = -3061.79,           z = -2.506,               h = 8.04},
			CameraCoords = { x = -5504.35,            y = -3067.36,           z = -1.512,               rotx = 0.0, roty = 0.0, rotz = 34.39435, fov = 45.0 },
		},

		TrainingCoords         = { x = -5538.96, y = -3036.41, z = -1.295},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

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
		},

		Wagons = {
			SpawnCoords  = { x = -1424.836181640625,  y = -2211.908935546875, z = 42.15961837768555,  h = -121.60926055908203},
			CameraCoords = { x = -1422.89,            y = -2217.77,           z = 44.166,             rotx = 0.0, roty = 0.0, rotz = 13.27976, fov = 45.0 },
		},

		TrainingCoords         = { x = -1407.04, y = -2203.63, z = 42.531}, -- ZONE WHERE CAN START TRAINING AND BREEDING
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	},

	["HEFE"] = { -- GUARMA ISLAND
		
		Name = 'Stable Of Hefe',
				
		Coords = { x = 1500.212, y = -7077.13, z = 77.242, h = 20.246 }, -- THE LOCATION FOR OPENING THE MENU TO BUY OR SELL HORSES AND WAGONS.
		ActionDistance = 2.0,

		MainCameraCoords = { x = 1492.270, y = -7071.85, z = 77.827, rotx = 0.0, roty = 0.0, rotz = 303.9746, fov = 45.0}, -- THE MAIN CAMERA BEFORE SELECTING ANY OF THE MENU OPTIONS.

		BlipData = { 
            Allowed = true,
            Name    = "Stable",
            Sprite  = -1456209806,

			OpenBlipModifier = 'BLIP_MODIFIER_MP_COLOR_32',
            DisplayClosedHours = { Enabled = true, Sprite = -1456209806, BlipModifier = "BLIP_MODIFIER_MP_COLOR_2" },
        },

		Hours = { Allowed = true, Opening = 7, Closing = 23 },

		Horses = {
			SpawnCoords  = { x = 1498.774658203125,   y = -7065.8251953125,           z = 76.08771514892578,  h = -104.761},
			CameraCoords = { x = 1500.547,            y = -7070.13,                   z = 77.871,             rotx = 0.0, roty = 0.0, rotz = 23.052982, fov = 45.0 },
		},

		Wagons = {
			SpawnCoords  = { x = 1495.36376953125,    y = -7074.7412109375,           z = 76.8135986328125,   h = -137.6897430419922},
			CameraCoords = { x = 1502.432,            y = -7074.72,                   z = 78.1,               rotx = 0.0, roty = 0.0, rotz =  88.400, fov = 45.0 },
		},

		TrainingCoords         = { x = 1497.343017578125, y = -7073.33056640625, z = 76.97714233398438},
		StartDistance          = 15.0, -- Distance <= Coords for starting the training.
		CancelTrainingDistance = 50.0, -- Distance > Coords for cancelling the training in case player went too far.

		MenuCategories = {
			{ Enabled = true, Action = 'BUY_HORSES',    Title = 'Buy Horses',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_HORSES', Title = 'Manage Owned Horses', Description = '' },
			{ Enabled = true, Action = 'BUY_WAGONS',    Title = 'Buy Wagons',          Description = '' },
			{ Enabled = true, Action = 'MANAGE_WAGONS', Title = 'Manage Owned Wagons', Description = '' },
			{ Enabled = true, Action = 'EXIT',          Title = 'Exit',                Description = '' },
		},
	}, 
	

}