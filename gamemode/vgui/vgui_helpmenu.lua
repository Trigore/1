local PANEL = {}

PANEL.Text = { "<html><body style=\"background-color:DimGray;\">",
"<p style=\"font-family:tahoma;color:red;font-size:25;text-align:center\"><b>READ THIS!</b></p>",
"<p style=\"font-family:verdana;color:white;font-size:10px;text-align:left\"><b>The Wave System:</b> ",
"The objective of the game is to kill the designated number of zombies per wave. At the end of each wave, you'll have a limited amount of time to shop for supplies. Each wave is harder than the last, bringing new mutations and leading up the Finale. Before the final wave, you'll have your last opportunity to shop for both it and the Finale.<br><br>",
"<b>The Finale:</b> After the last wave, you'll encounter a range of endings. Ultimately, you'll have to reach an evac point marked on your screen. You'll be notified of exactly what to do if the evac isn't there yet. When in doubt, SURVIVE.<br><br>",
"<b>Classes and Leveling:</b> You will have an opportunity to play as an array of classes, each with their own unique benefits and abilities. As you do damage to the undead, you'll gain experience that allow you to level it up and make the class more proficient. Currently, the maximum level is six.<br><br>",
"<b>Purchasing Items:</b> Unless you're playing as the Specialist, you'll have to buy items from the trader. She'll appear at the end of waves for a limited time, so stock up on any supplies you think you'll need. The Specialist is able to air drop shipments directly to him if he is outdoors. If he's indoors, the shipment will be sent to a marked location.<br><br>",
"<b>The Inventory System:</b> To toggle your inventory, press your spawn menu button (default Q). Click an item in your inventory to interact with it. To interact with dropped items, press your USE key (default E) on them.<br><br>",
"<b>The Panic Button:</b> Press F3 to activate the panic button. It automatically detects your ailments and attempts to fix them using what you have in your inventory.<br><br>",
"<b>The HUD:</b> The location of important locations and items are marked on your screen. Your teammates are highlighted through walls, as well as the antidote, trader, and your shipment.",
"If you have radiation poisoning, an icon indicating the severity of the poisoning will appear on the bottom left of your screen. An icon will also appear if you are bleeding or infected.<br><br>",
"The bar at the top center of your screen keeps track of your class progression. A wave counter at the top right of your screen indicates how far you are in the game. Directly under it is a zombie counter indicating the status of the current wave.<br><br>",
"<b>The Infection:</b> The common undead will infect you when they hit you. To cure infection, go to the antidote and press your USE key to access it. The antidote location is always marked on your HUD.<br><br>",
"<b>Radiation:</b> Radiation is visually unnoticeable. When near radiation, your handheld geiger counter will make sounds indicating how close you are to a radioactive deposit. Radiation poisoning is cured by vodka or Anti-Rad.<br><br>" }

PANEL.ButtonText = { "Holy Shit I Don't Care",
"I Didn't Read Any Of That",
"That's A Lot Of Words",
"I'd Rather Just Whine For Help",
"Just Wanna Play Video Games",
"Who Gives A Shit?",
"Help Menus Are For Nerds",
"I Thought This Was A Roleplay Server",
"How I Shoot Zobies",
"How Do I Buy Wepon",
"HEY GUYS WHERES ANTIDOTE this game suck",
"WHERE MY INVENTOREY",
"TL;DR",
"Gay as fuck in my pink truck",
"How do I get my Rust key",
"redead rip off",
"FUCK OFF" }

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
	local text = ""
	
	for k,v in pairs( self.Text ) do
	
		text = text .. v
	
	end
	
	self.Label = vgui.Create( "HTML", self )
	self.Label:SetHTML( text )
	
	self.Button = vgui.Create( "DButton", self )
	self.Button:SetText( table.Random( self.ButtonText ) )
	self.Button.OnMousePressed = function()

		self:Remove() 
		
		if LocalPlayer():Team() == TEAM_UNASSIGNED then 
			local classmenu = vgui.Create( "ClassPicker" )
			classmenu:SetSize( 475, 500 )
			classmenu:Center()
			classmenu:MakePopup()		
		else
		if LocalPlayer():Alive() == false then
			local classmenu = vgui.Create( "ClassPicker" )
			classmenu:SetSize( 475, 500 )
			classmenu:Center()
			classmenu:MakePopup()
		else
			return
		end
		end
		
	end
	
end

function PANEL:Think()

	self.Dragging = false

end

function PANEL:ChooseParent()
	
end

function PANEL:GetPadding()

	return 5
	
end

function PANEL:PerformLayout()

	local x,y = self:GetPadding(), self:GetPadding() + 10
	
	self.Label:SetSize( self:GetWide() - ( self:GetPadding() * 2 ) - 5, self:GetTall() - 50 )
	self.Label:SetPos( x + 5, y + 5 )
	
	self.Button:SetSize( 250, 20 )
	self.Button:SetPos( self:GetWide() * 0.5 - self.Button:GetWide() * 0.5, self:GetTall() - 30 )
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	draw.SimpleText( "Help Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "HelpMenu", "A help menu.", PANEL, "PanelBase" )
