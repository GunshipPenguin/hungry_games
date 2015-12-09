arena = {}

-- Register a node to fill the area outside the arena that should not be accessible to players
minetest.register_node("hungry_games:arena_node", {
	diggable = false,
	sunlight_propagates = true,
	drawtype = "airlike",
	groups = {not_in_creative_inventory = 1}
})

-- Ensure that the only world generated is a cube centered around (0,0,0) with an x,y and z dimension of arena.size
minetest.register_on_generated(function(minp, maxp, seed)
	local c_arena = minetest.get_content_id("hungry_games:arena_node")
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
	local data = vm:get_data(minp, maxp)
	
	for i in area:iterp(emin, emax) do
		local curr_pos = area:position(i)
		if math.abs(curr_pos["x"]) > arena.size/2 or 
				math.abs(curr_pos["y"]) > arena.size/2 or
				math.abs(curr_pos["z"]) > arena.size/2 then
			data[i] = c_arena;
		end
	end

	vm:set_data(data)
	vm:write_to_map(data)
end)
