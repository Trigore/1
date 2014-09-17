local Player = FindMetaTable("Player") 

util.AddNetworkString("EXPDataTransmit")
util.AddNetworkString("EXPGotTransmit")

if !file.Exists( "toxsinx", "DATA" ) then
	file.CreateDir( "toxsinx" )
	if !file.Exists( "toxsinx/userdata", "DATA" ) then
		file.CreateDir( "toxsinx/userdata" )
	end
end

function GetPlyClass( ply )
    local id = ply:GetPlayerClass()	
	if id == 0 then return end
	
	if id == 1 then
    return "class_scout" 
	
	elseif id == 2 then
    return "class_commando" 
	
	elseif id == 3 then
    return "class_specialist" 
	
	elseif id == 4 then
    return "class_engineer" 
	
	elseif id == 5 then
	return "class_banshee"
	
	else
	
	return string.lower(id)
end
end

---------------------------------------
-----------Loading Levels--------------
---------------------------------------

function CreateEXPData( ply )
		if file.Exists("toxsinx/userdata/" .. ply:SteamID64() .. "_perkdata.txt", "DATA") == false then
			ply:PrintMessage(HUD_PRINTCONSOLE,"First time user! Initializing perk data.." )
			plyInitialData = {}
			plyInitialData["SteamID"] = ply:SteamID()
			plyInitialData["CLASS_SCOUT.Experience"] = 0
			plyInitialData["CLASS_SCOUT.Level"] = 0
			plyInitialData["CLASS_SCOUT.ReqExperience"] = 25000			
			plyInitialData["CLASS_COMMANDO.Experience"] = 0
			plyInitialData["CLASS_COMMANDO.Level"] = 0
			plyInitialData["CLASS_COMMANDO.ReqExperience"] = 25000			
			plyInitialData["CLASS_SPECIALIST.Experience"] = 0
			plyInitialData["CLASS_SPECIALIST.Level"] = 0
			plyInitialData["CLASS_SPECIALIST.ReqExperience"] = 25000	
			plyInitialData["CLASS_ENGINEER.Experience"] = 0
			plyInitialData["CLASS_ENGINEER.Level"] = 0
			plyInitialData["CLASS_ENGINEER.ReqExperience"] = 25000
			file.Write("toxsinx/userdata/" .. ply:SteamID64() .. "_perkdata.txt", util.TableToKeyValues(plyInitialData))
		end
end

hook.Add( "PlayerInitialSpawn", "Safety Net", CreateEXPData )

function Player:LoadEXPData()
	local class = string.lower(self:GetPlayerClass())
	if self:Team() == TEAM_UNASSIGNED then return end
	if self:Alive() then 
	class = GetPlyClass( self )
		local plyInitialData = {}
		if !file.Exists("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", "DATA") then

			plyInitialData["SteamID"] = self:SteamID()
			plyInitialData["CLASS_SCOUT.Experience"] = 0
			plyInitialData["CLASS_SCOUT.Level"] = 0
			plyInitialData["CLASS_SCOUT.ReqExperience"] = 25000			
			plyInitialData["CLASS_COMMANDO.Experience"] = 0
			plyInitialData["CLASS_COMMANDO.Level"] = 0
			plyInitialData["CLASS_COMMANDO.ReqExperience"] = 25000			
			plyInitialData["CLASS_SPECIALIST.Experience"] = 0
			plyInitialData["CLASS_SPECIALIST.Level"] = 0
			plyInitialData["CLASS_SPECIALIST.ReqExperience"] = 25000	
			plyInitialData["CLASS_ENGINEER.Experience"] = 0
			plyInitialData["CLASS_ENGINEER.Level"] = 0
			plyInitialData["CLASS_ENGINEER.ReqExperience"] = 25000
			file.Write("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", util.TableToKeyValues(plyInitialData))
		end

		local plySavedData = util.KeyValuesToTable(file.Read("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", "DATA"))
		self:SetExperience( plySavedData[ class .. ".experience" ] )
		self:SetLevel( plySavedData[ class .. ".level" ] )
		self:SetReqExperience( plySavedData[ class .. ".reqexperience" ] )

	self:GrantLevelUpgrades()
	end
end

---------------------------------------
-----------Saving Levels---------------
---------------------------------------
timer.Create( "EXPSaver", 10, 0, function()  
	for k, v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		if v:Alive() then
			v:SaveEXPData()
		end
	end 
end ) 

function Player:SaveEXPData()

	if self:GetNWInt( "Level", 0 )  == nil or self:GetNWInt( "Experience", 0 ) == nil or self:GetNWInt( "ReqExperience", 25000 ) == nil then
		self:ChatPrint("[TOXSIN X] Failed to save perk progression. Contact the server owner.")
		self:ChatPrint(self:GetNWInt( "Level", 0 ) )
		self:ChatPrint(self:GetNWInt( "Experience", 0 ))
		self:ChatPrint(self:GetNWInt( "ReqExperience", 25000 ))
		self:ChatPrint(self:GetPlayerClass())
	return end
	local class = GetPlyClass( self )
	local plySavedData = {}
	plySavedData = util.KeyValuesToTable(file.Read("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", "DATA"))
	local plySaveData = {}
	
	plySaveData["SteamID"] = plySavedData["steamid"]
	plySaveData["class_scout.experience"]  = plySavedData["class_scout.experience"] 									
	plySaveData["class_scout.level"] = plySavedData["class_scout.level"] 
	plySaveData["class_scout.reqexperience"] = plySavedData["class_scout.reqexperience"] 			
	plySaveData["class_commando.experience"] = plySavedData["class_commando.experience"]
	plySaveData["class_commando.level"] = plySavedData["class_commando.level"]
	plySaveData["class_commando.reqexperience"]  = plySavedData["class_commando.reqexperience"] 		
	plySaveData["class_specialist.experience"] = plySavedData["class_specialist.experience"]
	plySaveData["class_specialist.level"] = plySavedData["class_specialist.level"]
	plySaveData["class_specialist.reqexperience"] = plySavedData["class_specialist.reqexperience"]
	plySaveData["class_engineer.experience"] = plySavedData["class_engineer.experience"]
	plySaveData["class_engineer.level"]  = plySavedData["class_engineer.level"] 
	plySaveData["class_engineer.reqexperience"]  = plySavedData["class_engineer.reqexperience"] 
	
	plySaveData[ class .. ".level" ]  = self:GetNWInt( "Level", 0 ) 
	plySaveData[ class .. ".experience" ] = self:GetNWInt( "Experience", 0 )
	plySaveData[ class .. ".reqexperience" ] = self:GetNWInt( "ReqExperience", 25000 )
	
	file.Write("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", util.TableToKeyValues(plySaveData))

end

---------------------------------------
-----------EXP Granting----------------
---------------------------------------
--hook.Add("EntityTakeDamage", "EXPEntityTakeDamage", function( target, dmginfo )

--if IsValid(dmginfo:GetAttacker()) then
--	local attacker = dmginfo:GetAttacker()
--	if target.NextBot and attacker:IsPlayer() then 
--	
--	local damageAmount = dmginfo:GetDamage()			
--	local xpGranted = math.Round(damageAmount * 0.125)
--		attacker:AddEXP(xpGranted)
--	end
--	end
--	
--end)

function Player:AddEXP( amount )
	if self:GetLevel() == 6 then return end
	if !self:Alive() then return end

	amount = math.Round( tonumber( amount ) )
	if amount == nil then amount = 0 end
	
	self:AddExperience( amount )
	local requiredEXP = self:GetReqExperience()
	local currentEXP = self:GetExperience()

		if requiredEXP <= currentEXP then
			
			self:SetLevel( self:GetLevel() + 1 )
			if self:GetLevel() == 1 then
				self:SetReqExperience( 100000 )
			end
			if self:GetLevel() == 2 then
				self:SetReqExperience( 500000 )			
			end
			if self:GetLevel() == 3 then
				self:SetReqExperience( 1500000 )			
			end
			if self:GetLevel() == 4 then
				self:SetReqExperience( 3500000 )			
			end
			if self:GetLevel() == 5 then
				self:SetReqExperience( 5500000 )			
			end
			self:Notice("Perk level up achieved! You're now Level " .. self:GetLevel() .. "!", GAMEMODE.Colors.White, 5 )
			self:GrantLevelUpgrades()
			self:SaveEXPData()
			self:EmitSound("yay.wav", 100, 100)
		end
end

---------------------------------------
-----------Reward Granting-------------
---------------------------------------


function Player:GrantLevelUpgrades()
	if !self:Alive() then return end
	if self:Team() == TEAM_UNASSIGNED then return end
	local h = self:GetLevel()
	
	if self:GetPlayerClass() == CLASS_SCOUT then
		self:AddCash ( 4 * h )
		self:SetRunSpeed( GAMEMODE.RunSpeed + ( GAMEMODE.RunSpeed * 0.1 ) + (GAMEMODE.RunSpeed * 0.05 * h ) )
		self:SetMaxSpeed( GAMEMODE.RunSpeed + ( GAMEMODE.RunSpeed * 0.1 ) + (GAMEMODE.RunSpeed * 0.05 * h ) )
		
		if h >= 5 then
			self:Give( "rad_m92" )
		end
		
		if h == 6 then
			self:Give( "rad_mp5k" )
		end
	
	end

	if self:GetPlayerClass() == CLASS_COMMANDO then
	
		self:SetMaxHealth( self:GetMaxHealth() + ( 12 * h ) )
	
		if h >= 5 then
			self:Give( "rad_brown" )
		end
		
		if h == 6 then
			self:Give( "rad_deagle" )
		end
	
	end
	
	if self:GetPlayerClass() == CLASS_SPECIALIST then
	
		if h >= 5 then
		self:Give( "rad_cz75" )
		end
		
		if h == 6 then
		self:Give ( "rad_mateba" )
		end
		
	end
	
	if self:GetPlayerClass() == CLASS_ENGINEER then
		if h >= 5 then
			self:Give( "rad_trapbuilder" )
		end
		if h == 6 then
			self:Give ( "rad_syringegun" )
		end
	end
end

---------------------------------------
--------Console Commands---------------
---------------------------------------

concommand.Add("toxsinx_savexp", function(ply)
ply:SaveEXPData()
end )
