local CameraAPI = require("FOXCamera")
local anims = require("EZAnims")
local patpat = require("patpat")

models.Abrum.root.Head:setParentType("None")
models.Abrum.root.Body:setParentType("None")
models.Abrum.over_power.ulra_super.super.body_main.base:setParentType("Body")

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)

nameplate.ENTITY:setPivot(0,3,0)

models.Abrum.root.Head.Head:setPrimaryTexture("Skin") 
models.Abrum.root.Head.Hat:setPrimaryTexture("Skin") 
models.Abrum.root.Body.Body:setPrimaryTexture("Skin") 
models.Abrum.root.Body.Jacket:setPrimaryTexture("Skin") 
models.Abrum.root.Left_Arm.LeftArm:setPrimaryTexture("Skin") 
models.Abrum.root.Left_Arm["Left Sleeve"]:setPrimaryTexture("Skin") 
models.Abrum.root.Right_Arm.RightArm:setPrimaryTexture("Skin") 
models.Abrum.root.Right_Arm["Right Sleeve"]:setPrimaryTexture("Skin") 
models.Abrum.root.Left_Leg.LeftLeg:setPrimaryTexture("Skin") 
models.Abrum.root.Left_Leg["Left Pants"]:setPrimaryTexture("Skin") 
models.Abrum.root.Right_Leg.RightLeg:setPrimaryTexture("Skin") 
models.Abrum.root.Right_Leg["Right Pants"]:setPrimaryTexture("Skin") 

local ride = anims:addBBModel(animations.Abrum)
local sit = anims:addBBModel(animations.Abrum)

function events.render(_, ctx)
  local item=player:getHeldItem()
  local in_firstperson = ctx == "FIRST_PERSON"
  vanilla_model.LEFT_ITEM:setVisible(not in_firstperson)
  vanilla_model.LEFT_ITEM:setVisible(in_firstperson)
  if item.id=="minecraft:bow" or item.id=="minecraft:crossbow" or item.id=="minecraft:trident" or item.id=="minecraft:firework_rocket" or item.id=="minecraft:wind_charge" or item.id=="minecraft:egg" or item.id=="minecraft:snowball" or item.id=="minecraft:fireball" or item.id=="minecraft:ender_pearl" or item.id=="minecraft:eye_of_ender" or item.id=="minecraft:experience_bottle" or item.id:find("potion") then
  	vanilla_model.RIGHT_ITEM:setVisible(false)
  else
  	vanilla_model.RIGHT_ITEM:setVisible(true)
  end
  if item.id:find("_sword") then
  	models.Abrum.over_power.ulra_super.super.body_main.turret.gun.barrel.RightItemPivot:setRot(10,0,0)
  else
  	models.Abrum.over_power.ulra_super.super.body_main.turret.gun.barrel.RightItemPivot:setRot(90,0,0)
  end
  if (player:getPose() == "SLEEPING") then
  models.Abrum.over_power:setSecondaryRenderType("NONE")
  else
  models.Abrum.over_power:setSecondaryRenderType("EMISSIVE")
  end
end

function events.render(delta)
  local vehicle = player:getVehicle()
  local riding_minecart = vehicle and vehicle:getType():find("minecart")
  local riding_boat = vehicle and vehicle:getType():find("boat")
  local state = world.getBlockState(player:getPos() + vec(0,-0.1,0))
  if riding_boat and not state:getID():find("water") or riding_minecart then
  	ride:setState("b")
  	else
  	ride:setState()
  	end
end

function events.render()
    local headRot = (vanilla_model.HEAD:getOriginRot()+180)%360-180
    models.Abrum.root.Head:setRot(0,headRot.y,0)
    models.Abrum.over_power.ulra_super.super.body_main.turret:setRot(0,headRot.y,0)
    models.Abrum.over_power.ulra_super.super.body_main.turret.gun:setRot(headRot.x,0,headRot.z)
end

function events.tick()
  local move = player:getVelocity().x_z:normalized():dot(player:getLookDir().x_z:normalized()) > 0 and 1 or -1
  animations.Abrum.wheels:playing(player:getVelocity().xz:length() >= 0.02):speed(player:getVelocity().xz:length() * move/2)
end

renderer:setRenderVehicle(false)

function events.ON_PLAY_SOUND(id, pos, vol, pitch, loop, cat, path)

    if not path then return end
    if not player:isLoaded() then return end 

    local distance = (player:getPos() - pos):length()

    if distance > 0.2 then return end 
    if id:find(".hurt") then  
        sounds:playSound("entity.iron_golem.hurt", pos, vol, pitch)
        return true
    end
    
    if distance > 1 then return end 
    if id:find(".death") then  
        sounds:playSound("entity.iron_golem.death", pos, vol, pitch)
        sounds:playSound("entity.generic.explode", pos, vol, pitch)
        return true
    end
end

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.nod()
    animations.Abrum.nod:play()
end

local action = mainPage:newAction()
    :title("Nod")
    :item("lime_concrete")
    :onLeftClick(pings.nod)
    
function pings.shake()
    animations.Abrum.shake:play()
end

local action = mainPage:newAction()
    :title("Shake")
    :item("red_concrete")
    :onLeftClick(pings.shake)

function pings.spin(state)
	animations.Abrum.spin:setPlaying(state)
end

local toggleaction = mainPage:newAction()
    :title("Spin - Off")
    :toggleTitle("Spin - On")
    :item("detector_rail")
    :toggleItem("powered_rail")
    :setOnToggle(pings.spin)

function pings.sit(state)
	if state then 
    		sit:setState("c")
	else
    		sit:setState()
    	end
end

local toggleaction = mainPage:newAction()
    :title("Sit - Plugin")
    :toggleTitle("Sit - Command")
    :item("oak_stairs")
    :toggleItem("stick")
    :setOnToggle(pings.sit)

function pings.chatOpen(isChatOpen)
	if isChatOpen then 
  		models.Abrum.over_power.ulra_super.super.body_main.turret.citv:setSecondaryRenderType("EMISSIVE")
	else
    		models.Abrum.over_power.ulra_super.super.body_main.turret.citv:setSecondaryRenderType("NONE")
    	end
end

if host:isHost() then
  local wasChatOpen
  function events.tick()
    local isChatOpen = host:isChatOpen()
    if wasChatOpen ~= isChatOpen then
      wasChatOpen = isChatOpen
      pings.chatOpen(isChatOpen)
    end
  end
end

local microphoneOffTime = 0
local isMicrophoneOn = false

function pings.talking(talk)
	if talk then 
  		models.Abrum.over_power.ulra_super.super.body_main.turret.citv:setSecondaryRenderType("EMISSIVE")
	else
    		models.Abrum.over_power.ulra_super.super.body_main.turret.citv:setSecondaryRenderType("NONE")
    	end
end

function events.tick()
    local previousMicState = isMicrophoneOn
    microphoneOffTime = microphoneOffTime + 1
    isMicrophoneOn = microphoneOffTime <= 2

    if previousMicState ~= isMicrophoneOn then
        pings.talking(isMicrophoneOn)
    end
end

if client:isModLoaded("figurasvc") and host:isHost() then
    function events.host_microphone()
        microphoneOffTime = 0
    end
end

local myCamera = CameraAPI.newCamera(
  models.Abrum.root.Head.camera, -- (nil) cameraPart
  models.Abrum.root.Head, -- (nil) hiddenPart
  nil, -- ("PLAYER") parentType
  8, -- (nil) distance
  nil, -- (1) scale
  nil, -- (false) unlockPos
  nil, -- (false) unlockRot
  true, -- (true) doCollisions
  true, -- (false) doEyeOffset
  nil, -- (false) doEyeRotation
  nil, -- (true) doLerpH
  nil, -- (true) doLerpV
  nil, -- (vec(0, 0, 0)) offsetPos
  nil, -- (vec(0, 0, 0)) offsetRot
  nil -- ("CAMERA") offsetSpace
)

CameraAPI.setCamera(myCamera)

if host:isHost() then
-- Variables
local cameraPos-- Camera position
local playerPos-- Player position
local fadeDistance = 5-- Distance at which the model should begin fading - default third person camera distance is around 5 at most
local fadeSpeed = 0.2-- The rate the model should fade at
local fadedOpacity = 0.2-- How faded the model should become
local fadeParts = {}-- The parts of the model that should fade
local fade = 0

function events.RENDER(delta)
cameraPos = client:getCameraPos(delta)
playerPos = player:getPos(delta)
-- Calculate distance between the camera and the player
local cameraDist = math.sqrt(((cameraPos[1] - playerPos[1]) ^ 2) + ((cameraPos[2] - playerPos[2]) ^ 2) + ((cameraPos[3] - playerPos[3]) ^ 2))

if not renderer:isFirstPerson() and cameraDist < fadeDistance then
if fade < 1 then
fade = math.clamp(fade + fadeSpeed, 0, 1)
end
else
if fade > 0 then
fade = math.clamp(fade - fadeSpeed, 0, 1)
end
end
if #fadeParts == 0 then
models:setOpacity(math.lerp(1, fadedOpacity, fade))
else
for _, part in pairs(fadeParts) do
part:setOpacity(math.lerp(1, fadedOpacity, fade))
end
end
end
end

table.insert(patpat.onPat, function()
  animations.Abrum.onpat:play()
  print("someone started petting me")
end)

table.insert(patpat.patting, function()
  animations.Abrum.patting:play()
  print("patpat...")
end)
