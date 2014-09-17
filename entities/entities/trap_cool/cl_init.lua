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
	
		local particle = self.Emitter:Add( "particles/smokey", self.Entity:GetPos() + self.Entity:GetRight() + Vector(10,-5,0) )
		particle:SetVelocity( VectorRand() * 5)
		particle:SetDieTime( 5 )
		particle:SetStartAlpha( 100 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 5 )
		particle:SetGravity( Vector( 5, 0, 0 ) )
			
		particle:SetColor( 0, 125, 255 )
	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	if self.Beep <= ( CurTime() + 0.1 ) then
	
		render.SetMaterial( self.Light )
		render.DrawSprite( self.Entity:GetPos() + self.Entity:GetRight() + Vector(2, 0, 10), 100, 60, Color( 0, 125, 125 ) )
	
	end
	
end

