if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "AK-74U"
	SWEP.IconLetter = "x"
	SWEP.Slot = 3
	SWEP.Slotpos = 24
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg_aks.mdl"
SWEP.WorldModel = "models/weapons/w_rif_ak47.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, -21.9362, 0.0001)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_Galil.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 50
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.060
SWEP.Primary.Delay			= 0.085

SWEP.Primary.ClipSize		= 30
SWEP.Primary.Automatic		= true
