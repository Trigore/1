
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable


ENT.AttackAnims = { "Melee" }
ENT.AnimSpeed = 1.0
ENT.AttackTime = 0.3
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 30
ENT.BaseHealth = 400
ENT.MoveSpeed = 250
ENT.MoveAnim = ACT_RUN
ENT.TeleSound = Sound( "beams/beamstart5.wav" )
ENT.TeleTime = CurTime() + 10
ENT.ScreamTime = CurTime() + 5
ENT.Orig = Vector(0, 0, 0 )

ENT.Models = nil
ENT.Model = Model( "models/rake/rake.mdl" )


ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/zombie_poison/pz_die1.wav" ),
Sound( "npc/zombie_poison/pz_die2.wav" ),
Sound( "npc/zombie_poison/pz_idle2.wav" ),
Sound( "npc/zombie_poison/pz_warn2.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/zombie_poison/pz_idle3.wav" ),
Sound( "npc/zombie_poison/pz_idle4.wav" ),
Sound( "npc/zombie_poison/pz_pain1.wav" ),
Sound( "npc/zombie_poison/pz_pain2.wav" ),
Sound( "npc/zombie_poison/pz_pain3.wav" ),
Sound( "npc/zombie_poison/pz_warn1.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/zombie_poison/pz_alert1.wav" ),
Sound( "npc/zombie_poison/pz_alert2.wav" ),
Sound( "npc/zombie_poison/pz_call1.wav" ),
Sound( "npc/zombie_poison/pz_throw2.wav" ),
Sound( "npc/zombie_poison/pz_throw3.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/zombie_poison/pz_throw2.wav" ),
Sound( "npc/zombie_poison/pz_throw3.wav" ),
Sound( "npc/zombie_poison/pz_alert2.wav" ) }

function ENT:OnDeath( dmginfo ) 

end

function ENT:OnThink()
	if IsValid( self.CurEnemy) then
		if self.TeleTime < CurTime() then
			self.Orig = self.Entity:GetPos()
			
			if self.CurEnemy:GetPos():Distance( self.Entity:GetPos() ) <= 1600 then
				local loc = ( self.CurEnemy:EyePos() + self.CurEnemy:GetForward() )
				self:SetPos( loc + Vector(175, 0, 0 ) )
				self:EmitSound( self.TeleSound, math.random( 90, 100 ) )
				local ed = EffectData()
				ed:SetOrigin( self.Orig )
				util.Effect( "TeslaZap ", ed, true, true )
				self.TeleTime = CurTime() + 5
			end
		end
	end
	for k,v in pairs( team.GetPlayers( TEAM_ARMY) ) do

		v:NoticeOnce( "Something is phasing through walls around you, stay sharp", GAMEMODE.Colors.Blue )
		v:NoticeOnce( "Boss Zombies are powerful with unique abilities. Work Together!", GAMEMODE.Colors.Blue, 3, 2 )
			
	end
end

function ENT:OnHitEnemy( enemy )
	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:ViewBounce( 20 )
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()
	self.Entity:SetPos( self.Orig )
end

function ENT:OnStuck()

	local ent = self.Entity:GetBreakable()
	
	if IsValid( ent ) then
	
		self.Obstructed = true
	
	else
	
		self.Obstructed = false
		self.Entity:DownTrace()
	
	end
	
	self.loco:ClearStuck()

end

function ENT:DownTrace()

	local trace = {}
	trace.start = self.Entity:GetPos() 
	trace.endpos = trace.start + Vector(0,0,-1000)
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	if tr.Hit then
	
		self.Entity:SetPos( tr.HitPos + tr.HitNormal * 5 )
	
	end

end

function ENT:RunBehaviour()

    while true do
	
        self.Entity:StartActivity( self.MoveAnim )    
        self.loco:SetDesiredSpeed( self.MoveSpeed )
		
		local enemy = self.Entity:FindEnemy()
		
		if not IsValid( enemy ) then
		
			self.Entity:MoveToPos( self.Entity:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 500 )
			self.Entity:StartActivity( ACT_IDLE ) 
		
		else
		
			if self.Obstructed then
			
				self.Entity:BreakableRoutine()
				
				coroutine.yield()
			
			end
		
			local age = math.Clamp( math.min( enemy:GetPos():Distance( self.Entity:GetPos() ), 1000 ) / 1000, 0.2, 1 )
			local opts = { draw = self.ShouldDrawPath, maxage = 3 * age, tolerance = self.MeleeDistance }
		
			if math.random(1,20) == 0 then
			
				self.loco:SetDesiredSpeed( math.random( 350, 700 ) )
				self.loco:SetJumpHeight( math.random( 150, self.JumpHeight ) )
				self.loco:Jump()
				
				self.Entity:SetVelocity( self.Entity:GetForward() * math.random( 350, 700 ) + Vector(0,0,200) )
				self.Entity:EmitSound( self.Leap, 100, math.random(90,110) )
			
			end
		
			self.Entity:MoveToPos( enemy:GetPos(), opts ) 
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
			self.Entity:BreakableRoutine()
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end