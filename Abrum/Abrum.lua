local CameraAPI = require("FOXCamera")

models.Abrum.root.Head:setParentType("None")
models.Abrum.root.Body:setParentType("None")
models.Abrum.over_power.ulra_super.super.body_main.base:setParentType("Body")

vanilla_model.PLAYER:setVisible(false)
vanilla_model.ARMOR:setVisible(false)
vanilla_model.ELYTRA:setVisible(false)
vanilla_model.PARROTS:setVisible(false)

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

function events.render(_, ctx)
  local mainItem=player:getHeldItem()
  if mainItem.id=="minecraft:bow" or mainItem.id=="minecraft:crossbow" or mainItem.id=="minecraft:trident" then
  vanilla_model.RIGHT_ITEM:setVisible(false)
  else
  vanilla_model.RIGHT_ITEM:setVisible(true)
  end
  if mainItem.id:find("_sword") then
  models.Abrum.over_power.ulra_super.super.body_main.turret.gun.barrel.RightItemPivot:setRot(10,0,0)
  else
  models.Abrum.over_power.ulra_super.super.body_main.turret.gun.barrel.RightItemPivot:setRot(90,0,0)
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

local mainPage = action_wheel:newPage()
action_wheel:setPage(mainPage)

function pings.nod()
    animations.Abrum.nod:play()
end

local action = mainPage:newAction()
    :title("Nod")
    :onLeftClick(pings.nod)
    
function pings.shake()
    animations.Abrum.shake:play()
end

local action = mainPage:newAction()
    :title("Shake")
    :onLeftClick(pings.shake)

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

