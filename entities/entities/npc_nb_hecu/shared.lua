
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "attackA", "attackB", "attackC", "attackD", "attackE", "attackF", "fastattack" }
ENT.AnimSpeed = 1.5
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.BreakableDistance = 96
ENT.Damage = 45
ENT.BaseHealth = 300
ENT.MoveSpeed = 200
ENT.MoveAnim = ACT_RUN
ENT.GrenadeMoveAnim = ACT_ZOMBINE_GRENADE_WALK
ENT.Grenade = false

ENT.Models = nil
ENT.Model = Model( "models/zombie/zombie_hecugru.mdl" ) 

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

function ENT:OnDeath( dmginfo )
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		if v:GetPos():Distance( self.Entity:GetPos() ) < 150 then
		
			v:TakeDamage( 50, self.Entity )
			v:SetInfected( true )
			
			umsg.Start( "Drunk", v )
			umsg.Short( 2 )
			umsg.End()
		
		end
	
	end
	
	local ed = EffectData()
	ed:SetOrigin( self.Entity:GetPos() )
	util.Effect( "puke_spray", ed, true, true )
	
	if dmginfo:IsExplosionDamage() then
	
		local ed = EffectData()
		ed:SetOrigin( self.Entity:GetPos() )
		util.Effect( "gore_explosion", ed, true, true )
	
	end


end

function ENT:CheckGrenade()

if self:Health() < 60 and self.Grenade == false then
		local ent = ents.Create( "sent_hecu_grenade" )
		ent:SetPos(self:GetPos() + Vector( 0, 0, 40 ))
		ent:SetAngles(self:GetForward():Angle())
		ent:Spawn()
		ent:SetParent( self )
		ent:SetOwner( self )
		local ent1 = ents.Create( "prop_physics" )
		local att = "grenade_attachment"
		local location = self.Entity:GetAttachment(self.Entity:LookupAttachment("grenade_attachment"))
		ent1:SetPos(location.Pos)
		ent1:SetModel( Model( "models/weapons/w_eq_fraggrenade.mdl") )
		ent1:SetAngles(self:GetForward():Angle())
		ent1:Spawn()
		ent1:SetParent( self )
		ent1:SetOwner( self )
		ent1:Fire("setparentattachment", "grenade_attachment")
		ent1:AddEffects(EF_BONEMERGE)
		self.Entity:PlaySequenceAndWait( "pullGrenade", 1)
		self.Grenade = true
end
end

function ENT:EnemyRoutine()
	local closest = self.Entity:CanAttackEnemy( enemy )
			
	while IsValid( closest ) do
			
		local anim = table.Random( self.AttackAnims )
				
		self.Entity:StartAttack( closest )
		self.Entity:PlaySequenceAndWait( anim, self.AnimSpeed )
		//self.Entity:StartActivity( ACT_MELEE_ATTACK1 )
				
		closest = self.Entity:CanAttackEnemy( closest )
				
	end

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:ViewBounce( 30 )

	umsg.Start( "Drunk", enemy )
	umsg.Short( 2 )
	umsg.End()

end

function ENT:RunBehaviour()
if self.Grenade == false then
    while true do
		self:CheckGrenade()
		if self.Grenade == false then
        self.Entity:StartActivity( self.MoveAnim )    
		else
		return
		end
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
	
end