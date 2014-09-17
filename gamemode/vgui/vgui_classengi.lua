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
		local intro = "THE TECHNICIAN"
		local desc = "It's hard to think the Technician was never in combat before the Toxsin virus spread with the way he handles himself. Everyone considered him to be more of the book worm type than the physical type, and with a diploma in electrical, biomedical, and mechanical engineering you couldn't possibly blame them. His days in Seal Team 6 consisted of repairing the vehicles and tending to any injured in the base. When the Toxsin virus actually hit he spent most of his time trying to design antidotes, although with some unfavorable side effects. He was recruited into Unit 9 for his outstanding resourcefulness and somewhat sadistic creativity. On a scavenging mission he found and cured the Scout, effectively recruiting him into Unit 9. He designed most of the team's equipment: Scout's cloaking module, Specialist's universal radio, and Commando's reactive kevlar. Even though he never got much action before, there are some things that'll always be effective. Like strapping a C4 to a gas can."
		local level = "Level: " .. plySavedData[ "class_engineer.level" ]
		local totexp = "Experience: " .. plySavedData[ "class_engineer.experience" ]
		local reqexp = plySavedData[ "class_engineer.reqexperience" ]
		local experience = totexp .. " / " .. reqexp
		local logo = "nuke/redead/engineer"
		
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
		stats:SetText( "Can build traps and rebuild doors" )
		stats:SetColor(Color(0,255,0,255))
		stats:SetFont( "ItemDisplayFont" )
		stats:SetPos( self:GetPadding() + 210, self:GetPadding() + 50  ) 
		stats:SetSize( 400, 100 )
		
		local stats1 = vgui.Create( "DLabel", self )
		stats1:SetWrap( true )
		stats1:SetText( "Has access to advanced supplies" )
		stats1:SetColor(Color(0,255,0,255))
		stats1:SetFont( "ItemDisplayFont" )
		stats1:SetPos( self:GetPadding() + 210, self:GetPadding() + 65  ) 
		stats1:SetSize( 400, 100 )
		
		local stats2 = vgui.Create( "DLabel", self )
		stats2:SetWrap( true )
		stats2:SetText( "Ability: Health Dispenser" )
		stats2:SetColor(Color(0,255,0,255))
		stats2:SetFont( "ItemDisplayFont" )
		stats2:SetPos( self:GetPadding() + 210, self:GetPadding() + 35  ) 
		stats2:SetSize( 400, 100 )
		
		local stats3 = vgui.Create( "DLabel", self )
		stats3:SetWrap( true )
		stats3:SetText( "+" .. 2 * plySavedData[ "class_engineer.level" ] .. "% Rebuilt door HP" )
		stats3:SetColor(Color(0,255,0,255))
		stats3:SetFont( "ItemDisplayFont" )
		stats3:SetPos( self:GetPadding() + 210, self:GetPadding() + 110  ) 
		stats3:SetSize( 400, 100 )
		
		local stats4 = vgui.Create( "DLabel", self )
		stats4:SetWrap( true )
		stats4:SetText( "+" .. ( 20 + (8 * plySavedData[ "class_engineer.level" ] ) ) .. "% Reinforcement HP"  )
		stats4:SetColor(Color(0,255,0,255))
		stats4:SetFont( "ItemDisplayFont" )
		stats4:SetPos( self:GetPadding() + 210, self:GetPadding() + 95  ) 
		stats4:SetSize( 400, 100 )
		
		local stats8 = vgui.Create( "DLabel", self )
		stats8:SetWrap( true )
		stats8:SetText( "+" .. 6 * plySavedData[ "class_engineer.level" ] .. "% Trap Potency"  )
		stats8:SetColor(Color(0,255,0,255))
		stats8:SetFont( "ItemDisplayFont" )
		stats8:SetPos( self:GetPadding() + 210, self:GetPadding() + 125 ) 
		stats8:SetSize( 400, 100 )
		
		local stats7 = vgui.Create( "DLabel", self )
		stats7:SetWrap( true )
		stats7:SetText( "Ability recharges " .. 10 * plySavedData[ "class_engineer.level" ] .. "% Faster"  )
		stats7:SetColor(Color(0,255,0,255))
		stats7:SetFont( "ItemDisplayFont" )
		stats7:SetPos( self:GetPadding() + 210, self:GetPadding() + 140  ) 
		stats7:SetSize( 400, 100 )
		
		local stats9 = vgui.Create( "DLabel", self )
		stats9:SetWrap( true )
		stats9:SetText( "No Character Attributes" )
		stats9:SetColor(Color(255,0,0,255))
		stats9:SetFont( "ItemDisplayFont" )
		stats9:SetPos( self:GetPadding() + 210, self:GetPadding() + 155  ) 
		stats9:SetSize( 400, 100 )
		
		local stats5 = vgui.Create( "DLabel", self )
		stats5:SetWrap( true )
		stats5:SetText( "Spawns with a hammer" )
		stats5:SetColor(Color(0,255,0,255))
		stats5:SetFont( "ItemDisplayFont" )
		stats5:SetPos( self:GetPadding() + 210, self:GetPadding() + 80  ) 
		stats5:SetSize( 400, 100 )
		local h = plySavedData[ "class_engineer.level" ]
		if h >= 5 then
		if h == 5 then
		bonus = "Spawns with HNH-18 due to perk level"
		elseif h == 6 then
		bonus = "Spawns with HNH-18 and Trap Building Tool due to perk level"
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
		Button1.OnMousePressed = function() RunConsoleCommand( "changeclass", CLASS_ENGINEER ) if LocalPlayer():Team() == TEAM_UNASSIGNED then RunConsoleCommand( "changeteam", TEAM_ARMY ) end self:GetParent():GetParent():Remove() end
		
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


derma.DefineControl( "ClassEngi", "Engineer's menu for the ClassPicker.", PANEL, "PanelBase" )