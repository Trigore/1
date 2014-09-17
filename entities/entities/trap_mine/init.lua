
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Trigger = Sound( "weapons/c4/c4_exp_deb2.wav" )
ENT.BeepSound = Sound( "npc/roller/mine/combine_mine_deploy1.wav" )
ENT.Triggered = false
ENT.Beep = CurTime() + 1
ENT.Damage = 100
ENT.Radius = 200
ENT.Distance = 150

function ENT:Initialize()

	self.Entity:SetModel( "models/props_combine/combine_mine01.mdl" )	
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

	if self.Triggered == true then
	
		self.Entity:Remove()
	
	end

	for k,g in pairs( ents.FindByClass( "npc_*") ) do
	
			local dist = g:GetPos():Distance( self.Entity:GetPos() )
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
		
			if dist < ( self.Distance ) then
			if self.Triggered == false then
			if g:GetClass() == "npc_scientist" then return 
			else
			self:EmitSound( self.Trigger )
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "Explosion", ed, true, true )
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,20)
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )

	if tr.HitWorld then
	
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetMagnitude( 0.8 )
		util.Effect( "smoke_crater", ed, true, true )
		
		util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
	end
		util.BlastDamage( self.Entity, self.Entity, self.Entity:GetPos(), (self.Radius * (1 + (0.01 * self.Owner:GetLevel()))), ( self.Damage * (1 + (0.01 * self.Owner:GetLevel()))))
			end end
			self.Triggered = true
	end
	end

	if self.Beep < CurTime() and self.Triggered == false then
	
		self.Beep = CurTime() + 1
		
		self.Entity:EmitSound( self.BeepSound, 100, 120 )
	
	end
	
end

function ENT:OnRemove()

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end
