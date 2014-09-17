
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable


ENT.AttackAnims = { "Melee" }
ENT.AnimSpeed = 1.0
ENT.AttackTime = 0.3
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 10
ENT.BaseHealth = 200
ENT.MoveSpeed = 250
ENT.JumpHeight = 300
ENT.MoveAnim = ACT_RUN
ENT.Scream = Sound( "npc/stalker/go_alert2a.wav" )
ENT.Beep = CurTime() + 1
ENT.ScreamTime = CurTime() + 5

ENT.Models = nil
ENT.Model = Model( "models/zombie/zm_fast.mdl" )


ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/fast_zombie/fz_alert_close1.wav" ),
Sound( "npc/fast_zombie/fz_alert_far1.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/fast_zombie/idle1.wav" ),
Sound( "npc/fast_zombie/idle2.wav" ),
Sound( "npc/fast_zombie/idle3.wav" ),
Sound( "npc/headcrab_poison/ph_hiss1.wav" ),
Sound( "npc/headcrab_poison/ph_idle1.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/fast_zombie/fz_frenzy1.wav" ),
Sound( "npc/fast_zombie/fz_scream1.wav" ),
Sound( "npc/barnacle/barnacle_pull1.wav" ),
Sound( "npc/barnacle/barnacle_pull2.wav" ),
Sound( "npc/barnacle/barnacle_pull3.wav" ),
Sound( "npc/barnacle/barnacle_pull4.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/fast_zombie/wake1.wav" ),
Sound( "npc/fast_zombie/leap1.wav" ) }

ENT.Leap = Sound( "npc/fast_zombie/fz_scream1.wav" )

function ENT:OnDeath( dmginfo ) 

end

function ENT:OnThink()

	if self.Beep < CurTime() then
	for k,v in pairs( ents.FindByClass( "npc_nb_common") ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 300 then
		v:SetHealth( v:Health() + 10 )
		
		end
	
	end
	self.Beep = CurTime() + 2
	end
		if self.ScreamTime < CurTime() then
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) )  do
			
			local dist = v:GetPos():Distance( self.Entity:GetPos() )
			
			if dist <= 200 then
			
				local scale = 1 - ( dist / 350 )
				local count = math.Round( scale * 4 )
				
				self:EmitSound( self.Scream, math.random( 90, 100 ) )
				v:TakeDamage( scale * 10, self.Owner, self.Weapon )
				umsg.Start( "Drunk", v )
				umsg.Short( count )
				umsg.End()

				umsg.Start( "ScreamHit", v )
				umsg.End()
				self.ScreamTime = CurTime() + 10
			
			
			end
		
		end
	end
end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:ViewBounce( 20 )
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()

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