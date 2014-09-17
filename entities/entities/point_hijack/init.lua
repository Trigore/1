
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Heli = Sound( "ambient/machines/heli_pass2.wav" )

ENT.EvacDist = 700
ENT.Dying = false

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetTrigger( true )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	self.Entity:PhysicsInitBox( Vector( -150, -150, -150 ), Vector( 150, 150, 150 ) )
	
	self.DieTime = CurTime() + 9999999999
	self.SoundTime = CurTime() + 9999999
	
	self.Players = {}
	
	local flare = ents.Create( "sent_hijackflare" )
	flare:SetPos( self.Entity:GetPos() )
	flare:Spawn()
	
	self.Entity:EmitSound( self.Heli, 150 )
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,10)
	trace.endpos = trace.start + Vector(0,0,800)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if tr.HitPos:Distance( self.Entity:GetPos() ) < 400 then return end
	
	local heli = ents.Create( "prop_dynamic" )
	heli:SetModel( "models/cihan_helicopter.mdl" )
	heli:SetPos( tr.HitPos + Vector(0,0,-150) )
	heli:Spawn()
	heli:Fire( "SetAnimation", "idle", 1 )
	
end

function ENT:Think()
	
	if self.Dying == true then
		if self.DieTime < CurTime() then
	
		self.Entity:Evac()
		self.Entity:Remove()
		GAMEMODE:CheckGameOver( true )
		
		for k,v in pairs( team.GetPlayers( TEAM_ZOMBIES ) ) do
		
			v:Notice( "The chopper has left the evac zone", GAMEMODE.Colors.White, 5 )
		
		end
		
	end
	else
	if self.SoundTime and self.SoundTime < CurTime() then
	
		self.Entity:EmitSound( self.Heli, 150 )
		
		self.SoundTime = nil
	
	end
	
self:CheckEndgame() end end



function ENT:CheckEndgame()
	if #ents.FindByClass( "npc_hum_blackwatch" ) == 0 then 
	self:Destruct()
	self.Dying = true
	else
	end
	end
	
function ENT:Destruct()
	self.DieTime = CurTime() + 45
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "All VENOM soldiers have been eliminated", GAMEMODE.Colors.White, 5 )
		v:Notice( "You have 45 seconds to get to the evac zone", GAMEMODE.Colors.White, 5 )
		
	end
end

function ENT:Evac()

	for k,v in pairs( self.Players ) do
	
		if IsValid( v ) and v:Alive() and v:Team() == TEAM_ARMY and v:GetPos():Distance( self.Entity:GetPos() ) < self.EvacDist and #ents.FindByClass( "npc_hum_blackwatch" ) < 1 then
		
			v:Evac()
		
		end
	
	end

end

function ENT:Touch( ent ) 

	if not ent:IsPlayer() then return end
	
	if ent:Team() != TEAM_ARMY then return end
	
	if table.HasValue( self.Players, ent ) then return end
	
	table.insert( self.Players, ent )
	
	if #ents.FindByClass( "npc_hum_blackwatch" ) > 0 then 
		ent:Notice( "There are still VENOM soldiers around", GAMEMODE.Colors.Red, 5 ) return end
	
	if not self.FirstEvac then
	
		self.FirstEvac = true
		
		ent:AddStat( "Evac" )
	
	end
	
	ent:Notice( "You made it to the evac zone", GAMEMODE.Colors.Green, 5 )
	ent:Notice( "The helicopter will take off shortly", GAMEMODE.Colors.Blue, 5, 2 )
	
end 

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
