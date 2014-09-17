
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ExplodeSound = { 1, 2, 4, 5, 6, 8 }
ENT.BeepSound = Sound( "items/medshot4.wav" )
ENT.DieTime = CurTime() + 11
ENT.Beep = CurTime() + 1
ENT.Distance = 200

function ENT:Initialize()
self.Entity:SetModel( "models/props_c17/TrapPropeller_Lever.mdl" )
self.Entity:SetAngles( Angle( 0,0,90 ) )
self.DieTime = CurTime() + 11
end

function ENT:SetSpeed( num )

	self.Speed = num

end

function ENT:Think()
	if self.DieTime < CurTime() then
		self.Entity:Remove()
	end

	if self.Beep < CurTime() then
	
		self.Beep = CurTime() + 1
		self.Entity:EmitSound( self.BeepSound )
		for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
			local dist = self:GetPos() - v:GetPos()
			dist = dist:Length()
				if dist < self.Distance then
					local ratio = v:GetMaxHealth() / 10
					v:AddHealth( ratio )
				end

		
		
		end
	
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
