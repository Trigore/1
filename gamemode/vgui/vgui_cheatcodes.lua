local PANEL = {}

--[[ This is where the gamemode will recognize that what you're typing is actually a real cheat code. 
Make sure you've added your cheat in enums.lua and cheat_module.lua, or the cheat won't work. 
For ease, I've indented the section you'll need heavily --]]

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
		surface.CreateFont ( "SuperFont", { size = 44, weight = 200, antialias = true, additive = true, font = "Verdana" } )
		surface.CreateFont ( "SupFont", { size = 20, weight = 200, antialias = true, additive = true, font = "Verdana" } )
		surface.CreateFont ( "KindaThereFont", { size = 16, weight = 200, antialias = true, additive = true, font = "Verdana" } )
		local cheatcode = ""
		local Button1 = vgui.Create( "DButton", self )
		Button1:SetSize( 469, 40 )
		Button1:SetText( "I KNOW A CHEATCODE" )
		Button1:SetPos( 0, 423 )
		Button1.OnMousePressed = function() 
local DermaPanel = vgui.Create( "DFrame" )
DermaPanel:SetPos( 420, 300 )
DermaPanel:SetSize( 400, 50 )
DermaPanel.Dragging = false
DermaPanel:SetTitle( "feed me words" )
DermaPanel:ShowCloseButton( false )
DermaPanel:SetVisible( true )
DermaPanel:MakePopup()
 
local DermaText = vgui.Create( "DTextEntry", DermaPanel )
DermaText:SetPos( 5,25 )
DermaText:SetTall( 20 )
DermaText:SetWide( 280 )
DermaText:SetEnterAllowed( true )
	--This is where we will have the gamemode recognize the inputted text as your cheatcode. You can copy the if statement and make it an elseif statement to keep the loop going as opposed to if statements.
		DermaText.OnEnter = function( ply )
			cheatcode = string.lower(DermaText:GetValue())
			if cheatcode == "monkey_123" then --This is your cheatcode input
				local label1 = vgui.Create( "DLabel", DermaPanel )
				label1:SetWrap( true )
				label1:SetText( "We're gonna be poor" ) --This is the custom message a user will see after inputting the cheatcode successfully
				label1:SetColor( Color( 0,255,0 ) )
				label1:SetPos( 290, 25 ) 
				label1:SetSize( 280, 20 )
				local ply = LocalPlayer()
				RunConsoleCommand( "inputcheat", monkey_123 ) --This will send the valid cheat to the server so it can apply it to the player.
				timer.Simple( 2, function() DermaPanel:SetVisible ( false ) end)
			else
				local label1 = vgui.Create( "DLabel", DermaPanel )
				label1:SetWrap( true )
				label1:SetText( "Invalid Code.." )
				label1:SetColor( Color( 255,0,0 ) )
				label1:SetPos( 290, 25 ) 
				label1:SetSize( 280, 20 )
				timer.Simple( 2, function() DermaPanel:SetVisible ( false ) end)		
			end
		end 
end

		
		local label1 = vgui.Create( "DLabel", self )
		label1:SetWrap( true )
		label1:SetText( "Are you a bad enough dude?" )
		label1:SetColor( Color( 255,0,0 ) )
		label1:SetFont( "SupFont" )
		label1:SetPos( self:GetPadding() + 101, self:GetPadding()  ) 
		label1:SetSize( 300, 100 )
		
		local label2 = vgui.Create( "DLabel", self )
		label2:SetWrap( true )
		label2:SetText( "CHEAT CODES" )
		label2:SetFont( "SuperFont" )
		label2:SetColor( Color( 255,0,0 ) )
		label2:SetPos( self:GetPadding() + 100, self:GetPadding() ) 
		label2:SetSize( 300, 50 )
		
		local label3 = vgui.Create( "DLabel", self )
		label3:SetWrap( true )
		label3:SetText( "While you play you might get a random, unrelated, multi-word-no-space notification. Maybe you already have. Either that's bad coding, or you enter them here for cool stuff. There are plenty of opportunities to get codes, whether that be randomly, doing particular tasks, or just asking that guy in the server why he looks like that. You can combine codes, just know that once you enter a code you can't undo it without rejoining." )
		label3:SetFont( "KindaThereFont" )
		label3:SetPos( self:GetPadding(), self:GetPadding() + 50 ) 
		label3:SetSize( 400, 200 )
		
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
	
	self:SizeToContents()

end

function PANEL:Paint()

	draw.RoundedBox( 4, 0, 0, self:GetWide(), self:GetTall(), Color( 0, 0, 0, 255 ) )
	draw.RoundedBox( 4, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color( 150, 150, 150, 150 ) )
	
	//draw.SimpleText( "Class Menu", "ItemDisplayFont", self:GetWide() * 0.5, 10, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

end

derma.DefineControl( "CheatCodes", "Are you a bad enough dude?", PANEL, "PanelBase" )
