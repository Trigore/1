
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ExplodeSound = { 1, 2, 4, 5, 6, 8 }
ENT.Trigger = Sound( "physics/glass/glass_bottle_break2.wav" )
ENT.BeepSound = Sound( "UI/buttonclick.wav" )
ENT.Emitting = Sound( "weapons/bugbait/bugbait_impact1.wav" )
ENT.Triggered = false
ENT.Damage = 5
ENT.DieTime = CurTime() + 999999999
ENT.Beep = CurTime() + 1
ENT.Distance = 100

function ENT:Initialize()

	self.Entity:SetModel( "models/healthvial.mdl" )	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )

	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()

	if self.DieTime < CurTime() then
	
		self.Entity:Remove()
	
	end

	for k,g in pairs( ents.FindByClass( "npc_*") ) do
			if g:GetClass() == "npc_nb_annihilator" then return end
			local dist = g:GetPos():Distance( self.Entity:GetPos() )
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
		
			if dist < ( self.Distance ) then
			if self.Triggered == false then
			if g:GetClass() == "npc_scientist" then return end
			self:EmitSound( self.Trigger )
			self.DieTime = CurTime() + (5 * (1 + (0.01 * self.Owner:GetLevel())))
			self:EmitSound( self.Emitting )
			self.Triggered = true
			end 
			g:SetHealth(g:Health() * 0.05)
	end
	end

	if self.Beep < CurTime() and self.Triggered == false then
	
		self.Beep = CurTime() + 1
		
		self.Entity:EmitSound( self.BeepSound, 100, 120 )
	
	end
	
end

function ENT:OnRemove()
local ed = EffectData()
ed:SetOrigin( self.Entity:GetPos() )
util.Effect("Explosion", ed)
end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end
