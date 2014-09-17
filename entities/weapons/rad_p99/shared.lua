if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "P99"
	SWEP.IconLetter = "a"
	SWEP.Slot = 2
	SWEP.Slotpos = 23
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_p99.mdl"
SWEP.WorldModel = "models/weapons/w_pist_usp.mdl"

SWEP.SprintPos = Vector (1.3846, -0.6033, -7.1994)
SWEP.SprintAng = Vector (33.9412, 15.0662, 6.288)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_USP.Single" )
SWEP.Primary.Recoil			= 5.5
SWEP.Primary.Damage			= 28
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.035
SWEP.Primary.Delay			= 0.1

SWEP.Primary.ClipSize		= 13
SWEP.Primary.Automatic		= false
