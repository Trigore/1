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
	
end

function ENT:Draw()

	self.Entity:DrawModel()
	
	if self.Beep <= ( CurTime() + 0.1 ) then
	
		render.SetMaterial( self.Light )
		render.DrawSprite( self.Entity:GetPos() + self.Entity:GetRight() + Vector( 0, 0, 12), 100, 60, Color( 255, 0, 0 ) )
	
	end
	
end

