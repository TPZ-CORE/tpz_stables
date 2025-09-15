-- (!) THE GOLD PRICES ARE NOT CORRECT FOR BUYING OR SELLING, THOSE ARE JUST EXAMPLES.
-- ALWAYS MODIFY THE PRICES BASED ON YOUR SERVER PREFERENCES AND MAKE SURE THE SELLING CASH AND GOLD ARE MODIFIED AFTER JOBS PARAMETER.

-- ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD")

Config.Horses = {

	{ 

		Category = 'Missouri Fox Trotter',

		BackgroundImage = "missourifoxtrotter",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_missourifoxtrotter_amberchampagne", "Amber Champagne", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_missourifoxtrotter_blacktovero", "Black Tovero", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_missourifoxtrotter_blueroan", "Blue Roan", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_missourifoxtrotter_buckskinbrindle", "Buckskin Brindle", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_missourifoxtrotter_dapplegrey", "Dappled Grey", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 },
			{"a_c_horse_missourifoxtrotter_sablechampagne", "Sable Champagne", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 },
			{"a_c_horse_missourifoxtrotter_silverdapplepinto", "Silver Dappled Pinto", 350, 35, { 70, 60, 50, 50, 40 }, {}, 175, 0, 120, 130 }, 
		  
		  }
	},

	{ 

		Category = 'Turkoman',

		BackgroundImage = "turkoman",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_turkoman_black", "Black", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_turkoman_chestnut", "Chestnut", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_turkoman_darkbay", "Dark Bay", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_turkoman_gold", "Gold", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_turkoman_grey", "Grey", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 },
			{"a_c_horse_turkoman_perlino", "Perlino", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 },
			{"a_c_horse_turkoman_silver", "Silver", 350, 35, { 60, 50, 70, 50, 40 }, {}, 175, 0, 120, 130 },         
		},
	},

	{

		Category = 'Arabian',

		BackgroundImage = "arabian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_arabian_rosegreybay", "Rosegrey Bay", 350, 35, { 60, 70, 70, 60, 80 }, {}, 175, 0, 120, 130 },         
			{"a_c_horse_arabian_black", "Black", 350, 35, { 60, 60, 60, 70, 80 }, {}, 175, 0, 120, 130 },                      
			{"a_c_horse_arabian_white", "White", 350, 35, { 60, 50, 50, 60, 80 }, {}, 175, 0, 120, 130 },                      
			{"a_c_horse_arabian_warpedbrindle_pc", "Warped Brindle", 350, 35, { 60, 50, 30, 40, 80  }, {}, 175, 0, 120, 130 },  
			{"a_c_horse_arabian_redchestnut", "Red Chestnut", 350, 35, { 50, 40, 30, 40, 80 }, {}, 175, 0, 120, 130 },         
			{"a_c_horse_arabian_redchestnut_pc", "Red Chestnut Wrap", 350, 35, { 50, 40, 30, 40, 80 }, {}, 175, 0, 120, 130 }, 
			{"a_c_horse_arabian_grey", "Grey", 350, 35, { 60, 70, 70, 60, 80 }, {}, 175, 0, 120, 130 },                        
			{"a_c_horse_gang_dutch", "Dutch Gang", 350, 35, { 60, 70, 70, 60, 80 }, {}, 175, 0, 120, 130 }, -- This horse is associated with Dutch's gang and is not available for purchase or taming in the game.               
	
		},
	},
	
	{ 

		Category = 'Kladruber',

		BackgroundImage = "kladruber",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_kladruber_black", "Black", 150, 15, { 20, 50, 50, 30, 40 }, {}, 75, 0, 60, 70 }, 
			{"a_c_horse_kladruber_cremello", "Cremello", 150, 15, { 30, 60, 60, 40, 40 }, {}, 75, 0, 60, 70 }, 
			{"a_c_horse_kladruber_dapplerosegrey", "Dappler Rose Grey", 200, 20, { 40, 70, 70, 50, 40 }, {}, 100, 0, 60, 70 }, 
			{"a_c_horse_kladruber_grey", "Grey", 150, 15, { 30, 60, 60, 40, 40 }, {}, 75, 0, 60, 70 }, 
			{"a_c_horse_kladruber_silver", "Silver", 150, 15, { 40, 70, 70, 50, 40 }, {}, 75, 0, 60, 70 },
			{"a_c_horse_kladruber_white", "White", 150, 15, { 20, 50, 50, 30, 40 }, {}, 75, 0, 60, 70 },
		},
	},

	{

		Category = 'Mustang',

		BackgroundImage = "mustang",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_mustang_blackovero", "Black Overo", 120, 35, { 60, 60, 50, 30, 40 }, {}, 60, 0, 120, 130 }, 
			{"a_c_horse_mustang_buckskin", "Buckskin", 120, 35, { 60, 60, 50, 30, 40 }, {}, 60, 0, 120, 130 }, 
			{"a_c_horse_mustang_chestnuttovero", "Chestnut Tovero", 120, 35, { 60, 60, 50, 30, 40 }, {}, 60, 0, 120, 130 }, 
			{"a_c_horse_mustang_goldendun", "Golden Dun", 120, 35, { 40, 40, 30, 20, 40 }, {}, 60, 0, 120, 130 }, 
			{"a_c_horse_mustang_grullodun", "Grullo Dun", 120, 35, { 40, 40, 30, 20, 40 }, {}, 60, 0, 120, 130 },
			{"a_c_horse_mustang_reddunovero", "Red Dun Overo", 120, 35, { 60, 60, 50, 30, 40 }, {}, 60, 0, 120, 130 },
			{"a_c_horse_mustang_tigerstripedbay", "Tiger Striped Bay", 120, 35, {50, 50, 40, 20, 40 }, {}, 60, 0, 120, 130 },    
			{"a_c_horse_mustang_wildbay", "Tiger Striped Bay", 120, 35, { 40, 40, 30, 20 }, {}, 60, 0, 120, 130 },             
		},
	
	},

	{ 

		Category = 'Thoroughbred',

		BackgroundImage = "thoroughbred",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_thoroughbred_blackchestnut", "Black Chestnut", 100, 35, { 70, 30, 30, 50, 60 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_thoroughbred_bloodbay", "Blood Bay", 100, 35, { 40, 30, 30, 30, 60 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_thoroughbred_brindle", "Brindle", 100, 35, { 70, 30, 30, 50, 60 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_thoroughbred_dapplegrey", "Dappled Grey", 100, 35, { 40, 30, 30, 30, 60 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_thoroughbred_reversedappleblack", "Reverse Dappled Black", 100, 35, { 70, 30, 30, 50, 60 }, {}, 50, 0, 120, 130 },          
		},
	},

	{

		Category = 'Norfolk',

		BackgroundImage = "norfolk",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_norfolkroadster_spottedtricolor", "Spotted Tricolor", 100, 35, {70, 60, 40, 60, 40 }, {"police", "sheriff", "marshall", "detective", "judecator"}, 50, 0, 120, 130 }, 
			{"a_c_horse_norfolkroadster_speckledgrey", "Speckled Grey", 100, 35, { 50, 40, 20, 40, 40 }, {"medic"}, 50, 0, 120, 130 }, 
			{"a_c_horse_norfolkroadster_rosegrey", "Rose Grey", 100, 35, { 60, 50, 30, 50, 40 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_norfolkroadster_piebaldroan", "Piebaldo Roan", 100, 35, { 60, 50, 30, 50, 40 }, {}, 50, 0, 120, 130 }, 
			{"a_c_horse_norfolkroadster_dappledbuckskin", "Dappled Buckskin", 100, 35, { 70, 60, 40, 60, 40}, {}, 50, 0, 120, 130 },
			{"a_c_horse_norfolkroadster_black", "Black", 100, 35, { 50, 40, 20, 40, 40 }, {}, 50, 0, 120, 130 },           
		},
	},

	{ 

	    Category = 'Gypsy Cob',

		BackgroundImage = "gypsycob",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_gypsycob_splashedpiebald", "Splashed Piebald", 100, 20, { 50, 70, 70, 40, 40 }, {}, 50, 0, 90, 100  },
			{"a_c_horse_gypsycob_splashedbay", "Splashed Bay", 100, 20, { 50, 70, 70, 40, 40 }, {}, 50, 0, 90, 100  },         
			{"a_c_horse_gypsycob_palominoblagdon", "Palomino Blagdon", 100, 20, { 30, 60, 70, 30, 40 }, {}, 50, 0, 90, 100  },   
			{"a_c_horse_gypsycob_skewbald", "Skewbald", 100, 20, { 30, 60, 70, 30, 40 }, {}, 50, 0, 90, 100  },                 
			{"a_c_horse_gypsycob_piebald", "Piebald", 100, 20, { 20, 50, 60, 20, 40 }, {}, 50, 0, 90, 100  },                   
			{"a_c_horse_gypsycob_whiteblagdon", "WhiteBlagdon", 100, 20, { 20, 50, 60, 20, 40 }, {}, 50, 0, 90, 100  },        
		},

	},

	{

		Category = 'Breton',

		BackgroundImage = "breton",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_breton_sealbrown", "Seal Brown", 100, 20, { 50, 60, 50, 30, 40 }, {}, 50, 0, 90, 100  }, 
			{"a_c_horse_breton_redroan", "Red Roan", 100, 20, { 40, 50, 40, 20, 40 }, {}, 50, 0, 90, 100  }, 
			{"a_c_horse_breton_steelgrey", "Steel Grey", 100, 20, { 60, 70, 60, 40, 40 }, {}, 50, 0, 90, 100  }, 
			{"a_c_horse_breton_grullodun", "Grullo Dun", 100, 20, { 50, 60, 50, 30, 40 }, {}, 50, 0, 90, 100  }, 
			{"a_c_horse_breton_mealydapplebay", "Mealy Dappled Bay", 100, 20, { 60, 70, 60, 40, 40 }, {}, 50, 0, 90, 100  },
			{"a_c_horse_breton_sorrel", "Sorrel", 100, 20, { 40, 50, 40, 20, 40 }, {}, 50, 0, 90, 100  },
	
		},
	},


	{

		Category = 'Criollo',

		BackgroundImage = "criollo",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_criollo_baybrindle", "Bay Brindle", 80, 35, { 60, 50, 40, 40, 40 }, {}, 40, 0, 120, 130 }, 
			{"a_c_horse_criollo_bayframeovero", "Bay Frame Overo", 80, 35, { 70, 60, 50, 50, 40 }, {}, 40, 0, 120, 130 }, 
			{"a_c_horse_criollo_blueroanovero", "Blue Roan Overo", 80, 35, { 50, 40, 30, 30, 40 }, {}, 40, 0, 120, 130 }, 
			{"a_c_horse_criollo_dun", "Dun", 80, 35, { 50, 40, 30, 30, 40 }, {}, 40, 0, 120, 130 }, 
			{"a_c_horse_criollo_marblesabino", "Marble Sabino", 80, 35, { 70, 60, 50, 40, 40}, {}, 40, 0, 120, 130 },
			{"a_c_horse_criollo_sorrelovero", "Sorrel Overo", 80, 35, { 60, 50, 40, 40, 40 }, {}, 40, 0, 120, 130 },         
		},
	},


	{

		Category = 'Andalusian',

		BackgroundImage = "andalusian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_andalusian_darkbay", "Dark Grey", 70, 15, { 30, 40, 50, 30, 40 }, {}, 35, 0, 60, 70 }, 
			{"a_c_horse_andalusian_perlino", "Perlino", 70, 15, { 30, 50, 70, 30, 40 }, {}, 35, 0, 60, 70 },        
			{"a_c_horse_andalusian_rosegray", "Rose Gray", 70, 15, { 30, 50, 70, 30, 40}, {}, 35, 0, 60, 70 },
		},

	},   


	{

		Category = 'Nokota',

		BackgroundImage = "nokota",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_nokota_blueroan", "Blue Roan", 60, 20, { 40, 30, 30, 30, 60 }, {}, 30, 0, 90, 100 }, 
			{"a_c_horse_nokota_reversedappleroan", "Reverse Dappled Roan", 60, 20, { 70, 30, 30, 50, 60 }, {}, 30, 0, 90, 100 }, 
			{"a_c_horse_nokota_whiteroan", "White Roan", 60, 20, { 40, 30, 30, 30, 60 }, {}, 30, 0, 90, 100 },      
		},
	
	},

	{ 

		Category = 'Appaloosa',

		BackgroundImage = "appaloosa",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_appaloosa_brownleopard", "Brawn Leopard", 50, 20, { 40, 60, 50, 30, 40 }, {}, 25, 0, 90, 100 },     
			{"a_c_horse_appaloosa_leopard", "Leopard", 50, 20, { 40, 60, 50, 30, 40 }, {}, 25, 0, 90, 100 },                
			{"a_c_horse_appaloosa_fewspotted_pc", "Few Spotted", 50, 20, { 30, 50, 30, 30, 40 }, {}, 25, 0, 90, 100 },     
			{"a_c_horse_appaloosa_leopardblanket", "Blanket Leopard", 50, 20, { 30, 40, 30, 30, 40 }, {}, 25, 0, 90, 100 },
			{"a_c_horse_appaloosa_blanket", "Blanket", 50, 20, { 30, 40, 30, 30, 40 }, {}, 25, 0, 90, 100 },       
	
		},
      
	}, 

	{

		Category = 'Hungarian',

		BackgroundImage = "hungarian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_hungarianhalfbred_darkdapplegrey","Dark Apple Grey", 50, 15, { 30, 40, 50, 30, 40 }, {}, 25, 0, 60, 70 }, 
			{"a_c_horse_hungarianhalfbred_flaxenchestnut","Flaxen Chestnut", 50, 15, { 30, 30, 40, 30, 40 }, {}, 25, 0, 60, 70 },
			{"a_c_horse_hungarianhalfbred_liverchestnut","Liver Chestnut", 50, 15, { 30, 30, 40, 30, 40 }, {}, 25, 0, 60, 70 },  
			{"a_c_horse_hungarianhalfbred_piebaldtobiano","Piebald Tobiano", 50, 15, { 30, 30, 40, 30, 40 }, {}, 25, 0, 60, 70 },
		},
		
	},

	{

		Category = 'Dutch Warmblood',

		BackgroundImage = "dutchwarmblood",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_dutchwarmblood_chocolateroan", "Chocolate Roan", 50, 20, { 40, 60, 50, 30, 40 }, {}, 25, 0, 90, 100 }, 
			{"a_c_horse_dutchwarmblood_sealbrown", "Seal Brown", 50, 20, { 30, 50, 40, 30, 40 }, {}, 25, 0, 90, 100 },          
			{"a_c_horse_dutchwarmblood_sootybuckskin", "Sooty Buckskin", 50, 20, { 30, 50, 40, 30, 40 }, {}, 25, 0, 90, 100 }, 
		},
	
	},

	{ 

		Category = 'Ardennes',

		BackgroundImage = "ardennes",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_ardennes_strawberryroan", "Strawberry Roan", 70, 15, { 30, 50, 70, 30, 40 },{}, 35, 0, 60, 70 },
			{"a_c_horse_ardennes_irongreyroan", "Iron Grey Roan", 45, 15, { 30, 50, 70, 30, 40 }, {}, 22, 0, 60, 70 },  
			{"a_c_horse_ardennes_bayroan", "Bay Roan", 45, 15, { 30, 50, 70, 30, 40 }, {}, 22, 0, 60, 70 },             
			
		},

	},

	{ 

	    Category = 'American Paint',

		BackgroundImage = "americanpaint",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_americanpaint_greyovero", "Grey", 60, 20, { 40, 50, 50, 40, 40 }, {}, 30, 0, 90, 100  },               
			{"a_c_horse_americanpaint_overo", "Overo", 40, 20, { 30, 40, 30, 30, 40 }, {}, 20, 0, 90, 100  },                   
			{"a_c_horse_americanpaint_splashedwhite", "Splashed White", 40, 20, { 30, 50, 30, 30, 40 }, {}, 20, 0, 90, 100 }, 
			{"a_c_horse_americanpaint_tobiano", "Tobiano", 40, 20, { 30, 40, 30, 30, 40 }, {}, 20, 0, 90, 100  },              
		},

	},

	{  

		Category = 'American Standard',
		
		BackgroundImage = "americanstandard",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {
			{"a_c_horse_americanstandardbred_silvertailbuckskin", "Silver Tail Buckskin", 35, 20, { 48, 70, 40, 40, 40 }, {}, 17, 0, 90, 100  }, 
			{"a_c_horse_americanstandardbred_palominodapple", "Palomino Dapple", 35, 20, { 48, 60, 40, 40, 40 }, {}, 17, 0, 90, 100  },          
			{"a_c_horse_americanstandardbred_buckskin", "Buckskin", 35, 20, { 45, 55, 40, 35, 40 }, {}, 17, 0, 90, 100  },                       
			{"a_c_horse_americanstandardbred_black", "Black", 35, 20, { 45, 55, 40, 35, 44 }, {}, 17, 0, 90, 100  },                             
	
		},
	},  

	{

		Category = 'Shire',

		BackgroundImage = "shire",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_shire_darkbay", "Dark Bay", 30, 15, { 30, 30, 40, 20, 20 }, {}, 15, 0, 60, 70 }, 
			{"a_c_horse_shire_lightgrey", "Light Grey", 30, 15, { 30, 30, 40, 20, 20 }, {}, 15, 0, 60, 70 }, 
			{"a_c_horse_shire_ravenblack", "Raven Black", 30, 15, { 30, 40, 40, 20, 20 }, {}, 15, 0, 60, 70 },          
		},
	
	},

	{ 

		Category = 'Morgan',

		BackgroundImage = "morgan",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_morgan_bay", "Bay", 22, 20, { 50, 50, 40, 30, 40 }, {}, 12, 0, 90, 100 }, 
			{"a_c_horse_morgan_bayroan", "Bay Roan", 22, 20, { 50, 50, 40, 30, 40 }, {}, 12, 0, 90, 100 }, 
			{"a_c_horse_morgan_flaxenchestnut", "Flaxen Chestnut", 22, 20, { 50, 50, 40, 30, 40 }, {}, 12, 0, 90, 100 }, 
			{"a_c_Horse_morgan_liverchestnut_pc", "Liver Chestnut", 22, 20, { 50, 50, 40, 30, 40 }, {}, 12, 0, 90, 100 }, 
			{"a_c_horse_morgan_palomino", "Palomino", 22, 20, { 50, 50, 40, 30, 40 }, {}, 12, 0, 90, 100 },           
		},
	
	},

	
	{

		Category = 'Kentucky',

		BackgroundImage = "kentucky",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_kentuckysaddle_black", "Black", 20, 15, { 30, 20, 30, 20, 40 }, {}, 10, 0, 60, 70 },                               
			{"a_c_horse_kentuckysaddle_buttermilkbuckskin_pc", "Butter Milk Buckskin", 20, 15, { 40, 30, 30, 20, 40 }, {}, 10, 0, 60, 70 },
			{"a_c_horse_kentuckysaddle_chestnutpinto", "Chestnut Pinto", 20, 15, { 30, 20, 30, 20, 40 }, {}, 10, 0, 60, 70 },              
			{"a_c_horse_kentuckysaddle_grey", "Grey", 20, 15, { 30, 20, 30, 20, 40 }, {}, 10, 0, 60, 70 },                                 
			{"a_c_horse_kentuckysaddle_silverbay", "Silver Bay", 20, 15, {30, 20, 30, 20, 40 }, {}, 10, 0, 60, 70 },                      
		},
	},

	{ 

		Category = 'Suffolk Punch',

		BackgroundImage = "suffolkpunch",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_suffolkpunch_redchestnut", "Red Chestnut", 20, 10, { 30, 40, 30, 20, 20 }, {}, 10, 0, 60, 70 }, 
			{"a_c_horse_suffolkpunch_sorrel", "Sorrel", 20, 10, { 30, 40, 30, 20, 20 }, {}, 10, 0, 60, 70 },           
		},
	},

	{ 

		Category = 'Belgian',

		BackgroundImage = "belgian",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_belgian_blondchestnut", "Blond Chestnut", 18, 10, { 20, 30, 30, 20, 20 }, {}, 9, 0, 60, 70 },
			{"a_c_horse_belgian_mealychestnut", "Mealy Chestnut", 18, 10, { 20, 30, 30, 20, 20 }, {}, 9, 0, 60, 70 },
		},

	},
	
	{ 

		Category = 'Tennessee',

		BackgroundImage = "tennessee",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS", "SELL CASH", "SELL GOLD", "MAXIMUM AGE", "DELETE AGE")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_horse_tennesseewalker_blackrabicano", "Black Rabicano", 17, 15, {20, 30, 30, 20, 40 }, {}, 8, 0, 60, 70 }, 
			{"a_c_horse_tennesseewalker_chestnut", "Chestnut", 17, 15, { 20, 30, 30, 20, 40 }, {}, 8, 0, 60, 70 }, 
			{"a_c_horse_tennesseewalker_dapplebay", "Dappled Bay", 17, 15, { 20, 20, 30, 20, 40 }, {}, 8, 0, 60, 70 }, 
			{"a_c_horse_tennesseewalker_flaxenroan", "Flaxen Roan", 17, 15, { 30, 50, 40, 30, 40 }, {}, 8, 0, 60, 70 }, 
			{"a_c_horse_tennesseewalker_goldpalomino_pc", "Gold Palomino", 17, 15, { 30, 40, 30, 20, 40 }, {}, 8, 0, 60, 70 },
			{"a_c_horse_tennesseewalker_mahoganybay", "Mahogany Bay", 17, 15, { 20, 40, 30, 20, 40 }, {}, 8, 0, 60, 70 },
			{"a_c_horse_tennesseewalker_redroan", "Red Roan", 17, 15, { 20, 30, 30, 20, 40 }, {}, 8, 0, 60, 70 },
		}, 
		
	},


	{ 

		Category = 'Others',

		BackgroundImage = "01",

		-- PARAMETERS: ("ENTITY MODEL", "LABEL", "CASH", "GOLD", "STATS", "JOBS")
		-- STATS: [1] SPEED, [2] STAMINA, [3] HEALTH, [4] ACCELERATION, [5] HANDLING
		Horses = {

			{"a_c_donkey_01", "Donkey", 10, 1, {30, 10, 10, 20, 20 }, {}, 5, 0, 60, 70 },
			{"a_c_horsemule_01", "Horse Mule", 15, 1, { 20, 10, 10, 10, 10 }, {}, 7.5, 0, 60, 70 },

		},
	},
			
}
	
