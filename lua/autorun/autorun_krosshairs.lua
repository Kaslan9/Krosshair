kcs = kcs or {}
kcs.Convars = kcs.Convars or {}
kcs.gamemode = engine.ActiveGamemode()
kcs.gaptime = 0.2 // temp, will probably later add to player convars, now too lazy.

if SERVER then
    AddCSLuaFile("krosshair/cl_krosshair.lua")
    AddCSLuaFile("krosshair/cl_krosshair_menu.lua")
    AddCSLuaFile("krosshair/cl_kvars.lua")
end

if CLIENT then
    include("krosshair/cl_krosshair.lua")
    include("krosshair/cl_krosshair_menu.lua")
    include("krosshair/cl_kvars.lua")
end
