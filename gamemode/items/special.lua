
// This is the ID given to any item that is a SPECIALIST supply
ITEM_SPECIAL = 3

function FUNC_ANTIRAD( ply, id, client, icon )

	if icon then return "icon16/pill.png" end
	if client then return "Inject" end
	
	ply:RemoveFromInventory( id )
	ply:EmitSound( "Weapon_SMG1.Special1" )
	ply:SetRadiation( 0 )
	ply:Notice( "-5 Radiation", GAMEMODE.Colors.Green )

end

--[[function FUNC_FLARE( ply, id, client, icon )

	if icon then return "icon16/lightbulb.png" end
	if client then return "Ignite" end
	
	ply:RemoveFromInventory( id )
	
	local prop = ents.Create( "sent_flare" )
	prop:SetPos( ply:GetItemDropPos() )
	prop:Spawn()

end]]

--[[item.Register( { 
	Name = "Sonar Module", 
	Description = "Improves your radar detection range.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 0.75, 
	Price = 30,
	Rarity = 0.90,
	Model = "models/gibs/shield_scanner_gib1.mdl",
	Functions = {},
	CamPos = Vector(2,-9,7),
	CamOrigin = Vector(0,1,-1)		
} )

item.Register( { 
	Name = "Flare", 
	Description = "Emits a bright red light.",
	Stackable = true, 
	Type = ITEM_SPECIAL,
	Weight = 0.35, 
	Price = 3,
	Rarity = 0.10,
	Model = "models/props_c17/trappropeller_lever.mdl",
	Functions = { FUNC_FLARE },
	CamPos = Vector(15,6,5),
	CamOrigin = Vector(0,0,0)		
} )]]