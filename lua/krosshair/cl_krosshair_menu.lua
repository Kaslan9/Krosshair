local PANEL = {}

local bulletfired = false
local firetime = CurTime()

local gaptime = kcs.gaptime // how long the gap increases and decreases

// f1 menu for TTT
function PANEL:Init()

    local settings_panel = vgui.Create("DScrollPanel", self)
    settings_panel:Dock(FILL)
    settings_panel.Paint = function(s,w,h)
        surface.SetDrawColor(64,64,64)
        surface.DrawRect(0,0,w,h)
    end

    local about_panel = vgui.Create("DPanel", self)
    about_panel:Dock(FILL)
    about_panel:SetBackgroundColor(Color(64,64,64))
    self:AddSheet("Settings", settings_panel, "icon16/cog.png")    
    self:AddSheet("About", about_panel, "icon16/user.png")

    // enable or disable custom crosshairs
    local enable_crosshair = vgui.Create("DCheckBoxLabel", settings_panel)
    enable_crosshair:SetPos(10,10)
    enable_crosshair:SetConVar("cl_krosshair")
    enable_crosshair:SetText("Enable Crosshair")
    enable_crosshair:SetTooltip("Enable or Disable this crosshair")

    // choosing color of crosshair
    local color_mixer = vgui.Create("DColorMixer", settings_panel)
    color_mixer:SetSize(200,100)
    color_mixer:SetPos(10,30)				-- Make Mixer fill place of Frame
    color_mixer:SetPalette(false)  			-- Show/hide the palette 				DEF:true
    color_mixer:SetAlphaBar(true) 			-- Show/hide the alpha bar 				DEF:true
    color_mixer:SetWangs(true) 				-- Show/hide the R G B A indicators 	DEF:true
    color_mixer:SetColor(Color(30,100,160)) 	-- Set the default color
    color_mixer:SetConVarA("cl_krosshair_brightness")
    color_mixer:SetConVarR("cl_krosshair_red")
    color_mixer:SetConVarG("cl_krosshair_green")
    color_mixer:SetConVarB("cl_krosshair_blue")

    // choosing length of crosshair
    local convar = GetConVar("cl_krosshair_length")
    local crosshair_len = vgui.Create("DNumSlider", settings_panel)
    crosshair_len:SetSize(250,20)
    crosshair_len:SetPos(10,135)
    crosshair_len:SetDecimals(0)
    crosshair_len:SetText("Crosshair Length")
    crosshair_len:SetMin(convar:GetMin())
    crosshair_len:SetMax(convar:GetMax())
    crosshair_len:SetConVar("cl_krosshair_length")
    crosshair_len:SetTooltip("Set the length of the crosshair")

    // choosing thickness of crosshair
    local convar = GetConVar("cl_krosshair_thickness")
    local crosshair_thickness = vgui.Create("DNumSlider", settings_panel)
    crosshair_thickness:SetSize(250,20)
    crosshair_thickness:SetPos(10,160)
    crosshair_thickness:SetDecimals(0)
    crosshair_thickness:SetText("Crosshair Thickness")
    crosshair_thickness:SetMin(convar:GetMin())
    crosshair_thickness:SetMax(convar:GetMax())
    crosshair_thickness:SetConVar("cl_krosshair_thickness")
    crosshair_thickness:SetTooltip("It is recommended to keep this value an even number.")

    // choosing gap of crosshair
    local convar = GetConVar("cl_krosshair_gap")
    local crosshair_gap = vgui.Create("DNumSlider", settings_panel)
    crosshair_gap:SetSize(250,20)
    crosshair_gap:SetPos(10,185)
    crosshair_gap:SetDecimals(0)
    crosshair_gap:SetText("Crosshair Gap")
    crosshair_gap:SetMin(convar:GetMin())
    crosshair_gap:SetMax(convar:GetMax())
    crosshair_gap:SetConVar("cl_krosshair_gap")
    crosshair_gap:SetTooltip("Set the gap in the crosshair")
    // name for shape
    local shape_label = vgui.Create("DLabel", settings_panel)
    shape_label:SetText("Crosshair Shape")
    shape_label:SizeToContents()
    shape_label:SetPos(10,212)

    // choosing shape of crosshair
    local convar = GetConVar("cl_krosshair_shape")
    local val = convar:GetInt()
    local crosshair_shape = vgui.Create("DComboBox", settings_panel)
    crosshair_shape:SetSize(60,20)
    crosshair_shape:SetPos(120,210)
    local shape = "Cross"
    if val == 1 then shape = "T" elseif val == 2 then shape = "Circle" end 
    crosshair_shape:SetValue(shape)
    crosshair_shape:AddChoice( "Cross" )
    crosshair_shape:AddChoice( "T" )
    crosshair_shape:AddChoice( "Circle" )
    crosshair_shape:SetToolTip("Set Crosshair Shape")
    crosshair_shape.OnSelect = function( self, index, value )
        GetConVar("cl_krosshair_shape"):SetInt(index-1)
    end

    // enable or disable dot
    local enable_dot = vgui.Create("DCheckBoxLabel", settings_panel)
    enable_dot:SetPos(10,240)
    enable_dot:SetConVar("cl_krosshair_dot")
    enable_dot:SetText("Enable Dot")
    enable_dot:SetToolTip("Enable or Disable center dot")

    // choose dot size
    local convar = GetConVar("cl_krosshair_dot_size")
    local dot_size = vgui.Create("DNumSlider", settings_panel)
    dot_size:SetSize(250,20)
    dot_size:SetPos(10,262)
    dot_size:SetDecimals(0)
    dot_size:SetText("Dot Size")
    dot_size:SetMin(convar:GetMin())
    dot_size:SetMax(convar:GetMax())
    dot_size:SetConVar("cl_krosshair_dot_size")
    dot_size:SetToolTip("Set the size of center dot")

    // enable or disable dynamic crosshair
    local crosshair_state = vgui.Create("DCheckBoxLabel", settings_panel)
    crosshair_state:SetPos(10,290)
    crosshair_state:SetConVar("cl_krosshair_static")
    crosshair_state:SetText("Static Crosshair")
    crosshair_state:SetToolTip("Enable or Disable static crosshair | Disabled: Reactive to shooting")

    // choose how much the crosshair "jumps"
    local convar = GetConVar("cl_krosshair_inaccuracy")
    local dynamic_inaccuracy = vgui.Create("DNumSlider", settings_panel)
    dynamic_inaccuracy:SetSize(250,20)
    dynamic_inaccuracy:SetPos(10,310)
    dynamic_inaccuracy:SetDecimals(0)
    dynamic_inaccuracy:SetText("Crosshair Inaccuracy")
    dynamic_inaccuracy:SetMin(convar:GetMin())
    dynamic_inaccuracy:SetMax(convar:GetMax())
    dynamic_inaccuracy:SetConVar("cl_krosshair_inaccuracy") 
    dynamic_inaccuracy:SetToolTip("Set how much the crosshair 'jumps' when shooting")

    // enable or disable outline
    local enable_outline = vgui.Create("DCheckBoxLabel", settings_panel)
    enable_outline:SetPos(10,340)
    enable_outline:SetConVar("cl_krosshair_outline")
    enable_outline:SetText("Enable Outline")
    enable_outline:SetToolTip("Enable or Disable outline")
    
    // choose opacity of outline
    local convar = GetConVar("cl_krosshair_outline_opacity")
    local outline_opacity = vgui.Create("DNumSlider", settings_panel)
    outline_opacity:SetSize(250,20)
    outline_opacity:SetPos(10,365)
    outline_opacity:SetDecimals(0)
    outline_opacity:SetText("Outline Opacity")
    outline_opacity:SetMin(convar:GetMin())
    outline_opacity:SetMax(convar:GetMax())
    outline_opacity:SetConVar("cl_krosshair_outline_opacity") 
    outline_opacity:SetToolTip("Set opacity of outline")

    // choose thickness of outline
    local convar = GetConVar("cl_krosshair_outline_thickness")
    local outline_thickness = vgui.Create("DNumSlider", settings_panel)
    outline_thickness:SetSize(250,20)
    outline_thickness:SetPos(10,390)
    outline_thickness:SetDecimals(0)
    outline_thickness:SetText("Outline Thickness")
    outline_thickness:SetMin(convar:GetMin())
    outline_thickness:SetMax(convar:GetMax())
    outline_thickness:SetConVar("cl_krosshair_outline_thickness") 
    outline_thickness:SetTooltip("It is recommended to keep this value an even number.")

    local renderer = vgui.Create("krosshair_renderer", settings_panel)
    renderer:SetSize(150,150)
    renderer:SetPos(400,30)
    //renderer:SetBackgroundColor(Color(32,32,32))

    local simulate_fire = vgui.Create("DButton", settings_panel)
    simulate_fire:SetText( "Shoot Bullet" )					
    simulate_fire:SetPos( 435, 190 )					
    simulate_fire:SetSize( 80, 20 )	
    simulate_fire:SetToolTip("Click to simulate the look of the crosshair when firing")				
    simulate_fire.DoClick = function()
        if not GetConVar("cl_krosshair_static"):GetBool() then
            bulletfired = true
            firetime = CurTime()
        end
    end

    local share_crosshair = vgui.Create("DButton", settings_panel)
    share_crosshair:SetText( "Share Crosshair" )					
    share_crosshair:SetPos( 425, 220 )					
    share_crosshair:SetSize( 100, 30 )	
    share_crosshair:SetToolTip("Click to copy crosshair settings to clipboard")				
    share_crosshair.DoClick = function()
        SetClipboardText(kcs.FormatCrosshair())
    end

end
vgui.Register("krosshair_Panel", PANEL, "DPropertySheet") // register panel to use it


// register crosshair settings in TTT f1 menu
if kcs.gamemode == "terrortown" then
    hook.Add("TTTSettingsTabs", "krosshair_TTTSettingsTabs", function(dtabs)
        local crosshair_settings = vgui.Create("krosshair_Panel", dtabs)
        dtabs:AddSheet("Custom Crosshair", crosshair_settings, "icon16/gun.png", false, false, "Create Custom Crosshair")
    end)
end

// Panel for crosshair renderer.
local PANEL = {}
function PANEL:Init()

    local base = vgui.Create("DPanel", self)
    base:Dock(FILL)

    local crosshair_state = 0 // Crosshair state refers to what happens when a bullet is fired
                              // should the crosshair increase or decrease.
                              // 0 for nothing, 1 for increase, 2 for decrease.

    local shape, length, thickness, origianlgap, dot, static, gapincrase, outline, outlineopacity, outlinethickness
    local r,g,b,a 
    local centerx, centery
    base.Paint = function(s,w,h)
        if not GetConVar("cl_krosshair"):GetBool() then return end

        r,g,b,a= GetConVar("cl_krosshair_red"):GetInt(), GetConVar("cl_krosshair_green"):GetInt(),GetConVar("cl_krosshair_blue"):GetInt(),GetConVar("cl_krosshair_brightness"):GetInt()

        centerx = w/2
        centery = h/2
        shape = GetConVar("cl_krosshair_shape"):GetInt()
        length= GetConVar("cl_krosshair_length"):GetInt()
        thickness = GetConVar("cl_krosshair_thickness"):GetInt()
        origianlgap = GetConVar("cl_krosshair_gap"):GetInt()
        dot = GetConVar("cl_krosshair_dot"):GetBool()
        static = GetConVar("cl_krosshair_static"):GetBool()
        gapincrease = GetConVar("cl_krosshair_inaccuracy"):GetInt()
        outline = GetConVar("cl_krosshair_outline"):GetBool()
        outlineopacity = GetConVar("cl_krosshair_outline_opacity"):GetInt()
        outlinethickness = GetConVar("cl_krosshair_outline_thickness"):GetInt()

        // simulate shooting a bullet with dynamic crosshair
        // gap should increase for a period of time and then decrease to original gap

        // what's the best way to do this?
        // how much should it increase?
        // for how long should it increase?
        // how fast should it decrease?
        
        if not static then
            if bulletfired then
                crosshair_state = 1
            end
            // logic for gap increase or decrease
            if crosshair_state == 1  then // increase gap as long as crosshair state allows it
                gap = origianlgap + gapincrease

            elseif crosshair_state == 2 then // decrease gap as long as crosshair state allows it
                gap = origianlgap - gapincrease

            elseif crosshair_state == 0 then // set gap back to original gap when crosshair state changes to 0
                gap = origianlgap 
            end

            if firetime + (gaptime/2) > CurTime() then // decrease gap
                crosshair_state = 2
            elseif firetime + gaptime > CurTime() then // set gap back to 0
                crosshair_state = 0
                bulletfired = false
            end

        end
        if static then
            gap = origianlgap
        end
        
        if shape == 1 || shape == 0 then

                if (shape == 0) then
                    // draw top segment
                    if outline then // draw outline
                        surface.SetDrawColor(0,0,0,outlineopacity)
                        surface.DrawOutlinedRect(centerx - (thickness/2) - (outlinethickness/2), centery - gap - length - (outlinethickness/2), thickness + outlinethickness, length + outlinethickness, outlinethickness)
                    end
                    surface.SetDrawColor(r,g,b,a)
                    surface.DrawRect(centerx - (thickness/2), centery - gap - length, thickness, length)
                end
                
                // draw left segment
                if outline then // draw outline
                    surface.SetDrawColor(0,0,0,outlineopacity)
                    surface.DrawOutlinedRect(centerx - length - gap - (outlinethickness/2) , centery - (thickness/2) - (outlinethickness/2) , length + outlinethickness , thickness + outlinethickness,outlinethickness)
                end
                surface.SetDrawColor(r,g,b,a)
                surface.DrawRect(centerx - length - gap, centery - (thickness/2), length, thickness)
                
                // draw bottom segment
                if outline then // draw outline
                    surface.SetDrawColor(0,0,0,outlineopacity)
                    surface.DrawOutlinedRect(centerx - (thickness/2) - (outlinethickness/2), centery + gap - (outlinethickness/2), thickness + outlinethickness, length + outlinethickness, outlinethickness)
                end
                surface.SetDrawColor(r,g,b,a)
                surface.DrawRect(centerx - (thickness/2), centery + gap, thickness, length)

                // draw right segment
                if outline then // draw outline
                    surface.SetDrawColor(0,0,0,outlineopacity)
                    surface.DrawOutlinedRect(centerx + gap - (outlinethickness/2), centery - (thickness/2) - (outlinethickness/2), length + outlinethickness,thickness + outlinethickness, outlinethickness)
                end
                surface.SetDrawColor(r,g,b,a)
                surface.DrawRect(centerx + gap, centery - (thickness/2), length,thickness)
    
                // draw dot
                if dot then
                    dot_size = GetConVar("cl_krosshair_dot_size"):GetInt()
                    draw.NoTexture()
                    draw.Circle( centerx, centery, dot_size, 60)
                end
        elseif (shape == 2) then
            surface.DrawCircle(centerx, centery, length, r,g,b,a)
        end
    end
end

// ripped off wiki cause i'm not smart enough
function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

vgui.Register("krosshair_renderer", PANEL, "DPanel")


// Gets crosshair table returns formatted string for sharing
function kcs.FormatCrosshair()
    local str = ""
    for k,v in ipairs(kcs.Convars) do
        str = str..v:GetName().." "..v:GetInt()..";"
    end
    return str
end

