# TPZ-CORE Stables

## UNDER DEVELOPMENT! 

## Requirements

1. TPZ-Core: https://github.com/TPZ-CORE/tpz_core
2. TPZ-Characters: https://github.com/TPZ-CORE/tpz_characters
3. TPZ-Inventory: https://github.com/TPZ-CORE/tpz_inventory
4. TPZ-Inputs: https://github.com/TPZ-CORE/tpz_inputs
5. TPZ-Menu-Base: https://github.com/TPZ-CORE/tpz_menu_base

# Installation

1. When opening the zip file, open `tpz_stables-main` directory folder and inside there will be another directory folder which is called as `tpz_stables`, this directory folder is the one that should be exported to your resources (The folder which contains `fxmanifest.lua`).

2. Add `ensure tpz_stables` after the **REQUIREMENTS** in the resources.cfg or server.cfg, depends where your scripts are located.

## Commands 

| Command                          | Ace Permission                     | Description                                                               |
|----------------------------------|------------------------------------|---------------------------------------------------------------------------|
| addhorse [source] [model] [sex]  | tpzcore.stables.addhorse           | Execute this command to add (give) a horse on the selected player source. |
| addwagon [source] [model]        | tpzcore.stables.addwagon           | Execute this command to add (give) a wagon on the selected player source. |

- The ace permission: `tpzcore.all` Gives permissioms to all commands (FOR ALL OFFICIAL PUBLISHED FREE SCRIPTS).
- The ace permission: `tpzcore.stables.all` Gives permissions to all commands ONLY for this script.