
// This is the ID given to any item that is an essential supply for every faction
ITEM_ENGI = 23

function FUNC_DROPWEAPON( ply, id, client, icon )

	if icon then return "icon16/arrow_down.png" end
	if client then return "Drop" end
	
	local tbl = item.GetByID( id )
	
	local prop = ents.Create( "sent_droppedgun" )
	prop:SetPos( ply:GetItemDropPos() )
	
	if tbl.DropModel then
			
		prop:SetModel( tbl.DropModel )
				
	else
			
		prop:SetModel( tbl.Model )
				
	end
	
	prop:Spawn()
	
	ply:EmitSound( Sound( "items/ammopickup.wav" ) )
	ply:RemoveFromInventory( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_REMOVEWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	if not ply:HasItem( id ) then
	
		ply:StripWeapon( tbl.Weapon )
		
	end

end

function FUNC_GRABWEAPON( ply, id )

	local tbl = item.GetByID( id )
	
	ply:Give( tbl.Weapon )
	
	return true

end

function FUNC_TECHENERGY( ply, id, client, icon )

	if icon then return "icon16/cup.png" end
	if client then return "Drink" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( table.Random{ "npc/barnacle/barnacle_gulp1.wav", "npc/barnacle/barnacle_gulp2.wav" }, 100, math.random( 90, 110 ) )
	ply:AddStamina( 70 )
	ply:Notice( "+70 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_TECHHEAL( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddHealth( 90 )
	ply:Notice( "+90 Health", GAMEMODE.Colors.Green )

end

function FUNC_SUPERDUPERHEAL( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "HealthVial.Touch" )
	ply:AddHealth( 150 )
	ply:AddStamina( 50 )
	ply:Notice( "+150 Health", GAMEMODE.Colors.Green )
	ply:Notice( "+50 Stamina", GAMEMODE.Colors.Green )

end

function FUNC_TECHBANDAGE( ply, id, client, icon )

	if icon then return "icon16/heart.png" end
	if client then return "Use" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Cardboard.Strain" )
	ply:SetBleeding( false )
	ply:AddHealth( 40 )
	ply:Notice( "+40 Health", GAMEMODE.Colors.Green )
	ply:Notice( "Stopped bleeding", GAMEMODE.Colors.Green )

end

function FUNC_MUTAGEN( ply, id, client, icon )

	if icon then return "icon16/pill.png" end
	if client then return "Inject" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Weapon_SMG1.Special1" )
	
	if ply:IsInfected() then
		
		ply:Notice( "Your infection has been cured", GAMEMODE.Colors.Green, 5, 0 )
		ply:SetInfected( false )
					
	end
	
	local tbl = {}
	local inc = 0
	
	for i=1,math.random(1,3) do
	
		local rand = math.random(1,5)
		
		while table.HasValue( tbl, rand ) do
		
			rand = math.random(1,5)
		
		end
		
		table.insert( tbl, rand )
		
		if rand == 1 then
		
			ply:Notice( "You feel extremely nauseous", GAMEMODE.Colors.Red, 5, inc * 2 )
		
			umsg.Start( "Drunk", ply )
			umsg.Short( math.random( 10, 20 ) )
			umsg.End()
		
		elseif rand == 2 then
		
			local rad = math.random(2,5)
		
			if math.random(1,2) == 1 and ply:GetRadiation() < 1 then
		
				ply:Notice( "+" .. rad .. " Radiation", GAMEMODE.Colors.Red, 5, inc * 2 )
				ply:AddRadiation( rad )
				
			else
			
				ply:Notice( "-" .. rad .. " Radiation", GAMEMODE.Colors.Green, 5, inc * 2 )
				ply:AddRadiation( -rad )
			
			end
		
		elseif rand == 3 then
		
			ply:Notice( "Your whole body aches", GAMEMODE.Colors.Red, 5, inc * 2 )
			
			local dmg = math.random(2,5)
			
			ply:AddHealth( dmg * -10 )
		
		elseif rand == 4 then
		
			if math.random(1,2) == 1 then
		
				ply:Notice( "You feel exhausted", GAMEMODE.Colors.Red, 5, inc * 2 )
				ply:AddStamina( -50 )
				
			else
			
				ply:Notice( "+20 Stamina", GAMEMODE.Colors.Green, 5, inc * 2 )
				ply:AddStamina( 20 )
			
			end
		
		elseif rand == 5 then
		
			ply:Notice( "Your legs begin to feel weak", GAMEMODE.Colors.Red, 5, inc * 2 )
			ply:SetWalkSpeed( GAMEMODE.WalkSpeed - 80 )
			ply:SetRunSpeed( GAMEMODE.RunSpeed - 80 )
			
			local legtime = math.random( 20, 40 )
			
			timer.Simple( legtime - 5, function() if IsValid( ply ) and ply:Team() == TEAM_ARMY then ply:Notice( "Your legs start to feel better", GAMEMODE.Colors.Green, 5 ) end end )
			timer.Simple( legtime, function() if IsValid( ply ) and ply:Team() == TEAM_ARMY then ply:SetWalkSpeed( GAMEMODE.WalkSpeed ) ply:SetRunSpeed( GAMEMODE.RunSpeed ) end end )
		
		end
		
		inc = inc + 1
		
	end

end

item.Register( { 
	Name = "Medical Darts", 
	Description = "10 Darts per capsule.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 0.75, 
	Price = 5,
	Rarity = 0.20,
	Model = "models/gibs/shield_scanner_gib1.mdl",
	Ammo = "Syringe",
	Amount = 10,
	PickupFunction = FUNC_AMMO,
	DropFunction = FUNC_DROPAMMO,
	CamPos = Vector(0,10,10),
	CamOrigin = Vector(1,0,0)	
} )

item.Register( { 
	Name = "Anti-Rad", 
	Description = "Releives all radiation poisoning.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 0.15, 
	Price = 10,
	Rarity = 0.20,
	Model = "models/props_lab/jar01b.mdl",
	Functions = { FUNC_ANTIRAD },
	CamPos = Vector(-17,-9,0),
	CamOrigin = Vector(0,0,-1)	
} )

item.Register( { 
	Name = "Respirator", 
	Description = "Filters out chemicals and radiation.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 1.75, 
	Price = 40,
	Rarity = 0.95,
	Model = "models/items/combine_rifle_cartridge01.mdl",
	CamPos = Vector(13,-14,0),
	CamOrigin = Vector(0,0,-1)	
} )

item.Register( { 
	Name = "Wood", 
	Description = "Used in building barricades.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 1.50, 
	Price = 5,
	Rarity = 0.15,
	Model = "models/props_debris/wood_chunk04a.mdl",
	Functions = {},
	CamPos = Vector(42,15,0),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "Adrenaline Drink", 
	Description = "Restores 70 stamina.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 0.25, 
	Price = 2,
	Rarity = 0.25,
	Model = "models/props_junk/popcan01a.mdl",
	Functions = { FUNC_TECHENERGY },
	CamPos = Vector(10,10,0),
	CamOrigin = Vector(0,0,0)	
} )

item.Register( { 
	Name = "Military Medikit", 
	Description = "Restores 60% of your health.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 1.25, 
	Price = 5,
	Rarity = 0.65,
	Model = "models/radbox/healthpack.mdl",
	Functions = { FUNC_TECHHEAL },
	CamPos = Vector(23,8,3),
	CamOrigin = Vector(0,0,-1)		
} )

item.Register( { 
	Name = "Specialized Medikit", 
	Description = "Restores 100% of your health and 70 stamina.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 1.25, 
	Price = 10,
	Rarity = 0.85,
	Model = "models/radbox/healthpack2.mdl",
	Functions = { FUNC_SUPERDUPERHEAL },
	CamPos = Vector(23,8,3),
	CamOrigin = Vector(0,0,-1)
} )

item.Register( { 
	Name = "Alpha Mutagen", 
	Description = "Prototype drug which cures the infection.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 1.25, 
	Price = 25,
	Rarity = 0.95,
	Model = "models/items/healthkit.mdl",
	Functions = { FUNC_MUTAGEN },
	CamPos = Vector(0,0,35),
	CamOrigin = Vector(4,0,0)
} )

item.Register( { 
	Name = "Advanced Bandage", 
	Description = "Stops all bleeding and treats wound.",
	Stackable = true, 
	Type = ITEM_ENGI,
	Weight = 0.35, 
	Price = 2,
	Rarity = 0.50,
	Model = "models/radbox/bandage.mdl",
	Functions = { FUNC_TECHBANDAGE },
	CamPos = Vector(18,10,5),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Zyklone Z", 
	Description = "The germans got something right.",
	Stackable = true, 
	Type = ITEM_ENGI,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 8,
	Rarity = 0.40,
	Model = "models/healthvial.mdl",
	Weapon = "rad_zyklone",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(3,16,3),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "Trap Kit", 
	Description = "Admiral Ackbar approved.",
	Stackable = true, 
	Type = ITEM_ENGI,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 40,
	Rarity = 0.40,
	Model = "models/weapons/w_slam.mdl",
	Weapon = "rad_trapplacer",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(18,10,5),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "HNH-18", 
	Description = "Heals players and cripples zombies.",
	Stackable = true, 
	Type = ITEM_ENGI,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 50,
	Rarity = 0.40,
	Model = "models/weapons/w_rif_gug.mdl",
	Weapon = "rad_syringegun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-5,37,5),
	CamOrigin = Vector(-4,34.5,5)
} )
