if SERVER then

	AddCSLuaFile("shared.lua")
	
end

if CLIENT then

	SWEP.ViewModelFOV		= 70
	SWEP.ViewModelFlip		= false
	
	SWEP.PrintName = "Claws"
	SWEP.IconLetter = "C"
	SWEP.Slot = 0
	SWEP.Slotpos = 0
	
	killicon.AddFont( "rad_z_banshee", "CSKillIcons", SWEP.IconLetter, Color( 255, 80, 0, 255 ) )
	
end

SWEP.Base = "rad_z_base"

SWEP.Taunt = Sound( "npc/stalker/go_alert2a.wav" )

SWEP.Die = { "npc/headcrab_poison/ph_scream1.wav",
"npc/headcrab_poison/ph_scream2.wav",
"npc/headcrab_poison/ph_scream3.wav"}

SWEP.Primary.Hit            = Sound( "npc/antlion/shell_impact3.wav" )
SWEP.Primary.HitFlesh		= Sound( "npc/antlion/foot4.wav" )
SWEP.Primary.Sound			= Sound( "npc/zombie/zo_attack1.wav" )
SWEP.Primary.Recoil			= 3.5
SWEP.Primary.Damage			= 200
SWEP.Primary.NumShots		= 1
SWEP.Primary.Delay			= 1.900

SWEP.Primary.ClipSize		= 1
SWEP.Primary.Automatic		= true


function SWEP:Holster()

	if SERVER then
	
		self.Owner:EmitSound( table.Random( self.Die ), 100, math.random(40,60) )
	
	end
	
	return true

end

function SWEP:SecondaryAttack()

	self.Weapon:SetNextSecondaryFire( CurTime() + 8 )
	
	if SERVER then
	
		self.Owner:VoiceSound( self.Taunt, 100, math.random( 90, 100 ) )
		
		local tbl = ents.FindByClass( "npc_hum_blackwatch" ) 
		tbl = table.Add( tbl, ents.FindByClass( "npc_nb*" ) )
		tbl = table.Add( tbl, ents.FindByClass( "npc_hum_anarchist" ) )
	
		for k,v in pairs( tbl ) do
		
			local dist = v:GetPos():Distance( self.Owner:GetPos() )
			
			if dist <= 350 then
			
				local scale = 1 - ( dist / 350 )
				local count = math.Round( scale * 4 )
				
				
				v:TakeDamage( scale * 50, self.Owner, self.Weapon )
				
			
			end
		
		end
	
	end

end
	
function SWEP:MeleeTrace( dmg )
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Weapon:SendWeaponAnim( ACT_VM_MISSCENTER )
	
	if CLIENT then return end
	
	self.Weapon:SetNWString( "CurrentAnim", "zattack" .. math.random(1,3) )
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	
	local pos = self.Owner:GetShootPos()
	local aim = self.Owner:GetAimVector() * 80
	
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
		
		self.Owner:EmitSound( self.Primary.Miss, 100, math.random(90,110) )
		
		return 
		
	elseif not ent:IsWorld() then
		
		if ent:IsPlayer() and ent:Team() == TEAM_ARMY then 		
		if ent:GetRadiation() > 0 then
		ent:AddRadiation( -1 )
		self.Owner:AddHealth( 20 )
		self.Owner:AddEXP( 500 )
		self.Owner:Notice( "You absorbed your teammate's radiation", GAMEMODE.Colors.Green )
		end
			
		elseif string.find( ent:GetClass(), "npc" ) then
		
			ent:TakeDamage( 200, self.Owner, self.Weapon )
			ent:EmitSound( self.Primary.HitFlesh, 100, math.random(90,110) )
			self.Owner:AddHealth( 25 ) 
		

		
		elseif !ent:IsPlayer() then 
			
			local phys = ent:GetPhysicsObject()
			
			if IsValid( phys ) then
			
				ent:SetPhysicsAttacker( self.Owner )
				ent:EmitSound( self.Primary.Hit, 100, math.random(90,110) )
				
				if ent.IsWood then
				
					ent:TakeDamage( 75, self.Owner, self.Weapon )
					ent:EmitSound( self.Primary.Door )
				
				else
				
					ent:TakeDamage( 25, self.Owner, self.Weapon )
				
				end
				
				if ent:GetClass() != "sent_antidote" then
				phys:Wake()
				phys:ApplyForceCenter( self.Owner:GetAimVector() * phys:GetMass() * 400 )
				end
			end
			
		end
		
	end

end

function SWEP:PrimaryAttack()
	
	self.Weapon:EmitSound( self.Primary.Sound, 100, math.random(130,150) )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.ThinkTime = CurTime() + ( self.Primary.Delay * 0.3 )
	
end


