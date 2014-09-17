
local EVENT = {}

EVENT.Chance = 0.5
EVENT.Type = EVENT_BAD

function EVENT:Start()
	
	local spawns = ents.FindByClass( "info_evac" )
	local evac = table.Random( spawns )
	
	local ent1 = ents.Create( "npc_hum_blackwatch" )
	local ent2 = ents.Create( "npc_hum_blackwatch" )
	local ent3 = ents.Create( "npc_hum_blackwatch" )
	local ent4 = ents.Create( "npc_hum_blackwatch" )
	ent1:SetPos( evac:GetPos() + Vector(0,-32,10))
	ent1:Spawn()
	ent2:SetPos( evac:GetPos() + Vector(32,0,10) )
	ent2:Spawn()
	ent3:SetPos( evac:GetPos() + Vector(-32,0,10) )
	ent3:Spawn()
	ent4:SetPos( evac:GetPos() + Vector(-32,32,10) )
	ent4:Spawn()
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		
		v:Notice( "A VENOM squad has been dispatched nearby, stay sharp.", GAMEMODE.Colors.Red, 5 )
		
	end
	
end
	
function EVENT:Think()

end

function EVENT:EndThink()

	return true // true ends this immediately

end

function EVENT:End()

end

event.Register( EVENT )
