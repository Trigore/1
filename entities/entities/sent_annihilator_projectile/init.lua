
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "physics/glass/glass_bottle_break1.wav" )
ENT.DieSound = Sound( "ambient/fire/ignite.wav" )
ENT.Damage = 200
ENT.Radius = 400
ENT.Speed = 10000

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/props_junk/watermelon01.mdl" ) )
	self.Entity:SetMaterial( "models/flesh" )
	self.Entity:SetColor( Color( 127,0,0,255 ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 5 )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * self.Speed )
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Explode()

	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 150 then
		
			v:TakeDamage( 40, self.Entity )
			v:SetInfected( true )
			
			umsg.Start( "Drunk", v )
			umsg.Short( 2 )
			umsg.End()
		
		end
	
	end

	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "puke_spray", ed, true, true )
	
	local snd = table.Random( GAMEMODE.GoreSplash )
	self.Entity:EmitSound( snd, 90, math.random( 90, 110 ) )
	self.Entity:Remove()

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
		self.Entity:EmitSound( self.HitSound, 50, math.random(120,140) )
		self.Entity:Explode()
	
end

