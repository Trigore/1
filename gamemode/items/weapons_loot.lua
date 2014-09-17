
// This is the ID given to any weapon item for all teams
ITEM_GUNDROPS = 23

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

item.Register( { 
	Name = "Crowbar", 
	Description = "Gordon's weapon of choice.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 5, 
	Price = 50,
	Rarity = 0.20,
	Model = "models/weapons/w_crowbar.mdl",
	Weapon = "rad_crowbar",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,0,-44),
	CamOrigin = Vector(0,0,8)
} )

item.Register( { 
	Name = "FN Five-Seven", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.01,
	Model = "models/weapons/w_pist_fiveseven.mdl",
	Weapon = "rad_fiveseven",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,17,5),
	CamOrigin = Vector(2,0,3)
} )

item.Register( { 
	Name = "USP Compact", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.01,
	Model = "models/weapons/w_pistol.mdl",
	Weapon = "rad_usp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-17,0),
	CamOrigin = Vector(-1,0,-2)
} )

item.Register( { 
	Name = "P228 Compact", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.01,
	Model = "models/weapons/w_pist_p228.mdl",
	Weapon = "rad_p228",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,17,5),
	CamOrigin = Vector(2,0,3)
} )

item.Register( { 
	Name = "Glock 19", 
	Description = "A standard issue sidearm.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.01,
	Model = "models/weapons/w_pist_glock18.mdl",
	Weapon = "rad_glock",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,17,5),
	CamOrigin = Vector(2,0,3)
} )


item.Register( { 
	Name = "P-99", 
	Description = "Decent in all categories.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 20,
	Rarity = 0.30,
	Model = "models/weapons/w_pist_p99.mdl",
	Weapon = "rad_p99",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-15,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Browning HP", 
	Description = "Accurate but powerful.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 4, 
	Price = 40,
	Rarity = 0.50,
	Model = "models/weapons/w_pist_brhp.mdl",
	Weapon = "rad_brown",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-25,0,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "M3 Shorty", 
	Description = "A 3 bullet shotgun with plenty to say",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 4, 
	Price = 45,
	Rarity = 0.60,
	Model = "models/weapons/w_shot_shortygun.mdl",
	Weapon = "rad_shorty",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,20,2),
	CamOrigin = Vector(-1,0,-3)
} )

item.Register( { 
	Name = "CMP250", 
	Description = "A prototype burst-fire SMG.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	SaleOverride = true,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 60,
	Rarity = 0.70,
	Model = "models/weapons/w_smg1.mdl",
	Weapon = "rad_cmp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,27,0),
	CamOrigin = Vector(-1,0,-1)
} )

item.Register( { 
	Name = "FAMAS", 
	Description = "The least expensive assault rifle.",
	Stackable = false, 
	Type = ITEM_GUNDROPS,
	SaleOverride = true,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 80,
	Rarity = 0.80,
	Model = "models/weapons/w_rif_famas.mdl",
	Weapon = "rad_famas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-7,39,5),
	CamOrigin = Vector(-6,0,5)
} )
