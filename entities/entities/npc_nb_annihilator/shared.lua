
AddCSLuaFile()

ENT.Base = "npc_nb_base"

// Moddable

ENT.AttackAnims = { "attackB", "attackD", "attackE", "attackF", "swatleftmid", "swatrightmid" }
ENT.AnimSpeed = 1.5
ENT.AttackTime = 0.5
ENT.MeleeDistance = 128
ENT.BreakableDistance = 192
ENT.Damage = 65
ENT.BaseHealth = 50000
ENT.MoveSpeed = 200
ENT.MoveAnim = ACT_WALK_ON_FIRE
ENT.SpawnTime = CurTime() + 10
ENT.FormAttack = CurTime() + 15
ENT.HealTime = CurTime() + 60
ENT.Heal = CurTime() + 2
ENT.Vulnerable = CurTime()
ENT.Form = 1
ENT.Dead = false
ENT.Healing = false
ENT.HealCancel = false

ENT.Models = nil
ENT.Model = Model( "models/half-dead/specimen.mdl" ) 

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

function ENT:Initialize()
	if self.Models then

		local model = table.Random( self.Models )
		self.Entity:SetModel( model )
		
	else
	
		self.Entity:SetModel( self.Model )
	
	end
	
	self.Entity:SetBodygroup( 1, 2 )
	self.Entity:SetBodygroup( 2, 0 )
	self.Entity:SetBodygroup( 3, 3 )
	self.Entity:SetBodygroup( 4, 1 )
	self.Entity:SetBodygroup( 5, 2 )
	self.Entity:SetModelScale( 1.3, 0 )
	self.Entity:SetHealth( self.BaseHealth )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NPC )
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) ) // nice fat shaming
	self.Entity:SetSkin( 1 )
	
	self.loco:SetDeathDropHeight( 1000 )	
	self.loco:SetAcceleration( 500 )	
	self.loco:SetJumpHeight( self.JumpHeight )
	
	self.DmgTable = {}
	self.LastPos = self.Entity:GetPos()
	self.Stuck = CurTime() + 10
	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		v:Notice( "Barthilex has entered the area", GAMEMODE.Colors.Red )
	end
	
end

function ENT:OnThink()

end


function ENT:BackupBehavior()
	while self.SpawnTime < CurTime() do
	self.Entity:PlaySequenceAndWait( "releasecrab", 0.5)
		if self.Form == 1 then
			local spawns = { "npc_nb_contagion", "npc_nb_poison", "npc_nb_hecu" }
			local tbl = table.Random( spawns )
			local ent = ents.Create( tbl )
			ent:SetPos( self:GetPos() + Vector( 60, 0, 10 ) )
			ent:Spawn()
			
			local ent1 = ents.Create( tbl )
			ent1:SetPos( self:GetPos() + Vector( 60, 30, 10 ) )
			ent1:Spawn()
			
			local ent2 = ents.Create( tbl )
			ent2:SetPos( self:GetPos() + Vector( -60, 0, 10 ) )
			ent2:Spawn()
			self.SpawnTime = CurTime() + 15
		elseif self.Form == 2 then
			local spawns = { "npc_nb_reanim", "npc_nb_leaper", "npc_nb_ghoul" }
			local tbl = table.Random( spawns )
			local ent = ents.Create( tbl )
			ent:SetPos( self:GetPos() + Vector( 60, 0, 10 ) )
			ent:Spawn()
			
			local ent1 = ents.Create( tbl )
			ent1:SetPos( self:GetPos() + Vector( 60, 30, 10 ) )
			ent1:Spawn()
			
			local ent2 = ents.Create( tbl )
			ent2:SetPos( self:GetPos() + Vector( -60, 0, 10 ) )
			ent2:Spawn()
			self.SpawnTime = CurTime() + 14
		elseif self.Form == 3 then
			local ent = ents.Create( "npc_nb_spectre" )
			ent:SetPos( self:GetPos() + Vector( 60, 0, 10 ) )
			ent:Spawn()
			
			local ent1 = ents.Create( "npc_nb_spectre" )
			ent1:SetPos( self:GetPos() + Vector( 60, 30, 10 ) )
			ent1:Spawn()
			
			local ent2 = ents.Create( "npc_nb_spectre" )
			ent2:SetPos( self:GetPos() + Vector( -60, 0, 10 ) )
			ent2:Spawn()
			self.SpawnTime = CurTime() + 20
		elseif self.Form == 4 then
			local spawns = { "npc_nb_ravager", "npc_nb_wraith" }
			local tbl = table.Random( spawns )
			local ent = ents.Create( tbl )
			ent:SetPos( self:GetPos() + Vector( 60, 0, 10 ) )
			ent:Spawn()
			
			local ent1 = ents.Create( tbl )
			ent1:SetPos( self:GetPos() + Vector( 60, 30, 10 ) )
			ent1:Spawn()
			
			local ent2 = ents.Create( tbl )
			ent2:SetPos( self:GetPos() + Vector( -60, 0, 10 ) )
			ent2:Spawn()
			self.SpawnTime = CurTime() + 25
		else
			local spawns = { "npc_nb_crawler", "npc_nb_hulk" }
			local tbl = table.Random( spawns )
			local ent = ents.Create( tbl )
			ent:SetPos( self:GetPos() + Vector( 60, 0, 10 ) )
			ent:Spawn()
			
			local ent1 = ents.Create( tbl )
			ent1:SetPos( self:GetPos() + Vector( 60, 30, 10 ) )
			ent1:Spawn()
			
			local ent2 = ents.Create( tbl )
			ent2:SetPos( self:GetPos() + Vector( -60, 0, 10 ) )
			ent2:Spawn()
			self.SpawnTime = CurTime() + 30
		end 
		self.Entity:EmitSound( "ambient/creatures/town_zombie_call1.wav" )
	end
end

function ENT:Transform()
	local effectdata = EffectData()
	effectdata:SetStart( self.Entity:GetPos() )
	effectdata:SetOrigin( self.Entity:GetPos() )
	effectdata:SetScale( 512 )
	util.Effect( "AR2Explosion", effectdata )
	self.Entity:PlaySequenceAndWait( "Tantrum", 0.6)
	self.Form = self.Form + 1
	self.Entity:EmitSound( "ambient/materials/cartrap_explode_impact1.wav" )
	self.Entity:EmitSound( "items/suitchargeok1.wav" )
	for k,v in pairs( player.GetAll() ) do
		v:Notice( "Barthilex has transformed into another mutation!", GAMEMODE.Colors.Red )
	end
end

function ENT:TransformBehavior()

	if self.Form == 1 and self:Health() <= 40000 then
		self:Transform()
	elseif self.Form == 2 and self:Health() <= 30000 then
		self:Transform()
	elseif self.Form == 3 and self:Health() <= 20000 then
		self:Transform()
	elseif self.Form == 4 and self:Health() <= 10000 then
		self:Transform()
	end

end

function ENT:FormBehavior()
	if self.FormAttack < CurTime() and not self.Healing then
		if self.Form == 1 then
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
			local dist = v:GetPos():Distance( self.Entity:GetPos() )
			if dist <= 300 then 
			v:SetVelocity( Vector(0,0, math.random(400,600) ) )
			self.Entity:EmitSound( "ambient/machines/thumper_hit.wav" )
			local effectdata = EffectData()
			effectdata:SetStart( self.Entity:GetPos() )
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetScale( 512 )
			util.Effect( "ThumperDust", effectdata )
			self.Entity:PlaySequenceAndWait( "WallPound", 1.2)
			self.FormAttack = CurTime() + 20
			end
			end

		elseif self.Form == 2 then
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
			local dist = v:GetPos():Distance( self.Entity:GetPos() )
			if dist <= 500 and v:Visible( self.Entity ) then 
			self.Entity:EmitSound( "npc/fast_zombie/fz_scream1.wav" )
			self.Entity:PlaySequenceAndWait( "swatrightlow", 1.5)
			local ent = ents.Create( "sent_annihilator_projectile" )
			ent:SetPos( self:EyePos() + Vector( 0,0,40) )
			local vect = v:GetPos() - self.Entity:GetPos()
			ent:SetAngles( vect:Angle() )
			ent:SetSpeed( 10000 )
			ent:Spawn()
			self.FormAttack = CurTime() + 15
			end
			end
			
		elseif self.Form == 3 then
		
			local target = table.Random( team.GetPlayers( TEAM_ARMY ) )
			self.Entity:EmitSound( "beams/beamstart5.wav" )
			self.Entity:SetPos( target:GetPos() + Vector( 50, 50, 50 ) )
			local effectdata = EffectData()
			effectdata:SetStart( self.Entity:GetPos() )
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetScale( 512 )
			util.Effect( "cball_explode", effectdata )
			self.FormAttack = CurTime() + 15

		elseif self.Form == 4 then
		
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) )  do
			
			local dist = v:GetPos():Distance( self.Entity:GetPos() )
			
				if dist <= 300 then
				
					local scale = 1 - ( dist / 350 )
					local count = math.Round( scale * 4 )
					
					self:EmitSound( "npc/stalker/go_alert2a.wav", math.random( 90, 100 ) )
					v:SetVelocity( v:GetPos():GetForward() * -3000 + Vector(0,0, math.random(200,300) ) )
					v:TakeDamage( scale * 30 )
					umsg.Start( "Drunk", v )
					umsg.Short( count )
					umsg.End()

					umsg.Start( "ScreamHit", v )
					umsg.End()
					self.Entity:PlaySequenceAndWait( "Breakthrough", 1.5)
					self.FormAttack = CurTime() + 30			
				end
		
			end
			self.FormAttack = CurTime() + 30	
			
		else
			local target = table.Random( team.GetPlayers( TEAM_ARMY ) )
			self.Entity:EmitSound( "beams/beamstart5.wav" )
			self.Entity:SetPos( target:GetPos() + Vector( 50, 50, 50 ) )
			local effectdata = EffectData()
			effectdata:SetStart( self.Entity:GetPos() )
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetScale( 512 )
			util.Effect( "cball_explode", effectdata )
			target:SetVelocity( Vector(0,0, math.random(400,600) ) )
			self.Entity:EmitSound( "ambient/machines/thumper_hit.wav" )
			local effectdata = EffectData()
			effectdata:SetStart( self.Entity:GetPos() )
			effectdata:SetOrigin( self.Entity:GetPos() )
			effectdata:SetScale( 512 )
			util.Effect( "ThumperDust", effectdata )
			self.Entity:PlaySequenceAndWait( "WallPound", 1.2)
			self:EmitSound( "npc/stalker/go_alert2a.wav", math.random( 90, 100 ) )
			local dist = target:GetPos():Distance( self.Entity:GetPos() )			
			local scale = 1 - ( dist / 350 )
			local count = math.Round( scale * 4 )
			target:TakeDamage( scale * 10 )
			
			self.FormAttack = CurTime() + 10
		end
	end
end

function ENT:HealBehavior()
	if self.HealTime < CurTime() then
	local target = table.Random( ents.FindByClass( "info_evac" ) )
	self.Entity:EmitSound( "beams/beamstart5.wav" )
	self.Entity:SetPos( target:GetPos() + Vector( 0, 0, 50 ) )
	local effectdata = EffectData()
	effectdata:SetStart( self.Entity:GetPos() )
	effectdata:SetOrigin( self.Entity:GetPos() )
	effectdata:SetScale( 512 )
	util.Effect( "cball_explode", effectdata )
	for k,v in pairs( player.GetAll() ) do
		v:Notice( "He's teleported somewhere to heal. Stop him at all costs", GAMEMODE.Colors.Red )
	end
	self.HealTime = CurTime() + 120
	self.Heal = 0
	self.Healing = true
	end
	while self.Healing do
		self.Entity:PlaySequenceAndWait( "slump_b", 1)		
	if self.HealCancel then
		self.Entity:PlaySequenceAndWait( "slumprise_b", 1.5)	
		self.Healing = false
		self.HealCancel = false
	end
	if self.Heal < CurTime() and self.Healing then
	if self.Form == 1 then
		self.Entity:SetHealth( self.Entity:Health() + 50 )
		self.Heal = CurTime() + 2
	elseif self.Form == 2 then
		self.Entity:SetHealth( self.Entity:Health() + 75 )
		self.Heal = CurTime() + 2
	elseif self.Form == 3 then
		self.Entity:SetHealth( self.Entity:Health() + 100 )
		self.Heal = CurTime() + 2
	elseif self.Form == 4 then
		self.Entity:SetHealth( self.Entity:Health() + 126 )
		self.Heal = CurTime() + 2
	else
		self.Entity:SetHealth( self.Entity:Health() + 150 )
		self.Heal = CurTime() + 2
	end
	if self.Entity:Health() >= self.BaseHealth then
	self.Healing = false
	end
	end
	end
end

function ENT:StuckThink()

	if not self.Healing then
		local target = table.Random( team.GetPlayers( TEAM_ARMY ) )
		if self.LastPos:Distance( self.Entity:GetPos() ) < 50 and IsValid( target ) then
		self.Entity:EmitSound( "beams/beamstart5.wav" )
		self.Entity:SetPos( target:GetPos() + Vector( 50, 50, 50 ) )
		local effectdata = EffectData()
		effectdata:SetStart( self.Entity:GetPos() )
		effectdata:SetOrigin( self.Entity:GetPos() )
		effectdata:SetScale( 512 )
		util.Effect( "cball_explode", effectdata )
		end
	end

end

function ENT:RunBehaviour()
	self.Entity:PlaySequenceAndWait( "canal5aattack", 0.6)
    while true do
	
		self.Entity:BackupBehavior()
		self.Entity:FormBehavior()
		self.Entity:HealBehavior()
		self.Entity:TransformBehavior()
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
			
			self.Entity:StartActivity( ACT_IDLE_ON_FIRE ) 
			
			self.Entity:BreakableRoutine()
			self.Entity:EnemyRoutine()
			
			self.Entity:StartActivity( ACT_IDLE_ON_FIRE ) 
			
		end
		
        coroutine.yield()
		
    end
	
end

function ENT:OnHitBreakable( ent )

	if not IsValid( ent ) then return end
	if ent:GetName() == "ghost_stuff" then return end

	if string.find( ent:GetClass(), "func_breakable" ) then
			
		ent:TakeDamage( 200, self.Entity, self.Entity )
				
		if ent:GetClass() == "func_breakable_surf" then
			
			ent:Fire( "shatter", "1 1 1", 0 )

		end
			
	elseif string.find( ent:GetClass(), "func_door" ) then
	
		ent:Fire( "lock", "", 0 )
	
			
	else
		
		if not ent.Hits then
				
			ent.Hits = 20
			ent.MaxHits = math.random(10,20)
			ent:EmitSound( self.WoodHit )
				
		else
				
			ent.Hits = ent.Hits + 1
					
			if ent.Hits > ent.MaxHits then
					
				if ent:GetModel() != "models/props_debris/wood_board04a.mdl" and ent:GetName() != "ghost_stuff" then
					
					local prop = ents.Create( "prop_physics" )
					prop:SetModel( ent:GetModel() )
					prop:SetPos( ent:GetPos() )
					prop:SetAngles( ent:GetAngles() + Angle( math.random(-10,10), math.random(-5,5), math.random(-5,5) ) )
					prop:SetSkin( ent:GetSkin() )
					prop:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					prop:Spawn()
					
							
					local dir = ( ent:GetPos() - self.Entity:GetPos() ):Normalize()
					local phys = prop:GetPhysicsObject()
							
					if IsValid( phys ) and dir then
							
						phys:ApplyForceCenter( dir * phys:GetMass() * 800 )
						phys:AddAngleVelocity( VectorRand() * 200 )

					end	
					ent:EmitSound( self.WoodBust )
					ent:SetName( "ghost_stuff" )
					ent:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
					ent:SetNotSolid( true )
					ent:SetRenderMode( RENDERGROUP_TRANSLUCENT )
					ent:SetColor( Color(255, 0, 0, 110 ) )	
					ent:Fire( "lock", "", 0 )
					
				else
						
					ent:Fire( "break", "", 0 )		
					
				end

			else
					
				ent:EmitSound( self.WoodHit )
					
			end
				
		end
		
	end

end

function ENT:OnInjured( dmginfo )

	if self.Healing then
		self.Healing = false
		for k,v in pairs( player.GetAll() ) do
		v:Notice( "Healing has been stopped!", GAMEMODE.Colors.Green )
		end
		self.HealCancel = true
	end
	if dmginfo:IsExplosionDamage() then
	
		if self.Form !=4 or self.Vulnerable > CurTime() then
	
		dmginfo:ScaleDamage( 0.80 )
		
		else
		
		for k,v in pairs( player.GetAll() ) do
			v:Notice( "His armor is penetrated, attack him now!", GAMEMODE.Colors.Green )
		end
		self.Vulnerable = CurTime() + 30
		end
	
	end
	
	if self.Form != 4 or self.Vulnerable > CurTime() then
	if not self.Entity:OnFire() then
	
		local snd = table.Random( GAMEMODE.GoreBullet )
		sound.Play( snd, self.Entity:GetPos() + Vector(0,0,50), 75, math.random( 90, 110 ), 1.0 )
	
	end
	
	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() * 0.5 )
	
	
	if self.Entity:Health() > 0 and math.random(1,2) == 1 then
	
		self.Entity:VoiceSound( self.VoiceSounds.Pain )
		self.Entity:TakeDamageInfo( dmginfo )
		
	end
	else
	dmginfo:GetAttacker():NoticeOnce( "His armor is still up, use explosives to take it down!", GAMEMODE.Colors.Red )
	self.Entity:AddDamageTaken( dmginfo:GetAttacker(), dmginfo:GetDamage() * 0 )
	end
	end
	
	function ENT:OnKilled( dmginfo )

	if self.Dying then return end
	
	self.Dying = true
	
	self.Entity:OnDeath( dmginfo )
	
	if dmginfo then
		
		local ent1 = self.Entity:GetHighestDamager()
		local tbl = self.Entity:GetHighestDamagers()
		
		if IsValid( ent1 ) and ent1:IsPlayer() then
		
			if math.random(1,40) == 1 then
		
				ent1:RadioSound( VO_TAUNT )
				
			end

		
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
	
	self.Dead = true	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		v:Notice( "Barthilex has been taken down, evac has arrived on the scene", GAMEMODE.Colors.Green )
	end

	local evac = table.Random( ents.FindByClass( "info_evac" ) )
	local ent = ents.Create( "point_evac" )
	ent:SetPos( evac:GetPos() )
	ent:Spawn()
	
end
	