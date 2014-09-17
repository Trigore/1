
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.Skins = 22
ENT.AttackAnims = { "swing" }
ENT.ThrowAnims = { "heal", "throwitem" }
ENT.AnimSpeed = 0.8
ENT.ThrowSpeed = 2
ENT.AttackTime = 0.5
ENT.MeleeDistance = 64
ENT.ThrowDistance = 200
ENT.BreakableDistance = 96
ENT.Damage = 50
ENT.BaseHealth = 750
ENT.MoveSpeed = 175
ENT.MoveAnim = ACT_RUN
ENT.ThrowTime = 0


ENT.Melee = { 
Model( "models/weapons/w_crowbar.mdl" ),
Model( "models/weapons/w_axe.mdl" ),
Model( "models/weapons/w_hammer.mdl" )}

ENT.Models = { Model( "models/Humans/Group03/Male_01.mdl" ), 
Model( "models/Humans/Group03/Male_02.mdl" ),
Model( "models/Humans/Group03/Male_03.mdl" ),
Model( "models/Humans/Group03/Male_04.mdl" ),
Model( "models/Humans/Group03/Male_05.mdl" ),
Model( "models/Humans/Group03/Male_06.mdl" ),
Model( "models/Humans/Group03/Male_07.mdl" ),
Model( "models/Humans/Group03/Male_08.mdl" ),
Model( "models/Humans/Group03/Male_09.mdl" ) }

ENT.VoiceSounds = {}

ENT.VoiceSounds.Pain = { Sound( "vo/npc/male01/ow01.wav" ),
Sound( "vo/npc/male01/ow02.wav" ),
Sound( "vo/npc/male01/ohno.wav" ),
Sound( "vo/npc/male01/pain01.wav" ),
Sound( "vo/npc/male01/pain02.wav" ),
Sound( "vo/npc/male01/pain03.wav" ),
Sound( "vo/npc/male01/pain04.wav" ),
Sound( "vo/npc/male01/pain05.wav" ),
Sound( "vo/npc/male01/pain06.wav" ),
Sound( "vo/npc/male01/pain07.wav" ),
Sound( "vo/npc/male01/pain08.wav" ),
Sound( "vo/npc/male01/pain09.wav" ) }

ENT.VoiceSounds.Death = { Sound( "vo/npc/male01/hi01.wav" ),
Sound( "vo/npc/male01/hi02.wav" ),
Sound( "vo/npc/male01/hitingut01.wav" ),
Sound( "vo/npc/male01/hitingut02.wav" ),
Sound( "vo/npc/male01/moan01.wav" ),
Sound( "vo/npc/male01/moan02.wav" ),
Sound( "vo/npc/male01/moan03.wav" ),
Sound( "vo/npc/male01/moan04.wav" ),
Sound( "vo/npc/male01/moan05.wav" ),
Sound( "vo/npc/male01/myarm01.wav" ),
Sound( "vo/npc/male01/myarm02.wav" ),
Sound( "vo/npc/male01/mygut02.wav" ),
Sound( "vo/npc/male01/myleg01.wav" ),
Sound( "vo/npc/male01/myleg02.wav" ),
Sound( "vo/npc/male01/no01.wav" ),
Sound( "vo/npc/male01/no02.wav" ),
Sound( "vo/npc/male01/ohno.wav" ) }

ENT.VoiceSounds.Taunt = { Sound( "vo/npc/male01/notthemanithought01.wav" ),
Sound( "vo/npc/male01/notthemanithought02.wav" ),
Sound( "vo/npc/male01/wetrustedyou01.wav" ),
Sound( "vo/npc/male01/wetrustedyou02.wav" ),
Sound( "vo/npc/male01/waitingsomebody.wav" ),
Sound( "vo/npc/male01/onyourside.wav" ),
Sound( "vo/npc/male01/oneforme.wav" ),
Sound( "vo/npc/male01/watchwhat.wav" ),
Sound( "vo/npc/male01/watchout.wav" ) }

ENT.VoiceSounds.Attack = { Sound( "vo/npc/male01/sorry01.wav" ),
Sound( "vo/npc/male01/sorry02.wav" ),
Sound( "vo/npc/male01/sorry03.wav" ),
Sound( "vo/npc/male01/sorrydoc01.wav" ),
Sound( "vo/npc/male01/sorrydoc02.wav" ),
Sound( "vo/npc/male01/sorrydoc04.wav" ),
Sound( "vo/npc/male01/sorryfm01.wav" ),
Sound( "vo/npc/male01/sorryfm02.wav" ) }

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
	self.ThrowTime = CurTime() + 10
		local ent = ents.Create( "prop_dynamic" )
		local att = "anim_attachment_LH"
		local location = self.Entity:GetAttachment(self.Entity:LookupAttachment("anim_attachment_LH"))
		local meleemodel = table.Random( self.Melee )
		ent:SetModel( meleemodel )
		ent:SetPos(location.Pos)
		ent:SetAngles(self:GetForward():Angle())
		ent:Spawn()
		ent:SetParent( self )
		ent:SetOwner( self )
		ent:Fire("setparentattachment", "anim_attachment_LH")
		ent:AddEffects(EF_BONEMERGE)
	
end

function ENT:FindEnemy()

	local tbl = team.GetPlayers( TEAM_ARMY )
	tbl = table.Add( tbl, ents.FindByClass( "npc_scientist" ) )
	tbl = table.Add( tbl, ents.FindByClass( "npc_hum_blackwatch" ) )
	tbl = table.Add( tbl, ents.FindByClass( "npc_nb*" ) )
	
	self.EnemyTable = tbl

	if #tbl < 1 then
		
		return NULL
		
	else
	
		local enemy = NULL
		local dist = 99999
		
		for k,v in pairs( tbl ) do
		
			local compare = v:GetPos():Distance( self.Entity:GetPos() )
			
			if compare < dist and self.Entity:CanTarget( v ) then

				enemy = v
				dist = compare

			end
			
		end
		
		return enemy
		
	end
	
end

function ENT:CanThrow( ent )

	return IsValid( ent ) and self.Entity:CanTarget( ent ) and ent:GetPos():Distance( self.Entity:GetPos() ) <= self.ThrowDistance and self.Entity:MeleeTrace( ent )

end

function ENT:IsZombie()

	return false

end

function ENT:CanTarget( v )

	return ( ( v:IsPlayer() and v:Alive() and v:GetObserverMode() == OBS_MODE_NONE and v:Team() == TEAM_ARMY and v:IsCloaked() == false ) or ( v.NextBot and v:GetClass() != "npc_hum_anarchist" ) )

end

function ENT:StartThrow( enemy )

	self.Stuck = CurTime() + 10
	self.ThrowTime = CurTime() + 10
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
		self.Entity:PlaySequenceAndWait( anim, self.ThrowSpeed )
		local ent = ents.Create( "sent_molotov" )
		ent:SetPos( self:EyePos() + Vector( 0,0,20) )
		ent:SetAngles( self:GetForward():Angle() )
		ent:SetSpeed( 1000 )
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

function ENT:OnDeath( dmginfo ) 


end

function ENT:OnKilled( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	
	self.Entity:OnDeath( dmginfo )
	
	if dmginfo then
		
		local ent1 = self.Entity:GetHighestDamager()
		local tbl = self.Entity:GetHighestDamagers()
		
		if tbl then
		
			for k,v in pairs( tbl ) do
			
				if IsValid( v ) and v != ent1 then
				
					v:AddCash( GAMEMODE.AssistValues[ self.Entity:GetClass() ] )
					v:AddStat( "Assist" )
				
				end
			
			end
		
		end
		
		if IsValid( ent1 ) and ent1:IsPlayer() then
		
			if math.random(1,40) == 1 then
		
				ent1:RadioSound( VO_TAUNT )
				
			end
			
			ent1:AddCash( GAMEMODE.KillValues[ self.Entity:GetClass() ] )
			ent1:AddFrags( 1 )

			
			local dist = math.floor( ent1:GetPos():Distance( self.Entity:GetPos() ) / 8 )
			
			if dist > ent1:GetStat( "Longshot" ) then
			
				ent1:SetStat( "Longshot", dist )
			
			end
			
			if dmginfo:IsExplosionDamage() then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				local ed = EffectData()
				ed:SetOrigin( self.Entity:GetPos() )
				util.Effect( "gore_explosion", ed, true, true )
				
				ent1:AddStat( "Explode" )
				
				local corpse = table.Random( GAMEMODE.Corpses )
				self.Entity:SpawnRagdoll( dmginfo, corpse )
			
			elseif ent1:HasShotgun() and ent1:GetPos():Distance( self.Entity:GetPos() ) < 100 then
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local vec = ( self.Entity:GetPos() - ent1:GetPos() )
				vec:Normalize()
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,20) )
				effectdata:SetNormal( vec )
				util.Effect( "body_gib", effectdata, true, true )
				
				ent1:AddStat( "Meat" )
				
				self.Entity:SpawnRagdoll( dmginfo, self.Legs )
				
			elseif ent1:HasMelee() then
				
				ent1:AddStat( "Knife" )
				
				self.Entity:VoiceSound( self.VoiceSounds.Death )
				self.Entity:SpawnRagdoll( dmginfo )
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
				
				if self.Entity:GetHeadshotter( ent1 ) then
				
					local snd = table.Random( GAMEMODE.GoreSplash )
					self.Entity:EmitSound( snd, 90, math.random( 90, 110 ) )
					
					local effectdata = EffectData()
					effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,40) )
					util.Effect( "head_gib", effectdata, true, true )
					
					umsg.Start( "Headless" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
			
			elseif self.Entity:GetHeadshotter( ent1 ) then //self.HeadshotEffects
			
				local snd = table.Random( GAMEMODE.GoreSplash )
				self.Entity:EmitSound( snd, 90, math.random( 90, 110 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( self.Entity:GetPos() + Vector(0,0,40) )
				util.Effect( "head_gib", effectdata, true, true )
				
				umsg.Start( "Headless" )
				umsg.Vector( self.Entity:GetPos() )
				umsg.End()
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
				
				self.Entity:SpawnRagdoll( dmginfo )
			
			else
			
				self.Entity:VoiceSound( self.VoiceSounds.Death )
				self.Entity:SpawnRagdoll( dmginfo )
				
				if self.Entity:OnFire() then
				
					umsg.Start( "Burned" )
					umsg.Vector( self.Entity:GetPos() )
					umsg.End()
				
				end
			
			end
			
		else 
		self.Entity:VoiceSound( self.VoiceSounds.Death )
		self.Entity:SpawnRagdoll( dmginfo )
		
		end
	
	end
	
end

function ENT:OnHitEnemy( enemy )

	enemy:TakeDamage( self.Damage, self.Entity )
	enemy:ViewBounce( 20 )
	enemy:SetBleeding( true )
	umsg.Start( "Drunk", enemy )
	umsg.Short( 1 )
	umsg.End()

end