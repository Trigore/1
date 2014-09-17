if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFlip		= true
	
	SWEP.PrintName = "USAS-12"
	SWEP.IconLetter = "B"
	SWEP.Slot = 3
	SWEP.Slotpos = 11
	
end

SWEP.HoldType = "shotgun"

SWEP.Base = "rad_base"

SWEP.ViewModel = "models/weapons/v_shot_usas12.mdl"
SWEP.WorldModel = "models/weapons/w_shot_xm1014.mdl"

SWEP.SprintPos = Vector(-0.6026, -2.715, 0.0137)
SWEP.SprintAng = Vector(-3.4815, -21.9362, 0.0001)

SWEP.IsSniper = false
SWEP.AmmoType = "Buckshot"

SWEP.Primary.Sound			= Sound( "Weapon_XM1014.Single" )
SWEP.Primary.Recoil			= 10
SWEP.Primary.Damage			= 30
SWEP.Primary.NumShots		= 6
SWEP.Primary.Cone			= 0.1
SWEP.Primary.Delay			= 0.2

SWEP.Primary.ClipSize		= 8
SWEP.Primary.Automatic		= true

function SWEP:Deploy()

	self.Weapon:SetNWBool( "Reloading", false )
	self.Weapon:SetVar( "PumpTime", 0 )
	self.Weapon:SetNextPrimaryFire( CurTime() + 0.3 )

	if SERVER then
	
		self.Weapon:SetZoomMode( 1 )
		
	end	
	
	self.InIron = false

	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	
	return true
	
end 

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
		
	end

end

function SWEP:ReloadThink()

	if self.ReloadTime and self.ReloadTime <= CurTime() then
	
		self.ReloadTime = nil
		self.Weapon:SetClip1( self.Primary.ClipSize )
		self.Weapon:SendWeaponAnim( ACT_SHOTGUN_RELOAD_FINISH )	
	end

end

function SWEP:DrawHUD()

	if self.Weapon:ShouldNotDraw() then return end

	if not self.IsSniper and not self.Owner:GetNWBool( "InIron", false ) then
	
		local x = ScrW() * 0.5
		local y = ScrH() * 0.5
		local scalebywidth = ( ScrW() / 1024 ) * 10
		local scale = self.Primary.Cone
		
		if self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) then
		
			scale = self.Primary.Cone * 1.75
			
		elseif self.Owner:KeyDown( IN_DUCK ) or self.Owner:KeyDown( IN_WALK ) then
		
			scale = math.Clamp( self.Primary.Cone / 1.25, 0, 10 )
			
		end
		
		scale = scale * scalebywidth
		
		local dist = math.abs( self.CrosshairScale - scale )
		self.CrosshairScale = math.Approach( self.CrosshairScale, scale, FrameTime() * 2 + dist * 0.05 )
		
		local gap = 40 * self.CrosshairScale
		local length = gap + self.CrossLength:GetInt()
		
		surface.SetDrawColor( self.CrossRed:GetInt(), self.CrossGreen:GetInt(), self.CrossBlue:GetInt(), self.CrossAlpha:GetInt() )
		surface.DrawLine( x - length, y, x - gap, y )
		surface.DrawLine( x + length, y, x + gap, y )
		surface.DrawLine( x, y - length, x, y - gap )
		surface.DrawLine( x, y + length, x, y + gap )
	
	end
	
end
