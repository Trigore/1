include('shared.lua')

function ENT:Initialize()

	self.Light = Material( "sprites/light_glow02_add" )
	self.Beep = CurTime() + 1
	self.Emitter = ParticleEmitter( self.Entity:GetPos() ) 
	
end

function ENT:OnRemove()

	if self.Emitter then
	
		self.Emitter:Finish()
		
	end

end

function ENT:Think()

	if self.Beep < CurTime() then
	
		self.Beep = CurTime() + 1
	
	end
	
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:GetPos() + self.Entity:GetRight() )
		particle:SetVelocity( VectorRand() * 5)
		particle:SetDieTime( 5 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 0 )
		particle:SetEndSize( 10 )
		particle:SetGravity( Vector( 0, 0, 10 ) )
			
		particle:SetColor( 0, 255, 0 )
	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	if self.Beep <= ( CurTime() + 0.1 ) then
	
		render.SetMaterial( self.Light )
		render.DrawSprite( self.Entity:GetPos() + self.Entity:GetRight() + Vector(2, 0, -1), 100, 60, Color( 0, 255, 0 ) )
	
	end
	
end

