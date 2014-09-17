
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ExplodeSound = { 1, 2, 4, 5, 6, 8 }
ENT.Trigger = Sound( "ambient/fire/ignite.wav" )
ENT.BeepSound = Sound( "weapons/c4/c4_beep1.wav" )
ENT.Triggered = false
ENT.Damage = 5
ENT.DieTime = CurTime() + 999999999
ENT.Beep = CurTime() + 1
ENT.Distance = 200

function ENT:Initialize()

	self.Entity:SetModel( "models/props_junk/gascan001a.mdl" )	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	local bomb = ents.Create( "prop_dynamic" )
	bomb:SetOwner( self.Entity )
	bomb:SetParent( self.Entity)
	bomb:SetModel( "models/weapons/w_c4.mdl" )
	bomb:SetPos( self.Entity:GetPos() + Vector(2,0,2) )
	bomb:Spawn()
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
	
	local trace = {}
	trace.start = self.Entity:GetPos() + Vector(0,0,20)
	trace.endpos = trace.start + Vector( 0, 0, -200 )
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
			if tr.HitWorld then
		
			util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
	
			end
			local fire = ents.Create( "sent_fire" )
			fire:SetPos( self.Entity:GetPos() )
			fire:SetLifeTime( (5 * (1 + (0.01 * self.Owner:GetLevel()))) )
			fire:Spawn()
			self.DieTime = CurTime() + (5 * (1 + (0.01 * self.Owner:GetLevel())))
			self.Triggered = true
			end end
			g:DoIgnite()
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
