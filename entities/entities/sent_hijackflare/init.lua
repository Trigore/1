
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Rotor = Sound( "NPC_AttackHelicopter.RotorsLoud" )
ENT.Explode = Sound( "weapons/flashbang/flashbang_explode1.wav" )

ENT.Dying = false

function ENT:Initialize()


	self.Entity:SetModel( Model( "models/props_c17/TrapPropeller_Lever.mdl"  ) )
	
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:DrawShadow( false )
	
	self.Entity:SetNWFloat( "BurnDelay", CurTime() + 3 )
	
	local phys = self.Entity:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:Wake()
		phys:SetDamping( 0, 10 )
	
	end
	
	self.DieTime = CurTime() + 999999
	
end

function ENT:Think()

	if self.Dying == true then
		if self.DieTime < CurTime() then	
		self.Entity:Remove()
	end
	else
	if self.Entity:GetNWFloat( "BurnDelay", 0 ) < CurTime() then
		
		if not self.Burning then
		
			self.Burning = true
			self.Entity:EmitSound( self.Rotor )
			self.Entity:EmitSound( self.Explode, 100, math.random(90,110) )
		
		end
	
	end


	self:CheckEndGame()
	end
end

function ENT:CheckEndGame()
	if #ents.FindByClass( "npc_hum_blackwatch" ) == 0 then 
	self.DieTime = CurTime() + 45
	self.Dying = true
	else
	end
	end

function ENT:OnRemove()

	self.Entity:StopSound( self.Rotor )

end

function ENT:OnTakeDamage( dmginfo )
	
end

function ENT:PhysicsCollide( data, phys )
	
end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

