if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "PP Bizon"
	SWEP.IconLetter = "q"
	SWEP.Slot = 3
	SWEP.Slotpos = 23
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_biz.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector (-1.0859, -4.2523, -1.1534)
SWEP.SprintAng = Vector (-4.8822, -38.3984, 14.6527)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_Fiveseven.Single" )
SWEP.Primary.Recoil			= 7.5
SWEP.Primary.Damage			= 15
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.045
SWEP.Primary.Delay			= 0.100

SWEP.Primary.ClipSize		= 64
SWEP.Primary.Automatic		= true
