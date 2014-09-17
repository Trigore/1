if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 52
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Face Punchers"
	SWEP.IconLetter = "j"
	SWEP.Slot = 1
	SWEP.Slotpos = 5
	
end

SWEP.HoldType = "fist"

SWEP.Base = "rad_base"

SWEP.ViewModel	= "models/weapons/c_arms_citizen.mdl"

SWEP.HoldPos = Vector (1.1747, -16.6759, -5.7913)
SWEP.HoldAng = Vector (23.7548, -8.0105, -5.154)

SWEP.IsSniper = false
SWEP.AmmoType = "Knife"
SWEP.UseHands	= true

SWEP.Primary.Hit            = Sound( "Flesh.ImpactHard" )
SWEP.Primary.Sound			= Sound( "weapons/slam/throw.wav" )
SWEP.Primary.Recoil			= 9.5
SWEP.Primary.Damage			= 100
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 0.8
SWEP.Delay = 0

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true

function SWEP:Initialize()

	self:SetHoldType( "fist" )

end

function SWEP:PreDrawViewModel( vm, wep, ply )

	vm:SetMaterial( "engine/occlusionproxy" ) -- Hide that view model with hacky material

end

function SWEP:SecondaryAttack()
	if self.Delay < CurTime() then
		self:PrimaryAttack( true )
		self.Delay = CurTime() + 0.8
	end
end

function SWEP:PrimaryAttack( right )

	if SERVER then
	
		self.Owner:AddStamina( -4 )
	
	end
	local anim = "fists_left"
	if ( right ) then anim = "fists_right" end
	self.Owner:SetAnimation( PLAYER_ATTACK1 )	
	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Weapon:MeleeTrace( self.Primary.Damage )
	
end

function SWEP:Think()	

	if self.Owner:GetVelocity():Length() > 0 then
	
		if self.Owner:KeyDown( IN_SPEED ) then
		
			self.LastRunFrame = CurTime() + 0.3
		
		end
		
		if self.Weapon:GetZoomMode() != 1 then
		
			self.Weapon:UnZoom()
			
		end
		
	end
	
	if self.MoveTime and self.MoveTime < CurTime() and SERVER then
	
		self.MoveTime = nil
		self.Weapon:SetZoomMode( self.Weapon:GetZoomMode() + 1 )
		self.Owner:DrawViewModel( false )
		
	end
	
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()

end

function SWEP:MeleeTrace( dmg )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 64
	
	local line = {}
	line.start = pos
	line.endpos = pos + aim
	line.filter = self.Owner
	
	local linetr = util.TraceLine( line )
	
	local tr = {}
	tr.start = pos + self.Owner:GetAimVector() * -5
	tr.endpos = pos + aim
	tr.filter = self.Owner
	tr.mask = MASK_SHOT_HULL
	tr.mins = Vector(-20,-20,-20)
	tr.maxs = Vector(20,20,20)

	local trace = util.TraceHull( tr )
	local ent = trace.Entity
	local ent2 = linetr.Entity
	
	if not IsValid( ent ) and IsValid( ent2 ) then
	
		ent = ent2
	
	end

	if not IsValid( ent ) then 
		
		self.Owner:EmitSound( self.Primary.Sound, 100, math.random(60,80) )
		return 
		
	elseif not ent:IsWorld() then
	
		if ent:IsPlayer() then 
			
			local snd = self.Primary.Hit 
			ent:EmitSound( snd, 100, math.random(90,110) )
			
			if ent:Team() != self.Owner:Team() then
		
				ent:TakeDamage( dmg, self.Owner, self.Weapon )
			
				self.Owner:DrawBlood()
			
				local ed = EffectData()
				ed:SetOrigin( trace.HitPos )
				util.Effect( "BloodImpact", ed, true, true )
				
			end
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			ent:SetHeadshotter( self.Owner, true )
			ent:TakeDamage( dmg, self.Owner, self.Weapon )
			if ent:Health() < 200 then
				ent:OnKilled( dmginfo )
				local snd = table.Random( GAMEMODE.GoreSplash )
				ent:EmitSound( snd, 90, math.random( 60, 80 ) )
				
				local effectdata = EffectData()
				effectdata:SetOrigin( ent:GetPos() + Vector(0,0,20) )
				util.Effect( "body_gib", effectdata, true, true )
				
				local ed = EffectData()
				ed:SetOrigin( ent:GetPos() )
				util.Effect( "gore_explosion", ed, true, true )
				
				self.Owner:AddStat( "Explode" )
				
				local corpse = table.Random( GAMEMODE.Corpses )
				ent:SpawnRagdoll( dmginfo, corpse )
			end
			local snd = self.Primary.Hit 
			ent:EmitSound( snd, 100, math.random(90,110) )
			
			self.Owner:DrawBlood()
			
			local ed = EffectData()
			ed:SetOrigin( trace.HitPos )
			util.Effect( "BloodImpact", ed, true, true )
		
		elseif !ent:IsPlayer() then 
		
			if string.find( ent:GetClass(), "breakable" ) then
			
				ent:TakeDamage( 50, self.Owner, self.Weapon )
				
				if ent:GetClass() == "func_breakable_surf" then
				
					ent:Fire( "shatter", "1 1 1", 0 )
				
				end
			
			end
		
			ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				if ent.IsWooden then
				
					ent:Fire( "break", 0, 0 )
				
				else
				
					ent:SetPhysicsAttacker( self.Owner )
					ent:TakeDamage( 10, self.Owner, self.Weapon )
					
					phys:Wake()
					phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 200 )
					
				end
				
			end
			
		end
		
	end

end

function SWEP:DrawHUD()
	
end

function SWEP:OnRemove()
	
	if ( IsValid( self.Owner ) && CLIENT && self.Owner:IsPlayer() ) then
		local vm = self.Owner:GetViewModel()
		if ( IsValid( vm ) ) then vm:SetMaterial( "" ) end
	end
	
end

function SWEP:Holster( wep )

	self:OnRemove()

	return true

end

function SWEP:Deploy()

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "fists_draw" ) )
	
	
	return true

end
