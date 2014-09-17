
local meta = FindMetaTable( "Player" )
if (!meta) then return end 

function meta:Notice( text, col, len, delay, once )

	if delay then
	
		local function Notice( ply, col, len )
		
			if not IsValid( ply ) then return end
		
			umsg.Start( "ToxNotice", ply )
			umsg.String( text )
			umsg.Short( col.r )
			umsg.Short( col.g )
			umsg.Short( col.b )
			umsg.Short( len or 3 )
			umsg.Bool( tobool( once ) )
			umsg.End() 
			
		end
		
		timer.Simple( delay, function() Notice( self, col, len ) end )
		
		return
		
	end

	umsg.Start( "ToxNotice", self )
	umsg.String( text )
	umsg.Short( col.r )
	umsg.Short( col.g )
	umsg.Short( col.b )
	umsg.Short( len or 3 )
	umsg.Bool( tobool( once ) )
	umsg.End() 
	
end

function meta:NoticeOnce( text, col, len, delay )

	local crc = util.CRC( self:SteamID() .. text ) 
	
	if not table.HasValue( self.NoticeList or {}, crc ) then
	
		self:Notice( text, col, len, delay, true )
	
		self.NoticeList = self.NoticeList or {}
		table.insert( self.NoticeList, crc )
	
	end

end

function meta:DrawBlood( num )

	num = num or math.random(1,3)
	
	umsg.Start( "BloodStain", self )
	umsg.Short( num )
	umsg.End()

end

function meta:ClientSound( snd, pitch )

	umsg.Start( "Radio", self )
	umsg.Short( ( pitch or 100 ) )
	umsg.String( snd )
	umsg.End()

	//self:SendLua( "LocalPlayer():EmitSound( \"" .. snd .. "\", 100, " .. ( pitch or 100 ) .. " )" ) 

end

function meta:VoiceSound( snd, lvl, pitch )

	if ( self.SoundDelay or 0 ) < CurTime() then
	
		self.SoundDelay = CurTime() + 1.25
		self:EmitSound( snd, lvl, pitch )
		
	end

end

function meta:RadioSound( vtype, override )

	if not self:Alive() then return end
	
	if ( ( self.RadioTimer or 0 ) < CurTime() or override ) then
	
		local sound = table.Random( GAMEMODE.Radio[ vtype ] )
		
		self:EmitSound( table.Random( GAMEMODE.VoiceStart ), math.random( 90, 110 ) )
		timer.Simple( 0.2, function() if IsValid( self ) then self:EmitSound( sound, 90 ) end end )
		timer.Simple( SoundDuration( sound ) + math.Rand( 0.6, 0.8 ), function() if IsValid( self ) then self:EmitSound( table.Random( GAMEMODE.VoiceEnd ), math.random( 90, 110 ) ) end end )
				
		self.RadioTimer = CurTime() + SoundDuration( sound ) + 1
	
	end

end

function meta:VoiceThink()
	if self:GetPlayerClass() == CLASS_BANSHEE or self:GetPlayerClass() == 5 then return end
	if ( self.VoiceTbl[ VO_IDLE ] or 0 ) < CurTime() then
	
		if GAMEMODE.EvacAlert then
		
			self:RadioSound( VO_EVAC )
		
		else
	
			self:RadioSound( VO_IDLE )
			
		end
		
		self.VoiceTbl[ VO_IDLE ] = CurTime() + math.Rand( 120, 240 )
	
	end
	
	if ( self.VoiceTbl[ VO_ALERT ] or 0 ) < CurTime() then
	
		self.VoiceTbl[ VO_ALERT ] = CurTime() + math.Rand( 120, 240 )
	
		for k,v in pairs( ents.FindByClass( "npc_nb_*" ) ) do
		
			if v:GetPos():Distance( self:GetPos() ) < 100 then
			
				self:RadioSound( VO_ALERT )
			
			end
		
		end
	
	end

end

function meta:GetWeight()
	return 0//self:GetNWFloat( "Weight", 0 ) 
end

function meta:IsDrunk()
	return self:GetNWBool( "Drunk", false )
end

function meta:SetWeight( num )
	//self:SetNWFloat( "Weight", num )
end

function meta:AddWeight( num )
	//self:SetWeight( self:GetWeight() + num ) 
end

function meta:GetAmmo( ammotype )
	return self:GetNWInt( "Ammo"..ammotype, 0 ) 
end

function meta:SetAmmo( ammotype, num )
	self:SetNWInt( "Ammo"..ammotype, num )
end

function meta:AddAmmo( ammotype, num, dropfunc )

	self:SetAmmo( ammotype, self:GetAmmo( ammotype ) + num ) 
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
		
		if v.Ammo == ammotype and num < 0 and not dropfunc then
			
			local count = math.floor( self:GetAmmo( ammotype ) / v.Amount )
	
			while self:HasItem( v.ID ) and self:GetItemCount( v.ID ) > count do
				
				self:RemoveFromInventory( v.ID )
			
			end
		
		end
	
	end
	
end

function meta:GetStats()

	return self.Stats or {}

end

function meta:InitStats()

	self.Stats = {}

end

function meta:AddStat( name, count )

	count = count or 1
	
	self:SetStat( name, self:GetStat( name ) + count )

end

function meta:GetStat( name )

	if not self.Stats then
	
		self:InitStats()
	
	end

	return self.Stats[ name ] or 0
	
end

function meta:SetStat( name, count )

	self.Stats[ name ] = count
	
end

function meta:GetCash()
	return self:GetNWInt( "Cash", 0 ) 
end

function meta:SetCash( num )
	self:SetNWInt( "Cash", math.Clamp( num, -32000, 32000 ) )
end

function meta:GetSpec()
	return self:GetNWInt( "SpecReady", 1 ) 
end

function meta:SetSpec( num )
	self:SetNWInt( "SpecReady", num )
end


function meta:AddCash( num )

	if self:GetPlayerClass() == CLASS_BANSHEE then return end
	
	self:SetCash( self:GetCash() + num ) 
	
	if num < 0 then
	
		self:EmitSound( Sound( "Chain.ImpactSoft" ), 100, math.random( 90, 110 ) )
		self:AddStat( "Spent", -num )
		
	else
	
		if num > 1 then
	
			self:Notice( "+" .. num .. " " .. GAMEMODE.CurrencyName .. "s", GAMEMODE.Colors.Yellow )
			
		elseif num != 0 then
		
			self:Notice( "+" .. num .. " " .. GAMEMODE.CurrencyName, GAMEMODE.Colors.Yellow )
		
		end

	end
	
end

function meta:AddDeath()

	self:SetNWInt( "Deaths", (self:GetNWInt( "Deaths", 0 ) + 1 ) )
	
end

function meta:HasMelee()

	local wep = self:GetActiveWeapon()
	
	if IsValid( wep ) then
	
		if wep.WorldModel == "models/weapons/w_hammer.mdl" or wep.WorldModel == "models/weapons/w_knife_t.mdl" or wep.WorldModel == "models/weapons/w_axe.mdl" then
		
			return true
		
		end
	
	end
	
	return false

end

function meta:HasShotgun()

	local wep = self:GetActiveWeapon()
	
	if IsValid( wep ) then
	
		if wep.AmmoType == "Buckshot" or wep.WorldModel == "models/weapons/w_snip_awp.mdl" then
		
			return true
		
		end
	
	end
	
	return false

end

function meta:AddHeadshot()

	if self:HasShotgun() then return end

	self.Headshots = ( self.Headshots or 0 ) + 1
	
	self:AddStat( "Headshot" )
	
	if GAMEMODE.HeadshotCombos[ self.Headshots ] then
	
		self:Notice( self.Headshots .. " headshot combo", GAMEMODE.Colors.Blue )
		self:AddCash( GAMEMODE.HeadshotCombos[ self.Headshots ] ) 
	
	end

end

function meta:ResetHeadshots()

	self.Headshots = 0

end

function meta:ViewBounce( scale )
	if self:Alive() == false then return end
    self:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * scale, math.Rand( -0.05, 0.05 ) * scale, 0 ) )
end

function meta:GetStamina()
	return self:GetNWInt( "Stamina", 0 ) 
end

function meta:SetStamina( num )
	self:SetNWInt( "Stamina", math.Clamp( num, 0, 150 ) )
end

function meta:SetExperience( num )
	self:SetNWInt( "Experience", num )
end

function meta:GetExperience()
	return self:GetNWInt( "Experience", 0 ) 
end

function meta:SetReqExperience( num )
	self:SetNWInt( "ReqExperience", num )
end

function meta:GetReqExperience()
	return self:GetNWInt( "ReqExperience", 25000 ) 
end

function meta:SetLevel( num )
	self:SetNWInt( "Level", num )
end

function meta:GetLevel()
	return self:GetNWInt( "Level", 0 ) 
end

function meta:AddExperience( num )
	self:SetExperience( self:GetExperience() + num ) 
end

function meta:SetRemaining( num )
	self:SetNWInt( "Remaining", num )
end

function meta:GetRemaining()
	return self:GetNWInt( "Remaining", 0 ) 
end

function RemoveRemaining( num )
	SetGlobalInt( "Remaining", ( GetGlobalInt( "Remaining", 0 ) - num )  )
end

function meta:AddStamina( num )
	self:SetStamina( self:GetStamina() + num ) 
end

function meta:GetRadiation()
	return self:GetNWInt( "Radiation", 0 ) 
end

function meta:SetRadiation( num )
	
	self:SetNWInt( "Radiation", math.Clamp( num, 0, 5 ) )
	
end

function meta:AddRadiation( num )

	if self:GetPlayerClass() == CLASS_BANSHEE then return end
	
	if self:Alive() == false then return end
	
	if self:HasItem( "models/items/combine_rifle_cartridge01.mdl" ) and num > 0 then return end
	
	if num > 0 then
	
		self.PoisonFade = CurTime() + 30
		
		self:EmitSound( table.Random{ "Geiger.BeepLow", "Geiger.BeepHigh" }, 100, math.random( 90, 110 ) )
		
		self:NoticeOnce( "You have been irradiated", GAMEMODE.Colors.Red, 7 )
		self:NoticeOnce( "Radiation sickness will fade over time", GAMEMODE.Colors.Blue, 7, 2 )
		
		local ed = EffectData()
		ed:SetEntity( self )
		util.Effect( "radiation", ed, true, true )
		
		self:AddStat( "Rad", num )
		
	end

	self:SetRadiation( self:GetRadiation() + num ) 
	
end

function meta:AddHealth( num )
	
	if self:Health() + num <= 0 then
	
		self:Kill()
		return
	
	end

	self:SetHealth( math.Clamp( self:Health() + num, 1, self:GetMaxHealth() ) )
	
end

function meta:SetInfected( bool )
	if self:GetPlayerClass() == CLASS_BANSHEE then bool = false end
	if self:Team() != TEAM_ARMY then bool = false end

	if bool then
	
		self:NoticeOnce( "You have been infected", GAMEMODE.Colors.Red, 7 )
		self:NoticeOnce( "You can cure your infection with the antidote", GAMEMODE.Colors.Blue, 7, 2 )
		self:NoticeOnce( "The antidote location is marked on your screen", GAMEMODE.Colors.Blue, 7, 4 )
		
		self:AddStat( "Infections" )
	
	end

	self:SetNWBool( "Infected", bool )
	
end

function meta:IsInfected()
	return self:GetNWBool( "Infected", false )
end

function meta:SetBleeding( bool )

	if self:Team() != TEAM_ARMY then bool = false end
	if self:GetPlayerClass() == 5 then bool = false end
	if bool and IsValid( self.Stash ) and ( string.find( self.Stash:GetClass(), "npc" ) or self.Stash:GetClass() == "info_storage" ) then return end
	
	if bool then
	
		self:NoticeOnce( "You are bleeding to death", GAMEMODE.Colors.Red, 7 )
		self:NoticeOnce( "You can cover wounds with bandages", GAMEMODE.Colors.Blue, 7, 2 )
	
	end

	self:SetNWBool( "Bleeding", bool )
	
end

function meta:IsBleeding()
	return self:GetNWBool( "Bleeding", false )
end

function meta:SetPlayerClass( num )
	self.Class = num
	self:SetNWInt( "Class", num )
end

function meta:GetPlayerClass()
	return self.Class or CLASS_SCOUT
end

function meta:IsIndoors()

	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )
	
	if tr.HitSky or not tr.Hit then return false end
	
	return true

end

function meta:SetLord( bool )

	self:SetNWBool( "Lord", bool )

end

function meta:IsRaging()

	return self:GetNWBool( "Raging", false )

end

function meta:IsReady()

	return self:GetNWBool( "Ready", false )

end

function meta:UnReady()

	return self:SetNWBool( "Ready", false )

end

function meta:Ready()

	return self:SetNWBool( "Ready", true )

end

function meta:IsCloaked()

	return self:GetNWBool( "Cloaking", false )

end

function meta:IsLord()

	return self:GetNWBool( "Lord", false )

end

function meta:SetZedDamage( num )

	self:SetNWInt( "ZedDamage", num )

end

function meta:GetZedDamage()

	return self:GetNWInt( "ZedDamage", 0 )

end

function meta:AddZedDamage( num )

	self:AddStat( "ZedDamage", num )

	if self:IsLord() then

		self:SetZedDamage( self:GetZedDamage() + num )
		
		if self:GetZedDamage() >= GAMEMODE.RedemptionDamage then
		
			self:NoticeOnce( "You have redeemed yourself", GAMEMODE.Colors.Green, 5 )
			self:NoticeOnce( "You will respawn as a human", GAMEMODE.Colors.Green, 5, 2 )
		
		else 
		
			self:Notice( "+" .. num .. " " .. GAMEMODE.BloodName, GAMEMODE.Colors.Green, 5 )
		
		end
		
	end

end

function meta:Gib()

	if not self:Alive() then return end

	local dmg = DamageInfo()
	dmg:SetDamage( 500 )
	dmg:SetDamageType( DMG_BLAST )
	dmg:SetAttacker( self )
	dmg:SetInflictor( self )
	
	self:TakeDamageInfo( dmg )

end

function meta:OnSpawn()

	self.VoiceTbl = {}
	self.VoiceTbl[ VO_IDLE ] = CurTime() + math.random( 30, 60 )
	self.VoiceTbl[ VO_ALERT ] = CurTime() + math.random( 30, 60 )
	
	self:SetRadiation( 0 )
	self:SetInfected( false )
	self:SetBleeding( false )
	self:SetJumpPower( 200 )

	if self:Team() == TEAM_ARMY then
	
		player_manager.SetPlayerClass( self, "player_base" )
		if self:GetPlayerClass() == CLASS_SCOUT then
	
			self:AddCash( 25 )
			
		elseif self:GetPlayerClass() == CLASS_BANSHEE then
			self:AddCash( 0 )
		else
		
			self:AddCash( 15 )
		
		end
		
		if self:IsLord() then
		
			self:SetCash( 200 )
			
		end
		
		self:InitStats()
		self:SetEvacuated( false )
		self:SetLord( false )

		if self:GetPlayerClass() == CLASS_COMMANDO then
		self:SetMaxHealth( 162 + ( 12 * self:GetLevel() ) )
		self:SetHealth( 162 + ( 12 * self:GetLevel() ) )
		elseif self:GetPlayerClass() == CLASS_SCOUT then
		self:SetMaxHealth( 120 )
		self:SetHealth( 120 )
		elseif self:GetPlayerClass() == CLASS_BANSHEE then
		self:SetMaxHealth( 75 )
		self:SetHealth( 75 )
		else
		self:SetMaxHealth( 150 )
		self:SetHealth( 150 )
		end

		self:SetStamina( 150 )
		
		if self:GetPlayerClass() == CLASS_COMMANDO then
		self:SetWalkSpeed( GAMEMODE.WalkSpeed * 0.75 )
		elseif self:GetPlayerClass() == CLASS_BANSHEE then
		self:SetWalkSpeed( GAMEMODE.WalkSpeed * 1.25 )		
		else
		self:SetWalkSpeed( GAMEMODE.WalkSpeed )
		end
		
		if self:GetPlayerClass() == CLASS_SCOUT then
		self:SetRunSpeed( GAMEMODE.RunSpeed + ( GAMEMODE.RunSpeed * 0.1 ) + (GAMEMODE.RunSpeed * 0.05 * self:GetLevel() ) )
		elseif self:GetPlayerClass() == CLASS_COMMANDO then
		self:SetRunSpeed( GAMEMODE.RunSpeed * 0.75 )
		elseif self:GetPlayerClass() == CLASS_BANSHEE then
		self:SetWalkSpeed( GAMEMODE.RunSpeed * 1.25 )		
		else
		self:SetRunSpeed( GAMEMODE.RunSpeed )
		end
		
		self:SetModel( GAMEMODE.ClassModels[ self:GetPlayerClass() ] )
			end
end

function meta:GetItemLoadout()

	return GAMEMODE.ClassLoadouts[ self:GetPlayerClass() ]

end

function meta:OnLoadout() // this code is terrible, i just cant be arsed to tidy it up

	ApplyCheats( self )
	if self:Team() == TEAM_ARMY then
	if self:GetPlayerClass() == CLASS_BANSHEE then
	self:Give( GAMEMODE.ClassWeapons[ self:GetPlayerClass() ] )
	else
		self:GiveAmmo( 300, "Pistol" )
		//self:Give( "rad_inv" )
		local gun = ents.Create( "prop_physics" )
		gun:SetPos( self:GetPos() )
		gun:SetModel( GAMEMODE.ClassWeapons[ self:GetPlayerClass() ] )
		gun:Spawn()
		
		self:AddToInventory( gun )
		
		local ammobox = ents.Create( "prop_physics" )
		ammobox:SetPos( self:GetPos() )
		ammobox:SetModel( "models/items/357ammo.mdl" )
		ammobox:Spawn()
		ammobox:Spawn()
		self:AddToInventory( ammobox )
		self:AddToInventory( ammobox )
		if self:GetPlayerClass() == CLASS_ENGINEER then
		
			local hammer = ents.Create( "prop_physics" )
			hammer:SetPos( self:GetPos() )
			hammer:SetModel( "models/weapons/w_hammer.mdl" )
			hammer:Spawn()
			
			self:AddToInventory( hammer )
		
		end
		
		local load = self:GetItemLoadout()
		local items = {}
		
		for k,v in pairs( load ) do
		
			local tbl = item.RandomItem( v )
		
			table.insert( items, tbl.ID )
		
		end
		
		self:AddMultipleToInventory( items )
		
	end
	end
	
end

function meta:GetDroppedItems()

	local inv = self:GetInventory()

	if not inv[1] then
		
		local rand = item.RandomItem( ITEM_BUYABLE )
		
		return { rand.ID } 
	
	end
	
	return inv

end

function meta:DropLoot()

	if not self:GetInventory() then return end
	if self:GetPlayerClass() == 5 then return end

	local tbl = self:GetDroppedItems()
	local gun = nil
	
	for k,v in pairs( tbl ) do
	
		local itbl = item.GetByID( v )
		
		if itbl.Weapon then
		
			gun = itbl.Model
			table.remove( tbl, k )
			
			break
		
		end
	
	end
	
	if gun then
	
		local prop = ents.Create( "sent_droppedgun" )
		prop:SetPos( self:GetPos() + Vector(0,0,40) )
		prop:SetModel( gun )
		prop:Spawn()
		
		local phys = prop:GetPhysicsObject()
		
		if IsValid( phys ) then
		
			phys:ApplyForceCenter( self:GetAngles():Forward() * 200 )
		
		end
	
	end
	
	local ent = ents.Create( "sent_lootbag" )
	
	for k,v in pairs( tbl ) do
	
		ent:AddItem( v )
	
	end
	
	ent:SetPos( self:GetPos() + Vector(0,0,25) )
	ent:SetAngles( self:GetForward():Angle() )
	ent:SetRemoval( 60 * 5 )
	ent:Spawn()
	ent:SetCash( self:GetCash() )
	
end

function meta:DoIgnite( att )

	if self:OnFire() then return end

	self.BurnTime = CurTime() + 5
	self.BurnAttacker = att

	local ed = EffectData()
	ed:SetEntity( self )
	util.Effect( "immolate", ed, true, true )
	
	self:EmitSound( table.Random( GAMEMODE.Burning ), 100, 80 )

end

function meta:OnFire()

	return ( self.BurnTime or 0 ) > CurTime()

end


function meta:Think()

	if not self:Alive() then return end
	if self:OnFire() and ( self.BurnInt or 0 ) < CurTime() then
	
		self.BurnInt = CurTime() + 0.5
	
		if self:Team() == TEAM_ARMY then

			local dmginfo = DamageInfo()
			dmginfo:SetDamage( math.random(1,5) )
			dmginfo:SetDamageType( DMG_BURN ) 
			dmginfo:SetAttacker( self )
		
			self:TakeDamageInfo( dmginfo )
		
		elseif IsValid( self.BurnAttacker ) then
		
			self:TakeDamage( 5, self.BurnAttacker )
		
		end
	
	end
	
	if self:Team() == TEAM_ZOMBIES then
	
		if ( self.HealTime or 0 ) < CurTime() then

			self.HealTime = CurTime() + 1.0
			
			if self:IsLord() then
			
				self:AddHealth( 4 )
				
			else
			
				self:AddHealth( 2 )
			
			end
			
		end
		
		return
	
	end
	
	self:VoiceThink()
	
	if ( self.HealTime or 0 ) < CurTime() then // health regen - affected by bleeding and infection

		if self:GetPlayerClass() == CLASS_COMMANDO then
		self.HealTime = CurTime() + ( 2.7 - ( 0.06 * self:GetLevel() ) )
		else
		self.HealTime = CurTime() + 3.0
		end
		
		if self:IsInfected() and math.random(1,4) == 1 then
		
			if self:Health() > 75 then
				
				self:AddStamina( -4 )
				self:AddHealth( -4 )
			
			else
			
				self:AddStamina( -3 )
				self:AddHealth( -3 )
			
			end
		
			self:ViewBounce( math.random( 10, 20 ) )
			self:VoiceSound( table.Random( GAMEMODE.Coughs ), 100, math.random( 90, 100 ) )
		
		end
			
		if self:IsBleeding() then
			
			self:AddHealth( -1 )
			self.HealTime = CurTime() + 2.0
			
		elseif not self:IsBleeding() and not self:IsInfected() and self:GetRadiation() < 1 and self:Health() > 50 then // health regen only works if you arent affected by anything and >50 hp
			
			self:AddHealth( 1 )
		
		end
	
	end
	
	if ( self.PoisonTime or 0 ) < CurTime() then // radiation 
	
		self.PoisonTime = CurTime() + 1.5
	
		if self:GetRadiation() > 0 then
			
			local paintbl = { 0, 0, -1, -2, -2 }
			local stamtbl = { -1, -2, -2, -2, -3 }
		
			self:AddHealth( paintbl[ self:GetRadiation() ] )
			self:AddStamina( stamtbl[ self:GetRadiation() ] )
			
			if ( self.PoisonFade or 0 ) < CurTime() then
			
				self:AddRadiation( -1 )
				
				self.PoisonFade = CurTime() + 20
			
			end
			
		end
		
	end
	
	if ( self.StamTime or 0 ) < CurTime() then 
	
		if self:GetPlayerClass() == CLASS_SCOUT then
			
			self.StamTime = CurTime() + ( 0.82 - ( 0.02 * self:GetLevel() ) )
			
			else
			
			self.StamTime = CurTime() + 1.0
			
		end
		
		if self:KeyDown( IN_SPEED ) and self:GetVelocity():Length() > 1 then
			
			self:AddStamina( -1 )
			self.StamTime = CurTime() + 0.2
		
		elseif self:GetRadiation() < 1 then
		
			self:AddStamina( 1 )
						
			if self:GetStamina() <= 50 or self:IsInfected() then
			
				self.StamTime = CurTime() + 1.35
				
				if self:IsInfected() then
				
					self:NoticeOnce( "The infection slows your stamina regeneration", GAMEMODE.Colors.Red, 5 )
				
				else
				
					self:NoticeOnce( "Your stamina has dropped below 30%", GAMEMODE.Colors.Red, 5 )
					self:NoticeOnce( "Stamina replenishes slower when below 30%", GAMEMODE.Colors.Blue, 5, 2 )
					
				end
			
			end
			
		end
	
	end

end 

function meta:AddToShipment( tbl )

	self.Shipment = table.Add( self.Shipment, tbl )

end

function meta:RemoveFromShipment( id )

	for k,v in pairs( self.Shipment or {} ) do
	
		if v == id then
		
			table.remove( self.Shipment, k )
			
			return
		
		end
	
	end

end

function meta:GetShipment()

	return self.Shipment or {}

end

function meta:RefundAll()

	local tbl = self:GetShipment()
	local cash = 0
	
	for k,v in pairs( tbl ) do
		
		local itbl = item.GetByID( v )
		cash = cash + itbl.Price
		
	end
	
	if cash == 0 then return end
		
	self:AddCash( cash )
	self.Shipment = {}

end

function meta:SendShipment()

if self:GetPlayerClass() == CLASS_SPECIALIST then

	local droptime = nil
	
	if not self:GetShipment()[1] then
	
		self:Notice( "You haven't ordered any shipments", GAMEMODE.Colors.Red ) 
		return
	
	end
	local deliverypos = Vector(0,0,0)
	local dist = 0
	droptime = math.Round( ( 8 - (self:GetLevel() * 1.25 ))  + ( table.Count( self.Shipment ) * ( 2 - ( self:GetLevel() * 0.33 ) ) ) )
	for k,v in pairs( ents.FindByClass( "sent_trader" ) ) do
			dist = self:GetPos() - v:GetPos()
			dist = dist:Length()
			prepos = v:GetPos() + Vector( 0, 20, 30 )
	end
			if #ents.FindByClass( "sent_trader" ) < 1 then dist = 999999 end
			if dist < 100 then
			local ship = self:GetShipment()
			deliverypos = prepos
			droptime = 1
			self:Notice( "Pick up your shipment at the trader", GAMEMODE.Colors.Green, 5 )
		local box = ents.Create( "sent_supplycrate" )
		box:SetPos( deliverypos ) 
		box:SetUser( self )
		box:Spawn()
		box:SetContents( ship ) 
			else
	if self:IsIndoors() then 
		self:Notice( "Unable to send shipment directly to you", GAMEMODE.Colors.Red )
		self:Notice( "Your shipment will be dropped at a loot depot marked by flare", GAMEMODE.Colors.Green )
				local point = table.Random( ents.FindByClass( "info_lootspawn" ) )
				flarepos = point:GetPos() + Vector(0,0,10)
				deliverypos = flarepos + Vector(0,0,20)
	else
	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )
	flarepos = self:GetPos() + Vector(0,0,10)
	deliverypos = tr.HitPos + Vector( 0, 0, -100 )
	end	
	self:Notice( "Your shipment is due in " .. droptime .. " seconds", GAMEMODE.Colors.Green )
	local prop = ents.Create( "sent_dropflare" )
	prop:SetPos( flarepos )
	prop:SetDieTime( droptime )
	prop:Spawn()
	local function DropBox( ply, pos, tbl )
	
		ply:Notice( "Your shipment has been airdropped", GAMEMODE.Colors.Green, 5 )
	
		local box = ents.Create( "sent_supplycrate" )
		box:SetPos( pos ) 
		box:SetUser( ply )
		box:Spawn()
		box:SetContents( tbl ) 
		
	end
	
	local tr = util.TraceLine( util.GetPlayerTrace( self, Vector(0,0,1) ) )
	local ship = self:GetShipment()
	
	timer.Simple( droptime + 1, function() DropBox( self, deliverypos, ship ) end )
	timer.Simple( droptime - 1, function() sound.Play( table.Random( GAMEMODE.Choppers ), self:GetPos(), 100, 100, 0.8 ) end )
	end


	else
	
		if #ents.FindByClass( "sent_trader" ) > 0 then
			for k,v in pairs( ents.FindByClass( "sent_trader" ) ) do
				local dist = self:GetPos() - v:GetPos()
				dist = dist:Length()
				if dist < 100 then
					local ship = self:GetShipment()
					local box = ents.Create( "sent_supplycrate" )
					box:SetPos( v:GetPos() + Vector( 0, 20, 30 ) )
					box:SetUser( self )
					box:Spawn()
					box:SetContents( ship )
					self.Shipment = {}
					self:Notice( "Pick up your shipment at the trader", GAMEMODE.Colors.Green, 5 )
				else
				self:Notice( "You're too far away from the trader", GAMEMODE.Colors.Red ) 
				self:RefundAll()
				end
			end
		end
	
end
	self.Shipment = {}

end

function meta:InitializeInventory()

	self.Inventory = {}
	self:SynchInventory()

end

function meta:GetInventory()

	return self.Inventory or {}
	
end

function meta:GetUniqueInventory()

	local tbl = {}
	
	for k,v in pairs( self.Inventory or {} ) do
	
		if not table.HasValue( tbl, v ) then
		
			table.insert( tbl, v )
		
		end
	
	end
	
	return tbl

end

function meta:SynchInventory()

	//datastream.StreamToClients( { self }, "InventorySynch", self:GetInventory() )
	
	net.Start( "InventorySynch" )
		
		net.WriteTable( self:GetInventory() )
		
	net.Send( self )

end

function meta:AddMultipleToInventory( items )

	for k,v in pairs( items ) do

		local tbl = item.GetByID( v )
		
		if tbl then
		
			if ( tbl.PickupFunction and tbl.PickupFunction( self, tbl.ID ) ) or not tbl.PickupFunction then
			
				table.insert( self.Inventory, tbl.ID )
				self:AddWeight( tbl.Weight )
	
			end
			
			self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
		
		end
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot", #items )

end

function meta:RemoveMultipleFromInventory( items )

	for k,v in pairs( items ) do
	
		local tbl = item.GetByID( v )
	
		for c,d in pairs( self:GetInventory() ) do
		
			if d == v then
				
				self:AddWeight( -tbl.Weight )
		
				table.remove( self.Inventory, c )
				
				break
				
			end
		
		end
	
	end
	
	self:SynchInventory()

end

function meta:AddIDToInventory( id )

	local tbl = item.GetByID( id )
	
	if not tbl then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, id ) then return end
	
	end

	table.insert( self.Inventory, id )
	self:AddWeight( tbl.Weight )
	self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot" )
	
end

function meta:AddToInventory( prop )
	if self:GetPlayerClass() == CLASS_BANSHEE then return end
	local tbl = item.GetByModel( prop:GetModel() )
	
	if not tbl or ( tbl and tbl.AllowPickup ) then return end
	
	if tbl.PickupFunction then
	
		if not tbl.PickupFunction( self, tbl.ID ) then 
		
			if IsValid( prop ) then
	
				prop:Remove()
	
			end
		
			return 
			
		end
	
	end

	table.insert( self.Inventory, tbl.ID )
	self:AddWeight( tbl.Weight )
	self:Notice( "Picked up " .. tbl.Name, GAMEMODE.Colors.Green )
	
	if IsValid( prop ) then
	
		prop:Remove()
	
	end
	
	self:SynchInventory()
	self:EmitSound( Sound( "items/itempickup.wav" ) )
	self:AddStat( "Loot" )
	
end

function meta:RemoveFromInventory( id )

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then		
		
			local tbl = item.GetByID( id )
		
			table.remove( self.Inventory, k )
			
			self:SynchInventory()
			self:AddWeight( -tbl.Weight )
			
			return
		
		end
	
	end

end

function meta:GetItemDropPos()

	local trace = {}
	trace.start = self:GetShootPos() + Vector(0,0,-15)
	trace.endpos = trace.start + self:GetAimVector() * 30
	trace.filter = self
	
	local tr = util.TraceLine( trace )
	
	return tr.HitPos

end

function meta:GetItemCount( id )

	local count = 0

	for k,v in pairs( self:GetInventory() ) do
	
		if v == id then
		
			count = count + 1
		
		end
	
	end
	
	return count

end

function meta:GetWood()

	local tbl = item.GetByName( "Wood" )

	return self:HasItem( "Wood" ), tbl.ID

end

function meta:HasItem( thing )

	for k,v in pairs( ( self:GetInventory() ) ) do
	
		local tbl = item.GetByID( v )
	
		if ( type( thing ) == "number" and v == thing ) or ( type( thing ) == "string" and string.lower( tbl.Model ) == string.lower( thing ) ) or ( type( thing ) == "string" and string.lower( tbl.Name ) == string.lower( thing ) ) then
		
			return true
			
		end
		
	end
	
	return false
	
end

function meta:SynchCash( amt )

	if not amt then return end

	umsg.Start( "CashSynch", self )
	umsg.Short( amt )
	umsg.End()

end

function meta:SynchStash( ent )

	//datastream.StreamToClients( { self }, "StashSynch", ent:GetItems() )
	if ent:GetClass() == "sent_trader" then
	net.Start( "StashSynch" )
		
		net.WriteTable( ent:GetTraderItems( self ) )
		
	net.Send( self )
	else
	net.Start( "StashSynch" )
		
		net.WriteTable( ent:GetItems() )
		
	net.Send( self )
	end
end

function meta:SynchLevel()
	net.Start( "LevelSynch" )
		net.WriteTable( util.KeyValuesToTable(file.Read("toxsinx/userdata/" .. self:SteamID64() .. "_perkdata.txt", "DATA")) )
	net.Send( self )
end

function meta:ToggleStashMenu( ent, open, menutype, pricemod )
	
	if open then
		
		self:SynchInventory()
		self:SynchStash( ent )
		self.Stash = ent
	
	else
	
		self:SetMoveType( MOVETYPE_WALK )
		self.Stash = nil
	
	end
	
	umsg.Start( menutype, self )
	umsg.Bool( open )
	
	if pricemod then
		umsg.Float( pricemod )
	end
	
	umsg.End()

end

function meta:SetEvacuated( bool )

	self.Evacuated = bool

end

function meta:IsEvacuated()

	return self.Evacuated

end

function meta:Evac()

	self:Notice( "You were successfully evacuated", GAMEMODE.Colors.Green, 5 )
	
	self:SetEvacuated( true )
	self:Freeze( true )
	self:Flashlight( false )
	self:SetModel( "models/shells/shell_9mm.mdl" )
	self:Spectate( OBS_MODE_ROAMING )
	self:StripWeapons()
	self:GodEnable()
	
end

function meta:OnDeath()

	umsg.Start( "DeathScreen", self )
	umsg.Short( self:Team() )
	umsg.End()
	self:AddDeath()

	self.NextSpawn = CurTime() + 99999999

	if self:Team() == TEAM_ARMY then

		if IsValid( self.Stash ) then
		
			if self.Stash:GetClass() == "info_trader" then
			
				self.Stash:OnExit( self )
			
			else
		
				self:ToggleStashMenu( self.Stash, false, "StashMenu" )
				
			end
		
		end
		
		self.Stash = nil
		self:SetTeam( TEAM_ARMY )
		self:DropLoot()
		self:SetWeight( 0 )
		self:SetCash( 0 )
		self:Flashlight( false )
		self.Inventory = {}
		self:SynchInventory()
		
		for k,v in pairs{ "Buckshot", "Rifle", "SMG", "Pistol", "Sniper", "Prototype" } do
		
			self:SetAmmo( v, 0 )
		
		end

	else
	
		if self:GetPlayerClass() == CLASS_CONTAGION then
		
			self:SetModel( "models/zombie/classic_legs.mdl" )
			self:EmitSound( table.Random( GAMEMODE.GoreSplash ), 90, math.random( 60, 80 ) )
			
			local got = false
			
			for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
				if v:GetPos():Distance( self:GetPos() ) < 200 then
		
					self:AddZedDamage( 20 )
					v:TakeDamage( 25, self )
					v:SetInfected( true )
			
					umsg.Start( "Drunk", v )
					umsg.Short( 2 )
					umsg.End()
		
					got = true
		
				end
	
			end
			
			if got then
			
				self:Notice( "You infected a human", GAMEMODE.Colors.Green )
			
			end
	
			local ed = EffectData()
			ed:SetOrigin( self:GetPos() )
			util.Effect( "puke_explosion", ed, true, true )
		
		end
	
	end

end