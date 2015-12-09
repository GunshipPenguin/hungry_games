-- random_chests API
random_chests = {}

-- Default values for settings
random_chests.spawn_chests = true
random_chests.chest_rarity = 2
random_chests.generator_ignore_groups = {"liquid", "leafdecay", "flora", "plant"}

-- Table for storing chest locations
local chests = {}

--Table for storing chest items
local chest_items = {}

-- Path to the file storing chest locations
local filepath = minetest.get_worldpath() .. "/random_chests.chests"

-- Registers an item to spawn in chests
random_chests.register_item = function(name, rarity, max_num)
	assert(name and rarity and max_num)
	table.insert(chest_items, {name=name, rarity=rarity, max_num=max_num})
end

-- Removes all items from chest at pos
local clear_chest = function(pos)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	inv:set_list("main", {})
end

-- Removes all items from all chests
random_chests.clear = function()
	for _,i in pairs(chests) do
		clear_chest(i)
	end
end

-- Fills the chest at the position pos with items
local fill_chest = function(pos)
	local inv_items = {}
	for _,v in pairs(chest_items) do
		if math.random(1, v.rarity) == 1 then
			table.insert(inv_items, v.name .." "..tostring(math.random(1,v.max_num)))
		end
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	for _,item in pairs(inv_items) do
		inv:add_item("main", item)
	end
end

-- Refills all chests
random_chests.refill = function()
	for i,pos in pairs(chests) do
		local n = minetest.get_node(pos).name
		if (not n:match("default:chest")) and n ~= "ignore" then
			table.remove(chests,i)
		else
			fill_chest(pos)
		end
	end
end

-- Save the positions of all chests in the chests table to disk
local save_chests = function()
	local output = io.open(filepath, "w")
	for i,v in pairs(chests) do
		output:write(v.x.." "..v.y.." "..v.z.."\n")
	end
	io.close(output)
end

-- Ensure that the positions of placed chests are saved
minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if newnode.name == "default:chest" then
			table.insert(chests,pos)
			save_chests()
	end
end)

-- Load chests from disk
local input = io.open(filepath, "r")
if input then
	while true do
		local line = input:read("*l")
		if not line then 
			break
		end
		
		local parms = {}
		remaining = line
		while true do
			v, p = remaining:match("^(%S*) (.*)")
			if p then
				remaining = p
			end
			if v then
				table.insert(parms,v)
			else
				v = remaining:match("^(%S*)")
				table.insert(parms,v)
				break
			end
		end
		table.insert(chests,{x=parms[1],y=parms[2],z=parms[3]})
	end
	io.close(input)
end

-- Spawn chests if enabled
if random_chests.spawn_chests then
	minetest.register_on_generated(function(minp, maxp, seed)
	
		-- To not spawn chests outside the arena, modify the region defined by minp and maxp so that it does not include any nodes within the arena
		local out_of_bounds = false
		for _,axis in pairs({"x","y","z"}) do
			if minp[axis] > arena.size/2 or maxp[axis] < -arena.size/2 then
				out_of_bounds = true
				break
			end
			maxp[axis] = math.min(arena.size/2, maxp[axis])
			minp[axis] = math.max(-arena.size/2, minp[axis])
		end
		
		if not out_of_bounds then
			-- Get all possible (x,z) coordinates for this chunk
			local possible_xz_coords = {}
			for x=minp.x,maxp.x do
				for z=minp.z,maxp.z do
					table.insert(possible_xz_coords, {x=x, z=z})
				end 
			end
			
			-- Loop through possible_xz_coords, attempting to place a chest for each (x,z) coordinate until we have placed a suitable number of chests or are out of positions
			local placed_chests = 0
			while placed_chests < random_chests.chest_rarity and table.getn(possible_xz_coords) ~= 0 do
				-- Pick a random x and y position within this chunk from the possible_xz_coordinates table and remove it from the table
				local random_pos_index = table.getn(possible_xz_coords)
				local random_pos = possible_xz_coords[math.random(table.getn(possible_xz_coords))]
				table.remove(possible_xz_coords, random_pos_index)
				-- Starting at maxp.y and ending at minp.y, deincrement the y value of the position and get the node there
				for y=maxp.y,minp.y,-1 do
					random_pos.y = y
					local curr_node = minetest.get_node(random_pos)
					-- If curr_node is not air and not in any of the groups in ignore_groups, increment randomPos.y by 1 and place a chest at randomPos
					if curr_node.name ~= "air" then
						local place_chest = true
						for _,group in pairs(random_chests.generator_ignore_groups) do
							if minetest.get_item_group(curr_node.name, group) ~= 0 then
								place_chest = false
								break
							end
						end
						-- If random_pos is a suitable position to place a chest, place a chest and increment placed_chests by 1
						if place_chest then
							random_pos.y = random_pos.y + 1
							minetest.set_node(random_pos, {name="default:chest"})
							table.insert(chests, random_pos)
							placed_chests = placed_chests + 1
							break
						end
					end
				end
			end
			-- Save all chests spawned in this chunk
			save_chests()
		end
	end)
end
