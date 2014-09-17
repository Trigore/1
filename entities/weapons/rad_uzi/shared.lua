if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "IMI UZI"
	SWEP.IconLetter = "l"
	SWEP.Slot = 3
	SWEP.Slotpos = 21
	
end

SWEP.HoldType = "pistol"

SWEP.Base = "rad_base"

SWEP.ViewModel			= "models/weapons/v_smg_mac11.mdl"
SWEP.WorldModel			= "models/weapons/w_smg_mac10.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, 21.9362, 0.0001)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_mac10.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.050
SWEP.Primary.Delay			= 0.080

SWEP.Primary.ClipSize		= 32
SWEP.Primary.Automatic		= true
