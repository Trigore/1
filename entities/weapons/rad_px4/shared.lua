if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Beretta PX4"
	SWEP.IconLetter = "y"
	SWEP.Slot = 2
	SWEP.Slotpos = 20
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_bpx4.mdl"
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"

SWEP.SprintPos = Vector (1.3846, -0.6033, -7.1994)
SWEP.SprintAng = Vector (33.9412, 15.0662, 6.288)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Elite.Single" )
SWEP.Primary.Recoil			= 6.0
SWEP.Primary.Damage			= 25
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 17
SWEP.Primary.Automatic		= false
