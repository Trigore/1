
// This is the ID given to any weapon item for SPECIAL
ITEM_WPN_SPECIAL = 10

--[[function FUNC_PLANTBOMB( ply, id, client )

	if client then return "Arm" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "weapons/c4/c4_plant.wav" )
	
	local trace = {}
	trace.start = ply:GetShootPos()
	trace.endpos = ply:GetShootPos() + ply:GetAimVector() * 50
	trace.filter = ply
	local tr = util.TraceLine( trace )
	
	local bomb = ents.Create( "sent_c4" )
	bomb:SetPos( tr.HitPos )
	bomb:SetOwner( ply )
	bomb:Spawn()

end]]

item.Register( { 
	Name = "Hammer", 
	Description = "Builds barricades and bashes skulls.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 35,
	Rarity = 0.40,
	Model = "models/weapons/w_hammer.mdl",
	Weapon = "rad_hammer",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-28,0),
	CamOrigin = Vector(0,0,5)
} )

item.Register( { 
	Name = "Axe", 
	Description = "The messiest melee weapon.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 5, 
	Price = 50,
	Rarity = 0.60,
	Model = "models/weapons/w_axe.mdl",
	Weapon = "rad_axe",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-42,0),
	CamOrigin = Vector(0,0,8)
} )

item.Register( { 
	Name = "Crowbar", 
	Description = "Gordon's weapon of choice.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
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
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.90,
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
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.90,
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
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.90,
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
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	SaleOverride = true,
	Weight = 3, 
	Price = 8,
	Rarity = 0.90,
	Model = "models/weapons/w_pist_glock18.mdl",
	Weapon = "rad_glock",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,17,5),
	CamOrigin = Vector(2,0,3)
} )

item.Register( { 
	Name = "Beretta PX4", 
	Description = "Accurate but weak handgun.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 10,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_bpx4.mdl",
	Weapon = "rad_px4",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-17,5),
	CamOrigin = Vector(0,-3,0)
} )

item.Register( { 
	Name = "P-99", 
	Description = "Decent in all categories.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 14,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_p99.mdl",
	Weapon = "rad_p99",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-15,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Beretta M92 Raffica", 
	Description = "Burst firin' wonder.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 18,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_m92.mdl",
	Weapon = "rad_m92",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-17,5),
	CamOrigin = Vector(0,-3,0)
} )

item.Register( { 
	Name = "CZ-75 Full Auto", 
	Description = "It's an auto pistol.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 18,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_ulcz-75.mdl",
	Weapon = "rad_cz75",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,17,5),
	CamOrigin = Vector(5,0,1)
} )

item.Register( { 
	Name = "Dual Berettas", 
	Description = "A gun for each hand.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 25,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_elite_single.mdl",
	DropModel = "models/weapons/w_pist_elite_dropped.mdl",
	Weapon = "rad_berettas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,-5),
	CamOrigin = Vector(2,0,3)
} )

item.Register( { 
	Name = "Browning HP", 
	Description = "Accurate but powerful.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 28,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_brhp.mdl",
	Weapon = "rad_brown",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-25,0,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "Colt Python", 
	Description = "A six shooter that packs a punch.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 28,
	Rarity = 0.20,
	Model = "models/weapons/w_357.mdl",
	Weapon = "rad_revolver",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,18,0),
	CamOrigin = Vector(6,0,0)
} )

item.Register( { 
	Name = "Mateba Revolver", 
	Description = "Shotty pisty boomy zombie.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 28,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_mateba.mdl",
	Weapon = "rad_mateba",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-18,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "M3 Shorty", 
	Description = "A 3 bullet shotgun with plenty to say",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 28,
	Rarity = 0.20,
	Model = "models/weapons/w_shot_shortygun.mdl",
	Weapon = "rad_shorty",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,20,2),
	CamOrigin = Vector(-1,0,-3)
} )

item.Register( { 
	Name = "Desert Eagle", 
	Description = "What are you compensating for?",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 32,
	Rarity = 0.20,
	Model = "models/weapons/w_pist_deagle.mdl",
	Weapon = "rad_deagle",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,15,2),
	CamOrigin = Vector(3,0,4)
} )

item.Register( { 
	Name = "HK MP5K", 
	Description = "You got pistol ammo in my SMG!",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 35,
	Rarity = 0.20,
	Model = "models/weapons/w_mp5k.mdl",
	Weapon = "rad_mp5k",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,20,5),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "IMI UZI", 
	Description = "The terrorists use it why can't I?",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 35,
	Rarity = 0.20,
	Model = "models/weapons/w_smg_mac11.mdl",
	Weapon = "rad_uzi",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,20,0),
	CamOrigin = Vector(10,-5,5)
} )

item.Register( { 
	Name = "UMP45", 
	Description = "A powerful SMG with a smaller magazine.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 39,
	Rarity = 0.30,
	Model = "models/weapons/w_smg_ump45.mdl",
	Weapon = "rad_ump45",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,30,5),
	CamOrigin = Vector(-2,0,4)
} )

item.Register( { 
	Name = "PP Bizon", 
	Description = "Not enough bullets? Here's 64.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 39,
	Rarity = 0.30,
	Model = "models/weapons/w_smg_biz.mdl",
	Weapon = "rad_bizon",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,30,5),
	CamOrigin = Vector(-2,0,0)
} )


item.Register( { 
	Name = "CMP250", 
	Description = "A prototype burst-fire SMG.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 42,
	Rarity = 0.30,
	Model = "models/weapons/w_smg1.mdl",
	Weapon = "rad_cmp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,27,0),
	CamOrigin = Vector(-1,0,-1)
} )

item.Register( { 
	Name = "Winchester 1887", 
	Description = "Zombies are in season.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 46,
	Rarity = 0.30,
	Model = "models/weapons/w_annabelle.mdl",
	Weapon = "rad_shotgun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-50,5),
	CamOrigin = Vector(3,0,1)
} )

item.Register( { 
	Name = "Remington 870", 
	Description = "An accurate shotgun? What",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 46,
	Rarity = 0.30,
	Model = "models/weapons/w_shot_remmin870.mdl",
	Weapon = "rad_remington",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-50,5),
	CamOrigin = Vector(3,0,1)
} )

item.Register( { 
	Name = "TMP", 
	Description = "A silent but deadly SMG.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 50,
	Rarity = 0.40,
	Model = "models/weapons/w_smg_tmp.mdl",
	Weapon = "rad_tmp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,31,5),
	CamOrigin = Vector(5,0,3)
} )

item.Register( { 
	Name = "KRISS Vector", 
	Description = "Fast firing, man tiring.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 50,
	Rarity = 0.40,
	Model = "models/weapons/w_smg_kis.mdl",
	Weapon = "rad_vector",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,31,5),
	CamOrigin = Vector(-2,0,0)
} )

item.Register( { 
	Name = "MP5", 
	Description = "A well-rounded, reliable SMG.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 56,
	Rarity = 0.40,
	Model = "models/weapons/w_smg_mp5.mdl",
	Weapon = "rad_mp5",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,38,5),
	CamOrigin = Vector(2,0,5)
} )

item.Register( { 
	Name = "AK-74U", 
	Description = "Is it my turn yet big brother?",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 6, 
	Price = 56,
	Rarity = 0.40,
	Model = "models/weapons/w_smg_aks.mdl",
	Weapon = "rad_ak74",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,38,5),
	CamOrigin = Vector(1,0,-1)
} )

item.Register( { 
	Name = "AR-57", 
	Description = "Prototype 5 burst rifle/SMG hybrid.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 56,
	Rarity = 0.50,
	Model = "models/weapons/w_smg_ar5.mdl",
	Weapon = "rad_ar57",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,35,5),
	CamOrigin = Vector(6,0,5)
} )

item.Register( { 
	Name = "FAMAS", 
	Description = "The least expensive assault rifle.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 61,
	Rarity = 0.50,
	Model = "models/weapons/w_rif_famas.mdl",
	Weapon = "rad_famas",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(-7,39,5),
	CamOrigin = Vector(-6,0,5)
} )

item.Register( { 
	Name = "FN P90", 
	Description = "A powerful SMG with a large magazine.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 4, 
	Price = 66,
	Rarity = 0.50,
	Model = "models/weapons/w_smg_p90.mdl",
	Weapon = "rad_p90",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,35,5),
	CamOrigin = Vector(1,0,5)
} )

item.Register( { 
	Name = "Steyr Scout", 
	Description = "A bolt-action sniper rifle.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 70,
	Rarity = 0.60,
	Model = "models/weapons/w_snip_scout.mdl",
	Weapon = "rad_scout",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,44,5),
	CamOrigin = Vector(0,0,4)
} )

item.Register( { 
	Name = "IMI Galil", 
	Description = "Lower accuracy, larger magazine.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 8, 
	Price = 70,
	Rarity = 0.60,
	Model = "models/weapons/w_rif_galil.mdl",
	Weapon = "rad_galil",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,42,5),
	CamOrigin = Vector(-1,0,3)
} )

item.Register( { 
	Name = "FN SCAR", 
	Description = "Higher accuracy, smaller magazine.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 8, 
	Price = 70,
	Rarity = 0.60,
	Model = "models/weapons/w_rif_scar.mdl",
	Weapon = "rad_scar",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,42,5),
	CamOrigin = Vector(6,0,3)
} )

item.Register( { 
	Name = "SPAS-12", 
	Description = "Useful for crowd control.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 84,
	Rarity = 0.70,
	Model = "models/weapons/w_shotgun.mdl",
	Weapon = "rad_spas12",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-34,0),
	CamOrigin = Vector(0,0,0)
} )

item.Register( { 
	Name = "USAS-12", 
	Description = "Drum mag means no manual reloading!",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 95,
	Rarity = 0.70,
	Model = "models/weapons/w_shot_usas12.mdl",
	Weapon = "rad_usas12",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-34,0),
	CamOrigin = Vector(6,0,0)
} )

item.Register( { 
	Name = "AK-47", 
	Description = "A well-rounded assault rifle.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 100,
	Rarity = 0.80,
	Model = "models/weapons/w_rif_ak47.mdl",
	Weapon = "rad_ak47",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,43,5),
	CamOrigin = Vector(0,0,3)
} )

item.Register( { 
	Name = "XM-8", 
	Description = "Accurate and deadly.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 8, 
	Price = 100,
	Rarity = 0.90,
	Model = "models/weapons/w_smg_xm8.mdl",
	Weapon = "rad_xm8",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,37,5),
	CamOrigin = Vector(-4,0,5)
} )

item.Register( { 
	Name = "SG 552", 
	Description = "Comes with a free scope.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 8, 
	Price = 110,
	Rarity = 0.90,
	Model = "models/weapons/w_rif_sg552.mdl",
	Weapon = "rad_sg552",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,37,5),
	CamOrigin = Vector(-4,0,5)
} )

item.Register( { 
	Name = "G3 SG1", 
	Description = "An automatic sniper rifle.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 150,
	Rarity = 0.90,
	Model = "models/weapons/w_snip_g3sg1.mdl",
	Weapon = "rad_g3",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,42,5),
	CamOrigin = Vector(-3,0,5)
} )

item.Register( { 
	Name = "HEAT Cannon", 
	Description = "An experimental long range zombie cooker.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 160,
	Rarity = 0.70,
	Model = "models/weapons/w_physics.mdl",
	Weapon = "rad_firegun",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,35,0),
	CamOrigin = Vector(10,0,-1)
} )

item.Register( { 
	Name = "PPW-952", 
	Description = "An experimental particle projectile weapon.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 170,
	Rarity = 0.70,
	Model = "models/weapons/w_irifle.mdl",
	Weapon = "rad_experimental",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,-40,0),
	CamOrigin = Vector(5,0,0)
} )

item.Register( { 
	Name = "M1014", 
	Description = "Turn everything into ground beef.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 120,
	Rarity = 0.90,
	Model = "models/weapons/w_shot_xm1014.mdl",
	Weapon = "rad_m1014",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,38,5),
	CamOrigin = Vector(1,0,4)
} )

item.Register( { 
	Name = "Striker", 
	Description = "I put explosive rounds in this baby",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 7, 
	Price = 120,
	Rarity = 0.70,
	Model = "models/weapons/w_shot_strike.mdl",
	Weapon = "rad_striker",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,34,0),
	CamOrigin = Vector(1,0,0)
} )

item.Register( { 
	Name = "M249", 
	Description = "A belt-fed support machine gun.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 10, 
	Price = 140,
	Rarity = 0.90,
	Model = "models/weapons/w_mach_m249para.mdl",
	Weapon = "rad_m249",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,38,5),
	CamOrigin = Vector(2,0,6)
} )

item.Register( { 
	Name = "AWP", 
	Description = "The very definition of overkill.",
	Stackable = false, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 9, 
	Price = 170,
	Rarity = 0.70,
	Model = "models/weapons/w_snip_awp.mdl",
	Weapon = "rad_awp",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(0,51,5),
	CamOrigin = Vector(1,0,4)
} )

item.Register( { 
	Name = "HE Grenade", 
	Description = "The fuse lasts 3 seconds.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 3,
	Rarity = 0.20,
	Model = "models/weapons/w_eq_fraggrenade_thrown.mdl",
	Weapon = "rad_grenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(1,12,4),
	CamOrigin = Vector(0,0,1)
} )

item.Register( { 
	Name = "Incendiary Grenade", 
	Description = "Comes with free marshmallows.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 1, 
	Price = 5,
	Rarity = 0.40,
	Model = "models/weapons/w_eq_flashbang.mdl",
	Weapon = "rad_incendiarygrenade",
	Functions = { FUNC_DROPWEAPON },
	PickupFunction = FUNC_GRABWEAPON,
	DropFunction = FUNC_REMOVEWEAPON,
	CamPos = Vector(3,16,3),
	CamOrigin = Vector(0,0,5)
} )

--[[item.Register( { 
	Name = "Timed Explosives", 
	Description = "This is a homemade timed explosive.",
	Stackable = true, 
	Type = ITEM_WPN_SPECIAL,
	TypeOverride = "sent_droppedgun",
	Weight = 3, 
	Price = 10,
	Rarity = 0.80,
	Model = "models/weapons/w_c4.mdl",
	Functions = { FUNC_PLANTBOMB },
	CamPos = Vector(-12,-2,0),
	CamOrigin = Vector(0,5,0)
} )]]