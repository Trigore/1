if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "M92 Raffica"
	SWEP.IconLetter = "y"
	SWEP.Slot = 2
	SWEP.Slotpos = 21
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_m92.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.SprintPos = Vector (1.3846, -0.6033, -7.1994)
SWEP.SprintAng = Vector (33.9412, 15.0662, 6.288)


SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Elite.Single" )
SWEP.Primary.Recoil			= 7.0
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 18
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()		                
        timer.Create("burst", 0.1, 3, function() 		
			if not self:CanPrimaryAttack() then return nil end		
			self:EmitSound("Weapon_P228.Single")
            self:ShootBullet( 30, 1, 0.005 )
			if SERVER then
			self.Owner:AddAmmo( self.AmmoType, self.Primary.NumShots * -1 )
			end
			self.Weapon:SetClip1( self.Weapon:Clip1() - self.Primary.NumShots )	
			self.Weapon:ShootEffects() end)
end

