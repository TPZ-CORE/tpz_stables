-- (!) THE GOLD PRICES ARE NOT CORRECT FOR BUYING OR SELLING, THOSE ARE JUST EXAMPLES.
-- ALWAYS MODIFY THE PRICES BASED ON YOUR SERVER PREFERENCES AND MAKE SURE THE SELLING CASH AND GOLD ARE MODIFIED AFTER JOBS PARAMETER.

-- ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )

Config.Wagons = {

	{

	    Category = 'Carts',
		BackgroundImage = "carts",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"cart01", "Cart 1", 50, 5, 30, {}, 25, 2 },
			{"cart02", "Cart 2", 30, 3, 10, {}, 30, 1 },
			{"cart03", "Cart 3", 60, 6, 30, {}, 30, 3 },
			{"cart04", "Cart 4", 90, 9, 50, {}, 45.5, 4 },
			{"cart05", "Cart 5", 55, 5, 50, {}, 27.5, 2 },
			{"cart06", "Cart 6", 125, 12, 200, {}, 76, 6 },
			{"cart07", "Cart 7", 60, 6, 30, {}, 30, 3 },
			{"cart08", "Cart 8", 60, 6, 30, {}, 30, 3 },      
		},
	},

	{

	    Category = 'Coaches',
		BackgroundImage = "coaches",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"coach2", "Coach 1", 500, 50, 200, {}, 250, 25 },
			{"coach3", "Coach 2", 350, 35, 50, {}, 175, 17 },
			{"coach4", "Coach 3", 300, 30, 50, {}, 150, 15 },
			{"coach5", "Coach 4", 300, 30, 50, {}, 150, 15 },
			{"coach6", "Coach 5", 280, 28, 30, {}, 140, 14 },    
		},
	},

	{

	    Category = 'Stagecoach',
		BackgroundImage = "stagecoach",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"stagecoach001x", "Stagecoach 1", 275, 27, 250, {}, 137.5, 13 },
			{"stagecoach002x", "Stagecoach 2", 275, 27, 250, {}, 137.5, 13 },
			{"stagecoach004_2x", "Stagecoach 4", 300, 30, 50, {}, 15, 15 },
			{"stagecoach004x", "Stagecoach 5", 200, 20, 100, {}, 100, 10 },
			{"stagecoach006x", "Stagecoach 7",  275, 27, 250, {}, 137.5, 13 },    
		},
	},

	{

	    Category = 'Buggy',
		BackgroundImage = "buggy",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"buggy01", "Buggy 1", 350, 35, 30, {}, 175, 17 },
			{"buggy02", "Buggy 2", 400, 40, 30, {}, 200, 20 },
			{"buggy03", "Buggy 3", 450, 45, 30, {}, 450, 22 },  
		},
	},

	{

	    Category = 'Wagons',
		BackgroundImage = "wagons",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {
			{"chuckwagon000X", "Chuck Wagon 1", 160, 16, 250, {}, 130, 13 },
			{"chuckwagon002X", "Chuck Wagon 2", 160, 16, 250, {}, 130, 13 },
			{"wagon02x", "Wagon 1", 150, 15, 275, {}, 75, 7 },  
			{"wagon03x", "Wagon 2", 115, 11, 50, {}, 57, 5 },  
			{"wagon05x", "Wagon 4", 150, 15, 275, {}, 75, 7 },  
		},
	},

	{

	    Category = 'Utility',
		BackgroundImage = "other",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STASH / STORAGE TOTAL WEIGHT", "JOBS", "SELL CASH", "SELL GOLD" )
		Wagons = {

			{"huntercart01", "Hunter Cart", 175, 17, 300, {}, 87.5, 8 },  
			{"coal_wagon", "Coal Wagon", 130, 13, 300, { "miner"}, 65, 6 },  
			{"logwagon", "Log Wagon", 130, 13, 300, { "lumberjack" }, 65, 6 },  
			{"supplywagon", "Supply Wagon", 275, 27, 500, {}, 137.5, 13 },  

			{"WAGONDOC01X", "Doctor Wagon", 100, 10, 0, { "doctor", "medic" }, 50, 5 }, 

			{"bountywagon01x", "Bounty Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000 },
			{"ArmySupplyWagon", "Army Supply Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  },
			{"policeWagon01x", "Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  },  
			--{"policeWagongatling01x", "Gatling Police Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  },  
			{"wagonarmoured01x", "Armoured Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" }, 5000, 5000  },  
			{"wagonPrison01x", "Prison Wagon", 10000, 10000, 0, {"police", "detective", "sheriff", "marshal" }, 5000, 5000  }, 
			--{"warWagon2", "War Wagon", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  }, 
			{"gatchuck_2", "GatChuck 2", 10000, 10000, 0, { "police", "detective", "sheriff", "marshal" }, 5000, 5000  }, 
		},
	},

}