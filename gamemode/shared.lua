
GM.Name 		= "Toxsin X"  
GM.Author 		= "twoski (edited by solid_jake)"
GM.Email 		= ""
GM.Website 		= ""
GM.TeamBased 	= true

CreateConVar( "sv_toxsinx_max_zombies", "30", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the amount of zombies that can be on screen. (def 30)" )
CreateConVar( "sv_toxsinx_zombies_per_player", "20", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls the total zombies in a wave per player. (def 20)" )
CreateConVar( "sv_toxsinx_team_dmg", "0", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls whether teammates can hurt eachother. (def 0)" )
CreateConVar( "sv_toxsinx_dmg_scale", "1", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "Controls bullet damage scaling. (def 1.0)" )
CreateConVar( "sv_toxsinx_start_percent", "66", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "The percent of ready players required to start the game. (def 66)" )
CreateConVar( "sv_toxsinx_post_game_time", "45", { FCVAR_ARCHIVE, FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE }, "How much time before the next map loads? (def 45 seconds)" )

TEAM_ARMY = 1
TEAM_ZOMBIES = 2

function GM:CreateTeams()
	
	team.SetUp( TEAM_ARMY, GAMEMODE.ArmyTeamName, Color( 80, 80, 255 ), true )
	team.SetSpawnPoint( TEAM_ARMY, "info_player_army" ) 
	
	team.SetUp( TEAM_ZOMBIES, GAMEMODE.ZombieTeamName, Color( 255, 80, 80 ), true )
	team.SetSpawnPoint( TEAM_ZOMBIES, "info_player_zombie" ) 

end

function GM:ShouldCollide( ent1, ent2 )

	if ent1:IsPlayer() and ent1:Team() == TEAM_ARMY and ent2.IsWood then
	
		return false
	
	elseif ent2:IsPlayer() and ent2:Team() == TEAM_ARMY and ent1.IsWood then
	
		return false
	
	end
	
	return self.BaseClass:ShouldCollide( ent1, ent2 )

end

function GM:Move( ply, mv )

	if ply:Team() == TEAM_ARMY then
		
		if ply:GetNWFloat( "Stamina", 0 ) <= 5 then
		
			mv:SetMaxSpeed( 110 )
		
		end
	
	else
	
		if mv:GetSideSpeed() > 0 then
	
			mv:SetSideSpeed( 175 )
			
		elseif mv:GetSideSpeed() < 0 then
		
			mv:SetSideSpeed( -175 )
		
		end
	
	end
	
	return self.BaseClass:Move( ply, mv )

end

function GM:PlayerNoClip( pl, on )
	
	if ( game.SinglePlayer() ) then return true end
	
	if pl:IsAdmin() or pl:IsSuperAdmin() then return true end
	
	return false
	
end

function IncludeItems()
	
	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.Find( folder.."/gamemode/items/*.lua", "LUA" ) ) do 
	
		include( folder.."/gamemode/items/"..d )
		
		if SERVER then
		
			AddCSLuaFile( folder.."/gamemode/items/"..d )
			
		end
		
	end

end

IncludeItems()

function IncludeEvents()
	
	local folder = string.Replace( GM.Folder, "gamemodes/", "" )

	for c,d in pairs( file.Find( folder.."/gamemode/events/*.lua", "LUA" ) ) do 
	
		if SERVER then
	
			include( folder.."/gamemode/events/"..d )
			
		end
		
	end

end

IncludeEvents()