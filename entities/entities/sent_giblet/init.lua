
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.HitSound = Sound( "physics/flesh/flesh_bloody_break.wav" )
ENT.Damage = 250
ENT.Radius = 300
ENT.Speed = 6000

function ENT:Initialize()

	self.Entity:SetModel( Model( "models/weapons/w_eq_fraggrenade_thrown.mdl") )
	self.Entity:SetMaterial( "models/flesh" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Entity:DrawShadow( false )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 5 )
		phys:ApplyForceCenter( self.Entity:GetAngles():Forward() * self.Speed )
	
	end
	
	self.Delay = CurTime() + 3.5
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
	if data.HitEntity:IsPlayer() then
		data.HitEntity:TakeDamage( 10 )
		data.HitEntity:SetInfected( true )
	end
		
	self:Remove()
	
end

