--[[
This is where the gamemode is going to read your cheatcodes. Adding cheatcodes is not as difficult as it may seem, and the better you are at
coding, the more complicated things you can make. I've organized this file to help you add cheat codes. Just follow the functions and have fun!
--]]

function cheatcode( ply, cmd, args ) --Our first func, which will define what inputs are actually cheats
	if tonumber( args[1] ) == nil then print( "Invalid Code" ) return end --If it's not part of the table, its invalid
	local cheat = tonumber ( args[1] )
	
	if cheat == 1 then
	cheat = "monkey_123" --The text that should be inputted into the cheat menu
	end

	ply:SetNWBool( cheat, true ) --Apply the cheatcode to the player
	
end

function ApplyCheats( ply ) --Our second func, which is run every time the player spawns. Here we will define how the cheats work

	if ply:GetNWBool( "monkey_123", false ) == true then --This checks to see if the player has this particular cheat active. This will either spawn him with Face Punchers, or a knife.
		ply:Give( "rad_gibfists" )
	else
		ply:Give( "rad_knife" )
	end

end

concommand.Add( "inputcheat", cheatcode )

--[[
To add cheats, you'll need to give it a number in enums.lua and define it in the cheatcode function. 
Then, make it functional through the ApplyCheats function. 
Finally, go to vgui/vgui_cheatcodes.lua and set your own custom message and input. There is more documentation in that file.
]]--