Config.Wagons = {

	{

	    Category = 'Carts',
		BackgroundImage = "carts",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {
			{"cart01", "Cart 1", 50, 5, 30, {} },
			{"cart02", "Cart 2", 30, 3, 10, {} },
			{"cart03", "Cart 3", 60, 6, 30, {} },
			{"cart04", "Cart 4", 90, 9, 50, {} },
			{"cart05", "Cart 5", 55, 5, 50, {} },
			{"cart06", "Cart 6", 125, 12, 200, {} },
			{"cart07", "Cart 7", 60, 6, 30, {} },
			{"cart08", "Cart 8", 60, 6, 30, {} },      
		},
	},

	{

	    Category = 'Coaches',
		BackgroundImage = "coaches",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {
			{"coach2", "Coach 1", 500, 50, 200, {} },
			{"coach3", "Coach 2", 350, 35, 50, {} },
			{"coach4", "Coach 3", 300, 30, 50, {} },
			{"coach5", "Coach 4", 300, 30, 50, {} },
			{"coach6", "Coach 5", 280, 28, 30, {} },    
		},
	},

	{

	    Category = 'Stagecoach',
		BackgroundImage = "stagecoach",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {
			{"stagecoach001x", "Stagecoach 1", 275, 27, 250, {} },
			{"stagecoach002x", "Stagecoach 2", 275, 27, 250, {} },
			{"stagecoach004_2x", "Stagecoach 4", 300, 30, 50, {} },
			{"stagecoach004x", "Stagecoach 5", 200, 200, 100, {} },
			{"stagecoach006x", "Stagecoach 7",  275, 27, 250, {} },    
		},
	},

	{

	    Category = 'Buggy',
		BackgroundImage = "buggy",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {
			{"buggy01", "Buggy 1", 350, 35, 30, {} },
			{"buggy02", "Buggy 2", 400, 40, 30, {} },
			{"buggy03", "Buggy 3", 450, 45, 30, {} },  
		},
	},

	{

	    Category = 'Wagons',
		BackgroundImage = "wagons",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {
			{"chuckwagon000X", "Chuck Wagon 1", 160, 16, 250, {} },
			{"chuckwagon002X", "Chuck Wagon 2", 160, 16, 250, {} },
			{"wagon02x", "Wagon 1", 150, 15, 275, {} },  
			{"wagon03x", "Wagon 2", 115, 11, 50, {} },  
			{"wagon05x", "Wagon 4", 150, 15, 275, {} },  
		},
	},

	{

	    Category = 'Utility',
		BackgroundImage = "other",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS")
		Wagons = {

			{"huntercart01", "Hunter Cart", 175, 17, 300, {} },  
			{"coal_wagon", "Coal Wagon", 130, 13, 300, { "miner"} },  
			{"logwagon", "Log Wagon", 130, 13, 300, { "lumberjack" } },  
			{"supplywagon", "Supply Wagon", 275, 27, 500, {} },  

			{"WAGONDOC01X", "Doctor Wagon", 100, 10, 0, { "doctor", "medic" } }, 

			{"bountywagon01x", "Bounty Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } },
			{"ArmySupplyWagon", "Army Supply Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } },
			{"policeWagon01x", "Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } },  
			--{"policeWagongatling01x", "Gatling Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } },  
			{"wagonarmoured01x", "Armoured Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" } },  
			{"wagonPrison01x", "Prison Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" } }, 
			--{"warWagon2", "War Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } }, 
			{"gatchuck_2", "GatChuck 2", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" } }, 
		},
	},

}