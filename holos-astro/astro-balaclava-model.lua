--@name Astro balaclava Model
--@author Ratyuha
--@server

--[[ Holos ]]--
--@include https://raw.githubusercontent.com/AstricUnion/Libs/refs/heads/main/holos.lua as holos
local holos = require("holos")
---@class Holo
local Holo = holos.Holo
local SubHolo = holos.SubHolo


local function blaster(offset)
    local blaster = hologram.createPart(
        Holo(SubHolo(Vector(-5,0,2),Angle(0,0,0),"models/hunter/blocks/cube025x025x025.mdl",Vector(1,1,1),false,Color(255,0,0,0))),
        Holo(SubHolo(Vector(-28,0,-2),Angle(180,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(31,31,31),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,0,6),Angle(0,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(31,31,31),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,-5,2),Angle(-90,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(31,31,31),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-28,5,2),Angle(90,90,90),"models/props_combine/combinethumper001a.mdl",Vector(0.08,0.08,0.12),false,Color(31,31,31),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(-19,0,12),Angle(180,0,0),"models/combine_dropship_container.mdl",Vector(0.12,0.12,0.12),false,Color(31,31,31),"models/props_combine/metal_combinebridge001")),
        Holo(SubHolo(Vector(33,0,2),Angle(90,0,0),"models/xqm/afterburner1.mdl",Vector(0.7,0.7,0.7),false,Color(31,31,31))),
        Holo(SubHolo(Vector(20,-8,2),Angle(90,0,0),"models/xqm/afterburner1.mdl",Vector(0.3,0.3,1.9),false,Color(31,31,31))),
        Holo(SubHolo(Vector(20,09,2),Angle(90,0,0),"models/xqm/afterburner1.mdl",Vector(0.3,0.3,1.9),false,Color(31,31,31))),
        Holo(SubHolo(Vector(-17,-6,2),Angle(90,-90,0),"models/props_combine/combine_train02a.mdl",Vector(0.16,0.09,0.09),false,Color(31,31,31))),
        Holo(SubHolo(Vector(-17,5,2),Angle(90,90,0),"models/props_combine/combine_train02a.mdl",Vector(0.16,0.09,0.09),false,Color(31,31,31)))
    )
    blaster:setPos(blaster:getPos() + offset)
    return blaster
end


body = {
    base = {
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,0),Angle(0,0,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(31,31,31))),
            Holo(SubHolo(Vector(27,0,-6),Angle(0,0,0),"models/combine_gate_citizen.mdl",Vector(0.19,0.19,0.19),false,Color(31,31,31))),
            Holo(SubHolo(Vector(29,14,2),Angle(15,30,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(31,31,31))),
            Holo(SubHolo(Vector(29,-14,2),Angle(15,-30,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.15),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-32,0,5),Angle(15,180,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.15,0.15,0.2),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-29,14,2),Angle(15,150,180),"models/combine_gate_citizen.mdl",Vector(0.15,0.15,0.15),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,49,39),Angle(-90,0,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.40,0.40,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,-49,39),Angle(-90,0,0),"models/props_combine/headcrabcannister01a.mdl",Vector(0.40,0.40,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,49,10),Angle(180,0,0),"models/xqm/afterburner1.mdl",Vector(0.59,0.59,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,-49,10),Angle(180,0,0),"models/xqm/afterburner1.mdl",Vector(0.59,0.59,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,49,25),Angle(0,0,0),"models/xqm/pistontype1large.mdl",Vector(0.59,0.59,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-45,-49,25),Angle(0,0,0),"models/xqm/pistontype1large.mdl",Vector(0.59,0.59,0.45),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-29,-14,4),Angle(15,210,180),"models/props_combine/combine_barricade_med01b.mdl",Vector(0.14,0.14,0.14),false,Color(31,31,31))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,90,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(31,31,31))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,-90,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(31,31,31))),
            Holo(SubHolo(Vector(0,0,0),Angle(0,180,0),"models/props_combine/combine_train02a.mdl",Vector(0.1,0.1,0.06),false,Color(31,31,31))),
            Holo(SubHolo(Vector(-9,0,-50),Angle(0,0,0),"models/props/CS_militia/toilet.mdl",Vector(3,4,3),false,Color(31,31,31))),
            Holo(SubHolo(Vector(0,40,12),Angle(-150,90,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.15,0.18,0.18),false,Color(31,31,31))),
            Holo(SubHolo(Vector(0,-40,12),Angle(-150,-90,0),"models/props_combine/combine_barricade_med02a.mdl",Vector(0.15,0.18,0.18),false,Color(31,31,31)))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-11),Angle(0,0,0),"models/props_phx/wheels/moped_tire.mdl",Vector(1.8,1.8,2.2),false,Color(31,31,31),"models/props_combine/metal_combinebridge001"))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-6),Angle(0,0,90),"models/props_wasteland/wheel03a.mdl",Vector(0.27,0.18,0.27),false,Color(31,31,31)))
        ),
        hologram.createPart(
            Holo(SubHolo(Vector(0,0,-10),Angle(90,0,0),"models/props_c17/pulleywheels_large01.mdl",Vector(1.2,1,1),false,Color(31,31,31),"models/props_combine/metal_combinebridge001"))
        )
    },
    head = hologram.createPart(
        Holo(SubHolo(Vector(0,0,25),Angle(0,0,0))),
        Holo(SubHolo(Vector(0,0,25),Angle(-90,180,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(31,31,31))),
        Holo(SubHolo(Vector(0,0,25),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(31,31,31))),
        Holo(SubHolo(Vector(0,0,10),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(31,31,31))),
        Holo(SubHolo(Vector(0,0,10),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(31,31,31))),
        Holo(SubHolo(Vector(-0,0,25),Angle(100,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(0.22,0.22,0.16),false,Color(31,31,31)))
    ),
    leftBlaster = blaster(Vector(0, 40, 0)),
    rightBlaster = blaster(Vector(0, -40, 0))
}