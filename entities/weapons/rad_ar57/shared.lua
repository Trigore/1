if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip = true
	
	SWEP.PrintName = "AR-57"
	SWEP.IconLetter = "l"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_ar5.mdl"
SWEP.WorldModel			= "models/weapons/w_rif_m4a1.mdl"

SWEP.SprintPos = Vector(-4.7699, -7.2246, -2.8428)
SWEP.SprintAng = Vector(4.4604, -47.001, 6.8488)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.LaserOffset = Angle( 39.9, -50, -90 )
SWEP.LaserScale = 0.75

SWEP.Primary.Sound			= Sound( "Weapon_USP.SilencedShot" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.060

SWEP.Primary.ClipSize		= 40
SWEP.Primary.Automatic		= true

function SWEP:PrimaryAttack()		                
        timer.Create("burst", 0.1, 5, function() 		
			if not self:CanPrimaryAttack() then return nil end		
			self:EmitSound("Weapon_USP.SilencedShot")
            self:ShootBullet( 40, 1, 0.030 )
			if SERVER then
			self.Owner:AddAmmo( self.AmmoType, self.Primary.NumShots * -1 )
			end
			self.Weapon:SetClip1( self.Weapon:Clip1() - self.Primary.NumShots )	
			self.Weapon:ShootEffects() end)
end
