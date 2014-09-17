if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "HK MP5K"
	SWEP.IconLetter = "x"
	SWEP.Slot = 3
	SWEP.Slotpos = 2
	
end

SWEP.HoldType = "smg"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/v_mpi_mp5.mdl"
SWEP.WorldModel = "models/weapons/w_smg_mp5.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, 21.9362, 0.0001)

SWEP.IsSniper = false
SWEP.AmmoType = "Pistol"

SWEP.Primary.Sound			= Sound( "Weapon_MP5Navy.Single" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.025
SWEP.Primary.Delay			= 0.055

SWEP.Primary.ClipSize		= 32
SWEP.Primary.Automatic		= true
