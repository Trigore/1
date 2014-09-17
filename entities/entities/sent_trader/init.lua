AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Hello = { Sound( "vo/npc/female01/getgoingsoon.wav" ), Sound( "vo/npc/female01/heretohelp01.wav" ), Sound( "vo/npc/female01/heretohelp02.wav" ), Sound( "vo/npc/female01/hi01.wav" ), Sound( "vo/npc/female01/hi02.wav" ), Sound( "vo/npc/female01/heretohelp01.wav" ), Sound( "vo/npc/female01/readywhenyouare01.wav" ), Sound( "vo/npc/female01/readywhenyouare02.wav" ), Sound( "vo/npc/female01/squad_greet01.wav" ), Sound( "vo/npc/female01/squad_greet02.wav" ), Sound( "vo/npc/female01/squad_greet04.wav" ), Sound( "vo/npc/female01/startle01.wav" ), Sound( "vo/npc/female01/startle02.wav" ) }
ENT.Bye = { Sound( "vo/canals/arrest_getgoing.wav" ), Sound( "vo/npc/female01/busy02.wav" ), Sound( "vo/npc/female01/getgoingsoon.wav" ), Sound( "vo/npc/female01/gethellout.wav" ), Sound( "vo/npc/female01/headsup01.wav" ), Sound( "vo/npc/female01/headsup02.wav" ), Sound( "vo/npc/female01/incoming02.wav" ), Sound( "vo/npc/female01/littlecorner01.wav" ), Sound( "vo/npc/female01/runforyourlife01.wav" ), Sound( "vo/npc/female01/runforyourlife02.wav" ), Sound( "vo/npc/female01/thislldonicely01.wav" ), Sound( "vo/npc/female01/watchout.wav" ) }
ENT.Here = { Sound( "vo/npc/female01/overhere01.wav" ), Sound( "vo/npc/female01/overthere01.wav" ), Sound( "vo/npc/female01/overthere02.wav" ), Sound( "vo/npc/female01/okimready01.wav" ), Sound( "vo/npc/female01/okimready02.wav" ), Sound( "vo/npc/female01/okimready03.wav" ), Sound( "vo/npc/female01/littlecorner01.wav" ) }
ENT.Models = { Model( "models/Humans/Group03m/Female_01.mdl"), Model( "models/Humans/Group03m/Female_02.mdl"), Model( "models/Humans/Group03m/Female_03.mdl"), Model( "models/Humans/Group03m/Female_04.mdl"), Model( "models/Humans/Group03m/Female_06.mdl"), Model( "models/Humans/Group03m/Female_07.mdl") } 
ENT.Anims = { "lineidle01", "lineidle02", "lineidle03" } 
ENT.DieTime = CurTime() + 999999
ENT.AutomaticFrameAdvance = true 
ENT.BuybackScale = 1.0

function ENT:Initialize()
	
	local model = table.Random( self.Models )
	self.Entity:SetModel( model )
	local here = table.Random( self.Here )
	self.Entity:TraderSound( here )
	local anim = table.Random( self.Anims )
	local sequence = self.Entity:LookupSequence(anim)
	self.Entity:SetSequence( sequence )
	self.Entity:SetPos( self.Entity:GetPos() + Vector(0,0,-8) )
	self.Entity:ResetSequence( sequence )
	self.Entity:PhysicsInit( SOLID_BBOX )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_BBOX )
	self:DrawShadow(true)
	self.Entity:SetCollisionGroup( COLLISION_GROUP_NONE )
	self.Entity:SetUseType(ONOFF_USE)
	self.DieTime = CurTime() + 90
	SetGlobalInt( "TraderTime", self.DieTime )
	timer.Simple( 60, function()	
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
	
		v:Notice( "Trader is moving in 30 seconds.", GAMEMODE.Colors.White, 5 )
	end
end)
	
	self.Items = {}
	self.Engi = {}
	self.Special = {}
	self.MasterItems = {}
	
	self.Entity:GenerateInventory()
	
end

function ENT:SetAnim()
	local anim = table.Random( self.Anims )
	local sequence = self.Entity:LookupSequence(anim)
		self.Entity:SetSequence( sequence)
	self.Entity:ResetSequence( sequence )
end

function ENT:GetTraderItems( ply )

local class = ply:GetPlayerClass()
	if class == CLASS_ENGINEER or class == 4 then
	return self.Engi
	elseif class == 3 or class == CLASS_SPECIALIST then
	return self.Special	
	else
	return self.Items	
	end
	
end

function ENT:GetItems()
	return self.MasterItems
end

function ENT:AddItem( tabl, id )
	
	local tbl = item.GetByID( id )
	
	if tbl.SaleOverride then return end

	self.Items = self.Items or {}
	self.Engi = self.Engi or {}
	self.Special = self.Special or {}
	self.MasterItems = self.MasterItems or {}


	table.insert( tabl, id )

end

function ENT:GenerateInventory()
	
	
	for k,v in pairs( item.GetByType( ITEM_ENGI ) ) do
	
		self.Entity:AddItem( self.Engi, v.ID )
		self.Entity:AddItem( self.MasterItems, v.ID )
	end
	
	
	for k,v in pairs( item.GetByType( ITEM_SUPPLY ) ) do
			self.Entity:AddItem( self.MasterItems, v.ID )
		self.Entity:AddItem( self.Items, v.ID )
		self.Entity:AddItem( self.Special, v.ID )
	end
	
	
	for k,v in pairs( item.GetByType( ITEM_BUYABLE ) ) do
			self.Entity:AddItem( self.MasterItems, v.ID )
		self.Entity:AddItem( self.Items, v.ID )
		self.Entity:AddItem( self.Special, v.ID )
		self.Entity:AddItem( self.Engi, v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_MISC ) ) do
		self.Entity:AddItem( self.MasterItems, v.ID )	
		self.Entity:AddItem( self.Items, v.ID )
		self.Entity:AddItem( self.Special, v.ID )
		self.Entity:AddItem( self.Engi, v.ID )
	
	end
	
	for k,v in pairs( item.GetByType( ITEM_AMMO ) ) do
		self.Entity:AddItem( self.MasterItems, v.ID )	
		self.Entity:AddItem( self.Items, v.ID )
		self.Entity:AddItem( self.Special, v.ID )
		self.Entity:AddItem( self.Engi, v.ID )
	
	end
	
	
		for k,v in pairs( item.GetByType( ITEM_SPECIAL ) ) do
		self.Entity:AddItem( self.MasterItems, v.ID )	
			self.Entity:AddItem( self.Special, v.ID )
	
		end
	
		
	
		for k,v in pairs( item.GetByType( ITEM_WPN_SPECIAL ) ) do
			self.Entity:AddItem( self.MasterItems, v.ID )	
			self.Entity:AddItem( self.Special, v.ID )
		
		end
		
		
		for k,v in pairs( item.GetByType( ITEM_WPN_COMMON ) ) do
			self.Entity:AddItem( self.MasterItems, v.ID )
		self.Entity:AddItem( self.Items, v.ID )
		self.Entity:AddItem( self.Engi, v.ID )
	
		end
		

end

function ENT:Think() 
if self.DieTime < CurTime() then
	for k,v in pairs( team.GetPlayers( TEAM_ARMY ) ) do
		if v:GetPlayerClass() != 3 then
			self.Entity:OnExit( v )
			v:RefundAll()
		end
	end
	GAMEMODE.TraderFinished = true
	local bye = table.Random( self.Bye )
	self.Entity:TraderSound( bye )
	self.Entity:Remove()
end
end 

function ENT:Use( ply )
if ply:GetPlayerClass() == 5 then 
ply:Notice( "Zombies can't buy things!", GAMEMODE.Colors.Red )
ply:ClientSound( "items/suitchargeno1.wav" )

else

self.Entity:OnUsed( ply )
end

end

function ENT:TraderSound( vtype )
	
	if ( ( self.RadioTimer or 0 ) < CurTime() ) then
	
		local sound = vtype
		
		self:EmitSound( table.Random( GAMEMODE.VoiceStart ), math.random( 90, 110 ) )
		timer.Simple( 0.2, function() if IsValid( self ) then self:EmitSound( sound, 90 ) end end )
		timer.Simple( SoundDuration( sound ) + math.Rand( 0.6, 0.8 ), function() if IsValid( self ) then self:EmitSound( table.Random( GAMEMODE.VoiceEnd ), math.random( 90, 110 ) ) end end )
				
		self.RadioTimer = CurTime() + SoundDuration( sound ) + 1
	
	end

end

function ENT:OnUsed( ply )
	local hello = table.Random( self.Hello )
	if ply:GetPlayerClass() == 4 then
	ply.Stash = self.Engi
	elseif ply:GetPlayerClass() == 3 then
	ply.Stash = self.Special
	else
	ply.Stash = self.Items
	end
	ply:ToggleStashMenu( self.Entity, true, "StoreMenu", self.BuybackScale)
	self.Entity:TraderSound( hello )

end

function ENT:OnExit( ply )
	local bye = table.Random( self.Bye )
	ply:ToggleStashMenu( self.Entity, false, "StoreMenu", self.BuybackScale )
	ply.Stash = {}
	self.Entity:TraderSound( bye )

end

function ENT:UpdateTransmitState()

	return TRANSMIT_ALWAYS 

end

