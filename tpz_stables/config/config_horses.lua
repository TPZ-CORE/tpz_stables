-- (!) THE GOLD PRICES ARE NOT CORRECT FOR BUYING OR SELLING, THOSE ARE JUST EXAMPLES.
-- ALWAYS MODIFY THE PRICES BASED ON YOUR SERVER PREFERENCES AND MAKE SURE THE SELLING CASH AND GOLD ARE MODIFIED AFTER JOBS PARAMETER.

-- ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")

Config.Horses = {

	{ 

	    Category = 'American Paint',

		BackgroundImage = "americanpaint",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_americanpaint_greyovero", "Grey", 61, 9, { 40, 50, 50, 40, 40 }, {}, 30, 4 },               
			{"a_c_horse_americanpaint_overo", "Overo", 31, 3, { 30, 40, 30, 30, 40 }, {}, 15, 1 },                   
			{"a_c_horse_americanpaint_splashedwhite", "Splashed White", 40, 4, { 30, 50, 30, 30, 40 }, {}, 20, 2}, 
			{"a_c_horse_americanpaint_tobiano", "Tobiano", 35, 3, { 30, 40, 30, 30, 40 }, {}, 17, 1 },              
		},

	},

	{ 

	    Category = 'Gypsy Cob',

		BackgroundImage = "gypsycob",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_gypsycob_splashedpiebald", "Splashed Piebald", 100, 10, { 50, 70, 70, 40, 40 }, {}, 50, 5 },
			{"a_c_horse_gypsycob_splashedbay", "Splashed Bay", 103, 10, { 50, 70, 70, 40, 40 }, {}, 51, 5 },         
			{"a_c_horse_gypsycob_palominoblagdon", "Palomino Blagdon", 60, 6, { 30, 60, 70, 30, 40 }, {}, 30, 3 },   
			{"a_c_horse_gypsycob_skewbald", "Skewbald", 60, 6, { 30, 60, 70, 30, 40 }, {}, 30, 3 },                 
			{"a_c_horse_gypsycob_piebald", "Piebald", 42, 4, { 20, 50, 60, 20, 40 }, {}, 21, 2 },                   
			{"a_c_horse_gypsycob_whiteblagdon", "WhiteBlagdon", 48, 5, { 20, 50, 60, 20, 40 }, {}, 24, 2 },        
		},

	},

	{  

		Category = 'American Standard',
		
		BackgroundImage = "americanstandard",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_americanstandardbred_silvertailbuckskin", "Silver Tail Buckskin", 35, 3, { 48, 70, 40, 40, 40 }, {}, 17, 2 }, 
			{"a_c_horse_americanstandardbred_palominodapple", "Palomino Dapple", 35, 3, { 48, 60, 40, 40, 40 }, {}, 17, 1 },          
			{"a_c_horse_americanstandardbred_buckskin", "Buckskin", 24, 2, { 45, 55, 40, 35, 40 }, {}, 12, 1 },                       
			{"a_c_horse_americanstandardbred_black", "Black", 25, 2, { 45, 55, 40, 35, 44 }, {}, 12.5, 1 },                             
	
		},
	},  

	{

		Category = 'Andalusian',

		BackgroundImage = "andalusian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_andalusian_darkbay", "Dark Grey", 60, 6, { 30, 40, 50, 30, 40 }, {}, 30, 3}, 
			{"a_c_horse_andalusian_perlino", "Perlino", 70, 7, { 30, 50, 70, 30, 40 }, {}, 35, 3 },        
			{"a_c_horse_andalusian_rosegray", "Rose Gray", 67, 7, { 30, 50, 70, 30, 40}, {}, 33, 3 },
		},

	},   

	{ 

		Category = 'Appaloosa',

		BackgroundImage = "appaloosa",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_appaloosa_brownleopard", "Brawn Leopard", 53, 5, { 40, 60, 50, 30, 40 }, {}, 26, 2 },     
			{"a_c_horse_appaloosa_leopard", "Leopard", 50, 5, { 40, 60, 50, 30, 40 }, {}, 25, 2 },                
			{"a_c_horse_appaloosa_fewspotted_pc", "Few Spotted", 37, 4, { 30, 50, 30, 30, 40 }, {}, 18.5, 2 },     
			{"a_c_horse_appaloosa_leopardblanket", "Blanket Leopard", 38, 4, { 30, 40, 30, 30, 40 }, {}, 19, 2 },
			{"a_c_horse_appaloosa_blanket", "Blanket", 39, 4, { 30, 40, 30, 30, 40 }, {}, 19.5, 2 },       
	
		},
      
	}, 

	{

		Category = 'Arabian',

		BackgroundImage = "arabian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_arabian_rosegreybay", "Rosegrey Bay", 350, 35, { 60, 70, 70, 60, 80 }, {}, 175, 17 },         
			{"a_c_horse_arabian_black", "Black", 318, 32, { 60, 60, 60, 70, 80 }, {}, 159, 16 },                      
			{"a_c_horse_arabian_white", "White", 310, 31, { 60, 50, 50, 60, 80 }, {}, 155, 15 },                      
			{"a_c_horse_arabian_warpedbrindle_pc", "Warped Brindle", 300, 30, { 60, 50, 30, 40, 80  }, {}, 150, 15 },  
			{"a_c_horse_arabian_redchestnut", "Red Chestnut", 290, 29, { 50, 40, 30, 40, 80 }, {}, 145, 14 },         
			{"a_c_horse_arabian_redchestnut_pc", "Red Chestnut Wrap", 290, 29, { 50, 40, 30, 40, 80 }, {}, 145, 14 }, 
			{"a_c_horse_arabian_grey", "Grey", 295, 29, { 60, 70, 70, 60, 80 }, {}, 147.5, 14 },                        
			--{"a_c_horse_gang_dutch", "Dutch Gang", 330, 33, { 60, 70, 60, 80 }, {}, 165, 16 }, -- This horse is associated with Dutch's gang and is not available for purchase or taming in the game.               
	
		},
	},

	{ 

		Category = 'Ardennes',

		BackgroundImage = "ardennes",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_ardennes_strawberryroan", "Strawberry Roan", 69, 7, { 30, 50, 70, 30, 40 },{}, 34.5, 3 },
			{"a_c_horse_ardennes_irongreyroan", "Iron Grey Roan", 45, 4, { 30, 50, 70, 30, 40 }, {}, 22.5, 2 },  
			{"a_c_horse_ardennes_bayroan", "Bay Roan", 44, 4, { 30, 50, 70, 30, 40 }, {}, 22, 2},             
			
		},

	},

	{ 

		Category = 'Belgian',

		BackgroundImage = "belgian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_belgian_blondchestnut", "Blond Chestnut", 17, 2, { 20, 30, 30, 20, 20 }, {}, 8.5, 1 },
			{"a_c_horse_belgian_mealychestnut", "Mealy Chestnut", 17, 2, { 20, 30, 30, 20, 20 }, {}, 8.5, 1 },
		},

	},

	{

		Category = 'Dutch Warmblood',

		BackgroundImage = "dutchwarmblood",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_dutchwarmblood_chocolateroan", "Chocolate Roan", 73, 7, { 40, 60, 50, 30, 40 }, {}, 36.5, 3 }, 
			{"a_c_horse_dutchwarmblood_sealbrown", "Seal Brown", 50, 5, { 30, 50, 40, 30, 40 }, {}, 25, 2 },          
			{"a_c_horse_dutchwarmblood_sootybuckskin", "Sooty Buckskin", 55, 5, { 30, 50, 40, 30, 40 }, {}, 27.5, 2 }, 
		},
	
	},
	
	{

		Category = 'Hungarian',

		BackgroundImage = "hungarian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_hungarianhalfbred_darkdapplegrey","Dark Apple Grey", 45, 4, { 30, 40, 50, 30, 40 }, {}, 22.5, 2 }, 
			{"a_c_horse_hungarianhalfbred_flaxenchestnut","Flaxen Chestnut", 42, 4, { 30, 30, 40, 30, 40 }, {}, 21, 2 },
			{"a_c_horse_hungarianhalfbred_liverchestnut","Liver Chestnut", 51, 5, { 30, 30, 40, 30, 40 }, {}, 25.5, 2 },  
			{"a_c_horse_hungarianhalfbred_piebaldtobiano","Piebald Tobiano", 40, 4, { 30, 30, 40, 30, 40 }, {}, 20, 2 },
		},
		
	},

	{

		Category = 'Kentucky',

		BackgroundImage = "kentucky",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_kentuckysaddle_black", "Black", 20, 2, { 30, 20, 30, 20, 40 }, {}, 10, 1 },                               
			{"a_c_horse_kentuckysaddle_buttermilkbuckskin_pc", "Butter Milk Buckskin", 23, 2, { 40, 30, 30, 20, 40 }, {}, 11.5, 1 },
			{"a_c_horse_kentuckysaddle_chestnutpinto", "Chestnut Pinto", 20, 2, { 30, 20, 30, 20, 40 }, {}, 10, 1 },              
			{"a_c_horse_kentuckysaddle_grey", "Grey", 20, 2, { 30, 20, 30, 20, 40 }, {}, 10, 1 },                                 
			{"a_c_horse_kentuckysaddle_silverbay", "Silver Bay", 20, 2, {30, 20, 30, 20, 40 }, {}, 10, 1 },                      
		},
	},
	
	{ 

		Category = 'Kladruber',

		BackgroundImage = "kladruber",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_kladruber_black", "Black", 130, 13, { 20, 50, 50, 30, 40 }, {}, 65, 6 }, 
			{"a_c_horse_kladruber_cremello", "Cremello", 151, 15, { 30, 60, 60, 40, 40 }, {}, 75.5, 7 }, 
			{"a_c_horse_kladruber_dapplerosegrey", "Dappler Rose Grey", 200, 20, { 40, 70, 70, 50, 40 }, {}, 100, 10 }, 
			{"a_c_horse_kladruber_grey", "Grey", 150, 15, { 30, 60, 60, 40, 40 }, {}, 75, 7 }, 
			{"a_c_horse_kladruber_silver", "Silver", 198, 2, { 40, 70, 70, 50, 40 }, {}, 99, 1 },
			{"a_c_horse_kladruber_white", "White", 130, 13, { 20, 50, 50, 30, 40 }, {}, 65, 6 },
		},
	},

	{ 

		Category = 'Missouri Fox Trotter',

		BackgroundImage = "missourifoxtrotter",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_missourifoxtrotter_amberchampagne", "Amber Champagne", 277, 27, { 70, 60, 50, 50, 40 }, {}, 138.5, 13 }, 
			{"a_c_horse_missourifoxtrotter_blacktovero", "Black Tovero", 280, 28, { 70, 60, 50, 50, 40 }, {}, 140, 14 }, 
			{"a_c_horse_missourifoxtrotter_blueroan", "Blue Roan", 282, 28, { 70, 60, 50, 50, 40 }, {}, 141, 14 }, 
			{"a_c_horse_missourifoxtrotter_buckskinbrindle", "Buckskin Brindle", 275, 27, { 70, 60, 50, 50, 40 }, {}, 137.5, 13 }, 
			{"a_c_horse_missourifoxtrotter_dapplegrey", "Dappled Grey", 273, 27, { 70, 60, 50, 50, 40 }, {}, 136.5, 13 },
			{"a_c_horse_missourifoxtrotter_sablechampagne", "Sable Champagne", 278, 27, { 70, 60, 50, 50, 40 }, {}, 139, 13 },
			{"a_c_horse_missourifoxtrotter_silverdapplepinto", "Silver Dappled Pinto", 285, 28, { 70, 60, 50, 50, 40 }, {}, 142.5, 14 }, 
		  
		  }
	},

	{ 

		Category = 'Morgan',

		BackgroundImage = "morgan",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_morgan_bay", "Bay", 22, 2,{ 50, 50, 40, 30, 40 }, {}, 11, 1 }, 
			{"a_c_horse_morgan_bayroan", "Bay Roan", 23, 2,{ 50, 50, 40, 30, 40 }, {}, 11.5, 1 }, 
			{"a_c_horse_morgan_flaxenchestnut", "Flaxen Chestnut", 18, 1,{ 50, 50, 40, 30, 40 }, {}, 9, 0 }, 
			{"a_c_Horse_morgan_liverchestnut_pc", "Liver Chestnut", 25, 2,{ 50, 50, 40, 30, 40 }, {}, 12.5, 1 }, 
			{"a_c_horse_morgan_palomino", "Palomino", 20,2,{ 50, 50, 40, 30, 40 }, {}, 10, 1 },           
		},
	
	},
	  
	{

		Category = 'Mustang',

		BackgroundImage = "mustang",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_mustang_blackovero", "Black Overo", 125, 12, { 60, 60, 50, 30, 40 }, {}, 62.5, 6 }, 
			{"a_c_horse_mustang_buckskin", "Buckskin", 123, 12, { 60, 60, 50, 30, 40 }, {}, 61.5, 6 }, 
			{"a_c_horse_mustang_chestnuttovero", "Chestnut Tovero", 121, 12, { 60, 60, 50, 30, 40 }, {} }, 
			{"a_c_horse_mustang_goldendun", "Golden Dun", 46, 4, { 40, 40, 30, 20, 40 }, {}, 23, 2 }, 
			{"a_c_horse_mustang_grullodun", "Grullo Dun", 47, 4, { 40, 40, 30, 20, 40 }, {}, 23.5, 2 },
			{"a_c_horse_mustang_reddunovero", "Red Dun Overo", 120, 12, { 60, 60, 50, 30, 40 }, {}, 60, 6 },
			{"a_c_horse_mustang_tigerstripedbay", "Tiger Striped Bay", 72, 7, {50, 50, 40, 20, 40 }, {}, 35.1, 3 },    
			{"a_c_horse_mustang_wildbay", "Tiger Striped Bay", 43, 4, { 40, 40, 30, 20 }, {}, 21.5, 2 },             
		},
	
	},

	{

		Category = 'Nokota',

		BackgroundImage = "nokota",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_nokota_blueroan", "Blue Roan", 55, 5, { 40, 30, 30, 30, 60 }, {}, 27.5, 2 }, 
			{"a_c_horse_nokota_reversedappleroan", "Reverse Dappled Roan", 60, 6, { 70, 30, 30, 50, 60 }, {}, 30, 3 }, 
			{"a_c_horse_nokota_whiteroan", "White Roan", 58, 5, { 40, 30, 30, 30, 60 }, {}, 29, 2 },      
		},
	
	},
	
	{

		Category = 'Shire',

		BackgroundImage = "shire",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_shire_darkbay", "Dark Bay", 30, 3, { 30, 30, 40, 20, 20 }, {}, 15, 1 }, 
			{"a_c_horse_shire_lightgrey", "Light Grey", 32, 3, { 30, 30, 40, 20, 20 }, {}, 16, 1 }, 
			{"a_c_horse_shire_ravenblack", "Raven Black", 35, 3, { 30, 40, 40, 20, 20 }, {}, 17.5, 1 },          
		},
	
	},

	{ 

		Category = 'Suffolk Punch',

		BackgroundImage = "suffolkpunch",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_suffolkpunch_redchestnut", "Red Chestnut", 20, 2, { 30, 40, 30, 20, 20 }, {}, 10, 1 }, 
			{"a_c_horse_suffolkpunch_sorrel", "Sorrel", 18, 1, { 30, 40, 30, 20, 20 }, {}, 9, 0 },           
		},
	},

	{ 

		Category = 'Tennessee',

		BackgroundImage = "tennessee",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_tennesseewalker_blackrabicano", "Black Rabicano", 17, 2, {20, 30, 30, 20, 40 }, {}, 7.5, 1 }, 
			{"a_c_horse_tennesseewalker_chestnut", "Chestnut", 18, 2, { 20, 30, 30, 20, 40 }, {}, 9, 1 }, 
			{"a_c_horse_tennesseewalker_dapplebay", "Dappled Bay", 17, 2, { 20, 20, 30, 20, 40 }, {}, 7.5, 1 }, 
			{"a_c_horse_tennesseewalker_flaxenroan", "Flaxen Roan", 22, 2, { 30, 50, 40, 30, 40 }, {}, 12, 1 }, 
			{"a_c_horse_tennesseewalker_goldpalomino_pc", "Gold Palomino", 20, 2, { 30, 40, 30, 20, 40 }, {}, 10, 1 },
			{"a_c_horse_tennesseewalker_mahoganybay", "Mahogany Bay", 19, 2, { 20, 40, 30, 20, 40 }, {}, 9.5, 1 },
			{"a_c_horse_tennesseewalker_redroan", "Red Roan", 17, 2, { 20, 30, 30, 20, 40 }, {}, 7.5, 1 },
		}, 
		
	},

	{ 

		Category = 'Thoroughbred',

		BackgroundImage = "thoroughbred",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_thoroughbred_blackchestnut", "Black Chestnut", 51, 5, { 70, 30, 30, 50, 60 }, {}, 25.5, 2 }, 
			{"a_c_horse_thoroughbred_bloodbay", "Blood Bay", 50, 5, { 40, 30, 30, 30, 60 }, {}, 25, 2 }, 
			{"a_c_horse_thoroughbred_brindle", "Brindle", 100, 10, { 70, 30, 30, 50, 60 }, {}, 50, 5 }, 
			{"a_c_horse_thoroughbred_dapplegrey", "Dappled Grey", 53, 5, { 40, 30, 30, 30, 60 }, {}, 26.5, 2 }, 
			{"a_c_horse_thoroughbred_reversedappleblack", "Reverse Dappled Black", 101, 10, { 70, 30, 30, 50, 60 }, {}, 50.5, 5 },          
		},
	},

	{ 

		Category = 'Turkoman',

		BackgroundImage = "turkoman",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_turkoman_black", "Black", 275, 27, { 60, 50, 70, 50, 40 }, {}, 137.5, 13 }, 
			{"a_c_horse_turkoman_chestnut", "Chestnut", 282, 28, { 60, 50, 70, 50, 40 }, {}, 141, 14 }, 
			{"a_c_horse_turkoman_darkbay", "Dark Bay", 274, 27, { 60, 50, 70, 50, 40 }, {}, 137, 13 }, 
			{"a_c_horse_turkoman_gold", "Gold", 271, 27, { 60, 50, 70, 50, 40 }, {}, 135.5, 13 }, 
			{"a_c_horse_turkoman_grey", "Grey", 251, 25, { 60, 50, 70, 50, 40 }, {}, 125.5, 12 },
			{"a_c_horse_turkoman_perlino", "Perlino", 278, 27, { 60, 50, 70, 50, 40 }, {}, 139, 13 },
			{"a_c_horse_turkoman_silver", "Silver", 260, 26, { 60, 50, 70, 50, 40 }, {}, 130, 13 },         
		},
	},

	{

		Category = 'Criollo',

		BackgroundImage = "criollo",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_criollo_baybrindle", "Bay Brindle", 67, 6, { 60, 50, 40, 40, 40 }, {}, 33.5, 3 }, 
			{"a_c_horse_criollo_bayframeovero", "Bay Frame Overo", 77, 7, { 70, 60, 50, 50, 40 }, {}, 38.5, 3 }, 
			{"a_c_horse_criollo_blueroanovero", "Blue Roan Overo", 63, 6, { 50, 40, 30, 30, 40 }, {}, 31.5, 3 }, 
			{"a_c_horse_criollo_dun", "Dun", 65, 6, { 50, 40, 30, 30, 40 }, {}, 32.5, 3 }, 
			{"a_c_horse_criollo_marblesabino", "Marble Sabino", 75, 7, { 70, 60, 50, 40, 40}, {}, 37.5, 3 },
			{"a_c_horse_criollo_sorrelovero", "Sorrel Overo", 69, 7, { 60, 50, 40, 40, 40 }, {}, 34.5, 3 },         
		},
	},

	{

		Category = 'Breton',

		BackgroundImage = "breton",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_breton_sealbrown", "Seal Brown", 83, 8, { 50, 60, 50, 30, 40 }, {}, 41.5, 4 }, 
			{"a_c_horse_breton_redroan", "Red Roan", 81, 8, { 40, 50, 40, 20, 40 }, {}, 40.5, 4 }, 
			{"a_c_horse_breton_steelgrey", "Steel Grey", 86, 8, { 60, 70, 60, 40, 40 }, {}, 43, 4 }, 
			{"a_c_horse_breton_grullodun", "Grullo Dun", 85, 8, { 50, 60, 50, 30, 40 }, {}, 42.5, 4 }, 
			{"a_c_horse_breton_mealydapplebay", "Mealy Dappled Bay", 88, 8, { 60, 70, 60, 40, 40 }, {}, 44, 4 },
			{"a_c_horse_breton_sorrel", "Sorrel", 80, 8, { 40, 50, 40, 20, 40 }, {}, 40, 4 },
	
		},
	},

	{

		Category = 'Norfolk',

		BackgroundImage = "norfolk",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_norfolkroadster_spottedtricolor", "Spotted Tricolor", 95, 9, {70, 60, 40, 60, 40 }, {"police", "sheriff", "marshall", "detective", "judecator"}, 47.5, 4 }, 
			{"a_c_horse_norfolkroadster_speckledgrey", "Speckled Grey", 72, 7, { 50, 40, 20, 40, 40 }, {"medic"}, 36, 3 }, 
			{"a_c_horse_norfolkroadster_rosegrey", "Rose Grey", 78, 7, { 60, 50, 30, 50, 40 }, {}, 39, 3 }, 
			{"a_c_horse_norfolkroadster_piebaldroan", "Piebaldo Roan", 80, 8, { 60, 50, 30, 50, 40 }, {}, 40, 4 }, 
			{"a_c_horse_norfolkroadster_dappledbuckskin", "Dappled Buckskin", 95, 9, { 70, 60, 40, 60, 40}, {}, 47.5, 4 },
			{"a_c_horse_norfolkroadster_black", "Black", 75, 7, { 50, 40, 20, 40, 40 }, {}, 37.5, 3 },           
		},
	},

	{ 

		Category = 'Others',

		BackgroundImage = "01",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_donkey_01", "Donkey", 10, 1, {30, 10, 10, 20, 20 }, {}, 5, 0 },
			{"a_c_horsemule_01", "Horse Mule", 15, 1, { 20, 10, 10, 10, 10 }, {}, 7.5, 0 },

		},
	},
			
}
	