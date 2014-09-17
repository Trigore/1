
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ExplodeSound = { 1, 2, 4, 5, 6, 8 }
ENT.Trigger = Sound( "weapons/crossbow/bolt_skewer1.wav" )
ENT.BeepSound = Sound( "vehicles/Airboat/fan_motor_shut_off1.wav" )
ENT.Ready = Sound( "weapons/357/357_reload1.wav" )
ENT.Triggered = false
ENT.Damage = 5
ENT.DieTime = CurTime() + 999999999
ENT.Beep = CurTime() + math.random(3,7)
ENT.Distance = 30
ENT.Countdown = false
ENT.h = 0
ENT.OriginalS = 0


function ENT:Initialize()
	
	self.Entity:SetModel( "models/props_junk/sawblade001a.mdl" )	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
	self.Entity:DrawShadow( false )

	local phys = self.Entity:GetPhysicsObject()
	
	local bomb = ents.Create( "prop_dynamic" )
	bomb:SetOwner( self.Entity )
	bomb:SetParent( self.Entity )
	bomb:SetModel( "models/props_junk/sawblade001a.mdl"  )
	bomb:SetPos( self.Entity:GetPos() + self.Entity:GetRight() )
	bomb:SetAngles( Angle(0,0,0) )
	bomb:SetName( "bear_saw1" )
	bomb:Spawn()
	
		local bomb1 = ents.Create( "prop_dynamic" )
	bomb1:SetOwner( self.Entity )
	bomb1:SetParent( self.Entity )
	bomb1:SetModel( "models/props_c17/TrapPropeller_Lever.mdl"  )
	bomb1:SetPos( self.Entity:GetPos() + self.Entity:GetRight() )
	bomb1:SetAngles( Angle(0,0,90) )
	bomb:SetName( "bear_trigger" )
	bomb1:Spawn()
	
	
	if IsValid( phys ) then
	
		phys:Wake()
	
	end
	
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()
	if self.h == 5 then
		self.Entity:Remove()
	
	end

	for k,g in pairs( ents.FindByClass( "npc_*") ) do
	
			local dist = g:GetPos():Distance( self.Entity:GetPos() )
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
		
			if dist < ( self.Distance ) then
			if self.Triggered == false then
			self:EmitSound( self.Trigger )			
			self.OriginalS = g.MoveSpeed
			g.MoveSpeed = 0
			g:TakeDamage((100 * (1 + (0.01 * self.Owner:GetLevel()))))
			self.Entity:SetAngles( Angle(0,0,90) )
			self.Triggered = true
			self.Initial = false
			else
			if self.Countdown == false then
			if g:Health() <= 0 then g:OnKilled() end

			timer.Simple( 15, function()
			self:EmitSound( self.Ready )			
			self.Entity:SetAngles( Angle(0,0,0) )
			if self.h == nil then self.h = 1
			else
			self.h = self.h + 1
			end
			self.Triggered = false
			self.Countdown = false
			end)
			timer.Simple( 10, function()
			g.MoveSpeed = self.OriginalS
			end)
			end
			self.Countdown = true
			end
			

	end
end

	if self.Beep < CurTime() and self.Triggered == false then
	
		self.Beep = CurTime() + math.random(3,7)
		
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
