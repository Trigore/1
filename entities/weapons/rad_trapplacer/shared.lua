if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 90
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Trap Kit"
	SWEP.IconLetter = "j"
	SWEP.Slot = 1
	SWEP.Slotpos = 7
	
end

SWEP.HoldType = "melee"

SWEP.Base = "rad_base"

SWEP.ViewModel  = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/weapons/w_slam.mdl"
SWEP.Barricade = "models/weapons/w_slam.mdl"

SWEP.Mine = true
SWEP.Firebomb = false
SWEP.Zyklone = false
SWEP.BearTrap = false
SWEP.Coolant = false

SWEP.HoldPos = Vector (1.1747, -16.6759, -5.7913)
SWEP.HoldAng = Vector (23.7548, -8.0105, -5.154)

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"

SWEP.Click = Sound( "Buttons.snd14" )
SWEP.Deny = Sound( "HL1/fvox/buzz.wav" )

SWEP.Primary.Hit            = Sound( "weapons/crowbar/crowbar_impact1.wav" )
SWEP.Primary.Sound			= Sound( "weapons/iceaxe/iceaxe_swing1.wav" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.100

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

SWEP.Position = 35
SWEP.BuildAng = 0

function SWEP:GetViewModelPosition( pos, ang )

	return self.Weapon:MoveViewModelTo( self.HoldPos, self.HoldAng, pos, ang, 1 )
	
end

function SWEP:ReleaseGhost()

	if IsValid( self.GhostEntity ) then

		self.GhostEntity:Remove()
		self.GhostEntity = nil
		
	end
	
end

function SWEP:MakeGhost( model, pos, angle )
	
	self.GhostEntity = ents.CreateClientProp( model )
	//self.GhostEntity:SetModel( model )
	self.GhostEntity:SetPos( pos )
	self.GhostEntity:SetAngles( angle )
	self.GhostEntity:Spawn()
	
	self.GhostEntity:SetSolid( SOLID_VPHYSICS )
	self.GhostEntity:SetMoveType( MOVETYPE_NONE )
	self.GhostEntity:SetNotSolid( true )
	self.GhostEntity:SetRenderMode( RENDERMODE_TRANSALPHA )
	self.GhostEntity:SetColor( Color( 255, 255, 255, 200 ) )
	
end

function SWEP:UpdateGhost()

	if not IsValid( self.GhostEntity ) then return end
	
	local tr = util.GetPlayerTrace( self.Owner )
	local trace = util.TraceLine( tr )
	
	if not trace.Hit then return end
	
	local ang = trace.HitNormal:Angle()
	ang.p = ang.p + 90
	local pos = trace.HitPos
	
	local trlength = self.Weapon:GetOwner():GetPos() - trace.HitPos
	trlength = trlength:Length() 
	
	if trlength < 150 and ( trace.HitWorld ) then
	
		self.GhostEntity:SetColor( Color( 50, 255, 50, 200 ) )
		
	else
	
		self.GhostEntity:SetColor( Color( 255, 50, 50, 200 ) )
		
	end
	
	if not trace.HitWorld then
	
		self.GhostEntity:SetColor( Color( 255, 50, 50, 200 ) )
		self.GhostEntity:SetModel( self.Barricade )
		self.GhostEntity:SetPos( pos + ( self.GhostEntity:GetUp() ) )
		self.GhostEntity:SetAngles( ang )
		
	else
	
		self.GhostEntity:SetModel( self.Barricade )
		self.GhostEntity:SetPos( pos + ( self.GhostEntity:GetUp() ) )
		self.GhostEntity:SetAngles( ang )
		
	end
	
end

function SWEP:SetPlacePosition( ent )

	local tr = util.GetPlayerTrace( self:GetOwner() )
	local trace = util.TraceLine( tr )
	
	if not trace.Hit then return end
	
	local ang = ( trace.HitNormal * -1 ):Angle()
	ent:SetAngles( ang )
	
	local pos = trace.HitPos 
	ent:SetPos( pos + ( ent:GetUp() * self.Position ) )
	
	local phys = ent:GetPhysicsObject()
	
	if IsValid( phys ) then
	
		phys:EnableMotion( false )
		
	end

end

function SWEP:Deploy()

	if SERVER then
	
		self.Owner:DrawViewModel( true )
		self.Owner:NoticeOnce( "Change traps by pressing your alternate fire button", GAMEMODE.Colors.Blue, 5, 2 )
		self:Check()
	end
	
	self.InIron = false

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end  

function SWEP:Holster()

	if CLIENT then
	
		self.Weapon:ReleaseGhost()
	
	end
	
	return true

end

function SWEP:Check()

		if self.Mine then
			self.Owner:Notice( "Ready to build Mine", GAMEMODE.Colors.White )
			
		elseif self.Firebomb then
			self.Owner:Notice( "Ready to build Fire Bomb", GAMEMODE.Colors.White )

		elseif self.Zyklone then
			self.Owner:Notice( "Ready to build Zyklone Trap", GAMEMODE.Colors.White )		

		elseif self.BearTrap then
			self.Owner:Notice( "Ready to build B.E.A.R. Trap", GAMEMODE.Colors.White )		

		else 
			self.Owner:Notice( "Ready to build Coolant Trap", GAMEMODE.Colors.White )	
			
		end

end

function SWEP:SecondaryAttack()

	if CLIENT then return end
		
	if ( self.SecondDelay or 0 ) < CurTime() then
	
		self.SecondDelay = CurTime() + 0.25
		if self.Mine then
			self.Owner:Notice( "Fire Bomb selected", GAMEMODE.Colors.White )
			self.Mine = false
			self.Firebomb = true
			
		elseif self.Firebomb then
		
			self.Owner:Notice( "Zyklone Trap selected", GAMEMODE.Colors.White )
			self.Firebomb = false
			self.Zyklone = true
			
		elseif self.Zyklone then
		
			self.Owner:Notice( "B.E.A.R. Trap selected", GAMEMODE.Colors.White )		
			self.Zyklone = false
			self.BearTrap = true
			
		elseif self.BearTrap then
		
			self.Owner:Notice( "Coolant Trap selected", GAMEMODE.Colors.White )		
			self.BearTrap = false
			self.Coolant = true
			
		else 
			self.Owner:Notice( "Mine selected", GAMEMODE.Colors.White )	
			self.Coolant = false
			self.Zyklone = false
			self.Firebomb = false
			self.Beartrap = false
			self.Mine = true
			
		end
		
		self.Owner:EmitSound( self.Click )
		
	end
	
end

function SWEP:PrimaryAttack()

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:BarricadeTrace()
	
end

function SWEP:BarricadeTrace()

	if CLIENT then return end

	local trace = util.GetPlayerTrace( self.Owner )
	local tr = util.TraceLine( trace )
	local trlength = self.Weapon:GetOwner():GetPos() - tr.HitPos
	trlength = trlength:Length() 
	
	local has, id = self.Owner:GetWood()
	
	if not has then
	
		self.Owner:Notice( "You don't have enough wood", GAMEMODE.Colors.Red )
		self.Owner:EmitSound( self.Deny, 50, 100 )
		
		return
	
	end
	
	if tr.HitWorld and trlength < 150 then
	
		if self.Mine then
		
			self.Owner:Notice( "Built a Mine using 1 piece of wood", GAMEMODE.Colors.Green )
			local prop = ents.Create( "trap_mine" )
			self.Weapon:SetPlacePosition( prop )
			prop:SetSolid( SOLID_VPHYSICS )
			prop:SetOwner( self.Owner )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetAngles( Angle(0,0,0) )
			prop:SetNotSolid( true )
			prop:SetRenderMode( RENDERMODE_NORMAL )
			prop:SetPos( tr.HitPos )
			prop:SetColor( Color( 255, 255, 255, 200 ) )
			prop:Spawn()
			prop:SetCustomCollisionCheck()
		
		elseif self.Firebomb then

			self.Owner:Notice( "Built a Fire Bomb using 1 piece of wood", GAMEMODE.Colors.Green )
			local prop = ents.Create( "trap_fire" )
			self.Weapon:SetPlacePosition( prop )
			prop:SetSolid( SOLID_VPHYSICS )
			prop:SetOwner( self.Owner )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetNotSolid( true )
			prop:SetRenderMode( RENDERMODE_NORMAL )
			prop:SetPos( tr.HitPos + Vector(0,0,4))
			prop:SetColor( Color( 255, 255, 255, 200 ) )
			prop:Spawn()
			prop:SetCustomCollisionCheck()
		
		elseif self.Zyklone then
		
			self.Owner:Notice( "Built a Zyklone Trap using 1 piece of wood", GAMEMODE.Colors.Green )
			local prop = ents.Create( "trap_zyklone" )
			self.Weapon:SetPlacePosition( prop )
			prop:SetOwner( self.Owner )
			prop:SetSolid( SOLID_VPHYSICS )			
			prop:SetAngles( Angle(0,0,180) )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetNotSolid( true )
			prop:SetRenderMode( RENDERMODE_NORMAL )
			prop:SetPos( tr.HitPos + Vector(0,0,10))
			prop:SetColor( Color( 255, 255, 255, 200 ) )
			prop:Spawn()
			prop:SetCustomCollisionCheck()
			
		elseif self.BearTrap then
		
			self.Owner:Notice( "Built a B.E.A.R. Trap using 1 piece of wood", GAMEMODE.Colors.Green )
			local prop = ents.Create( "trap_bear" )
			self.Weapon:SetPlacePosition( prop )
			prop:SetSolid( SOLID_VPHYSICS )			
			prop:SetOwner( self.Owner )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetNotSolid( true )
			prop:SetAngles( Angle(0,0,0))
			prop:SetRenderMode( RENDERMODE_NORMAL )
			prop:SetPos( tr.HitPos )
			prop:SetColor( Color( 255, 255, 255, 200 ) )
			prop:Spawn()
			prop:SetCustomCollisionCheck()
		
		elseif self.Coolant then
		
			self.Owner:Notice( "Built a Coolant Trap using 1 piece of wood", GAMEMODE.Colors.Green )
			local prop = ents.Create( "trap_cool" )
			self.Weapon:SetPlacePosition( prop )
			prop:SetOwner( self.Owner )
			prop:SetSolid( SOLID_VPHYSICS )
			prop:SetMoveType( MOVETYPE_NONE )
			prop:SetNotSolid( true )
			prop:SetRenderMode( RENDERMODE_NORMAL )
			prop:SetPos( tr.HitPos + Vector(0,0,4))
			prop:SetColor( Color( 255, 255, 255, 200 ) )
			prop:Spawn()
			prop:SetCustomCollisionCheck()
		
		else
			self.Owner:Notice( "No trap selected, right click to select one", GAMEMODE.Colors.Red )

		end
		
	else
		self.Owner:Notice( "You can't build a trap here", GAMEMODE.Colors.Red )
		self.Owner:EmitSound( self.Deny, 50, 100 )
		
		return 
		
	end 
	 
	self.Owner:AddStamina( -25 )
	self.Owner:RemoveFromInventory( id )
	self.Owner:AddStat( "Wood" )
	
	self.Owner:EmitSound( table.Random( GAMEMODE.Drill ), 100, math.random(90,110) )
	self.Owner:EmitSound( table.Random( GAMEMODE.WoodHammer ), 100, math.random(90,110) )

end 

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 64
	
	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = self.Owner
	
	local linetr = util.TraceLine( line )
	
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mask = MASK_SHOT_HULL
	tr.mins = Vector(-20,-20,-20)
	tr.maxs = Vector(20,20,20)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if not IsValid( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(60,80) )
		return 
		
	elseif not ent:IsWorld() then
	
		self.Weapon:SendWeaponAnim( ACT_VM_HITCENTER )
		
		if ent:IsPlayer() then 
			
			local snd = table.Random( GAMEMODE.BluntHit )
			ent:EmitSound( snd, 100, math.random(90,110) )
			
			if ent:Team() != self.Owner:Team() then
		
				ent:TakeDamage( dmg, self.Owner, self.Weapon )
			
				self.Owner:DrawBlood()
			
				local ed = EffectData()
				ed:SetOrigin( trace.HitPos )
				util.Effect( "BloodImpact", ed, true, true )
				
			end
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			local snd = table.Random( GAMEMODE.BluntHit )
			ent:EmitSound( snd, 100, math.random(90,110) )
		
			if math.random(1,3) == 1 then
		
				ent:SetHeadshotter( self.Owner, true )
				
			end
			
			ent:TakeDamage( dmg, self.Owner, self.Weapon )
			
			self.Owner:DrawBlood()
			
			local ed = EffectData()
			ed:SetOrigin( trace.HitPos )
			util.Effect( "BloodImpact", ed, true, true )
		
		elseif !ent:IsPlayer() then 
		
			if string.find( ent:GetClass(), "breakable" ) then
			
				ent:TakeDamage( 50, self.Owner, self.Weapon )
				
				if ent:GetClass() == "func_breakable_surf" then
				
					ent:Fire( "shatter", "1 1 1", 0 )
				
				end
			
			end
		
			ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				if ent.IsWooden then
				
					ent:Fire( "break", 0, 0 )
				
				else
				
					ent:SetPhysicsAttacker( self.Owner )
					ent:TakeDamage( 10, self.Owner, self.Weapon )
					
					phys:Wake()
					phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 200 )
					
				end
				
			end
			
		end
		
	end

end

function SWEP:Think()	

	if CLIENT then
		
			if not self.GhostEntity then
				
				self.Weapon:MakeGhost( self.Barricade, self.Owner:GetPos() + Vector(0,0,100), Angle(0,0,0))
				
			else
				
				self.Weapon:UpdateGhost()
				
			end
			
		elseif IsValid( self.GhostEntity ) then
		
			self.Weapon:ReleaseGhost()
		
		end
	


	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) then
		
			self.LastRunFrame = CurTime() + 0.3
		
		end
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
		
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
	
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
		
	end

end

function SWEP:DrawHUD()
	
end
