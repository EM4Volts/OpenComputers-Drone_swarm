local component = require("component") --adding events and components
local event = require("event")
local keyboard = require("keyboard")
local m = component.modem
tempX = 0 -- init for dicts and vars
tempY = 0
tempZ = 0
local D1 = {
    port = 901,
    xpos = 0,
    ypos = 0,
    zpos = 0,
}
local D2 = {
    port = 902,
    xpos = 0,
    ypos = 0,
    zpos = 0,
}
local D3 = {
    port = 903,
    xpos = 0,
    ypos = 0,
    zpos = 0,
}
local D4 = {
    port = 904,
    xpos = 0,
    ypos = 0,
    zpos = 0,
}
local D5 = {
    port = 905,
    xpos = 0,
    ypos = 0,
    zpos = 0,
}
D1P = D1["port"] -- better typable drone port ids because less is more AMIRITE
D2P = D2["port"]
D3P = D3["port"]
D4P = D4["port"]
D5P = D5["port"]

DS = 900
m.open(DS) --opening required ports for wireless modem
m.open(D1P)
m.open(D2P)
m.open(D3P)
m.open(D4P)
m.open(D5P)

function sendCMD(dId, droneCmd) --sends a comand to be executed on target drone
    m.broadcast(dId, droneCmd)
end

function idMove(dId,x,y,z,resetP) --moves the selected drone relative on xyz
    tempX = dId["xpos"]
    tempY = dId["ypos"]
    tempZ = dId["zpos"]
    dId["xpos"] = tempX + x
    dId["ypos"] = tempY + y
    dId["zpos"] = tempZ + z
    if resetP == true then
        dId["xpos"] = 0
        dId["ypos"] = 0
        dId["zpos"] = 0
    end
    cmdString = "drone.move("..tostring(x)..","..tostring(y)..","..tostring(z)..")"
    m.broadcast(dId["port"], cmdString)
end

function resetPos(dId) --resets drones pos
    tempX = dId["xpos"] - dId["xpos"]*2
    tempY = dId["ypos"] - dId["ypos"]*2
    tempZ = dId["zpos"] - dId["zpos"]*2
    dId["xpos"] = 0
    dId["ypos"] = 0
    dId["zpos"] = 0
    idMove(dId,tempX,tempY,tempZ,true)
end

function resetAllPos()
    resetPos(D1)
    resetPos(D2)
    resetPos(D3)
    resetPos(D4)
    resetPos(D5)
end

function swarmMove(x,y,z) --moves the whole swarm while moving relative points with it
    cmdString = "drone.move("..tostring(x)..","..tostring(y)..","..tostring(z)..")"
    m.broadcast(DS, cmdString)
end
function testFlight()
    resetAllPos()
    idMove(D1, 4,5,0) --startup test flight
    idMove(D2, -4,5,0)
    idMove(D3, 0,5,4)
    idMove(D4, 0,5,-4)
    idMove(D5, 0,5,0)
    os.sleep(3)
    idMove(D1, -4,4,0)
    idMove(D2, 4,-4,0)
    idMove(D3, 4,0,-4)
    idMove(D4, -4,0,4)
end
function rectFly()
    resetAllPos()
    idMove(D1, 2,0,0)
    idMove(D2, 4,0,0)
    idMove(D3, -2,0,0)
    idMove(D4, -4,0,0)
    idMove(D1, 0,1,0)
    os.sleep(0.4)
    idMove(D2, 0,1,0)
    os.sleep(0.4)
    idMove(D1, 0,-1,0)
    os.sleep(0.4)
    idMove(D3, 0,1,0)
    os.sleep(0.4)
    idMove(D2, 0,-1,0)
    os.sleep(0.4)
    idMove(D4, 0,1,0)
    os.sleep(0.4)
    idMove(D3, 0,-1,0)
    os.sleep(0.4)
    idMove(D4, 0,-1,0)
    os.sleep(2)
    idMove(D1, 0,0,2)
    idMove(D2, 0,0,4)
    idMove(D3, 0,0,-2)
    idMove(D4, 0,0,-4)
    os.sleep(1)
    testFlight()
end
while true do -- main loop for flight control WIP
    os.sleep(0.08)
    if keyboard.isKeyDown(keyboard.keys.q) then
        sendCMD(DS, "shutdown")
        print("Exiting...")
        break
    end
    if keyboard.isKeyDown(keyboard.keys.r) then
        resetAllPos()
    end
    if keyboard.isKeyDown(keyboard.keys.w) then
        swarmMove(5,8,1)
    end
    if keyboard.isKeyDown(keyboard.keys.up) then
        swarmMove(1,0,0)
    end
    if keyboard.isKeyDown(keyboard.keys.down) then
        swarmMove(-1,0,0)
    end
    if keyboard.isKeyDown(keyboard.keys.left) then
        swarmMove(0,0,-1)
    end
    if keyboard.isKeyDown(keyboard.keys.right) then
        swarmMove(0,0,1)
    end
    if keyboard.isKeyDown(keyboard.keys.space) then
        swarmMove(0,1,0)
    end
    if keyboard.isKeyDown(keyboard.keys.c) then
        swarmMove(0,-1,0)
    end
    if keyboard.isKeyDown(keyboard.keys.g) then
        rectFly()
    end
    if keyboard.isKeyDown(keyboard.keys.d) then
        testFlight()
    end
end
