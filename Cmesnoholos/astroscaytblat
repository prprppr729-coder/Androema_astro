--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
local holos = require("holos")
---@class Holo
local Holo = holos.Holo
local Rig = holos.Rig
local SubHolo = holos.SubHolo

local function circlePos(ang, radius, pos)
    local rad = math.rad(ang)
    return Vector(math.sin(rad)*radius,0,math.cos(rad)*radius)+pos
end

local function prong(ang)
    local prongHolo = hologram.createPart(
        Holo(Rig(Vector(-1.5,242,24))),
        Holo(SubHolo(Vector(-1.5,242,48),Angle(145,90,-90),"models/props_combine/combine_barricade_bracket01a.mdl",Vector(1.4,1,1),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
    )
    prongHolo:setLocalAngles(Angle(-ang,0,0))
    return Holo(prongHolo)
end

local function laserTube(ang)
    local pos = circlePos(ang,18.5,Vector(-3,208,24))
    return Holo(SubHolo(pos,Angle(90,90,0),"models/hunter/tubes/circle2x2.mdl",Vector(0.06,0.06,18),false,Color(255,40,40,255),"models/props_combine/metal_combinebridge001"))
end

body = {
    base = {
        hologram.createPart(
            Holo(Rig(Vector(0,0,19))),
            Holo(SubHolo(Vector(0,0,19),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.65,0.2,0.65),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.65,0.2,0.65),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,8),Angle(0),"models/props_phx/construct/metal_angle360.mdl",Vector(1.3,1.3,3),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-60,0,40),Angle(0),"models/props_combine/combineinnerwallcluster1024_002a.mdl",Vector(0.09,0.09,0.09),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-34,-60,20),Angle(0,40,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.1,0.2,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-34,60,20),Angle(0,-40,0),"models/props_combine/combineinnerwall001a.mdl",Vector(0.1,0.2,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(46,70,10),Angle(180,225,-90),"models/combine_wall.mdl",Vector(0.06,0.08,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(46,-70,10),Angle(180,-225,90),"models/combine_wall.mdl",Vector(0.06,0.08,0.05),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,-72,0),Angle(0,-90,0),"models/props_combine/combine_barricade_med03b.mdl",Vector(0.3,0.3,0.25),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,72,0),Angle(0,90,0),"models/props_combine/combine_barricade_med04b.mdl",Vector(0.3,0.3,0.25),false,Color(255,40,40))),
            Holo(SubHolo(Vector(70,0,-6),Angle(0),"models/props_combine/combine_barricade_tall02b.mdl",Vector(0.4,0.4,0.15),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-10,0,-19),Angle(50,180,180),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.07,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(10,0,-19),Angle(130,-180,0),"models/props_combine/combineinnerwallcluster1024_003a.mdl",Vector(0.07,0.07,0.06),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-66,-20,12),Angle(180,30,90),"models/props_combine/combine_barricade_tall01a.mdl",Vector(0.4),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-66,20,12),Angle(180,-30,270),"models/props_combine/combine_barricade_tall01a.mdl",Vector(0.4),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-70,0,4),Angle(0,180,0),"models/props_combine/combine_barricade_med01a.mdl",Vector(0.4,0.6,0.35),false,Color(255,40,40)))
        ),
        hologram.createPart(
            Holo(Rig(Vector(0,0,10))),
            Holo(SubHolo(Vector(0,0,10),Angle(0,0,90),"models/props_wasteland/wheel02b.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(30,0,15),Angle(5,-5,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(22,-22,15),Angle(5,-50,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-30,0,15),Angle(5,-185,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(22,-22,15),Angle(5,-140,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-30,15),Angle(5,-95,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(-22,22,15),Angle(5,130,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,30,15),Angle(5,85,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40))),
            Holo(SubHolo(Vector(22,22,15),Angle(5,40,-45),"models/Gibs/helicopter_brokenpiece_03.mdl",Vector(1),false,Color(255,40,40)))
        ),
        berserkTrails = {
            Rig(Vector(0, 75, 45)),
            Rig(Vector(0, -75, 45))
        }
    },
    head = hologram.createPart(
        Holo(Rig(Vector(0,0,68))),
        Holo(SubHolo(Vector(0,0,68),Angle(0),"models/hunter/misc/sphere075x075.mdl",Vector(1.4,1.4,1.4),true,Color(0,0,0),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(14,0,68),Angle(0),"models/hunter/misc/sphere075x075.mdl",Vector(0.6,1.1,1.1),true,Color(255,40,40),"models/debug/debugwhite")),
        Holo(SubHolo(Vector(20.2,0,67),Angle(0,0,0),"models/hunter/misc/sphere075x075.mdl",Vector(0.3,0.3,0.9),true,Color(255,255,255),"models/debug/debugwhite")),
        
        Holo(SubHolo(Vector(-22,0,70),Angle(-100,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.4,0.45,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(-4,0,64),Angle(45,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.3,0.45,0.4),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-35,52),Angle(20,-12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,35,52),Angle(20,12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-35,80),Angle(0,-12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,35,80),Angle(0,12,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.4,0.5,0.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,-30,64),Angle(0,0,90),"models/props_combine/combine_emitter01.mdl",Vector(1,2,1.2),false,Color(255,40,40))),
        Holo(SubHolo(Vector(0,30,64),Angle(0,0,-90),"models/props_combine/combine_emitter01.mdl",Vector(1,2,1.2),false,Color(255,40,40)))
    )
}
