
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "attack1" , "attack2" , "attack3" }
ENT.AnimSpeed = 1.0
ENT.AttackTime = 0.3
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 70
ENT.BaseHealth = 400
ENT.MoveSpeed = 250
ENT.JumpHeight = 300
ENT.MoveAnim = ACT_WALK
ENT.Beep = 0

ENT.Radius = 175
ENT.SoundRadius = 500
ENT.EffectTime = 0

ENT.Models = nil
ENT.Model = Model( "models/stalker_old.mdl" ) 
ENT.Legs = Model( "models/gibs/fast_zombie_legs.mdl" )

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

function ENT:OnThink()
		
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( ( self.SoundRadius - dist ) / ( self.SoundRadius - self.Radius ), 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + 1 - scale 
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) + scale * 20 )
				v:NoticeOnce( "Fast moving zombie in your area. It looks different..", GAMEMODE.Colors.Blue )
				v:NoticeOnce( "Boss Zombies are powerful with unique abilities. Work Together!", GAMEMODE.Colors.Blue, 3, 2 )
				
			end
		
		end


function ENT:OnThink()
	if self.Beep < CurTime() then
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 250 then
		v:ViewBounce( 70 )
		
		end
	
	end
	self.Beep = CurTime() + 2
	end
end



function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:SetBleeding( true )
	enemy:ViewBounce( 15 )
	
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
		

		
			self.Entity:MoveToPos( enemy:GetPos(), opts ) 
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
			self.Entity:BreakableRoutine()
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end