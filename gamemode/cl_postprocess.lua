
Sharpen = 0
MotionBlur = 0
DisorientTime = 0

ColorModify = {}
ColorModify[ "$pp_colour_addr" ] 		= 0
ColorModify[ "$pp_colour_addg" ] 		= 0
ColorModify[ "$pp_colour_addb" ] 		= 0
ColorModify[ "$pp_colour_brightness" ] 	= 0
ColorModify[ "$pp_colour_contrast" ] 	= 1
ColorModify[ "$pp_colour_colour" ] 		= 1
ColorModify[ "$pp_colour_mulr" ] 		= 0
ColorModify[ "$pp_colour_mulg" ] 		= 0
ColorModify[ "$pp_colour_mulb" ] 		= 0

MixedColorMod = {}

function GM:DOFThink()

end

function GM:RenderScreenspaceEffects()

	local approach = FrameTime() * 0.05

	if ( Sharpen > 0 ) then
	
		DrawSharpen( Sharpen, 0.5 )
		
		Sharpen = math.Approach( Sharpen, 0, FrameTime() * 0.5 )
		
	end

	if ( MotionBlur > 0 ) then
	
		DrawMotionBlur( 1 - MotionBlur, 1.0, 0.0 )
		
		MotionBlur = math.Approach( MotionBlur, 0, approach )
		
	end
	
	if LocalPlayer():FlashlightIsOn() then
	
		ColorModify[ "$pp_colour_brightness" ] = math.Approach( ColorModify[ "$pp_colour_brightness" ], 0.01, FrameTime() * 0.25 ) 
		ColorModify[ "$pp_colour_contrast" ] = math.Approach( ColorModify[ "$pp_colour_contrast" ], 1.02, FrameTime() * 0.25 ) 
	
	end
	
	local rads = LocalPlayer():GetNWInt( "Radiation", 0 )
	
	if rads > 0 and LocalPlayer():Alive() then
		
		local scale = rads / 5
		
		MotionBlur = math.Approach( MotionBlur, scale * 0.5, FrameTime() )
		Sharpen = math.Approach( Sharpen, scale * 5, FrameTime() * 3 )
	
		ColorModify[ "$pp_colour_colour" ] = math.Approach( ColorModify[ "$pp_colour_colour" ], 1.0 - scale * 0.8, FrameTime() * 0.1 )
		
	end
	
	if GetGlobalBool( "Radiation", false ) and not GAMEMODE.PlayerIsIndoors then
	
		ColorModify[ "$pp_colour_mulg" ] = 0.15
		ColorModify[ "$pp_colour_mulr" ] = 0.10
		ColorModify[ "$pp_colour_addg" ] = 0.05
		ColorModify[ "$pp_colour_addr" ] = 0.03
	
	end
	
	if LocalPlayer():Team() == TEAM_ZOMBIES then
	
		if LocalPlayer():Alive() then
	
			ColorModify[ "$pp_colour_brightness" ] 	= -0.15
			ColorModify[ "$pp_colour_addr" ]		= 0.25
			ColorModify[ "$pp_colour_mulr" ] 		= 0.15
			ColorModify[ "$pp_colour_addg" ]		= 0.15
			
		else
		
			ColorModify[ "$pp_colour_addr" ]		= 0.10
			ColorModify[ "$pp_colour_mulr" ] 		= 0.0
			ColorModify[ "$pp_colour_addg" ]		= 0.0
			ColorModify[ "$pp_colour_brightness" ] 	= 0
			
			MotionBlur = 0.40
		end
	
	else
		if LocalPlayer():Alive() and LocalPlayer():GetNWBool( "Raging", false ) == true then
			
			ColorModify[ "$pp_colour_addr" ]		= 0.25
			ColorModify[ "$pp_colour_mulr" ] 		= 0.30
			ColorModify[ "$pp_colour_brightness" ] 	= -0.20
			
		end
		
		if LocalPlayer():Alive() and LocalPlayer():GetNWBool( "Cloaking", false ) == true then
			
			ColorModify[ "$pp_colour_addb" ]		= 0.25
			ColorModify[ "$pp_colour_mulb" ] 		= 0.30
			ColorModify[ "$pp_colour_brightness" ] 	= 0.3
			
		end
	
		if not LocalPlayer():Alive() then
	
			ColorModify[ "$pp_colour_addr" ]		= 0.10
			ColorModify[ "$pp_colour_mulr" ] 		= 0.15
			ColorModify[ "$pp_colour_brightness" ] 	= -0.20
			
			MotionBlur = 0.40
			
		elseif LocalPlayer():GetNWBool( "Infected", false ) then
		
			ColorModify[ "$pp_colour_brightness" ] = -0.02
			ColorModify[ "$pp_colour_mulg" ] = 0.55
			ColorModify[ "$pp_colour_addg" ] = 0.02 // too much? too little?
			
			//MotionBlur = 0.30
		
		end
	
	end
	
	for k,v in pairs( ColorModify ) do
		
		if k == "$pp_colour_colour" or k == "$pp_colour_contrast" then
		
			ColorModify[k] = math.Approach( ColorModify[k], 1, approach ) 
		
		elseif k == "$pp_colour_brightness" and GetGlobalBool( "GameOver", false ) then
		
			ColorModify[k] = -1.50
		
		else
		
			ColorModify[k] = math.Approach( ColorModify[k], 0, approach ) 
		
		end
	
		MixedColorMod[k] = math.Approach( MixedColorMod[k] or 0, ColorModify[k], FrameTime() * 0.10 )
	
	end
	
	DrawColorModify( MixedColorMod )
	DrawPlayerRenderEffects()
	DrawLaser()
	
end

function GM:GetMotionBlurValues( y, x, fwd, spin ) 

	if LocalPlayer():Team() == TEAM_ZOMBIES then return y, x, fwd, spin end

	if LocalPlayer():Alive() and LocalPlayer():Health() <= 50 then
	
		local scale = math.Clamp( LocalPlayer():Health() / 50, 0, 1 )
		// local beat = math.Clamp( HeartBeat - CurTime(), 0, 2 ) * ( 1 - scale )
		
		fwd = 1 - scale // + beat
		
	elseif LocalPlayer():GetNWBool( "InIron", false ) then
	
		fwd = 0.05
		
	end
	
	if DisorientTime and DisorientTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			DisorientTime = nil
		end
	
		local scale = ( ( DisorientTime or 0 ) - CurTime() ) / 10
		local newx, newy = RotateAroundCoord( 0, 0, 1, scale * 0.05 )
		
		return newy, newx, fwd, spin
	
	end
	
	if ScreamTime and ScreamTime > CurTime() then
	
		if not LocalPlayer():Alive() then 
			ScreamTime = nil
		end
		
		local scale = ( ( ScreamTime or 0 ) - CurTime() ) / 10
		local newy = math.sin( CurTime() * 1.5 ) * scale * 0.08
		
		return newy, x, fwd, spin
	
	end
	
	return y, x, fwd, spin

end

function RotateAroundCoord( x, y, speed, dist )

	local newx = x + math.sin( CurTime() * speed ) * dist
	local newy = y + math.cos( CurTime() * speed ) * dist

	return newx, newy

end

local MaterialVision = Material( "nuke/redead/allyvision" )
//local MaterialItem = Material( "toxsin/allyvision" )

function DrawPlayerRenderEffects()
	
	if LocalPlayer():Team() != TEAM_ZOMBIES and LocalPlayer():Team() != TEAM_ARMY then return end
	
	if not LocalPlayer():Alive() then return end
	
	if GetGlobalBool( "GameOver", false ) then return end
	
	cam.Start3D( EyePos(), EyeAngles() )
	
	--[[if IsValid( TargetedEntity ) and table.HasValue( ValidTargetEnts, TargetedEntity:GetClass() ) then // halos replaced this
	
		if TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ) < 500 then
		
			local scale = 1 - ( TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ) / 500 )
			
			render.SuppressEngineLighting( true )
			render.SetBlend( scale * 0.4 )
			render.SetColorModulation( 0, 0.5, 0 )
			
			render.MaterialOverride( MaterialItem )
			
			cam.IgnoreZ( false )

			TargetedEntity:DrawModel()
	 
			render.SuppressEngineLighting( false )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			
			render.MaterialOverride( 0 )
		
		end
	
	end]]
	
	for k,v in pairs( GAMEMODE:GetHighlightedUnits() ) do
		
		if ( v:IsPlayer() and v:Alive() and v != LocalPlayer() ) or v:IsNPC() then
			
			local scale = ( math.Clamp( v:GetPos():Distance( LocalPlayer():GetPos() ), 500, 3000 ) - 500 ) / 2500

			//render.SuppressEngineLighting( true )
			render.SetBlend( scale )
			
			render.MaterialOverride( MaterialVision )
		
			if LocalPlayer():Team() == TEAM_ARMY then
		
		
				render.SetColorModulation( 0, 0.2, 1.0 )
				
			else
			
				render.SetColorModulation( 1.0, 0.2, 0 )
			
			end
	 
			cam.IgnoreZ( false )
	 
			v:SetupBones()
			v:DrawModel()
	 
			//render.SuppressEngineLighting( false )
			render.SetColorModulation( 1, 1, 1 )
			render.SetBlend( 1 )
			
			render.MaterialOverride( 0 )

		end
		
	end
	
	cam.End3D()

end

DotMat = Material( "sprites/light_glow02_add_noz" )
LasMat = Material( "sprites/bluelaser1" )

function DrawLaser()

	if LocalPlayer():Team() != TEAM_ARMY then return end
	
	//local vm = LocalPlayer():GetViewModel( 0 )
	
	//if not IsValid( vm ) then return end
	
	local wep = LocalPlayer():GetActiveWeapon()
	
	if not IsValid( wep ) or not wep:GetNWBool( "Laser", false ) then return end
	
	//local idx = vm:LookupAttachment( "1" )
		
	//if idx == 0 then idx = vm:LookupAttachment( "muzzle" ) end
		
	--[[local trace = util.GetPlayerTrace( LocalPlayer() )
	local tr = util.TraceLine( trace )
	local tbl = vm:GetAttachment( idx )
		
	local pos = tr.HitPos]]
	
	local look = LocalPlayer():EyeAngles()
	local dir = look:Forward()
	//local tbl = vm:GetAttachment( idx )
	//local ang = tbl.Ang
	//local offset = wep.LaserOffset
						
	//ang:RotateAroundAxis( look:Up(), ( offset.p or 0 ) )
	//ang:RotateAroundAxis( look:Forward(), ( offset.r or 0 ) )
	//ang:RotateAroundAxis( look:Right(), ( offset.y or 0 ) )
						
	//local forward = ang:Forward()
	//lasforward = tbl.Ang:Forward()
						
	//forward = forward * wep.LaserScale
						
	//dir = dir +	forward
	
	local trace = {}
	
	trace.start = LocalPlayer():GetShootPos()	
	trace.endpos = trace.start + dir * 9000
	trace.filter = { LocalPlayer(), weap, lp }
	trace.mask = MASK_SOLID
					
	local tr = util.TraceLine( trace )			
	local dist = math.Clamp( tr.HitPos:Distance( EyePos() ), 0, 500 )
	local size = math.Rand( 2, 4 ) + ( dist / 500 ) * 6
	local col = Color( 255, 0, 0, 255 )
					
	--[[if v == lp and IsValid( GAMEMODE.TargetEnt ) and GAMEMODE.TargetEnt:IsPlayer() and GAMEMODE.TargetEnt:Team() == TEAM_HUMAN then
					
		size = size + math.Rand( 0.5, 2.0 ) 
						
	elseif v != lp then
					
		size = math.Rand( 0, 1 ) + ( dist / 500 ) * 6
					
	end]]
					
	if ( wep.LastRunFrame or  0 ) > CurTime() then return end
					
	cam.Start3D( EyePos(), EyeAngles() )
					
		local norm = ( EyePos() - tr.HitPos ):GetNormal()
					
		render.SetMaterial( DotMat )
		render.DrawQuadEasy( tr.HitPos + norm * size, norm, size, size, col, 0 )
		
	cam.End3D()
		
	--[[if vm:GetSequence() != ACT_VM_IDLE then
			
		wep.AngDiff = ( tbl.Ang - ( wep.LastGoodAng or Angle(0,0,0) ) )//:Forward()
			
		trace = {}
		trace.start = EyePos() or Vector(0,0,0)
		trace.endpos = trace.start + ( ( EyeAngles() + wep.AngDiff ):Forward() * 99999 )
		trace.filter = { wep, LocalPlayer() }
		
		local tr2 = util.TraceLine( trace )
			
		pos = tr2.HitPos
			
	else
		
		wep.LastGoodAng = tbl.Ang
		
	end]]
		
	--[[cam.Start3D( EyePos(), EyeAngles() )
		
		local dir = ( tbl.Ang + Angle(0,90,0) ):Forward()
		dir.z = EyeAngles():Forward().z
		
		local start = tbl.Pos + ( dir * -5 ) + wep.LaserOffset
	
		render.SetMaterial( LasMat )
			
		for i=0,254 do
			
			render.DrawBeam( start, start + dir * 0.2, 2, 0, 12, Color( 255, 0, 0, 255 - i ) )
				
			start = start + dir * 0.2
				
		end
				
		local dist = tr.HitPos:Distance( EyePos() )
		local size = math.Rand( 7, 8 )
		local dotsize = dist / ( size ^ 2 )
			
		render.SetMaterial( DotMat )
		render.DrawQuadEasy( pos, ( EyePos() - tr.HitPos ):GetNormal(), dotsize, dotsize, Color( 255, 0, 0, 255 ), 0 )
			
	cam.End3D()	]]

end

function GM:GetHighlightedUnits()

	local tbl = team.GetPlayers( TEAM_ARMY )
	tbl = table.Add( tbl, ents.FindByClass( "npc_scientist" ) )
	
	return tbl

end

function GM:PreDrawHalos()

	if GetGlobalBool( "GameOver", false ) then return end

	if LocalPlayer():Team() != TEAM_ZOMBIES and LocalPlayer():Team() != TEAM_ARMY then return end
	
	--[[for k,v in pairs( GAMEMODE:GetHighlightedUnits() ) do
		
		if ( ( v:IsPlayer() and v:Alive() and v != LocalPlayer() ) or ( v:IsNPC() and not v.Ragdolled ) ) then
		
			local dist = math.Clamp( v:GetPos():Distance( LocalPlayer():GetPos() ), 250, 500 ) - 250
			local scale = dist / 250
		
			if scale > 0 then
		
				if LocalPlayer():Team() == TEAM_ARMY then
				
					//halo.Add( {v}, Color( 0, 200, 200, 200 * scale ), 2, 2, 1, 1, true ) // removed till garry optimizes this
				
				else
				
					//halo.Add( {v}, Color( 200, 0, 0, 200 * scale ), 2, 2, 1, 1, false )
				
				end
				
			end

		end
		
	end]]
	
	if LocalPlayer():Team() == TEAM_ARMY then
	
		if IsValid( TargetedEntity ) and not TargetedEntity:IsPlayer() and ( TargetedEntity:GetClass() != "npc_scientist" or TargetedEntity:GetNWBool( "Dead", false ) == false ) then
	
			local dist = math.Clamp( TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ), 0, 500 )
			local scale = 1 - ( dist / 500 )
			
			if TargetedEntity:GetClass() == "npc_hum_anarchist" or TargetedEntity:GetClass() == "npc_hum_blackwatch" then
			halo.Add( {TargetedEntity}, Color( 200, 0, 0, 255 * scale ), 2 * scale, 2 * scale, 1, 1, false )
			elseif TargetedEntity:GetClass() == "npc_nb_annihilator" then
			dist = math.Clamp( TargetedEntity:GetPos():Distance( LocalPlayer():GetPos() ), 0, 100 )
			halo.Add( {TargetedEntity}, Color( 255, 160, 0, 255 * scale ), 2 * scale, 2 * scale, 1, 1, false )
			else
			halo.Add( {TargetedEntity}, Color( 0, 100, 200, 255 * scale ), 2 * scale, 2 * scale, 1, 1, false )
			end
		end
		
		if IsValid( GAMEMODE.ClientAntidote ) then
		
			local dist = math.Clamp( GAMEMODE.ClientAntidote:GetPos():Distance( LocalPlayer():GetPos() ), 250, 500 ) - 250
			local scale = dist / 250
			
			halo.Add( {GAMEMODE.ClientAntidote}, Color( 0, 200, 0, 200 * scale ), 2, 2, 1, 1, true )
		
		end
		
		for k,v in pairs( ents.FindByClass( "sent_trader" ) ) do
		
			local dist = math.Clamp( v:GetPos():Distance( LocalPlayer():GetPos() ), 250, 500 ) - 250
			local scale = dist / 250
			
			halo.Add( {v}, Color( 102, 204, 0, 200 * scale ), 2, 2, 1, 1, true )
		
		end
		
		for k,v in pairs( ents.FindByClass( "sent_supplycrate" ) ) do
		
			local dist = math.Clamp( v:GetPos():Distance( LocalPlayer():GetPos() ), 250, 500 ) - 250
			local scale = dist / 250
			if v.User == LocalPlayer() then
			halo.Add( {v}, Color( 102, 204, 0, 200 * scale ), 2, 2, 1, 1, true )
			end
		
		end

	
	end

end

WalkTimer = 0
VelSmooth = 0
DeathAngle = Angle(0,0,0)
DeathOrigin = Vector(0,0,0)

function GM:CalcView( ply, origin, angle, fov )

	local vel = ply:GetVelocity()
	local ang = ply:EyeAngles()
	
	VelSmooth = VelSmooth * 0.5 + vel:Length() * 0.1
	WalkTimer = WalkTimer + VelSmooth * FrameTime() * 0.1
	
	angle.roll = angle.roll + ang:Right():DotProduct( vel ) * 0.002
	
	if ply:Alive() then
	
		--[[if ViewWobble > 0 then
	
			angle.roll = angle.roll + math.sin( CurTime() + TimeSeed( 1, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.pitch = angle.pitch + math.sin( CurTime() + TimeSeed( 2, -2, 2 ) ) * ( ViewWobble * 15 )
			angle.yaw = angle.yaw + math.sin( CurTime() + TimeSeed( 3, -2, 2 ) ) * ( ViewWobble * 15 )
			
		end]]
		
		DeathAngle = angle
		DeathOrigin = origin
		

		

	
	end
	
	if ply:GetGroundEntity() != NULL then
	
		angle.roll = angle.roll + math.sin( WalkTimer ) * VelSmooth * 0.001
		angle.pitch = angle.pitch + math.cos( WalkTimer * 1.25 ) * VelSmooth * 0.005
		
	end
		
	return self.BaseClass:CalcView( ply, origin, angle, fov )
	
end
