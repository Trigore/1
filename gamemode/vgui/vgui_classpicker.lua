local PANEL = {}

function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
	local PropertySheet = vgui.Create( "DPropertySheet" )
	PropertySheet:SetParent( self )
	PropertySheet:Center()
	PropertySheet:SetSize( 475, 500 )
	local cheatcode = ""
			
	local SheetItemOne = vgui.Create( "ClassScout" )
	
	local SheetItemTwo = vgui.Create( "ClassComm" )
	
	local SheetItemThree = vgui.Create( "ClassSpec" )
	
	local SheetItemFour = vgui.Create( "ClassEngi" )
	
	local SheetItemFive = vgui.Create( "CheatCodes" )
	
	if cheatcode == "helpme" then
		local helpme = vgui.Create( "HelpMenu" )
		helpme:SetSize( 475, 500 )
		helpme:Center()
		helpme:MakePopup()
	end
	
	PropertySheet:AddSheet( "Scout", SheetItemOne, false, false, false, "Wanna see me do it again" )
	PropertySheet:AddSheet( "Commando", SheetItemTwo, false, false, false, "I dare you to try" )
	PropertySheet:AddSheet( "Specialist", SheetItemThree, false, false, false, "I have a radio" )
	PropertySheet:AddSheet( "Technician", SheetItemFour, false, false, false, "I solve practical problems" )
	PropertySheet:AddSheet( "PUSH THE BUTTONS", SheetItemFive, false, false, false, "no the contra code does not work" )
	
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

derma.DefineControl( "ClassPicker", "A class picker menu.", PANEL, "PanelBase" )
