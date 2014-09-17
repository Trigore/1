
local EVENT = {}

EVENT.Chance = 0.7
EVENT.Type = EVENT_BAD
EVENT.LootDef = 0

function EVENT:Start()
EVENT.LootDef = GAMEMODE.MaxLoot
i = 0
while i < 7 do
	local spawns = ents.FindByClass( "info_lootspawn" )
	local evac = table.Random( spawns )
	
	local ent = ents.Create( "npc_hum_anarchist" )
	ent:SetPos( evac:GetPos() + Vector(0,0,10) )
	ent:Spawn()
	i = i + 1
end
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "There are a bunch of looters stealing supplies nearby, take care of them", GAMEMODE.Colors.Red, 5 )
		
	end
GAMEMODE.MaxLoot = 0.1
end
	
function EVENT:Think()

end

function EVENT:EndThink()

return #ents.FindByClass( "npc_hum_anarchist" ) < 1

end

function EVENT:End()
GAMEMODE.MaxLoot = EVENT.LootDef
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "All the looters have been taken care of", GAMEMODE.Colors.Green, 5 )
		
	end
end

event.Register( EVENT )
