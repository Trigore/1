
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Scale = 1
ENT.Distance = 300

function ENT:Initialize()
	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetNotSolid( true )
	self.Entity:DrawShadow( false )	
	
	self.Entity:SetCollisionBounds( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	self.Entity:PhysicsInitBox( Vector( -60, -60, -60 ), Vector( 60, 60, 60 ) )
	
	self.Entity:SetNWInt( "Distance", self.Distance )
	
	self.DieTime = CurTime() + 8
	
end

function ENT:SetDistance( num )

	self.Distance = num

end

function ENT:SetLifeTime( num )

	self.LifeTime = num

end

function ENT:OnRemove()

end
		
function ENT:Think()

	for k,g in pairs( ents.FindByClass( "npc_nb_*") ) do
		if g:GetClass() == "npc_nb_annihilator" then return end
			local dist = g:GetPos():Distance( self.Entity:GetPos() )
		
		if dist < ( self.Distance * self.Scale ) + 100 then
		
			if dist < ( self.Distance * self.Scale ) then
			g:SetHealth(1)
	end
	end
	end
	end



function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end
