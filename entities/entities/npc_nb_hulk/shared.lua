
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "melee_01" }
ENT.AnimSpeed = 1.2
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 120
ENT.BaseHealth = 750
ENT.MoveSpeed = 75
ENT.MoveAnim = ACT_WALK

ENT.Radius = 175
ENT.SoundRadius = 500
ENT.EffectTime = 0

ENT.Models = nil
ENT.Model = Model( "models/zombie/hulk.mdl" ) 

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "npc/zombie/zombie_die1.wav" ),
 Sound( "npc/zombie/zombie_die2.wav" ),
 Sound( "npc/zombie/zombie_die3.wav" ),
 Sound( "npc/zombie/zombie_voice_idle6.wav" ),
 Sound( "npc/zombie/zombie_voice_idle11.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "npc/zombie/zombie_pain1.wav" ),
 Sound( "npc/zombie/zombie_pain2.wav" ),
 Sound( "npc/zombie/zombie_pain3.wav" ),
 Sound( "npc/zombie/zombie_pain4.wav" ),
 Sound( "npc/zombie/zombie_pain5.wav" ),
 Sound( "npc/zombie/zombie_pain6.wav" ),
 Sound( "npc/zombie/zombie_alert1.wav" ),
 Sound( "npc/zombie/zombie_alert2.wav" ),
 Sound( "npc/zombie/zombie_alert3.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "npc/zombie/zombie_voice_idle1.wav" ),
 Sound( "npc/zombie/zombie_voice_idle2.wav" ),
 Sound( "npc/zombie/zombie_voice_idle3.wav" ),
 Sound( "npc/zombie/zombie_voice_idle4.wav" ),
 Sound( "npc/zombie/zombie_voice_idle5.wav" ),
 Sound( "npc/zombie/zombie_voice_idle7.wav" ),
 Sound( "npc/zombie/zombie_voice_idle8.wav" ),
 Sound( "npc/zombie/zombie_voice_idle9.wav" ),
 Sound( "npc/zombie/zombie_voice_idle10.wav" ),
 Sound( "npc/zombie/zombie_voice_idle12.wav" ),
 Sound( "npc/zombie/zombie_voice_idle13.wav" ),
 Sound( "npc/zombie/zombie_voice_idle14.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "npc/zombie/zo_attack1.wav" ),
Sound( "npc/zombie/zo_attack2.wav" ) }

ENT.Torso = Model( "models/zombie/classic_torso.mdl" )

function ENT:OnThink()

for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		local dist = v:GetPos():Distance( self.Entity:GetPos() )
				
			if ( v.NextRadSound or 0 ) < CurTime() then
			
				local scale = math.Clamp( ( self.SoundRadius - dist ) / ( self.SoundRadius - self.Radius ), 0.1, 1.0 )
			
				v.NextRadSound = CurTime() + 1 - scale 
				v:EmitSound( table.Random( GAMEMODE.Geiger ), 100, math.random( 80, 90 ) + scale * 20 )
				v:NoticeOnce( "Something big is coming your way!", GAMEMODE.Colors.Blue )
				v:NoticeOnce( "Boss Zombies are powerful with unique abilities. Work Together!", GAMEMODE.Colors.Blue, 3, 2 )
				
			end
		end
	end
		



function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:ViewBounce( 30 )

	umsg.Start( "Drunk", enemy )
	umsg.Short( 2 )
	umsg.End()

end