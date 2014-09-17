if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Browning HP"
	SWEP.IconLetter = "f"
	SWEP.Slot = 2
	SWEP.Slotpos = 27
	
end

SWEP.HoldType = "revolver"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_pist_brhp.mdl"
SWEP.WorldModel = "models/weapons/w_pist_deagle.mdl"

SWEP.SprintPos = Vector (-4.2232, -5.1203, -2.0386)
SWEP.SprintAng = Vector (12.7496, -52.6848, -7.5206)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_Deagle.Single" )
SWEP.Primary.Recoil			= 8.5
SWEP.Primary.Damage			= 38
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.020
SWEP.Primary.Delay			= 0.280

SWEP.Primary.ClipSize		= 7
SWEP.Primary.Automatic		= false