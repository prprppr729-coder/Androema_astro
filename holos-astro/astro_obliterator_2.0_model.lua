--@name Astro Obliterator Model
--@author WaYa
--@server
    
--[[ Holos ]]--
--[[ Holos library embedded inline (no external @include needed) ]]--
local CHIPPOS = chip():getPos()

local clientHolos = {}

if SERVER then
    -- This is a bad realization, in my opinion
    -- But I can't found something better
    -- If you want, you can send PR to it

    ---@type table[thread]
    local initializeThreads = {}
    
    local function initHolosThread(ply)
        if !isValid(ply) then return end
        for id, holo in pairs(clientHolos) do
            if !isValid(holo) then continue end
            net.start("HologramInitialized")
            net.writeString(id)
            net.writeEntity(holo)
            net.send(ply)
            coroutine.wait(0.2)
            coroutine.yield()
        end
    end


    hook.add("ClientInitialized", "HologramsInitialize", function(ply)
        local th = coroutine.create(initHolosThread)
        table.insert(initializeThreads, {th, ply})
    end)

    hook.add("Think", "ResumeInitializationThreads", function()
        for _, th in ipairs(initializeThreads) do
            if coroutine.status(th[1]) == "dead" then
                table.removeByValue(initializeThreads, th)
                continue
            end
            coroutine.resume(th[1], th[2])
        end
    end)
else
    net.receive("HologramInitialized", function()
        local id = net.readString()
        net.readEntity(function(ent)
            hook.run("HoloInitialized", id, ent)
        end)
    end)
end




---Function to create SubHolo
---@param pos? Vector Position, default Vector()
---@param ang? Angle Angle, default Angle()
---@param model? string Model of holo, default "models/hunter/blocks/cube025x025x025.mdl"
---@param scale? Vector Scale of holo, default Vector(1, 1, 1)
---@param suppressLight? boolean Suppress light of the holo, default false
---@param color? Color Color of holo, default full white
---@param mat? string Material of holo, default uses model material
---@param clientId? string Send holo to clients with unique ID. Default nil. Sends to client hook HoloInitialized. Does nothing on client
---@return Hologram?
local function SubHolo(pos, ang, model, scale, suppressLight, color, mat, clientId)
    local holo = {
        pos = pos or Vector(),
        ang = ang or Angle(),
        model = model or "models/hunter/blocks/cube025x025x025.mdl",
        scale = scale or Vector(1, 1, 1),
        suppressLight = suppressLight or false,
        color = color or Color(255, 255, 255),
        mat = mat or nil
    }
    local holo_obj = hologram.create(
        CHIPPOS + holo.pos,
        holo.ang,
        holo.model,
        holo.scale
    )
    if not holo_obj then
        throw("Can't create hologram with model " .. holo.model)
        return
    end
    holo_obj:suppressEngineLighting(holo.suppressLight)
    holo_obj:setColor(holo.color)
    if holo.mat then holo_obj:setMaterial(holo.mat) end
    if SERVER and clientId then
        net.start("HologramInitialized")
        net.writeString(clientId)
        net.writeEntity(holo_obj)
        net.send()
        clientHolos[clientId] = holo_obj
    end
    return holo_obj
end


---Function Rig, to create rig holograms
---@param pos? Vector Position, default Vector()
---@param ang? Angle Angle, default Angle()
---@param visible? boolean Turn on visibility (for designing)
---@return Hologram?
local function Rig(pos, ang, visible)
    local holo = {
        pos = pos or Vector(),
        ang = ang or Angle(),
        model = "models/editor/axis_helper_thick.mdl"
    }
    local holo_obj = hologram.create(
        CHIPPOS + holo.pos,
        holo.ang,
        holo.model,
        Vector(0.2, 0.2, 0.2)
    )
    if not holo_obj then
        throw("Can't create hologram with model " .. holo.model)
        return
    end
    if SERVER then
        holo_obj:setDrawShadow(false)
    end
    holo_obj:suppressEngineLighting(true)
    holo_obj:setNoDraw(!visible)
    return holo_obj
end


---@class Trail
---@field startSize number The start size of the trail (0-128)
---@field endSize number The end size of the trail (0-128)
---@field length number The length size of the trail
---@field mat string The material of the trail
---@field color Color The color of the trail
---@field attachmentID? number Optional attachmentid the trail should attach to
---@field additive? boolean If the trail's rendering is additive
local Trail = {}
Trail.__index = Trail


---Trail structure, stores hologram trail data
---@param startSize number The start size of the trail (0-128)
---@param endSize number The end size of the trail (0-128)
---@param length number The length size of the trail
---@param mat string The material of the trail
---@param color Color The color of the trail
---@param attachmentID? number Optional attachmentid the trail should attach to
---@param additive? boolean If the trail's rendering is additive
---@return Trail object
function Trail:new(startSize, endSize, length, mat, color, attachmentID, additive)
    return setmetatable(
        {
            startSize = startSize,
            endSize = endSize,
            length = length,
            mat = mat,
            color = color,
            attachmentID = attachmentID,
            additive = additive
        },
        Trail
    )
end
setmetatable(Trail, {__call = Trail.new})


---@class Clip
---@field pos Vector
---@field normal Vector
local Clip = {}
Clip.__index = Clip

---Clip structure
---@param pos any
---@param normal Vector Angle of clip, like normal, but local
---@return table
function Clip:new(pos, normal)
    return setmetatable(
        {
            pos = pos,
            normal = normal
        },
        Clip
    )
end

setmetatable(Clip, {__call = Clip.new})


---@class Holo
---@field subholo Hologram
---@field trail Trail
---@field clips table[Clip]
local Holo = {}
Holo.__index = Holo

---Holo structure, stores hologram data
---@param subholo Hologram Hologram to spawn
---@param trail? Trail Trail structure
---@param clips? table[Clip] Table with Clip structure
function Holo:new(subholo, trail, clips)
    return setmetatable(
        {
            subholo = subholo,
            trail = trail,
            clips = clips,
        },
        Holo
    )
end
setmetatable(Holo, {__call = Holo.new})


---Creates and parents holograms to first hologram, to create one object
---@param ... ... List of Holo structures
function hologram.createPart(...)
    local main_holo
    for i, holo in ipairs({...}) do
        ---@cast holo Holo
        if holo.trail then
            holo.subholo:setTrails(
                holo.trail.startSize,
                holo.trail.endSize,
                holo.trail.length,
                holo.trail.mat,
                holo.trail.color,
                holo.trail.attachmentID,
                holo.trail.additive
            )
        end
        if holo.clips then
            for i, clip in ipairs(holo.clips) do
                ---@cast clip Clip
                holo.subholo:setClip(
                    i,
                    true,
                    clip.pos,
                    clip.normal,
                    holo.subholo
                )
            end
        end
        if i == 1 then
            main_holo = holo.subholo
            continue
        end
        holo.subholo:setParent(main_holo)
    end
    return main_holo
end

---@material holo

local metal = "models/props_pipes/guttermetal01a"
local metal2= "models/gibs/metalgibs/metal_gibs"
local light = "models/ihvtest/eyeball_l"

local function blaster(offset)
    local blaster = hologram.createPart(
        Holo(Rig    (Vector(100,0,0))),
        Holo(SubHolo(Vector(860,0,0),Angle(90,0,0),"models/Mechanics/gears2/gear_60t1.mdl",Vector(2.5,2.5,105),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,0,0),Angle(90,0,0),"models/hunter/tubes/circle2x2.mdl",Vector(3.25,3.25,209.625),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(900,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1000,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1100,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1200,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(800,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(700,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(600,0,0),Angle(0,90,0),"models/props_wasteland/wheel02a.mdl",Vector(1.7575,2,1.7575),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(1200,0,0),Angle(90,0,0),"models/hunter/tubes/circle2x2.mdl",Vector(3,3,1.5),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(870.75,0,0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(870.75,0,0),Angle(45,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(870.75,0,0),Angle(63,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(870.75,0,0),Angle(73,90,90),"models/Items/combine_rifle_ammo01.mdl",Vector(40.25,40.25,30),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,160,0),Angle(0,0,0),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,-160,0),Angle(0,0,0),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,0,160),Angle(0,0,90),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,0,-160),Angle(0,0,90),"models/props_junk/iBeam01a.mdl",Vector(3.36,0.5,1),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(900,160,0),Angle(0,0,0),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(900,-160,0),Angle(0,0,0),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(900,0,-160),Angle(0,0,90),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(900,0,160),Angle(0,0,90),"models/hunter/plates/plate025x025.mdl",Vector(56,0.2,3.49),false,Color(255,40,40),light)),
        Holo(SubHolo(Vector(350,0,-80),Angle(0,0,0),"models/combine_dropship_container.mdl",Vector(2.5,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(160,0,-50),Angle(115,0,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(1.5,0.475,0.95),false,Color(255,40,40),metal2)),
        Holo(SubHolo(Vector(950,0,0),Angle(90,0,0),"models/hunter/tubes/tube4x4x6c.mdl",Vector(2,2,2),false,Color(130,40,40))),        
        Holo(SubHolo(Vector(870,-130,150),Angle(90,0,0),"models/props_phx/construct/metal_wire_angle180x2.mdl",Vector(4,4,4),false,Color(130,40,40))),        
        Holo(SubHolo(Vector(760,0,0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(50,50,50),false,Color(255,40,40))),        
        Holo(SubHolo(Vector(160,0,0),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(70,70,70),false,Color(255,40,40))),        
        Holo(SubHolo(Vector(1250,0,0),Angle(90,0,0),"models/props_phx/gears/bevel24.mdl",Vector(7,7,7),true,Color(255,40,40),"models/debug/debugwhite"))        
        
        
        
        
        
        
    )
    blaster:setPos(blaster:getPos() + offset)
    return blaster
end


body = {
    base = {
        hologram.createPart(
            Holo(Rig    (Vector(0,0,0))),
            Holo(SubHolo(Vector(-120,0,124),Angle(90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(6.0,6.0,6.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(120,0,124),Angle(90,0,180),"models/props_combine/combine_booth_short01a.mdl",Vector(6.0,6.0,6.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,184),Angle(180,0,0),"models/props_combine/CombineTrain01a.mdl",Vector(2.4,6.0,2.0),false,Color(255,40,40))),
            Holo(SubHolo(Vector(500,0,-90),Angle(180,180,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(4.5,0.8,0.56),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,0,-90),Angle(180,0,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(4.5,0.8,0.56),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,1000,40),Angle(0,0,-90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,1000,130),Angle(0,0,-90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-1000,40),Angle(0,0,90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-1000,130),Angle(0,0,90),"models/props_combine/combineinnerwall001a.mdl",Vector(3.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-1200,130),Angle(-30,180,0),"models/props_combine/combinebuttress.mdl",Vector(2.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,1200,130),Angle(-30,180,0),"models/props_combine/combinebuttress.mdl",Vector(2.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-2000,130),Angle(-30,180,0),"models/props_combine/combinebuttress.mdl",Vector(2.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,2000,130),Angle(-30,180,0),"models/props_combine/combinebuttress.mdl",Vector(2.5,1.5,2.5),false,Color(255,40,40))),
            Holo(SubHolo(Vector(0,-800,100),Angle(0,90,0),"models/props_phx/gears/bevel24.mdl",Vector(29,29,29),false,Color(190,40,40))),
            Holo(SubHolo(Vector(0,-800,100),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(9.5,9.5,3),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,800,100),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(9.5,9.5,3),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,-1600,190),Angle(0,90,0),"models/props_phx/gears/bevel24.mdl",Vector(23,23,23),false,Color(190,40,40))),
            Holo(SubHolo(Vector(300,-1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(2,2,2),false,Color(100,40,40))),
            Holo(SubHolo(Vector(330,-1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(1.5,1.5,1.5),true,Color(250,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(360,-1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(0.5,1.2,1),true,Color(255,195,195),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(300,1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(2,2,2),false,Color(100,40,40))),
            Holo(SubHolo(Vector(330,1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(1.5,1.5,1.5),true,Color(250,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(360,1250,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(0.5,1.2,1),true,Color(255,195,195),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(300,1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(2,2,2),false,Color(100,40,40))),
            Holo(SubHolo(Vector(330,1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(1.5,1.5,1.5),true,Color(250,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(360,1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(0.5,1.2,1),true,Color(255,195,195),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(300,-1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(2,2,2),false,Color(100,40,40))),
            Holo(SubHolo(Vector(330,-1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(1.5,1.5,1.5),true,Color(250,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(360,-1850,90),Angle(0,90,90),"models/hunter/misc/roundthing3.mdl",Vector(0.5,1.2,1),true,Color(255,195,195),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,-1600,320),Angle(0,90,0),"models/props_phx/gears/bevel9.mdl",Vector(30,30,53),false,Color(190,40,40))),
            Holo(SubHolo(Vector(-90,1600,320),Angle(0,90,0),"models/props_phx/gears/bevel9.mdl",Vector(30,30,53),false,Color(190,40,40))),
            Holo(SubHolo(Vector(-90,1600,620),Angle(0,90,0),"models/props_combine/breentp_rings.mdl",Vector(1.7,1.7,1.7),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,1600,620),Angle(0,90,0),"models/props_combine/breentp_rings.mdl",Vector(2,2,2),true,Color(190,40,40))),
            Holo(SubHolo(Vector(-90,-1600,620),Angle(0,90,0),"models/props_combine/breentp_rings.mdl",Vector(1.7,1.7,1.7),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,-1600,620),Angle(0,90,0),"models/props_combine/breentp_rings.mdl",Vector(2,2,2),true,Color(190,40,40))),
            Holo(SubHolo(Vector(-90,-1600,190),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(7.5,7.5,1),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,-800,180),Angle(0,90,0),"models/props_phx/gears/bevel90_24.mdl",Vector(15.5,15.5,15),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(0,800,180),Angle(0,90,0),"models/props_phx/gears/bevel90_24.mdl",Vector(15.5,15.5,15),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,1600,190),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(7.7,7.7,1),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,1600,450),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(3.9,3.9,1),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,-1600,450),Angle(0,90,0),"models/Mechanics/gears2/gear_48t1.mdl",Vector(3.9,3.9,1),true,Color(255,40,40),"models/debug/debugwhite")),
            Holo(SubHolo(Vector(-90,1600,190),Angle(0,90,0),"models/props_phx/gears/bevel24.mdl",Vector(23,23,23),false,Color(190,40,40))),
            Holo(SubHolo(Vector(0,800,100),Angle(0,90,0),"models/props_phx/gears/bevel24.mdl",Vector(29,29,29),false,Color(190,40,40))),
            Holo(SubHolo(Vector(100,-300,70),Angle(0,10,60),"models/props_combine/combine_emitter01.mdl",Vector(45,45,45),false,Color(255,40,40))),           
            Holo(SubHolo(Vector(100,300,70),Angle(0,-10,-60),"models/props_combine/combine_emitter01.mdl",Vector(45,45,45),false,Color(255,40,40))),           
            Holo(SubHolo(Vector(100,250,-120),Angle(0,0,215),"models/props_combine/combine_emitter01.mdl",Vector(45,45,45),false,Color(255,40,40))),           
            Holo(SubHolo(Vector(100,-250,-120),Angle(0,0,-215),"models/props_combine/combine_emitter01.mdl",Vector(45,45,45),false,Color(255,40,40))),          
            Holo(SubHolo(Vector(-100,-1700,100),Angle(10,0,90),"models/props_combine/combine_emitter01.mdl",Vector(30,45,45),false,Color(255,40,40))),          
            Holo(SubHolo(Vector(-90,1700,90),Angle(10,0,-90),"models/props_combine/combine_emitter01.mdl",Vector(30,45,45),false,Color(255,40,40))),          
            Holo(SubHolo(Vector(-350,0,400),Angle(0,0,0),"models/props_combine/combineinnerwallcluster1024_001a.mdl",Vector(1,1.3,1),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(-350,700,-100),Angle(0,-230,0),"models/props_combine/combine_bridge.mdl",Vector(3,3,3),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(-350,-700,-100),Angle(0,230,0),"models/props_combine/combine_bridge.mdl",Vector(3,3,3),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(-350,450,700),Angle(90,-10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(8,8,3),false,Color(40,40,40))),         
            Holo(SubHolo(Vector(-310,-450,700),Angle(90,10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(5,5,2),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(-285,-450,700),Angle(90,10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(1.5,1.5,1),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(-285,450,700),Angle(90,-10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(1.5,1.5,1),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(-310,450,700),Angle(90,-10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(5,5,2),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(-350,-450,700),Angle(90,10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(8,8,3),false,Color(40,40,40))),         
            Holo(SubHolo(Vector(-290,450,700),Angle(90,-10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(4,4,1),false,Color(40,40,40))),         
            Holo(SubHolo(Vector(-290,-450,700),Angle(90,10,0),"models/Mechanics/gears2/gear_24t3.mdl",Vector(4,4,1),false,Color(40,40,40))),         
            Holo(SubHolo(Vector(-400,0,600),Angle(0,90,0),"models/Mechanics/gears2/pinion_40t2.mdl",Vector(10,15,15),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(-800,0,600),Angle(0,0,180),"models/combine_gate_vehicle.mdl",Vector(6,5,6),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(500,250,-280),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(40,40,40),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(900,250,-280),Angle(90,0,0),"models/props_phx/gears/bevel90_24.mdl",Vector(5,5,5),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(900,-250,-280),Angle(90,0,0),"models/props_phx/gears/bevel90_24.mdl",Vector(5,5,5),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(900,0,-350),Angle(90,0,0),"models/props_phx/gears/bevel90_24.mdl",Vector(5,5,5),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(850,450,-50),Angle(90,0,0),"models/props_phx/gears/bevel90_24.mdl",Vector(4,4,4),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(850,-450,-50),Angle(90,0,0),"models/props_phx/gears/bevel90_24.mdl",Vector(4,4,4),true,Color(255,40,40),"models/debug/debugwhite")),         
            Holo(SubHolo(Vector(500,-250,-280),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(40,40,40),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(500,-450,-60),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(35,35,35),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(500,450,-60),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(35,35,35),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(500,0,-350),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(40,40,40),false,Color(255,40,40))),         
            Holo(SubHolo(Vector(900,0,-80),Angle(90,0,0),"models/Mechanics/gears2/vert_36t1.mdl",Vector(7.5,6.5,3),true,Color(255,40,40),"models/debug/debugwhite"))         
            ),
        hologram.createPart(
            Holo(Rig    (Vector(500,0,-70))),
            Holo(SubHolo(Vector(200.75,0,-70),Angle(90,0,0),"models/Items/combine_rifle_ammo01.mdl",Vector(75.45,75.55,90),false,Color(255,40,40))),
            Holo(SubHolo(Vector(1150.75,0,-70),Angle(90,0,0),"models/hunter/misc/cone1x1.mdl",Vector(8.45,8.55,13),false,Color(120,0,40))),
            Holo(SubHolo(Vector(900.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(2.8,2.8,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1030.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(2.5,2.5,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1150.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(2.2,2.2,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1250.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(1.9,1.9,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1380.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(1.6,1.6,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1500.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(1.1,1.1,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1630.75,0,-70),Angle(90,0,0),"models/hunter/tubes/circle4x4.mdl",Vector(0.6,0.6,5),false,Color(120,0,40))),
            Holo(SubHolo(Vector(1150.75,0,-70),Angle(90,0,0),"models/hunter/misc/cone1x1.mdl",Vector(8.45,8.55,13),true,Color(255,0,40),"models/wireframe"))
        
            )
    },
    
    
    head = {
        hologram.createPart(
        Holo(Rig    (Vector(200,0,550))),
        Holo(SubHolo(Vector(200,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(550.0,550.0,550.0),true,Color(0,0,0))),
        Holo(SubHolo(Vector(400,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(170.0,350.0,350.0),true,Color(200,30,30))),
        Holo(SubHolo(Vector(410,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(190.0,190.0,320),true,Color(0,0,0))),
        Holo(SubHolo(Vector(430,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(160.0,160.0,290),true,Color(255,40,40))),
        Holo(SubHolo(Vector(450,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(130.0,130.0,260),true,Color(255,90,90))),
        Holo(SubHolo(Vector(470,0,550),Angle(0,0,0),"models/starfall/holograms/sphere.mdl",Vector(100.0,100.0,230),true,Color(255,140,140))),
        Holo(SubHolo(Vector(350,0,550),Angle(-90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(500,0,650),Angle(65,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(105,40,40))),
        Holo(SubHolo(Vector(500,0,650),Angle(65,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(255,40,40),"models/wireframe")),
        Holo(SubHolo(Vector(500,0,750),Angle(50,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(255,40,40),"models/wireframe")),
        Holo(SubHolo(Vector(500,0,750),Angle(50,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(105,40,40))),
        Holo(SubHolo(Vector(400,0,800),Angle(30,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(255,40,40),"models/wireframe")),
        Holo(SubHolo(Vector(400,0,800),Angle(30,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(105,40,40))),
        Holo(SubHolo(Vector(300,0,800),Angle(5,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(255,40,40),"models/wireframe")),
        Holo(SubHolo(Vector(300,0,800),Angle(5,0,0),"models/hunter/misc/squarecap2x2x2.mdl",Vector(1.4,1.5,4.5),false,Color(105,40,40))),
        Holo(SubHolo(Vector(100,0,450),Angle(90,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(100,0,550),Angle(-90,0,180),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,4.5),false,Color(255,40,40))),
        Holo(SubHolo(Vector(190,0,640),Angle(170,0,0),"models/props_combine/combine_booth_short01a.mdl",Vector(4.4,4.5,3.75),false,Color(255,40,40))),
        Holo(SubHolo(Vector(300,0,270),Angle(0,-135,0),"models/props_combine/railing_corner_inside.mdl",Vector(10,10,10),false,Color(255,40,40))),
        Holo(SubHolo(Vector(190,300,730),Angle(10,95,-30),"models/Items/combine_rifle_cartridge01.mdl",Vector(50,70,70),false,Color(255,40,40))),        
        Holo(SubHolo(Vector(190,-300,730),Angle(10,-95,30),"models/Items/combine_rifle_cartridge01.mdl",Vector(50,70,70),false,Color(255,40,40))),                
        Holo(SubHolo(Vector(300,-300,530),Angle(-280,0,30),"models/Items/combine_rifle_cartridge01.mdl",Vector(50,70,70),false,Color(255,40,40))),                        
        Holo(SubHolo(Vector(300,300,530),Angle(-280,0,-30),"models/Items/combine_rifle_cartridge01.mdl",Vector(50,70,70),false,Color(255,40,40)))                                
        
        
        )
    },
    leftBlaster1 = blaster(Vector(-100, 830, -190)),
    leftBlaster3 = blaster(Vector(-240, 1550, -190)),
    
    rightBlaster1 = blaster(Vector(-100, -830, -190)),
    rightBlaster3 = blaster(Vector(-240, -1550, -190)),
}
