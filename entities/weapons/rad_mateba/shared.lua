if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "Mateba Autorevolver"
	SWEP.IconLetter = "k"
	SWEP.Slot = 2
	SWEP.Slotpos = 25
	
end

SWEP.HoldType = "revolver"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_pist_mateba.mdl"
SWEP.WorldModel = "models/weapons/w_357.mdl"

SWEP.SprintPos = Vector (0, 0, -10)
SWEP.SprintAng = Vector (40, 0, 0)

SWEP.IsSniper = false
SWEP.AmmoType = "Buckshot"

SWEP.Primary.Sound			= Sound( "weapons/shotgun/shotgun_fire6.wav" )
SWEP.Primary.Recoil			= 10
SWEP.Primary.Damage			= 9
SWEP.Primary.NumShots		= 6
SWEP.Primary.Cone			= 0.085
SWEP.Primary.Delay			= 0.300

SWEP.Primary.ClipSize		= 6
SWEP.Primary.Automatic		= false

function SWEP:PrimaryAttack()

	if not self.Weapon:CanPrimaryAttack() then 
		
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.5 )
		return 
		
	end

	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(95,105) )
	self.Weapon:ShootBullets( self.Primary.Damage, self.Primary.NumShots, self.Primary.Cone, self.Weapon:GetZoomMode() )
	self.Weapon:TakePrimaryAmmo( 1 )
	self.Weapon:ShootEffects()
	
	if self.Weapon:GetZoomMode() > 1 then
	
		self.Weapon:UnZoom()
	
	end
	
	if SERVER then
	
		self.Owner:AddAmmo( self.AmmoType, -1 )
		self.Owner:ViewBounce( 30 )  
		
	end

end

