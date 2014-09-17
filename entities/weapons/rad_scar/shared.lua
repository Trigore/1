if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "FN SCAR"
	SWEP.IconLetter = "v"
	SWEP.Slot = 4
	SWEP.Slotpos = 25

end

SWEP.HoldType = "ar2"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_rif_scar.mdl"
SWEP.WorldModel = "models/weapons/w_rif_galil.mdl"

SWEP.SprintPos = Vector(-2.7699, -2.2246, -2.8428)
SWEP.SprintAng = Vector(4.4604, -47.001, 6.8488)

SWEP.IsSniper = false
SWEP.AmmoType = "Rifle"

SWEP.Primary.Sound			= Sound( "Weapon_SG550.Single" )
SWEP.Primary.Recoil			= 6.5
SWEP.Primary.Damage			= 65
SWEP.Primary.NumShots		= 1
SWEP.Primary.Cone			= 0.030
SWEP.Primary.Delay			= 0.09

SWEP.Primary.ClipSize		= 20
SWEP.Primary.Automatic		= true
