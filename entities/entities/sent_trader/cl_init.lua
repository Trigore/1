
include('shared.lua')

	function ENT:Initialize()
		self:CreateBubble()
	end

	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Think()
		if (!IsValid(self.bubble)) then
			self:CreateBubble()
		end

		self:SetEyeTarget(LocalPlayer():GetPos())
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetAngles(Angle(0, realTime * 120, 0))
			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.03))
		end

		self:DrawModel()
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end

local matLight = Material( "toxsin/allyvision" )
--[[local scale = ( math.Clamp( self.Entity:GetPos():Distance( LocalPlayer():GetPos() ), 500, 3000 ) - 500 ) / 2500
	
	local eyenorm = self.Entity:GetPos() - EyePos()
	local dist = eyenorm:Length()
	eyenorm:Normalize()
	
	local pos = EyePos() + eyenorm * dist * 0.01
	
	cam.Start3D( pos, EyeAngles() )
		
		render.SetColorModulation( 0, 1.0, 0.5 )
		render.SetBlend( scale )
		render.MaterialOverride( matLight )
		
			self.Entity:DrawModel()
		
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		render.MaterialOverride( 0 )
		
	cam.End3D()
	
end]]