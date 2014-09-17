include( 'player_class/player_base.lua' )
include( 'player_class/player_zombie.lua' )
include( 'map_defaults.lua' )
include( 'resource.lua' )
include( 'enums.lua' )
include( 'items.lua' )
include( 'events.lua' )
include( 'shared.lua' )
include( 'moddable.lua' )
include( 'ply_extension.lua' )
include( 'tables.lua' )
include( 'weather.lua' )
include( 'perk_module.lua' )
include( 'cheat_module.lua' )

AddCSLuaFile( 'player_class/player_base.lua' )
AddCSLuaFile( 'player_class/player_zombie.lua' )
AddCSLuaFile( 'animations.lua' )
AddCSLuaFile( 'enums.lua' )
AddCSLuaFile( 'items.lua' )
AddCSLuaFile( 'shared.lua' )
AddCSLuaFile( 'moddable.lua' )
AddCSLuaFile( 'cl_notice.lua' )
AddCSLuaFile( 'cl_hudstains.lua' )
AddCSLuaFile( 'cl_targetid.lua' )
AddCSLuaFile( 'cl_spawnmenu.lua' )
AddCSLuaFile( 'cl_inventory.lua' )
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'cl_postprocess.lua' )
AddCSLuaFile( 'cl_scoreboard.lua' )
AddCSLuaFile( 'tables.lua' )
AddCSLuaFile( 'weather.lua' )
AddCSLuaFile( 'vgui/vgui_panelbase.lua' )
AddCSLuaFile( 'vgui/vgui_dialogue.lua' )
AddCSLuaFile( 'vgui/vgui_shopmenu.lua' )
AddCSLuaFile( 'vgui/vgui_classpicker.lua' )
AddCSLuaFile( 'vgui/vgui_zombieclasses.lua' )
AddCSLuaFile( 'vgui/vgui_itempanel.lua' )
AddCSLuaFile( 'vgui/vgui_helpmenu.lua' )
AddCSLuaFile( 'vgui/vgui_endgame.lua' )
AddCSLuaFile( 'vgui/vgui_itemdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_playerdisplay.lua' )
AddCSLuaFile( 'vgui/vgui_playerpanel.lua' )
AddCSLuaFile( 'vgui/vgui_panelsheet.lua' )
AddCSLuaFile( 'vgui/vgui_goodmodelpanel.lua' )
AddCSLuaFile( 'vgui/vgui_categorybutton.lua' )
AddCSLuaFile( 'vgui/vgui_sidebutton.lua' )
AddCSLuaFile( 'vgui/vgui_scroller.lua' )
AddCSLuaFile( 'vgui/vgui_classscout.lua' )
AddCSLuaFile( 'vgui/vgui_classcomm.lua' )
AddCSLuaFile( 'vgui/vgui_classspec.lua' )
AddCSLuaFile( 'vgui/vgui_classengi.lua' )
AddCSLuaFile( 'vgui/vgui_cheatcodes.lua' )


util.AddNetworkString( "InventorySynch" )
util.AddNetworkString( "StashSynch" )
util.AddNetworkString( "LevelSynch" )
util.AddNetworkString( "StatsSynch" )
util.AddNetworkString( "ItemPlacerSynch" )
util.AddNetworkString( "WeatherSynch" )

function GM:Initialize()
	GAMEMODE.Start = false
	GAMEMODE.WaveEnd = false
	GAMEMODE.EvacSpawned = false
	GAMEMODE.RandomLoot = {}
	GAMEMODE.PlayerIDs = {}
	GAMEMODE.Lords = {}
	GAMEMODE.Wave = 1
	GAMEMODE.Ready = {}
	GAMEMODE.TraderFinished = false
	GAMEMODE.EvacAlert = false
	GAMEMODE.WaveZombies = GAMEMODE.Wave * ( GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * team.NumPlayers( TEAM_ARMY ) )
	GAMEMODE.SpawnCounter = GAMEMODE.Wave * ( GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * team.NumPlayers( TEAM_ARMY ) )
	GAMEMODE.SpawnedZombies = 0
	SetGlobalBool( "Start", false )
	SetGlobalBool( "WaveEnd", true )
	GAMEMODE.NextWave = GAMEMODE.Wave + 1
	local total = #GAMEMODE.Waves
	SetGlobalInt( "Remaining", 0 )
	SetGlobalInt( "CurrentW", GAMEMODE.Wave )
	SetGlobalInt( "TotalW", total )
			
	GAMEMODE:WeatherInit()
	
	if math.random( 1, 10 ) == 1 then
	
		GAMEMODE.RandomEvent = CurTime() + ( 60 * math.Rand( 1.5, 3.5 ) )
	
	end
	
end

GM.Breakables = {}
GM.WoodLocations = {}
GM.NPCSpawns = {}
GM.WoodCount = 1
GM.WoodPercent = 1
GM.LordExists = false
GM.EarlyPick = false

function GM:InitPostEntity()	
	
	GAMEMODE.SpecialTrader = ents.Create( "info_trader" )
	GAMEMODE.SpecialTrader:SetSpecial( true )
	GAMEMODE.SpecialTrader:Spawn()
	
	local badshit = ents.FindByClass( "npc_*" )
	badshit = table.Add( badshit, ents.FindByClass( "weapon_*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "prop_ragdoll" ) )
	badshit = table.Add( badshit, ents.FindByClass( "item_*" ) )
	badshit = table.Add( badshit, ents.FindByClass( "point_servercommand" ) )
	badshit = table.Add( badshit, ents.FindByClass( "env_entity_maker" ) )
	badshit = table.Add( badshit, ents.FindByClass( "point_template" ) )
	badshit = table.Add( badshit, ents.FindByClass( "game_text" ) )
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		if string.find( v:GetModel(), "explosive" ) or string.find( v:GetModel(), "propane" ) or string.find( v:GetModel(), "gascan" ) or string.find( v:GetModel(), "gib" ) then
		
			table.insert( badshit, v )
		
		end
		
		local phys = v:GetPhysicsObject()
		
		if IsValid( phys ) and table.HasValue( { "wood", "wood_crate", "wood_furniture", "wood_plank", "default" }, phys:GetMaterial() ) and phys:GetMass() > 8 then
		
			table.insert( GAMEMODE.WoodLocations, { Pos = v:GetPos(), Ang = v:GetAngles(), Model = v:GetModel(), Health = v:Health() } )
			
			GAMEMODE.WoodCount = GAMEMODE.WoodCount + 1
			
			v.IsWooden = true
			
			if v:Health() == 0 then
			
				v:SetHealth( 100 )
			
			end
			
			if phys:IsAsleep() then
			
				phys:Wake()
			
			end
		
		end
	
	end
	

	for k,v in pairs( badshit ) do
	
		v:Remove()
	
	end
	
	GAMEMODE.WoodPercent = math.floor( table.Count( ents.FindByClass( "prop_phys*" ) ) * GAMEMODE.WoodPercentage )
	
	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
		
		local tbl = item.GetByModel( v:GetModel() )
		local phys = v:GetPhysicsObject()
		
		if tbl or ( IsValid( phys ) and phys:GetMass() <= 3 ) then
		
			v:Remove()
		
		end
	
	end
	
	GAMEMODE:LoadAllEnts()
	
	local tbl = ents.FindByClass( "prop_door*" )
	tbl = table.Add( tbl, ents.FindByClass( "func_breakable*" ) )
	tbl = table.Add( tbl, ents.FindByClass( "func_door*" ) )
	tbl = table.Add( tbl, ents.FindByModel( "models/props_debris/wood_board04a.mdl" ) )
	
	GAMEMODE.Breakables = tbl
	
	local num = #ents.FindByClass( "point_radiation" )
	
	if num < 5 then return end
	
	for i=1, math.floor( num * GAMEMODE.RadiationAmount ) do
	
		local rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		while !rad:IsActive() do
		
			rad = table.Random( ents.FindByClass( "point_radiation" ) )
		
		end
		
		rad:SetActive( false )
	
	end
	
end

function GM:SaveAllEnts()

	MsgN( "Saving toxsinx map config data..." )

	local enttbl = {
		info_player_zombie = {},
		info_player_army = {},
		info_traderspawn = {},
		info_lootspawn = {},
		info_npcspawn = {},
		info_evac = {},
		point_stash = {},
		point_radiation = {},
		prop_physics = {}
	}
	
	for k,v in pairs( enttbl ) do
	
		for c,d in pairs( ents.FindByClass( k ) ) do
		
			if k == "prop_physics" then
			
				if d.AdminPlaced then
				
					local phys = d:GetPhysicsObject()
					
					if IsValid( phys ) then
				
						table.insert( enttbl[k], { d:GetPos(), d:GetModel(), d:GetAngles(), phys:IsMoveable() } )
						
					end
				
				end
			
			elseif d.AdminPlaced then
		
				table.insert( enttbl[k], d:GetPos() )
				
			end
		
		end
		
	end
	
	file.Write( "toxsin-x/mapdata/" .. string.lower( game.GetMap() ) .. "_json.txt", util.TableToJSON( enttbl ) )

end

function GM:LoadAllEnts()

	MsgN( "Loading Toxsin-X map config data..." )

	local read = file.Read( "toxsin-x/mapdata/" .. string.lower( game.GetMap() ) .. "_json.txt", "DATA" )
	
	if not read then
	
		MsgN( "No map config data found for " .. game.GetMap() .. "." )
		
		return
	
	end
	
	local config = util.JSONToTable( read )
	
	if not config then 
	
		MsgN( "ERROR: Toxsin-X map config data file was empty!" ) 
		
		return 
		
	end
	
	MsgN( "Loaded Toxsin-X map config data successfully!" )
	
	for k,v in pairs( config ) do
	
		if v[1] then
		
			if k == "prop_physics" then
			
				for c,d in pairs( v ) do
				
					local function spawnent()
					
						local ent = ents.Create( k )
						ent:SetPos( d[1] )
						ent:SetModel( d[2] )
						ent:SetAngles( d[3] )
						ent:SetSkin( math.random( 0, 6 ) )
						ent:Spawn()
						ent.AdminPlaced = true
						
						local phys = ent:GetPhysicsObject()
						
						if IsValid( phys ) and not d[4] then
						
							phys:EnableMotion( false )
						
						end
						
					end
					
					timer.Simple( c * 0.1, function() spawnent() end )
					
				end
			
			else
			
				for c,d in pairs( ents.FindByClass( k ) ) do
					
					d:Remove()
					
				end

				for c,d in pairs( v ) do
				
					if k != "point_radiation" and k != "info_lootspawn" and k != "info_npcspawn" then
				
						local function spawnent()
						
							local ent = ents.Create( k )
							ent:SetPos( d )
							ent:Spawn()
							ent.AdminPlaced = true
						
						end
					
						timer.Simple( c * 0.1, function() spawnent() end )
						
					else
					
						local ent = ents.Create( k )
						ent:SetPos( d )
						ent:Spawn()
						ent.AdminPlaced = true
				
					end

				end
				
			end
			
		end
		
	end

end

function GM:AddToZombieList( ply ) 

		ply:Notice( "This does nothing for now but give you something to read.", GAMEMODE.Colors.Blue, 5 )

	end

function GM:RespawnAntidote()
	
	if IsValid( ents.FindByClass( "sent_antidote" )[1] ) and ents.FindByClass( "sent_antidote" )[1]:CuresLeft() > 0 then return end
	
	if #ents.FindByClass( "info_lootspawn" ) < 3 then return end

	local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
	local pos = ent:GetPos()
	local close = true
	
	while close do
	
		ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
		pos = ent:GetPos()
		close = false
		
		for k,v in pairs( ents.FindByClass( "sent_antidote" ) ) do
		
			if v:GetPos():Distance( pos ) < 500 then
			
				close = true
			
			end
		
		end
	
	end
	
	local ant = ents.Create( "sent_antidote" )
	ant:SetPos( pos )
	ant:Spawn()
	
	GAMEMODE.Antidote = ant
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		v:Notice( "The antidote resupply location has changed", GAMEMODE.Colors.White, 5 )
	
	end

end

function GM:SpawnEvac()

	local pos = Vector(0,0,0)

	if #ents.FindByClass( "info_evac" ) < 1 then
	
		local loot = ents.FindByClass( "info_lootspawn" )
		
		if #loot < 1 then
		
			MsgN( "ERROR: Map not configured properly." )
			
			return
		
		end
		
		local prop = table.Random( loot )
		
		pos = prop:GetPos()
	
	else
	
		local point = table.Random( ents.FindByClass( "info_evac" ) )
		pos = point:GetPos()
	
	end
	
	local evac = ents.Create( "point_evac" )
	evac:SetPos( pos )
	evac:Spawn()

end

function GM:SpawnBoss()

	local pos = Vector(0,0,0)

	if #ents.FindByClass( "info_evac" ) < 1 then
	
		local loot = ents.FindByClass( "info_lootspawn" )
		
		if #loot < 1 then
		
			MsgN( "ERROR: Map not configured properly." )
			
			return
		
		end
		
		local prop = table.Random( loot )
		
		pos = prop:GetPos()
	
	else
	
		local point = table.Random( ents.FindByClass( "info_evac" ) )
		pos = point:GetPos()
	
	end
	
	local evac = ents.Create( "npc_nb_annihilator" )
	evac:SetPos( pos )
	evac:Spawn()

end

function GM:SpawnTrader()
if GAMEMODE.Wave == #GAMEMODE.Waves then return end
	local pos = Vector(0,0,0)

	if #ents.FindByClass( "info_traderspawn" ) < 1 then
	
		local loot = ents.FindByClass( "info_evac" )
		
		if #loot < 1 then
		
			MsgN( "ERROR: Map not configured properly." )
			
			return
		
		end
		
		local prop = table.Random( loot )
		
		pos = prop:GetPos()
	
	else
	
		local point = table.Random( ents.FindByClass( "info_traderspawn" ) )
		pos = point:GetPos()
	
	end
	
	local trader = ents.Create( "sent_trader" )
	trader:SetPos( pos )
	trader:Spawn()
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	v:Notice( "The trader is open, stock up while you can", GAMEMODE.Colors.White, 7, 2 )
	v:Notice( "The location has been marked", GAMEMODE.Colors.White, 7, 4 )
		if GAMEMODE.NextWave == #GAMEMODE.Waves then
		v:Notice( "Stock up, the trader won't be coming back", GAMEMODE.Colors.White, 7, 7 )
		end
	end
end

function GM:CheckReady()
	if GAMEMODE.Start == false then
			local threshold = #player.GetAll() * ( GetConVar( "sv_toxsinx_start_percent" ):GetInt() * 0.01 )
				if #GAMEMODE.Ready > threshold then
					GAMEMODE.WaveZombies = math.Clamp( ( GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY ) + team.NumPlayers( TEAM_ZOMBIES ) + team.NumPlayers( TEAM_UNASSIGNED )) ) , 0, 60 )
					GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies
					local rtot = #GAMEMODE.Waves
					for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
					v:Notice( "The undead onslaught has begun", GAMEMODE.Colors.White, 5 )
					v:NoticeOnce( "Pressing F4 will now taunt", GAMEMODE.Colors.Blue, 7 )
					end
					SetGlobalInt( "Remaining", GAMEMODE.WaveZombies )
				GAMEMODE.Start = true
				SetGlobalBool( "Start", true )
				SetGlobalBool( "WaveEnd", false )
			end
		end
	end


function GM:SpawnCleanUp()

	local pos = Vector(0,0,0)

	if #ents.FindByClass( "info_evac" ) < 1 then
	
		local loot = ents.FindByClass( "info_lootspawn" )
		
		if #loot < 1 then
		
			MsgN( "ERROR: Map not configured properly." )
			
			return
		
		end
		
		local prop = table.Random( loot )
		
		pos = prop:GetPos()
	
	else
	
		local point = table.Random( ents.FindByClass( "info_evac" ) )
		pos = point:GetPos()
	
	end
	
	local evac = ents.Create( "point_hijack" )
	local ent1 = ents.Create( "npc_hum_blackwatch" )
	local ent2 = ents.Create( "npc_hum_blackwatch" )
	local ent3 = ents.Create( "npc_hum_blackwatch" )
	local ent4 = ents.Create( "npc_hum_blackwatch" )
	local ent5 = ents.Create( "npc_hum_blackwatch" )
	local ent6 = ents.Create( "npc_hum_blackwatch" )
	local ent7 = ents.Create( "npc_hum_blackwatch" )
	local ent8 = ents.Create( "npc_hum_blackwatch" )
	local ent9 = ents.Create( "npc_hum_blackwatch" )
	local ent10 = ents.Create( "npc_hum_blackwatch" )
	evac:SetPos( pos )
	evac:Spawn()
	ent1:SetPos( pos + Vector(0,-32,10))
	ent1:Spawn()
	ent2:SetPos( pos + Vector(32,0,10) )
	ent2:Spawn()
	ent3:SetPos( pos + Vector(-32,0,10) )
	ent3:Spawn()
	ent4:SetPos( pos + Vector(-32,32,10) )
	ent4:Spawn()
	ent5:SetPos( pos + Vector(-32,64,10) )
	ent5:Spawn()
	ent6:SetPos( pos + Vector(-32,-64,10) )
	ent6:Spawn()
	ent7:SetPos( pos + Vector(-64,32,10) )
	ent7:Spawn()
	ent8:SetPos( pos + Vector(64,32,10) )
	ent8:Spawn()
	ent9:SetPos( pos + Vector(96,32,10) )
	ent9:Spawn()
	ent10:SetPos( pos + Vector(-32,96,10) )
	ent10:Spawn()

end

function GM:GetGeneratedLoot()

	local tbl = {}

	for k,v in pairs( GAMEMODE.RandomLoot ) do
	
		if IsValid( v ) then
		
			table.insert( tbl, v )
		
		end
	
	end
	
	for k,v in pairs( GAMEMODE.RandomLoot ) do
	
		if not IsValid( v ) then
		
			table.remove( tbl, k )
			
			return tbl
		
		end
	
	end
	
	return tbl

end

function GM:LootThink()

	for k,v in pairs( ents.FindByClass( "prop_phys*" ) ) do
	
		if v.Removal and v.Removal < CurTime() and IsValid( v ) then
		
			v:Remove()
		
		end
	
	end

	if #ents.FindByClass( "info_lootspawn" ) < 10 then return end

	local amt = math.floor( GAMEMODE.MaxLoot * #ents.FindByClass( "info_lootspawn" ) )
	local total = 0
	
	local loots = GAMEMODE:GetGeneratedLoot()
	
	local num = amt - #loots
	
	if num > 0 then
	
		local tbl = { ITEM_SUPPLY, ITEM_LOOT, ITEM_AMMO, ITEM_MISC, ITEM_GUNDROPS, ITEM_EXPLOSIVE }
		local chancetbl = { 0.60,     0.70,      0.70,     0.95,          0.05,             0.10 }
		
		for i=1, num do
			
			local ent = table.Random( ents.FindByClass( "info_lootspawn" ) )
			local pos = ent:GetPos()
			local rnd = math.Rand(0,1)
			local choice = math.random( 1, table.Count( tbl ) ) 
				
			while rnd > chancetbl[ choice ] do
					
				rnd = math.Rand(0,1)
				choice = math.random( 1, table.Count( tbl ) ) 
					
			end
				
			local rand = item.RandomItem( tbl[choice] )
			local proptype = "prop_physics"
				
			if rand.TypeOverride then
				
				proptype = rand.TypeOverride
				
			end
				
			local loot = ents.Create( proptype )
			loot:SetPos( pos + Vector(0,0,5) )
			loot:SetAngles( VectorRand():Angle() )
			
			if rand.DropModel then
			
				loot:SetModel( rand.DropModel )
			
			else
			
				loot:SetModel( rand.Model )
			
			end
			
			loot:Spawn()
			loot.RandomLoot = true
			loot.IsItem = true
				
			if not rand.CollisionOverride then
				
				loot:SetCollisionGroup( COLLISION_GROUP_WEAPON )
			
			end
			
			table.insert( GAMEMODE.RandomLoot, loot )
			
		end
	
	end

end

function GM:WoodThink()

	if table.Count( GAMEMODE.WoodLocations ) < 1 then return end

	if GAMEMODE.WoodCount < GAMEMODE.WoodPercent then
	
		local tbl = table.Random( GAMEMODE.WoodLocations ) 
		local prop = ents.Create( "prop_physics" )
		prop:SetPos( tbl.Pos )
		prop:SetAngles( tbl.Ang )
		prop:SetModel( tbl.Model )
		prop:SetHealth( math.Clamp( tbl.Health, 50, 500 ) )
		prop:Spawn()
		prop.IsWooden = true
		
		GAMEMODE.WoodCount = GAMEMODE.WoodCount + 1
	
	elseif GAMEMODE.WoodCount > GAMEMODE.WoodPercent then
	
		local ent = table.Random( ents.FindByClass( "prop_phys*" ) )
		local phys = ent:GetPhysicsObject()
		
		if IsValid( phys ) and not ent.IsItem and ent.IsWooden then
		
			ent:Remove()
			
			GAMEMODE.WoodCount = GAMEMODE.WoodCount - 1
		
		end
	
	end

end

function GM:EventThink()

	if not GAMEMODE.RandomEvent then
	
		GAMEMODE.RandomEvent = CurTime() + ( 60 * math.random( 2, 7 ) )
	end
	
	if GAMEMODE.RandomEvent and GAMEMODE.RandomEvent < CurTime() then
		
		local ev = event.GetRandom()
		
		while ( ( ev.Type == EVENT_WEATHER and GAMEMODE.WeatherHappened ) or ev.Chance < math.Rand(0,1) ) do
		
			ev = event.GetRandom()
		
		end
		
		if ev.Type == EVENT_WEATHER then
		
			GAMEMODE.WeatherHappened = true
		
		end
		
		ev.Start()
	
		GAMEMODE.Event = ev
		GAMEMODE.RandomEvent = nil
	
	end
	
	if GAMEMODE.Event then
		if #ents.FindByClass( "sent_trader" ) == 1 then 
			GAMEMODE.Event:End() 
		else
			GAMEMODE.Event:Think()
			
			if GAMEMODE.Event:EndThink() then
			
				GAMEMODE.Event:End()
				GAMEMODE.Event = nil
			
			end
		end
	end

end

function GM:WaveThink()
if GAMEMODE.WaveEnd == false then
	if #ents.FindByClass( "npc_nb*" ) == 0 then
		SetGlobalInt( "Remaining", 0 )
		SetGlobalBool( "WaveEnd", true )
		GAMEMODE.WaveEnd = true
	end
else
	if GAMEMODE.Wave == #GAMEMODE.Waves and GAMEMODE.EvacSpawned == false then
		GAMEMODE:Finale()
		if #ents.FindByClass( "npc_nb_annihilator" ) < 1 then
		GAMEMODE.SpawnedZombies = 0
		GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies
		end
		GAMEMODE.WaveZombies = 999999999
		SetGlobalInt( "Remaining", GAMEMODE.WaveZombies )
	else
	
	if #ents.FindByClass( "sent_trader" ) == 0 and GAMEMODE.TraderFinished == false and GAMEMODE.WaveEnd == true then
		GAMEMODE:SpawnTrader()
	end		
		for k,v in pairs( player.GetAll() ) do
			if v:IsBot() and not v:Alive() then
				v:SetTeam( TEAM_ARMY )
				v:UnSpectate()
				v:Spawn()
			end
		end
		if #ents.FindByClass( "sent_trader" ) < 1 and GAMEMODE.TraderFinished == true then
		GAMEMODE.Wave = GAMEMODE.Wave + 1
		GAMEMODE.NextWave = GAMEMODE.Wave + 1
		GAMEMODE.SpawnedZombies = 0
		GAMEMODE.TraderFinished = false
		GAMEMODE.WaveEnd = false
		SetGlobalBool( "WaveEnd", false )
		local wave = GAMEMODE.Wave
		if wave == 2 then
			GAMEMODE.WaveZombies = math.Clamp( 20 + ( GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 80 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies
		elseif wave == 3 then
			GAMEMODE.WaveZombies = math.Clamp( (40 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 100 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies
		elseif wave == 4 then
			GAMEMODE.WaveZombies = math.Clamp( ( 50 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 120 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies		
		elseif wave == 5 then
			GAMEMODE.WaveZombies = math.Clamp( ( 60 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 120 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies		
		elseif wave == 6 then
			GAMEMODE.WaveZombies = math.Clamp( ( 70 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 120 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies		
		elseif wave == 7 then
			GAMEMODE.WaveZombies = math.Clamp( ( 80 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 120 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies		
		elseif wave == 8 then
			GAMEMODE.WaveZombies = math.Clamp( ( 100 + GetConVar( "sv_toxsinx_zombies_per_player" ):GetInt() * (team.NumPlayers( TEAM_ARMY )) ) , 0, 120 )
			GAMEMODE.SpawnCounter = GAMEMODE.WaveZombies		
		end
		for k,v in pairs( player.GetAll() ) do
			v:Notice( "New undead mutations have been spotted", GAMEMODE.Colors.White, 5 )
			v:ClientSound( table.Random( GAMEMODE.AmbientScream ) )			
		end 
		SetGlobalInt( "Remaining", GAMEMODE.WaveZombies )
		SetGlobalInt( "CurrentW", GAMEMODE.Wave)
		end
	end
end 
end

function GM:GetZombieClass()

	local rand = math.Rand(0,1)
	local class = table.Random( GAMEMODE.Waves[ GAMEMODE.Wave ] or { "npc_nb_common" } )
	if #GAMEMODE.Waves < GAMEMODE.Wave then
	class = table.Random( GAMEMODE.Waves[ 8 ] or { "npc_nb_common" } )
	end
	
	while #GAMEMODE.Waves[ GAMEMODE.Wave ] != 1 and rand > GAMEMODE.SpawnChance[ class ] do
	
		rand = math.Rand(0,1)
		if #GAMEMODE.Waves < GAMEMODE.Wave then
		class = table.Random( GAMEMODE.Waves[ 8 ] or { "npc_nb_common" } )
		else
		class = table.Random( GAMEMODE.Waves[ GAMEMODE.Wave ] or { "npc_nb_common" } )
		end
	
	end
	
	return class

end

function GM:ValidSpawns()
	if ( GAMEMODE.SpawnCheck or 0 ) < CurTime() then
		local spawns = ents.FindByClass( "info_npcspawn" )

		for k,v in pairs( spawns ) do
			for q,t in pairs( team.GetPlayers( TEAM_ARMY ) ) do
				if t:Visible( v ) then
					if table.HasValue( GAMEMODE.NPCSpawns, v ) then
					local delete = table.KeyFromValue(GAMEMODE.NPCSpawns, v)
						table.remove( GAMEMODE.NPCSpawns, delete )
					end
				else
					if not table.HasValue( GAMEMODE.NPCSpawns, v ) then
						table.insert( GAMEMODE.NPCSpawns, v )
					end
				end
			end
		end
		GAMEMODE.SpawnCheck = CurTime() + 2
	end
end

function GM:FindSpawn()
	local person = table.Random( team.GetPlayers( TEAM_ARMY ) )
	local dist = 999999
	for k,v in pairs( ( GAMEMODE.NPCSpawns or {} ) ) do
		if IsValid( person ) then
		local compare = person:GetPos():Distance( v:GetPos() )
			
		if compare < dist and not person:Visible( v ) then

			spawn = v
			dist = compare

		end
			
	end
		
	return spawn
	end
	
	
end

function GM:NPCRespawnThink()

	GAMEMODE:ValidSpawns()
	local spawn = GAMEMODE:FindSpawn()
	local v = spawn
	
	
	
		if IsValid( v ) then
	
			local box = ents.FindInBox( v:GetPos() + Vector( -32, -32, 0 ), v:GetPos() + Vector( 32, 32, 64 ) )
			local can = true
			
			for k,v in pairs( box ) do
			
				if v.NextBot then
				
					can = false
				
				end
			
			end
			
			if can and GAMEMODE.SpawnCounter > 0 and GAMEMODE.SpawnedZombies != GAMEMODE.WaveZombies and #ents.FindByClass( "npc_nb_*" ) < GetConVar( "sv_toxsinx_max_zombies" ):GetInt() then 
			
				local ent = ents.Create( GAMEMODE:GetZombieClass() )
				ent:SetPos( v:GetPos() )
				ent:Spawn()
				
				GAMEMODE.SpawnedZombies = GAMEMODE.SpawnedZombies + 1
				GAMEMODE.SpawnCounter = GAMEMODE.SpawnCounter - 1
		
			end
			
		end
		
	end

function GM:Think()
if GAMEMODE.Start == true then

	if ( GAMEMODE.NextGameThink or 0 ) < CurTime() then

		if ( GAMEMODE.NextZombieThink or 0 ) < CurTime() then
			
			GAMEMODE.NextZombieThink = CurTime() + 3
			
		end
		
		GAMEMODE:NPCRespawnThink()
		GAMEMODE:RespawnAntidote()
		GAMEMODE:EventThink()
		GAMEMODE:LootThink()
		GAMEMODE:WoodThink()
		GAMEMODE:WaveThink()
		GAMEMODE:WeatherThink()
		GAMEMODE:CheckGameOver( false )
		GAMEMODE.NextGameThink = CurTime() + 1
		
	end
	
	if GAMEMODE.Wave == #GAMEMODE.Waves and GAMEMODE.SpawnedCounter >= 10 and GAMEMODE.EvacAlert == false then
		if GetGlobalBool( "GameOver", false ) then return end
		GAMEMODE.EvacAlert = true 
			
		for k,v in pairs( player.GetAll() ) do 
			
			v:ClientSound( GAMEMODE.LastMinute ) 
			v:Notice( "The evac chopper is en route", GAMEMODE.Colors.White, 5 ) 
	
		end
	end
	else
	GAMEMODE:CheckReady()
	end
		for k,v in pairs( player.GetAll() ) do
	
		if v:Team() != TEAM_UNASSIGNED then
		
			v:Think()
		
		end
	
	end
	GAMEMODE:ValidSpawns()
end

function GM:Finale() 
		GAMEMODE.EvacSpawned = true
		if GetGlobalBool( "GameOver", false ) then return end
		SetGlobalBool( "Finale", true )
		local setter = math.random(1,4)
		if ( setter == 1 ) then
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do 
		
			v:Notice( "A VENOM helicopter intercepted the evac", GAMEMODE.Colors.Red, 5 ) 
			v:Notice( "Kill all the VENOM soldiers and steal their helicopter!", GAMEMODE.Colors.White, 5, 2 )
			v:Notice( "The location has been marked", GAMEMODE.Colors.White, 5, 4 )
			
		end 		
		GAMEMODE:SpawnCleanUp()
		
		elseif ( setter == 3 ) then
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do 
		
			v:Notice( "High priority mutation spotted in your area. We can't evac you until you take care of it", GAMEMODE.Colors.Red, 5 ) 
			v:Notice( "Kill Barthilex to call the evac", GAMEMODE.Colors.White, 5, 4 )
			
		end 		
		GAMEMODE:SpawnBoss()
		
		else
		
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do 
		
			v:Notice( "The evac chopper has arrived", GAMEMODE.Colors.White, 5 ) 
			v:Notice( "You have 45 seconds to reach the evac zone", GAMEMODE.Colors.White, 5, 2 )
			v:Notice( "The location has been marked", GAMEMODE.Colors.White, 5, 4 )
			
		end 
		
		if IsValid( GAMEMODE.Antidote ) then
									
			GAMEMODE.Antidote:SetOverride()
									
		end
		
		GAMEMODE:SpawnEvac() 
		end
end

function GM:PhysgunPickup( ply, ent )

	if ply:IsAdmin() or ply:IsSuperAdmin() then return true end

	if ent:IsPlayer() then return false end
	
	if not ent.Placer or ent.Placer != ply then return false end
	
	return true 

end

function GM:PlayerConnect( name, ip )
	PrintMessage( HUD_PRINTTALK, name.. " has joined the game." )
end

function GM:PlayerDisconnected( pl )

	if pl:Alive() then
	
		pl:DropLoot()
		
	end
	
	if not table.HasValue( GAMEMODE.PlayerIDs, pl:SteamID() ) then
	
		table.insert( GAMEMODE.PlayerIDs, pl:SteamID() )
	
	end
	
	if pl:IsLord() then
	
		GAMEMODE.LordExists = false
	
	end
	
end

function GM:PlayerInitialSpawn( pl )
	
	pl:GiveAmmo( 300, "Pistol", false )
	
	pl:SynchLevel()
	
	if pl:IsBot() then
	
		pl:SetTeam( TEAM_ARMY )
		pl:Spawn()
	
	else
		pl:SetTeam( TEAM_UNASSIGNED )
		pl:Spectate( OBS_MODE_ROAMING )
		end
		
	end

function GM:PlayerSpawn( pl )

	if pl:Team() == TEAM_UNASSIGNED then
		pl:Spectate( OBS_MODE_ROAMING )
		pl:SetPos( pl:GetPos() + Vector( 0, 0, 50 ) )
		
		return
		
	end
	GAMEMODE:RespawnAntidote()
	
	if pl:Team() == TEAM_ARMY then
	
		local music = table.Random( GAMEMODE.OpeningMusic )
	
		pl:ClientSound( music, 100 )
		pl:LoadEXPData()
		
	end
	if pl:GetPlayerClass() == CLASS_BANSHEE then
	pl:NoticeOnce( "As a zombie, you can't use or buy items", GAMEMODE.Colors.Blue, 7, 25 )
	pl:NoticeOnce( "You also cannot get infected or radiated", GAMEMODE.Colors.Blue, 7, 27 )
	pl:NoticeOnce( "You can heal yourself by absorbing your team's radiation or attacking things", GAMEMODE.Colors.Blue, 7, 29 )
	pl:NoticeOnce( "You can also consume infection with your perk's ability", GAMEMODE.Colors.Blue, 7, 31 )
	pl:NoticeOnce( "Right click to scream, damaging enemies nearby", GAMEMODE.Colors.Blue, 7, 40 )
	end
	pl:NoticeOnce( "Press F1 to view the help menu", GAMEMODE.Colors.Blue, 7, 15 )
	pl:NoticeOnce( "Press F2 to use your perk's ability", GAMEMODE.Colors.Blue, 7, 17 )
	pl:NoticeOnce( "Press F3 to activate the panic button", GAMEMODE.Colors.Blue, 7, 19 )
	pl:NoticeOnce( "Press F4 when you're ready to start the game", GAMEMODE.Colors.Blue, 7, 21 )
	pl:InitializeInventory()
	pl:OnSpawn()
	pl:OnLoadout()
	pl:SetSpec( 1 )
	pl:SetNWBool( "Raging", false )
	pl:SetNWBool( "Cloaking", false )
	pl:UnReady()

	local oldhands = pl:GetHands()
	
	if IsValid( oldhands ) then
	
		oldhands:Remove()
		
	end
	
	local hands = ents.Create( "gmod_hands" )
	
	if IsValid( hands ) then
	
		hands:DoSetup( pl )
		hands:Spawn()
		
	end	

end

function GM:PlayerSetModel( pl )

end

function GM:PlayerLoadout( pl )
	
end

function GM:PlayerJoinTeam( ply, teamid )
	
	local oldteam = ply:Team()
	
	if ply:Alive() and ply:Team() != TEAM_UNASSIGNED then return end
	
	if teamid != TEAM_UNASSIGNED and ply:Team() == TEAM_UNASSIGNED then
	
		ply:UnSpectate()
	
	end
	
	if teamid == TEAM_SPECTATOR or teamid == TEAM_UNASSIGNED then
	
		teamid = TEAM_ARMY
	
	end
	
	ply:SetTeam( teamid )
	
	if ply.NextSpawn and ply.NextSpawn > CurTime() then
	
		ply.NextSpawn = CurTime() + 5
	
	else
	
		ply:Spawn()
	
	end
	
end

function GM:PlayerSwitchFlashlight( ply, on )

	return ply:Team() == TEAM_ARMY
	
end

function GM:GetFallDamage( ply, speed )

	if ply:Team() == TEAM_ZOMBIES then
	
		return 5
	
	end

	local pain = speed * 0.12
	
	ply:AddStamina( math.floor( pain * -0.25 ) )

	return pain
	
end

function GM:PlayerDeathSound()

	return true
	
end

function GM:CanPlayerSuicide( ply )

	return false
	
end

function GM:KeyRelease( ply, key )

	if ply:Team() != TEAM_ARMY then return end

	if key == IN_JUMP then
	
		ply:AddStamina( -2 )
	
	end
	
	if key != IN_USE then return end
	
	local trace = {}
    trace.start = ply:GetShootPos()
    trace.endpos = trace.start + ply:GetAimVector() * 80
    trace.filter = ply
	
	local tr = util.TraceLine( trace )
	
	if IsValid( tr.Entity ) and tr.Entity:GetClass() == "prop_physics" then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
			return true
            
        end
        
        ply:AddToInventory( tr.Entity )
	
		return true
        
    elseif IsValid( tr.Entity ) and tr.Entity:GetClass() == "point_stash" then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
        else
           
            tr.Entity:OnUsed( ply )
            
        end
        
    elseif not IsValid( tr.Entity ) then
        
        if IsValid( ply.Stash ) then
            
            ply.Stash:OnExit( ply )
            
        end
        
    end
    
	return true

end

function GM:PropBreak( att, prop )

	local phys = prop:GetPhysicsObject()
	
	if IsValid( phys ) and prop:GetModel() != "models/props_debris/wood_board04a.mdl" then
	
		if prop.IsWooden then
		
			GAMEMODE:SpawnChunk( prop:LocalToWorld( prop:OBBCenter() ) )
			GAMEMODE.WoodCount = GAMEMODE.WoodCount - 1
		
		end
	
	end

end 

function GM:SpawnChunk( pos )

	local ent = ents.Create( "prop_physics" )
	ent:SetPos( pos )
	ent:SetModel( "models/props_debris/wood_chunk04a.mdl" )
	ent:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	ent:Spawn()
	ent.IsItem = true

end

function GM:AllowPlayerPickup( ply, ent )

	local tbl = item.GetByModel( ent:GetModel() )
	
	if tbl and tbl.AllowPickup then
	
		return true
	
	end

	return false
	
end

function GM:PlayerUse( ply, entity )

	if ply:Team() == TEAM_ARMY and ( ply.LastUse or 0 ) < CurTime() then
	
		if table.HasValue( { "sent_propane_canister", "sent_propane_tank", "sent_fuel_diesel", "sent_fuel_gas" }, entity:GetClass() ) then 
		
			ply.LastUse = CurTime() + 0.5
		
			if not IsValid( ply.HeldObject ) and not IsValid( entity.Holder ) then 
	
				ply:PickupObject( entity )
				ply.HeldObject = entity
				entity.Holder = ply
				entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				
			elseif entity == ply.HeldObject then 
			
				ply:DropObject( entity )
				ply.HeldObject = nil
				entity.Holder = nil
				entity:SetCollisionGroup( COLLISION_GROUP_NONE )
			
			end
	
		end
		
		return true
	
	end
	
	if ply:Team() != TEAM_ZOMBIES then return false end
	
	local trace = {}
    trace.start = ply:GetShootPos()
    trace.endpos = trace.start + ply:GetAimVector() * 80
    trace.filter = ply
	
	local tr = util.TraceLine( trace )
	
	if entity:GetClass() == "prop_door_rotating" or entity:GetClass() == "func_button" then

		return false
		
	end
	
	return true
	
end

function GM:EntityTakeDamage( ent, dmginfo )

	if ent.IsWooden then
	
		ent.WoodHealth = ( ent.WoodHealth or 150 ) - dmginfo:GetDamage() 
		
		if ent.WoodHealth < 1 then
		
			ent:Fire( "break", 0, 0 )
		
		end
	
	end

	if not ent:IsPlayer() and ent:IsOnFire() then
	
		ent:Extinguish()
	
	end

	if not ent:IsPlayer() and ent.IsItem then 

		dmginfo:ScaleDamage( 0 )
		
		return
		
	end
	
	local attacker = dmginfo:GetAttacker()
	
	if attacker:IsPlayer() and ent.NextBot and IsValid( attacker ) then
	
		local yes = math.Round(dmginfo:GetDamage())
		attacker:AddEXP( math.Clamp( yes, 1, 1000 ) ) 
		
	end
	
	if ent:IsPlayer() and ent:Team() == TEAM_ARMY and IsValid( attacker ) and ( attacker:IsNPC() or ( ( attacker:IsPlayer() and attacker:Team() == TEAM_ZOMBIES ) or ( attacker:IsPlayer() and attacker == ent ) ) ) then
	
		if ent:Health() <= 50 then
	
			ent:NoticeOnce( "Your health has dropped below 30%", GAMEMODE.Colors.Red, 5 )
			ent:NoticeOnce( "Health doesn't regenerate when below 30%", GAMEMODE.Colors.Blue, 5, 2 )
			
		end
	
		if dmginfo:IsDamageType( DMG_BURN ) then
	
			ent:ViewBounce( 30 )
			
		else
		
			ent:ViewBounce( 25 )
			if ent:GetPlayerClass() == CLASS_BANSHEE then
			ent:RadioSound( VO_ZRADIO )
			else
			ent:RadioSound( VO_PAIN )
			end
			ent:DrawBlood()
		
		end
		
		if ent:GetPlayerClass() == CLASS_COMMANDO then
		
			dmginfo:ScaleDamage( (GetConVar( "sv_toxsinx_dmg_scale" ):GetFloat() * 0.85) - ( 0.05 * ent:GetLevel() ) )
		
		elseif ent:GetPlayerClass() == CLASS_SCOUT then

			dmginfo:ScaleDamage( (GetConVar( "sv_toxsinx_dmg_scale" ):GetFloat() * 1.1) )
			
		else
		
			dmginfo:ScaleDamage( GetConVar( "sv_toxsinx_dmg_scale" ):GetFloat() ) 
		
		end
		
		if dmginfo:IsExplosionDamage() and attacker:Team() == TEAM_ZOMBIES then
	
			dmginfo:ScaleDamage( 0 )
	
		else
		
			ent:AddStat( "Damage", math.Round( dmginfo:GetDamage() ) )
			
			--[[if attacker:IsPlayer() then
			
				attacker:AddZedDamage( math.Round( dmginfo:GetDamage() ) )
				
			end]]
		
		end
		
	elseif ent:IsPlayer() and ent:Team() == TEAM_ZOMBIES and IsValid( attacker ) and attacker:IsPlayer() and dmginfo:GetDamage() > 30 then
	
		sound.Play( table.Random( GAMEMODE.GoreBullet ), ent:GetPos() + Vector(0,0,50), 75, math.random( 90, 110 ), 0.8 )
	
	end
	
	return self.BaseClass:EntityTakeDamage( ent, dmginfo )
	
end

function GM:ScaleNPCDamage( npc, hitgroup, dmginfo ) // obsolete!

	if hitgroup == HITGROUP_HEAD then
	
		npc:EmitSound( "Player.DamageHeadShot" )
		npc:SetHeadshotter( dmginfo:GetAttacker(), true )
		
		local effectdata = EffectData()
		effectdata:SetOrigin( dmginfo:GetDamagePosition() )
		util.Effect( "headshot", effectdata, true, true )
		
		if dmginfo:GetAttacker():IsRaging() then
		dmginfo:ScaleDamage( math.Rand( 4.50, 5.00 ) ) 
		else
		dmginfo:ScaleDamage( math.Rand( 2.50, 3.00 ) ) 		
		end
		dmginfo:GetAttacker():NoticeOnce( "Headshot combos earn you more " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Blue, 5 )
		dmginfo:GetAttacker():AddHeadshot()
		
    elseif hitgroup == HITGROUP_CHEST then
		
		if dmginfo:GetAttacker():IsRaging() then
		dmginfo:ScaleDamage( 2.75 ) 
		else
		dmginfo:ScaleDamage( 1.25 ) 
		end	
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		if dmginfo:GetAttacker():IsRaging() then
		dmginfo:ScaleDamage( 1.75 ) 
		else
		dmginfo:ScaleDamage( 0.75 ) 
		end
		
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	else
		if dmginfo:GetAttacker():IsRaging() then
		dmginfo:ScaleDamage( 1 )
		else
		dmginfo:ScaleDamage( 0.50 )
		end
		
		npc:SetHeadshotter( dmginfo:GetAttacker(), false )
		dmginfo:GetAttacker():ResetHeadshots()
		
	end
	
	return dmginfo

end 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )

	if IsValid( ply.Stash ) then
		
		return
	
	end

	if hitgroup == HITGROUP_HEAD then
	
		ply:EmitSound( "Player.DamageHeadShot" )
		ply:ViewBounce( 25 )
		
		dmginfo:ScaleDamage( 0.6 ) 
		
		return
		
    elseif hitgroup == HITGROUP_CHEST then
	
		ply:ViewBounce( 15 )
	
		dmginfo:ScaleDamage( 0.4 ) 
		
		return
		
	elseif hitgroup == HITGROUP_STOMACH then
	
		dmginfo:ScaleDamage( 0.2 ) 
		
	else
	
		dmginfo:ScaleDamage( 0.1 )
		
	end
	
	ply:ViewBounce( ( dmginfo:GetDamage() / 20 ) * 10 )

end 

function GM:PlayerShouldTakeDamage( ply, attacker )

	if ply:Team() == TEAM_UNASSIGNED then return false end
	
	if IsValid( attacker ) and attacker:IsPlayer() and attacker != ply then
	
		return ( ply:Team() != attacker:Team() or GetConVar( "sv_toxsinx_team_dmg" ):GetBool() ) 
	
	end

	return true
	
end

function GM:OnDamagedByExplosion( ply, dmginfo )

	if dmginfo:GetDamage() > 25 then
	
		ply:SetBleeding( true )
		
	end

	ply:SetDSP( 35, false )
	
	umsg.Start( "GrenadeHit", ply )
	umsg.End()
	
end

function GM:PlayerDeathThink( ply )

	if GAMEMODE.Start == true and not GAMEMODE.WaveEnd then 
	
	function SpecNext( ply )
        local players = player.GetAll()
       
        for f, v in pairs(players) do
                if v==ply then players[f]=nil end
				if v:Team() == TEAM_ZOMBIES then players[f]=nil end
        end
       
        local nextPerson = table.FindNext( players, ply:GetObserverTarget() )
       
        if nextPerson == ply:GetObserverTarget() then
                ply:Spectate( OBS_MODE_ROAMING )
        else
                ply:StripWeapons()
                ply:Spectate(OBS_MODE_CHASE)
                ply:SpectateEntity(nextPerson)
        end
       
end
 
function IfPlayerLeaves( ply )
        for f, v in pairs(player.GetAll()) do
                if v:GetObserverTarget() == ply then
                        SpecNext( v )
                end
        end
end
hook.Add( "PlayerDisconnected", "playerdisconnected", IfPlayerLeaves )
 
function KeyPressed(ply, key)
        if ply:GetObserverTarget() != nil then
                if key == IN_ATTACK2 then
                        if ply:GetObserverMode() == OBS_MODE_ROAMING then
                                ply:Spectate(OBS_MODE_CHASE)
                        elseif ply:GetObserverMode() == OBS_MODE_CHASE then
                                ply:Spectate(OBS_MODE_IN_EYE)
						elseif ply:GetObserverMode() == OBS_MODE_IN_EYE then
								ply:Spectate( OBS_MODE_ROAMING )
                        end
                elseif key == IN_ATTACK then
                        SpecNext( ply )
                end
        end
       
        if key == IN_ATTACK2 then
                if ply:GetObserverMode() == OBS_MODE_ROAMING then
                        ply:Spectate( OBS_MODE_CHASE )
                end
        end
end
 
hook.Add( "KeyPress", "KeyPressedHook", KeyPressed ) end

if ( GAMEMODE.Start == false or GAMEMODE.WaveEnd ) and GAMEMODE.EvacAlert == false and #ents.FindByClass( "point_evac" ) < 1 and #ents.FindByClass( "point_hijack" ) < 1 and #ents.FindByClass( "npc_nb_annihilator" ) < 1 then 
	if ply:KeyDown( IN_JUMP ) then
			ply:SetTeam( TEAM_ARMY )
			ply:UnSpectate() 
			ply:Spawn()
		
	end end end
	

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	ply:OnDeath()

	if ply:Team() == TEAM_ARMY then
	
		if team.NumPlayers( TEAM_ZOMBIES ) < 1 then
		
			ply:AddStat( "Martyr" )
		
		end
	
		local music = table.Random( GAMEMODE.DeathMusic )
		
		ply:ClientSound( music, 100 )
		ply:RadioSound( VO_DEATH )
		ply:SetTeam( TEAM_ZOMBIES )
		ply:Spectate( OBS_MODE_CHASE )
		ply:SpectateEntity( ent )
		for k,v in pairs( team.GetPlayers( TEAM_ARMY) ) do
			v:Notice( ply:Nick() .. " has been mauled to death", GAMEMODE.Colors.Red )
		end
		ply:Notice( "You died! Try to be more careful next time.", GAMEMODE.Colors.Red, 5, 2 )
		ply:Notice( "Use Primary Fire to change players, alternate fire to change views.", GAMEMODE.Colors.White, 5, 2 )
				
		if IsValid( attacker ) and attacker:IsPlayer() and attacker != ply then
		
			attacker:AddZedDamage( 50 )
		
		end
	
	elseif ply:Team() == TEAM_ZOMBIES then

		if IsValid( attacker ) and attacker:IsPlayer() then
	
			attacker:AddCash( GAMEMODE.PlayerZombieKillValue )
			attacker:AddFrags( 1 )
			
		end
		
		if ply:IsLord() and ply:GetZedDamage() >= GAMEMODE.RedemptionDamage then
		
			ply:SetTeam( TEAM_ARMY )
			ply:Notice( "Prepare to respawn as a human", GAMEMODE.Colors.Blue, 5, 2 )
		
		end
	
	end

	if dmginfo:IsExplosionDamage() then
	
		ply:SetModel( table.Random( GAMEMODE.Corpses ) )
		
		local ed = EffectData()
		ed:SetOrigin( ply:GetPos() )
		util.Effect( "gore_explosion", ed, true, true )
	
	end
	
	ply:CreateRagdoll()
	
end

function GM:SynchStats()

	net.Start( "StatsSynch" )
	net.WriteInt( table.Count( player.GetAll() ), 8 )

	for k,v in pairs( player.GetAll() ) do
	
		net.WriteEntity( v )
		net.WriteTable( v:GetStats() )
	
	end
	
	net.Broadcast()

end

function GM:EndGame( winner )

	GAMEMODE:SynchStats()

	SetGlobalBool( "GameOver", true )
	SetGlobalInt( "WinningTeam", winner )
	
	for k,v in pairs( player.GetAll() ) do
	
		if winner == TEAM_ZOMBIES then
		
			v:NoticeOnce( "The undead have overwhelmed " .. team.GetName( TEAM_ARMY ) , GAMEMODE.Colors.White, 7, 2 )
		
		elseif team.NumPlayers( TEAM_ARMY ) > 0 then
		
			v:NoticeOnce( team.GetName( TEAM_ARMY ) .. " has successfully evacuated", GAMEMODE.Colors.White, 7, 2 )
		
		end
	
		if v:Team() == winner and winner == TEAM_ARMY then
		
			local music = table.Random( GAMEMODE.WinMusic )
		
			v:ClientSound( music, 100 )
			v:GodEnable()
			
		else
		
			local music = table.Random( GAMEMODE.LoseMusic )
		
			v:ClientSound( music, 100 )
			
		end
		
		v:NoticeOnce( "Next map: " .. game.GetMapNext() , GAMEMODE.Colors.White, 7, 4 )
	
	end
	
	timer.Simple( GetConVar( "sv_toxsinx_post_game_time" ):GetInt(), function() game.LoadNextMap() end )
	
	for k,v in pairs( player.GetAll() ) do
		v:SaveEXPData()
	end

end

function GM:CheckGameOver( canend )

	if GetGlobalBool( "GameOver", false ) then return end
	
	local i = 0;

	for k, v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	if ( IsValid( v ) and v:Alive() ) then
		i = i + 1;
	end
end
	
	if i < 1 then
	
		GAMEMODE:EndGame( TEAM_ZOMBIES )
	
	elseif GAMEMODE.Wave == #GAMEMODE.Waves and canend then
	
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
			if not v:IsEvacuated() then
			
				v:Notice( "The evac chopper left without you", GAMEMODE.Colors.Red, 5 )
				v:SetTeam( TEAM_ZOMBIES )
			 
			end
		
		end
	
		GAMEMODE:EndGame( TEAM_ARMY )
	
	end

end 

function GM:ShowHelp( ply )

	ply:SendLua( "GAMEMODE:ShowHelp()" ) 

end

function GM:ShowTeam( ply )


	if not ply:Alive() then
	
		ply:Notice( "What is a dead guy supposed to do?", GAMEMODE.Colors.Red )
		ply:ClientSound( "items/suitchargeno1.wav" )
		
		return
	
	else
	
	if ply:GetPlayerClass() == CLASS_SPECIALIST then
	
	if not ply:Alive() then return end
	
	
			if IsValid( ply.Stash ) then
			
				GAMEMODE.SpecialTrader:OnExit( ply )
			
			else
		
				GAMEMODE.SpecialTrader:OnUsed( ply )
				
			end
			
		
		end
		
	if ply:GetPlayerClass() == CLASS_SCOUT then
		if ply:GetSpec() == 1 then
			counter = CurTime() + (40 - ( 4 * ply:GetLevel() ) )
			ply:SetNWBool( "Cloaking", true )
			ply:SetSpec( 0 )
			ply:SetMaterial( "models/shadertest/shader3" )
			ply:Notice( "Cloak Module activated", GAMEMODE.Colors.Green			)	
			ply:ClientSound( "buttons/combine_button1.wav" )
			timer.Simple( 10, function()
			if ply:Alive() then
			ply:Notice( "Cloak Module ran out of energy", GAMEMODE.Colors.Red )
			ply:SetMaterial( "" )
			ply:ClientSound( "buttons/combine_button_locked.wav" )
			end
			ply:SetNWBool( "Cloaking", false )
			end)
			timer.Simple( 40 - ( 4 * ply:GetLevel() ), function()
			if ply:Alive() then
			ply:SetSpec( 1 )
			ply:Notice( "Cloak Module ready to activate", GAMEMODE.Colors.Green )
			ply:ClientSound( "items/suitchargeok1.wav" )
			end
			counter = 0
			timeleft = 0
			end)
		else
			timeleft = math.Round(counter - CurTime())
			ply:Notice( "Cloak Module ready in " .. timeleft .. " seconds", GAMEMODE.Colors.Red )
			ply:ClientSound( "items/suitchargeno1.wav" )
		end
	end
	
	if ply:GetPlayerClass() == CLASS_COMMANDO then
		if ply:GetSpec() == 1 then
			counter = CurTime() + (40 - ( 4 * ply:GetLevel() ) )
			ply:SetNWBool( "Raging", true )
			ply:SetSpec( 0 )
			ply:Notice( "Your blood is boiling!", GAMEMODE.Colors.Green )
			timer.Create( "IT BURNS", 2, 4, function() ply:ClientSound( "player/pl_burnpain3.wav" ) end)
			ply:SetBleeding( false )	
			timer.Simple( 10, function()
			ply:Notice( "Your blood settles down", GAMEMODE.Colors.Red )
			ply:SetNWBool( "Raging", false )
			ply:ClientSound( "player/pl_pain5.wav" )
			end)
			timer.Simple( 40 - ( 4 * ply:GetLevel() ), function()
			ply:SetSpec( 1 )
			ply:Notice( "Blood Rage is recharged", GAMEMODE.Colors.Green )
			ply:ClientSound( "items/suitchargeok1.wav" )
			counter = 0
			timeleft = 0
			end)
		
		else
			timeleft = math.Round(counter - CurTime())
			ply:Notice( "Blood Rage ready in " .. timeleft .. " seconds", GAMEMODE.Colors.Red )
			ply:ClientSound( "items/suitchargeno1.wav" )
		end
	end
	
	if ply:GetPlayerClass() == CLASS_ENGINEER then
		if ply:GetSpec() == 1 then

			local dispenser = ents.Create( "engi_dispenser" )
			dispenser:SetPos( ply:GetPos() )
			dispenser:SetOwner( ply )
			dispenser:Spawn()
			ply:Notice( "Deployed a Health Dispenser", GAMEMODE.Colors.White )
			ply:SetSpec( 0 )
			counter = CurTime() + (45 - ( 4.5 * ply:GetLevel() ) )
			timer.Simple( 45 - ( 4.5 * ply:GetLevel() ), function()
			ply:SetSpec( 1 )
			ply:Notice( "Health Dispenser ready for deployment", GAMEMODE.Colors.Green )
			ply:ClientSound( "items/suitchargeok1.wav" )
			end)
		
		else
			timeleft = math.Round(counter - CurTime())
			ply:Notice( "Health Dispenser ready in " .. timeleft .. " seconds", GAMEMODE.Colors.Red )
			ply:ClientSound( "items/suitchargeno1.wav" )
		end
	end
	
		if ply:GetPlayerClass() == CLASS_BANSHEE then
		if ply:GetSpec() == 1 then
			ply:ClientSound( "npc/headcrab_poison/ph_scream1.wav" )
			ply:Notice( "You have consumed any nearby infections", GAMEMODE.Colors.White )
			ply:SetSpec( 0 )
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
			local dist = v:GetPos():Distance( ply:GetPos() )
			
			if dist <= 200 then
				v:SetInfected( false )
				ply:AddEXP( 200 )
				end
				end
			counter = CurTime() + 40
			timer.Simple( 40, function()
			ply:SetSpec( 1 )
			ply:Notice( "Consume is ready for use", GAMEMODE.Colors.Green )
			ply:ClientSound( "items/suitchargeok1.wav" )
			end)
		
		else
			timeleft = math.Round(counter - CurTime())
			ply:Notice( "Consume is ready in " .. timeleft .. " seconds", GAMEMODE.Colors.Red )
			ply:ClientSound( "items/suitchargeno1.wav" )
		end
	end
	end
	end

function GM:ShowSpare1( ply )
	if not ply:Alive() then
	
		ply:Notice( "The dead doesn't panic", GAMEMODE.Colors.Red )
		ply:ClientSound( "items/suitchargeno1.wav" )
	else
	GAMEMODE:PanicButton( ply )
	end
end

function GM:ShowSpare2( ply )
	if not ply:Alive() then
	
		ply:Notice( "Dead guys can't taunt", GAMEMODE.Colors.Red )
		ply:ClientSound( "items/suitchargeno1.wav" )
	else
		if GAMEMODE.Start == false then
			if	ply:IsReady() == false then
					ply:Ready()
					ply:Notice( "You have been set to READY", GAMEMODE.Colors.White )
					table.insert( GAMEMODE.Ready, ply )
			else
					ply:UnReady()
					ply:Notice( "You have been set to NOT READY", GAMEMODE.Colors.White )
					local clear = table.KeyFromValue(GAMEMODE.Ready, ply)
					table.remove( GAMEMODE.Ready, clear )
				end
		else
			if ply:GetPlayerClass() == CLASS_BANSHEE then
				ply:RadioSound( VO_ZRADIO )
			else
				ply:RadioSound( VO_FUCK )
			end
		end
	end
end

function GM:PanicButton( ply )
		if ply:GetPlayerClass() == CLASS_BANSHEE then
			ply:Notice( "Zombies don't panic", GAMEMODE.Colors.Red )
			ply:ClientSound( "items/suitchargeno1.wav" )
		else
	if ( ply.Panic or 0 ) > CurTime() or ply:Team() == TEAM_ZOMBIES then return end
	
	ply.Panic = CurTime() + 0.5

	local panic = { { ply:IsBleeding(), { "Bandage", "Advanced Bandage" }, "bleeding" },
	{ ply:GetRadiation() > 0, { "Vodka", "Moonshine Vodka", "Anti-Rad" }, "irradiated" },
	{ ply:Health() < 50, { "Advanced Medikit", "Basic Medikit", "Canned Food", "Military Medikit", "Specialized Medikit" }, "severely wounded" },
	{ ply:Health() < 100, { "Advanced Medikit", "Basic Medikit", "Canned Food", "Military Medikit" }, "wounded" },
	{ ply:GetStamina() < 100, { "Energy Drink", "Adrenaline Drink" }, "fatigued" },
	{ ply:GetStamina() < 100, { "Water" }, "fatigued" } }
	
	for k,v in pairs( panic ) do
	
		if v[1] then
		
			for c,d in pairs( v[2] ) do
			
				local tbl = item.GetByName( d )
			
				if tbl and ply:HasItem( tbl.ID ) then
                
					tbl.Functions[ 1 ]( ply, tbl.ID )
					
					ply:Notice( "Panic button detected that you were " .. v[3], GAMEMODE.Colors.Blue )
					
					return

				end
			
			end
		
		end
	
	end
	
	ply:Notice( "Panic button did not detect any usable items", GAMEMODE.Colors.Red )
	ply:ClientSound( "items/suitchargeno1.wav" )
end
end

function DropItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
	
		if ply:HasItem( id ) then
		
			local makeprop = true
		
			if tbl.DropFunction then
			
				makeprop = tbl.DropFunction( ply, id, true )
			
			end
			
			if makeprop then
		
				local prop = ents.Create( "prop_physics" )
				prop:SetPos( ply:GetItemDropPos() )
				prop:SetAngles( ply:GetAimVector():Angle() )
				
				if tbl.DropModel then
			
					prop:SetModel( tbl.DropModel )
				
				else
				
					prop:SetModel( tbl.Model )
				
				end
				
				prop:SetCollisionGroup( COLLISION_GROUP_WEAPON )
				prop:Spawn()
				prop.IsItem = true
				prop.Removal = CurTime() + 5 * 60
				
			end
			
			ply:RemoveFromInventory( id, true )
			ply:EmitSound( Sound( "items/ammopickup.wav" ) )
		
		end
		
		return
	
	end
	
	local itemcount = math.min( ply:GetItemCount( id ), count )
	local loot = ents.Create( "sent_lootbag" )
	
	for i=1, itemcount do
	
		loot:AddItem( id )
	
	end
	
	loot:SetAngles( ply:GetAimVector():Angle() )
	loot:SetPos( ply:GetItemDropPos() )
	loot:SetRemoval( 60 * 5 )
	loot:Spawn()
	//loot:SetUser( ply ) 
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveMultipleFromInventory( loot:GetItems() )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_drop", DropItem )

function UseItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local pos = tonumber( args[2] )
	
	if ply:HasItem( id ) then
	
		local tbl = item.GetByID( id )
		
		if not tbl.Functions[pos] then return end
		
		tbl.Functions[pos]( ply, id )
	
	end

end

concommand.Add( "inv_action", UseItem )

function TakeItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not table.HasValue( ply.Stash:GetItems(), id ) or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then
		
		ply:AddIDToInventory( id )
		ply.Stash:RemoveItem( id )
		
		return
	
	end
	
	local items = {}
	
	if IsValid( ply.Stash ) then
	
		for i=1, count do
	
			if table.HasValue( ply.Stash:GetItems(), id ) then
			
				table.insert( items, id )
				ply.Stash:RemoveItem( id )
			
			end
			
		end
		
		ply:AddMultipleToInventory( items )
		ply:EmitSound( Sound( "items/itempickup.wav" ) )
	
	end

end

concommand.Add( "inv_take", TakeItem )

function StoreItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = math.Clamp( tonumber( args[2] ), 1, 100 )
	
	if not IsValid( ply.Stash ) or not ply:HasItem( id ) then return end
	
	local tbl = item.GetByID( id )
	
	if count == 1 then

		ply.Stash:AddItem( id )
		
		ply:RemoveFromInventory( id )
		ply:EmitSound( Sound( "c4.disarmfinish" ) )
		
		if tbl.DropFunction then
			
			tbl.DropFunction( ply, id )
			
		end
		
		return
	
	end
	
	local items = {}
	
	for i=1, count do
	
		if ply:HasItem( id ) then
	
			table.insert( items, id )
			ply.Stash:AddItem( id )
			
		end
	
	end
	
	ply:RemoveMultipleFromInventory( items )
	ply:EmitSound( Sound( "c4.disarmfinish" ) )
	
	if tbl.DropFunction then
		
		tbl.DropFunction( ply, id )
		
	end

end

concommand.Add( "inv_store", StoreItem )

function SellbackItem( ply, cmd, args )

	if not IsValid( ply ) then return end

	local id = tonumber( args[1] )
	
	if not table.HasValue( ply:GetShipment(), id ) then return end
	
	local tbl = item.GetByID( id )

	ply:AddCash( tbl.Price )
	ply:RemoveFromShipment( id )

end

concommand.Add( "inv_refund", SellbackItem )

function SellItem( ply, cmd, args )
	if #ents.FindByClass( "sent_trader" ) == 1 then
		local ent = table.Random( ents.FindByClass( "sent_trader" ) )
		local dista = ent:GetPos()
		local count = math.Clamp( tonumber( args[2] ), 1, 100 )
		
		if not IsValid( ply ) then return end

		local id = tonumber( args[1] )
		
		if ply:GetPos():Distance( dista ) >= 150 then 
			ply:Notice( "Too far from the trader!", GAMEMODE.Colors.Red ) 
			ply:ClientSound( "items/suitchargeno1.wav" )
			return 
		end
	
		local itemcount = math.min( ply:GetItemCount( id ), count )
		local totalcash = 0
		local sell = ents.Create( "sent_lootbag" )
	
		for i=1, itemcount do
			local tbl = item.GetByID( id )
			if ply:GetPlayerClass() != CLASS_SPECIALIST then
			totalcash = totalcash + ( tbl.Price * 0.60 )
			else
			totalcash = totalcash + ( tbl.Price * ( 0.70 + ( ply:GetLevel() * 0.05)) )
			end
			sell:AddItem( id )
		end

		ply:AddCash( math.Round( totalcash ) )
		ply:RemoveMultipleFromInventory( sell:GetItems() )
		sell:Remove()		
		local tbl = item.GetByID( id )
		if not ply:HasItem( id ) and tbl.Weapon then
		ply:StripWeapon( tbl.Weapon )
		end
		ply:EmitSound( Sound( "c4.disarmfinish" ) )
	else
		ply:Notice( "You can only sell items to the Trader!", GAMEMODE.Colors.Red ) 	
		ply:ClientSound( "items/suitchargeno1.wav" )
	end
end

concommand.Add( "inv_sell", SellItem )

function OrderShipment( ply, cmd, args )

	ply:SendShipment()

end

concommand.Add( "ordershipment", OrderShipment )

function TraderClosePly( ply, cmd, args )

	ply:ToggleStashMenu( ply, false, "StoreMenu" )

end

concommand.Add( "closetrader", TraderClosePly )

function BuyItem( ply, cmd, args )

	local id = tonumber( args[1] )
	local count = tonumber( args[2] )
	
	if not IsValid( ply.Stash ) or not ply.Stash:GetClass() == "info_trader" or not table.HasValue( ply.Stash:GetItems(), id ) or count < 0 then return end
	
	local tbl = item.GetByID( id )
	local setprice = tbl.Price
	
	if setprice > ply:GetCash() then 
		
		return 
		
	end 
	
	if setprice > ply:GetStat( "Pricey" ) then
	
		ply:SetStat( "Pricey", setprice )
	
	end
	
	if count == 1 then
		
		ply:AddToShipment( { id } )
		ply:AddCash( -setprice )
		
		return
	
	end
	
	if ( setprice * count ) > ply:GetCash() then 
		
		return 
		
	end 
	
	local items = {}
	
	for i=1, count do
		
		table.insert( items, id )
	
	end
	
	ply:AddToShipment( items )
	ply:AddCash( -setprice * count )
	
end

concommand.Add( "inv_buy", BuyItem )

function DropCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if amt > ply:GetCash() or amt < 5 then return end
	
	ply:AddCash( -amt )
	
	local money = ents.Create( "sent_cash" )
	money:SetPos( ply:GetItemDropPos() )
	money:Spawn()
	money:SetCash( amt )

end

concommand.Add( "cash_drop", DropCash )

function StashCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( -amt )
	ply:SynchCash( ply.Stash:GetCash() + amt )
	ply.Stash:SetCash( ply.Stash:GetCash() + amt )

end

concommand.Add( "cash_stash", StashCash )

function TakeCash( ply, cmd, args )

	local amt = tonumber( args[1] )
	
	if not IsValid( ply.Stash ) or amt > ply.Stash:GetCash() or amt < 5 or string.find( ply.Stash:GetClass(), "npc" ) then return end
	
	ply:AddCash( amt )
	ply:SynchCash( ply.Stash:GetCash() - amt )
	ply.Stash:SetCash( ply.Stash:GetCash() - amt )

end

concommand.Add( "cash_take", TakeCash )

function SetPlyClass( ply, cmd, args )

	local class = tonumber( args[1] )
	
	if not GAMEMODE.ClassLogos[ class ] then return end
	
	if ply:Team() == TEAM_ARMY and ply:Alive() then return end
	
		ply:SetPlayerClass( class )
	
end

concommand.Add( "changeclass", SetPlyClass )

function SaveGameItems( ply, cmd, args )

	if ( !ply:IsAdmin() or !ply:IsSuperAdmin() ) then return end
	
	GAMEMODE:SaveAllEnts()
	
end

concommand.Add( "sv_toxsinx_save_map_config", SaveGameItems )

function NavMesher( ply, cmd, args )

	if ( !ply:IsAdmin() or !ply:IsSuperAdmin() ) then return end
	
	navmesh.BeginGeneration()
	
end

concommand.Add( "sv_toxsinx_generate_navmesh", NavMesher )

function MapSetupMode( ply, cmd, args )

	if not IsValid( ply ) then 
	
		for k, ply in pairs( player.GetAll() ) do
		
			if ply:IsAdmin() or ply:IsSuperAdmin() then
	
				ply:Give( "rad_itemplacer" )
				ply:Give( "rad_propplacer" )
				ply:Give( "weapon_physgun" )
			
			end
		
		end
		
		return
		
	end

	if ply:IsAdmin() or ply:IsSuperAdmin() then
	
		ply:Give( "rad_itemplacer" )
		ply:Give( "rad_propplacer" )
		ply:Give( "weapon_physgun" )
		ply:AddCash( 500 )
	
	end

end

concommand.Add( "sv_toxsinx_dev_mode", MapSetupMode )

function ItemListing( ply, cmd, args )

	if IsValid( ply ) and ply:IsAdmin() then
	
		local itemlist = item.GetList()
		
		for k,v in pairs( itemlist ) do
		
			print( v.ID .. ": " .. v.Name )
		
		end
	
	end

end

concommand.Add( "sv_toxsinx_dev_itemlist", ItemListing )

function DebugTable( ply, cmd, args )

PrintTable( GAMEMODE.NPCSpawns )

end

concommand.Add( "toxsinx_showspawns", DebugTable )

function TestItem( ply, cmd, args )

	if IsValid( ply ) and ply:IsAdmin() then
	
		local id = tonumber( args[1] )
		local tbl = item.GetByID( id )
		
		if tbl then
		
			ply:AddIDToInventory( id )
		
		end
	
	end

end

concommand.Add( "sv_toxsinx_dev_give", TestItem )