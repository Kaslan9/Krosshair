
local bulletfired = false
local firetime = CurTime()
local w,h = ScrW(), ScrH()
local gaptime = kcs.gaptime

local shape, length, thickness, origianlgap, dot, static, gapincrase, outline, outlineopacity, outlinethickness
local r,g,b,a 
local centerx, centery


local function DrawCrosshair()
    local client = LocalPlayer()
    //if not IsValid(client) then return end
    if not GetConVar("cl_krosshair"):GetBool() then return end
    if not IsValid(client) || client:IsSpec() then return end
    
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

    else
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
        surface.DrawCircle(centerx, centery, length, r,g,b,a) // draw circle crosshair
    end


end

local function DynamicCrosshair(ent, bullet)
    if (not ent:IsValid()) || (not client:IsValid()) then return end 
    if not (ent == client) then return end

    firetime = CurTime()
    bulletfired = true
end

hook.Add("HUDPaint", "krosshair_HUDPaint", DrawCrosshair)
hook.Add("EntityFireBullets", "krosshair_HUDPaint", DynamicCrosshair)