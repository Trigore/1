if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "KRISS Vector"
	SWEP.IconLetter = "x"
	SWEP.Slot = 3
	SWEP.Slotpos = 27
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_smg_kis.mdl"
SWEP.WorldModel = "models/weapons/w_smg_p90.mdl"

SWEP.SprintPos = Vector (2.0027, -0.751, 0.1411)
SWEP.SprintAng = Vector (-1.2669, -27.7284, 10.4434)

SWEP.IsSniper = false
SWEP.AmmoType = "SMG"

SWEP.Primary.Sound			= Sound( "Weapon_P228.Single" )
SWEP.Primary.Recoil			= 15
SWEP.Primary.Damage			= 40
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.010
SWEP.Primary.Delay			= 0.055

SWEP.Primary.ClipSize		= 20
SWEP.Primary.Automatic		= true
