
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.Skins = 22
ENT.AttackAnims = { "attack01", "attack02", "attack03", "attack04" }
ENT.ThrowAnims = { "heal", "throwitem" }
ENT.AnimSpeed = 0.8
ENT.ThrowSpeed = 1.8
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.ThrowDistance = 250
ENT.BreakableDistance = 96
ENT.Damage = 30
ENT.BaseHealth = 200
ENT.MoveSpeed = 175
ENT.MoveAnim = ACT_RUN
ENT.ThrowTime = 0


ENT.Models = { Model( "models/zed/malezed_04.mdl" ), 
Model( "models/zed/malezed_06.mdl" ), 
Model( "models/zed/malezed_08.mdl" ) }

ENT.VoiceSounds = {}

ENT.VoiceSounds.Death = { Sound( "nuke/redead/death_1.wav" ),
Sound( "nuke/redead/death_2.wav" ),
Sound( "nuke/redead/death_3.wav" ),
Sound( "nuke/redead/death_4.wav" ),
Sound( "nuke/redead/death_5.wav" ),
Sound( "nuke/redead/death_6.wav" ),
Sound( "nuke/redead/death_7.wav" ),
Sound( "nuke/redead/death_8.wav" ),
Sound( "nuke/redead/death_9.wav" ),
Sound( "nuke/redead/death_10.wav" ) }

ENT.VoiceSounds.Pain = { Sound( "nuke/redead/pain_1.wav" ),
Sound( "nuke/redead/pain_2.wav" ),
Sound( "nuke/redead/pain_3.wav" ),
Sound( "nuke/redead/pain_4.wav" ),
Sound( "nuke/redead/pain_5.wav" ),
Sound( "nuke/redead/pain_6.wav" ),
Sound( "nuke/redead/pain_7.wav" ),
Sound( "nuke/redead/pain_8.wav" ),
Sound( "nuke/redead/pain_9.wav" ),
Sound( "nuke/redead/pain_10.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "nuke/redead/idle_1.wav" ),
Sound( "nuke/redead/idle_2.wav" ),
Sound( "nuke/redead/idle_3.wav" ),
Sound( "nuke/redead/idle_4.wav" ),
Sound( "nuke/redead/idle_5.wav" ),
Sound( "nuke/redead/idle_6.wav" ),
Sound( "nuke/redead/idle_7.wav" ),
Sound( "nuke/redead/idle_8.wav" ),
Sound( "nuke/redead/idle_9.wav" ),
Sound( "nuke/redead/idle_10.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "nuke/redead/attack_1.wav" ),
Sound( "nuke/redead/attack_2.wav" ),
Sound( "nuke/redead/attack_3.wav" ),
Sound( "nuke/redead/attack_4.wav" ),
Sound( "nuke/redead/attack_5.wav" ),
Sound( "nuke/redead/attack_6.wav" ),
Sound( "nuke/redead/attack_7.wav" ),
Sound( "nuke/redead/attack_8.wav" ),
Sound( "nuke/redead/attack_9.wav" ),
Sound( "nuke/redead/attack_10.wav" ) }

function ENT:Initialize()
	if self.Models then

		local model = table.Random( self.Models )
		self.Entity:SetModel( model )
		
	else
	
		self.Entity:SetModel( self.Model )
	
	end
	
	self.Entity:SetHealth( self.BaseHealth )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming
	self.Entity:SetSkin( math.random( 0, self.Skins ) )
	
	self.loco:SetDeathDropHeight( 1000 )	
	self.loco:SetAcceleration( 500 )	
	self.loco:SetJumpHeight( self.JumpHeight )
	
	self.DmgTable = {}
	self.LastPos = self.Entity:GetPos()
	self.Stuck = CurTime() + 10
		local ent = ents.Create( "prop_dynamic" )
		local att = "anim_attachment_LH"
		local location = self.Entity:GetAttachment(self.Entity:LookupAttachment("anim_attachment_LH"))
		ent:SetModel( Model( "models/weapons/w_eq_fraggrenade.mdl") )
		ent:SetMaterial( "models/flesh" )
		ent:SetPos(location.Pos)
		ent:SetAngles(self:GetForward():Angle())
		ent:Spawn()
		ent:SetParent( self )
		ent:SetOwner( self )
		ent:Fire("setparentattachment", "anim_attachment_LH")
		ent:AddEffects(EF_BONEMERGE)
end

function ENT:OnDeath( dmginfo ) 


end

function ENT:CanThrow( ent )

	return IsValid( ent ) and self.Entity:CanTarget( ent ) and ent:GetPos():Distance( self.Entity:GetPos() ) <= self.ThrowDistance and self.Entity:MeleeTrace( ent )

end
function ENT:StartThrow( enemy )

	self.Stuck = CurTime() + 10
	self.ThrowTime = CurTime() + 5
	self.CurEnemy = enemy
	self.Entity:VoiceSound( self.VoiceSounds.Attack )
end

function ENT:EnemyRoutine()
	if self.ThrowTime < CurTime() then
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	local dist = self.Entity:GetPos():Distance( v:GetPos() )
			
	if dist < 500 then
			
		local anim = table.Random( self.ThrowAnims )
		self.Entity:StartThrow( v )
		local vect = v:GetPos() - self.Entity:GetPos()
		self.Entity:PlaySequenceAndWait( anim, self.ThrowSpeed)
		local ent = ents.Create( "sent_giblet" )
		ent:SetPos( self:EyePos() + Vector( 0,0,20) )
		ent:SetAngles( vect:Angle() )
		ent:SetSpeed( 5000 )
		ent:SetMaterial( "models/flesh" )
		ent:Spawn()
				
		end
				
	end
	
	else
	
	local closest = self.Entity:CanAttackEnemy( enemy )
			
	while IsValid( closest ) do
			
		local anim = table.Random( self.AttackAnims )
				
		self.Entity:StartAttack( closest )
		self.Entity:PlaySequenceAndWait( anim, self.AnimSpeed )
		//self.Entity:StartActivity( ACT_MELEE_ATTACK1 )
				
		closest = self.Entity:CanAttackEnemy( closest )
				
	end
	end

end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:SetInfected( true )
	enemy:ViewBounce( 10 )
	
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()

end

function ENT:Aim(vec)
local y,p=self:GetYawPitch(vec)
if y==false then
return false
end
self:SetPoseParameter("aim_yaw",y)
self:SetPoseParameter("aim_pitch",p)
return true
end