if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then
	
	SWEP.ViewModelFlip = true
	
	SWEP.ViewModelFOV = 70
	
	SWEP.PrintName = "HNH-18"
	SWEP.IconLetter = "m"
	SWEP.Slot = 4
	SWEP.Slotpos = 12
	
end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.UseHands = true

SWEP.ViewModel = "models/weapons/v_rif_gug.mdl"
SWEP.WorldModel = "models/weapons/w_rif_sg552.mdl"

//SWEP.SprintPos = Vector (4.9288, -2.4157, -0.2032)
//SWEP.SprintAng = Vector (-2, 1, 18.0526)

SWEP.SprintPos = Vector (0, -1, 2)
SWEP.SprintAng = Vector (-20, -20, 0)

//SWEP.SprintPos = Vector(0.55, -5.119, -1.025)
//SWEP.SprintAng = Vector(7.44, 25.079, 16.26)

SWEP.IsSniper = false
SWEP.AmmoType = "Syringe"
SWEP.LaserOffset = Angle( -90, -0.9, 0 )
SWEP.LaserScale = 0.25
//SWEP.IronsightsFOV = 60

SWEP.Healed					= Sound( "weapons/slam/mine_mode.wav" )
SWEP.Primary.Sound			= Sound( "weapons/airboat/airboat_gun_lastshot1.wav" )
SWEP.Primary.Sound2			= Sound( "weapons/fx/nearmiss/bulletltor11.wav" )
SWEP.Primary.Recoil			= 19.5
SWEP.Primary.Damage			= 0
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0
SWEP.Primary.Delay			= 0.2

SWEP.Primary.ClipSize		= 4
SWEP.Primary.Automatic		= false

function SWEP:ShootEffects()	

	if IsFirstTimePredicted() then
	
		self.Owner:ViewPunch( Angle( math.Rand( -0.2, -0.1 ) * self.Primary.Recoil, math.Rand( -0.05, 0.05 ) * self.Primary.Recoil, 0 ) )
		
	end
	
	self.Owner:MuzzleFlash()								
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK ) 
	
end

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(90,100) )
	self.Weapon:EmitSound( self.Primary.Sound2, 100, math.random(120,130) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		
	end

end

function SWEP:ShootBullets( damage, numbullets, aimcone, zoommode )

	if SERVER then
	
		self.Owner:AddStat( "Bullets", numbullets )
	
	end
		
	local bullet = {}
	bullet.Num 		= numbullets
	bullet.Src 		= self.Owner:GetShootPos()			
	bullet.Dir 		= self.Owner:GetAimVector()			
	bullet.Spread 	= Vector( scale, scale, 0 )		
	bullet.Tracer	= 1
	bullet.Force	= 0						
	bullet.Damage	= 0
	bullet.AmmoType = "Pistol"
	bullet.TracerName = "AirboatGunHeavyTracer"
	
	bullet.Callback = function ( attacker, tr, dmginfo )

		if IsValid( tr.Entity ) and IsValid( self ) and IsValid( self.Owner ) and SERVER then
		
			if tr.Entity:IsPlayer() and tr.Entity:Team() == TEAM_ARMY then
			
				tr.Entity:AddHealth( 25 )
				tr.Entity:EmitSound( self.Healed, 100, math.random(90,110) )
				tr.Entity:Notice( "+25 HP", GAMEMODE.Colors.Blue, 5 )
				
			end
			
			if tr.Entity.NextBot then
			
				tr.Entity:SetHealth( tr.Entity:Health() * 0.66 )
				tr.Entity:EmitSound( self.Healed, 100, math.random(90,110) )
				
			end
				
		end
		
		local ed = EffectData()
		ed:SetOrigin( tr.HitPos )
		ed:SetNormal( tr.HitNormal )
		util.Effect( "balloon_pop ", ed, true, true )

	end
	
	self.Owner:FireBullets( bullet )
	
end
