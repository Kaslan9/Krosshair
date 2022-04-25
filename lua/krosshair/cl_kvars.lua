table.Empty(kcs.Convars)

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair", "1", true, false,"Enable or Disable custom crosshair (0-1)", 0, 1))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_brightness", "255", true, false,"Brightness of the crosshair (0-255)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_red", "255", true, false,"Red component of RGB value of crosshair (0-255)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_green", "255", true, false,"Green component of RGB value of crosshair (0-255)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_blue", "255", true, false,"Blue component of RGB value of crosshair (0-255)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_length", "5", true, false,"Length of each segment of the crosshair (in pixels)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_thickness", "5", true, false,"Thickness of each segment of the crosshair (in pixels)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_gap", "3", true, false,"Size of gap in the crosshair (in pixels)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_shape", "0", true, false,"The shape of the crosshair (Cross, T, Circle)", 0, 2))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_dot", "0", true, false,"Enable or Disable dot in the crosshair (0-1)", 0, 1))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_dot_size", "0", true, false,"Thickness of the dot (in pixels)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_static", "0", true, false,"Enable or Disable shooting inaccuarcy in crosshair (0-1)", 0, 1))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_inaccuracy", "0", true, false,"How much the crosshair moves when shooting (in pixels)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_outline", "0", true, false,"Enable or Disable crosshair outline", 0, 1))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_outline_opacity", "0", true, false,"Brightness of outline (0-255)", 0, 255))

table.insert(kcs.Convars, 0, CreateClientConVar("cl_krosshair_outline_thickness", "0", true, false,"Thickness of the outline (in pixels)", 0, 255))
