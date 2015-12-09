--[[
This is the main configuration file for the hungry_games_plus subgame.

Fields marked with [SAFE] are safe to modify after world has been generated.
]]--
dofile(minetest.get_modpath("hungry_games").."/engine.lua")
dofile(minetest.get_modpath("hungry_games").."/random_chests.lua")
dofile(minetest.get_modpath("hungry_games").."/spawning.lua")
dofile(minetest.get_modpath("hungry_games").."/arena.lua")

------------------------------------------------
--------Arena configuration (arena.lua) --------

--How large the map gets before it stops generating. The map will be a cube centered around (0,0,0) with this number as its x y and z dimension.
arena.size = 400

-----------------------------------------------
-----Main Engine Configuration (engine.lua)----

hungry_games = {}

--Countdown (in seconds) during which players cannot leave their spawnpoint.
hungry_games.countdown = 10

--Grace period length in seconds (0 for no grace period).
hungry_games.grace_period = 90

--If true, grant players fly and fast after they die in a match so that they can "spectate" the match, they will retain those privs until the end of the match. If false, just spawn them in the lobby without any additional privs.
hungry_games.spectate_after_death = false

--Interval at which chests are refilled during each match (seconds), set to -1 to only fill chests once at the beginning of the match.
hungry_games.chest_refill_interval = 240

--Time (in seconds) after which all player inventories and chests will be cleared, chest refilling will stop (if enabled) and all players will receive the contents of hungry_games.sudden_death_items. -1 to disable.
hungry_games.sudden_death_time = 900

--Items which each player will receive upon the game going into sudden death. This is an array of minetest itemstrings.
hungry_games.sudden_death_items = {
	"default:sword_steel",
	"default:apple 2"
}

--Time (in seconds) after which the game will automatically end in a draw. Must be enabled.
hungry_games.hard_time_limit = 3600

--Percentage of players that must have voted (/vote) for the match to start (0 is 0%, 0.5 is 50%, 1 is 100%) must be <1 and >0.
hungry_games.vote_percent = 0.5

--If the number of connected players is less than or equal to this, the vote to start must be unaimous.
hungry_games.vote_unanimous = 5

--If the number of votes is greater than or equal to 2, a timer will start that will automatically initiate the match in this many seconds (nil to disable).
hungry_games.vote_countdown = 120

--Whether or not players are allowed to dig.
hungry_games.allow_dig = false

-----------------------------------------------------
--------Spawning Configuration (spawning.lua)--------

--Lobby and spawn points. [SAFE]
--NOTE: These are overridden by /hg set spawn & /hg set lobby.
spawning.register_spawn("spawn",{
	mode = "static", 
	pos = {x=0,y=0,z=0},
})
spawning.register_spawn("lobby",{
	mode = "static", 
	pos = {x=0,y=0,z=0},
})

---------------------------------------------------------------
--------Random Chests Configuration (random_chests.lua)--------

--Whether or not to spawn chest in the arena.
random_chests.spawn_chests = true

--How many chests to spawn per chunk (if enabled)
random_chests.chest_rarity = 2

--Node groups that the generator will not spawn chests on top of
random_chests.generator_ignore_groups = {"liquid", "leafdecay", "flora", "plant"}

--One call to random_chests.register_item should be here for each item that you wish to spawn in a chest.
--Example: chest_item('default:torch', 4, 6) means that upon each chest refill, there is a 1 in 4 chance of spawning up to 6 torches
random_chests.register_item('default:apple', 1, 100)
random_chests.register_item('default:axe_wood', 10, 1)
random_chests.register_item('default:axe_stone', 15, 1)
random_chests.register_item('default:axe_steel', 20, 1)
random_chests.register_item('throwing:arrow', 4, 15)
random_chests.register_item('throwing:arrow_fire', 12, 6)
random_chests.register_item('throwing:bow_wood', 5, 1)
random_chests.register_item('throwing:bow_stone', 10, 1)
random_chests.register_item('throwing:bow_steel', 15, 1)
random_chests.register_item('default:sword_wood', 10, 1)
random_chests.register_item('default:sword_stone', 15, 1)
random_chests.register_item('default:sword_steel', 20, 1)
random_chests.register_item('default:sword_diamond', 40, 1)
random_chests.register_item('food:bread_slice', 3, 1)
random_chests.register_item('food:bun', 5, 1)
random_chests.register_item('food:bread', 10, 1)
random_chests.register_item('food:apple_juice', 6, 2)
random_chests.register_item('food:strawberry', 6, 2)
random_chests.register_item('food:meat_raw', 6, 2)
random_chests.register_item('food:rainbow_juice', 30, 1)
random_chests.register_item('food:cactus_juice', 8, 2)
random_chests.register_item('survival_thirst:water_glass', 4, 2)
random_chests.register_item('3d_armor:helmet_wood', 10, 1)
random_chests.register_item('3d_armor:helmet_steel', 30, 1)
random_chests.register_item('3d_armor:helmet_bronze', 20, 1)
random_chests.register_item('3d_armor:helmet_diamond', 50, 1)
random_chests.register_item('3d_armor:helmet_mithril', 40, 1)
random_chests.register_item('3d_armor:chestplate_wood', 10, 1)
random_chests.register_item('3d_armor:chestplate_steel', 30, 1)
random_chests.register_item('3d_armor:chestplate_bronze', 20, 1)
random_chests.register_item('3d_armor:chestplate_mithril', 40, 1)
random_chests.register_item('3d_armor:chestplate_diamond', 50, 1)
random_chests.register_item('3d_armor:leggings_wood', 10, 1)
random_chests.register_item('3d_armor:leggings_steel', 30, 1)
random_chests.register_item('3d_armor:leggings_bronze', 20, 1)
random_chests.register_item('3d_armor:leggings_mithril', 40, 1)
random_chests.register_item('3d_armor:leggings_diamond', 50, 1)
random_chests.register_item('3d_armor:boots_wood', 10, 1)
random_chests.register_item('3d_armor:boots_steel', 30, 1)
random_chests.register_item('3d_armor:boots_bronze', 20, 1)
random_chests.register_item('3d_armor:boots_mithril', 40, 1)
random_chests.register_item('3d_armor:boots_diamond', 50, 1)
random_chests.register_item('shields:shield_wood', 10, 1)
random_chests.register_item('shields:shield_steel', 30, 1)
random_chests.register_item('shields:shield_bronze', 20, 1)
random_chests.register_item('shields:shield_diamond', 50, 1)
random_chests.register_item('shields:shield_mithril', 40, 1)
--Crafting items
random_chests.register_item('default:stick', 8, 10)
random_chests.register_item('default:steel_ingot', 15, 3)
random_chests.register_item('farming:string', 7, 3)
random_chests.register_item('food:cup', 5, 2)

--END OF CONFIG OPTIONS
dofile(minetest.get_modpath("hungry_games").."/setup.lua")
