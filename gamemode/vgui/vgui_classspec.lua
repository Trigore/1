local PANEL = {}
PANEL.ButtonText = { "I wanna be this guy",
"I choose you",
"this guy looks cool enough for me",
"wow I'm so handsome",
"this guy is ok",
"I'll take him",
"I'm not a nerd so I pick this guy",
"this job looks fun",
"he is my idol",
"everyone else just seems bad",
"let me thinkYES",
"didn't read but i like his picture",
"I'm gonna shoot so many zombies as this guy",
"wow uh how about yes",
"SELECTED",
"he's pretty cool",
"THIS IS WHO I WANT",
"liked, commented, and selected",
"i am liking the look of this guy" }
function PANEL:Init()

	//self:SetTitle( "" )
	//self:ShowCloseButton( false )
	self:ChooseParent()
	
		surface.CreateFont ( "PerkFont", { size = 30, weight = 200, antialias = true, additive = true, font = "Verdana" } )
		surface.CreateFont ( "LevelFont", { size = 20, weight = 200, antialias = true, additive = true, font = "Verdana" } )
		local plySavedData = LocalLevel
		local x,y = self:GetPadding(), self:GetPadding()
		local intro = "THE SPECIALIST"
		local desc = "You can't get very far in life without knowing the right people, and the Specialist knows all of them. He's worked at the SAS for years and has made some powerful friends along the way, the kind that'll get you whatever you need without strings attached. If anyone is naive enough to deny him what he wants, he's got multiple calibers of persuasion that he prides himself on being efficient with. Years of work and reputation collapsed with the Toxsin virus, as most of his friends wanted some blood as payment. When he met the Commando, they formed Unit 9 with the help of whatever friends weren't animated corpses. Together, they went on to train many of the finest members in the team. He was responsible for ordering any supplies they were short on, and with his smooth talking there was never an issue. When the X mutations appeared, only a handful of the unit weren't torn to shreds. The idea of zombies seemed insane to him at first, but a little bit of target practice never hurt anyone."
		local level = "Level: " .. plySavedData[ "class_specialist.level" ]
		local totexp = "Experience: " .. plySavedData[ "class_specialist.experience" ]
		local reqexp = plySavedData[ "class_specialist.reqexperience" ]
		local experience = totexp .. " / " .. reqexp
		local logo = "nuke/redead/specialist"
		
		local button = vgui.Create( "DImage", self )
		button:SetImage( logo )
		button:SetSize( 200, 200 )
		button:SetPos( x, y )

		local label1 = vgui.Create( "DLabel", self )
		label1:SetWrap( true )
		label1:SetText( level )
		label1:SetFont( "LevelFont" )
		label1:SetPos( self:GetPadding() + 210, self:GetPadding()  ) 
		label1:SetSize( 300, 100 )
		
		local label3 = vgui.Create( "DLabel", self )
		label3:SetWrap( true )
		label3:SetText( experience )
		label3:SetFont( "ItemDisplayFont" )
		label3:SetPos( self:GetPadding() + 211, self:GetPadding() + 20 ) 
		label3:SetSize( 300, 100 )
		
		local label2 = vgui.Create( "DLabel", self )
		label2:SetWrap( true )
		label2:SetText( intro )
		label2:SetFont( "PerkFont" )
		label2:SetPos( self:GetPadding() + 210, self:GetPadding()  ) 
		label2:SetSize( 300, 50 )
		
		local label = vgui.Create( "DLabel", self )
		label:SetWrap( true )
		label:SetText( desc )
		label:SetFont( "ItemDisplayFont" )
		label:SetPos( self:GetPadding(), self:GetPadding() + 150 ) 
		label:SetSize( 450, 300 )
	
		local stats = vgui.Create( "DLabel", self )
		stats:SetWrap( true )
		stats:SetText( "Ability: Airdrop Shipments" )
		stats:SetColor(Color(0,255,0,255))
		stats:SetFont( "ItemDisplayFont" )
		stats:SetPos( self:GetPadding() + 210, self:GetPadding() + 35  ) 
		stats:SetSize( 400, 100 )
		
		local stats3 = vgui.Create( "DLabel", self )
		stats3:SetWrap( true )
		stats3:SetText( "Access to advanced weaponry" )
		stats3:SetColor(Color(0,255,0,255))
		stats3:SetFont( "ItemDisplayFont" )
		stats3:SetPos( self:GetPadding() + 210, self:GetPadding() + 50  ) 
		stats3:SetSize( 400, 100 )
		
		local stats1 = vgui.Create( "DLabel", self )
		stats1:SetWrap( true )
		stats1:SetText( "-" .. (1.25 * plySavedData[ "class_specialist.level" ] ) .. "s initial wait time on Airdrops" )
		stats1:SetColor(Color(0,255,0,255))
		stats1:SetFont( "ItemDisplayFont" )
		stats1:SetPos( self:GetPadding() + 210, self:GetPadding() + 80  ) 
		stats1:SetSize( 400, 100 )
		
		local stats5 = vgui.Create( "DLabel", self )
		stats5:SetWrap( true )
		stats5:SetText( "-" .. (0.33 * plySavedData[ "class_specialist.level" ] ) .. "s wait time per item on Airdrops" )
		stats5:SetColor(Color(0,255,0,255))
		stats5:SetFont( "ItemDisplayFont" )
		stats5:SetPos( self:GetPadding() + 210, self:GetPadding() + 95  ) 
		stats5:SetSize( 400, 100 )
		
		local stats11 = vgui.Create( "DLabel", self )
		stats11:SetWrap( true )
		stats11:SetText( "No Ability Recharge" )
		stats11:SetColor(Color(0,255,0,255))
		stats11:SetFont( "ItemDisplayFont" )
		stats11:SetPos( self:GetPadding() + 210, self:GetPadding() + 110  ) 
		stats11:SetSize( 400, 100 )
		
		local stats4 = vgui.Create( "DLabel", self )
		stats4:SetWrap( true )
		stats4:SetText( "+" .. 10 + 5 * plySavedData[ "class_specialist.level" ] .. "% Cashback from selling items" )
		stats4:SetColor(Color(0,255,0,255))
		stats4:SetFont( "ItemDisplayFont" )
		stats4:SetPos( self:GetPadding() + 210, self:GetPadding() + 65  ) 
		stats4:SetSize( 400, 100 )
		
		local stats2 = vgui.Create( "DLabel", self )
		stats2:SetWrap( true )
		stats2:SetText( "No Character Attributes" )
		stats2:SetColor(Color(255,0,0,255))
		stats2:SetFont( "ItemDisplayFont" )
		stats2:SetPos( self:GetPadding() + 210, self:GetPadding() + 125  ) 
		stats2:SetSize( 400, 100 )
				local h = plySavedData[ "class_specialist.level" ]
		if h >= 5 then
		local bonus = ""
		if h == 5 then
		bonus = "Spawns with CZ-75 due to perk level"
		elseif h == 6 then
		bonus = "Spawns with CZ=75 and Mateba Revolver due to perk level"
		end
		local perk1 = vgui.Create( "DLabel", self )
		perk1:SetWrap( true )
		perk1:SetText( bonus  )
		perk1:SetColor(Color(0,255,0,255))
		perk1:SetFont( "ItemDisplayFont" )
		perk1:SetPos( self:GetPadding(), self:GetPadding() + 390 ) 
		perk1:SetSize( 400, 25 )
		end
		local Button1 = vgui.Create( "DButton", self )
		Button1:SetSize( 469, 40 )
		Button1:SetText( table.Random( self.ButtonText ) )
		Button1:SetPos( 0, 423 )
		Button1.OnMousePressed = function() RunConsoleCommand( "changeclass", CLASS_SPECIALIST ) if LocalPlayer():Team() == TEAM_UNASSIGNED then RunConsoleCommand( "changeteam", TEAM_ARMY ) end self:GetParent():GetParent():Remove() end
		
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


derma.DefineControl( "ClassSpec", "Specialist's menu for the ClassPicker.", PANEL, "PanelBase" )