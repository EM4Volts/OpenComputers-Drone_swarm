local component = require("component")
local event = require("event")
local keyboard = require("keyboard")
local m = component.modem
DS = 900
D1 = 901
D2 = 902
D3 = 903
D4 = 904
D5 = 905
m.open(DS)
m.open(D1)
m.open(D2)
m.open(D3)
m.open(D4)
m.open(D5)
m.broadcast(DS, "shutdown")
m.broadcast(D1, "shutdown")
m.broadcast(D2, "shutdown")
m.broadcast(D3, "shutdown")
m.broadcast(D4, "shutdown")
m.broadcast(D5, "shutdown")
function sendCMD(dId, droneCmd)
    m.broadcast(dId, droneCmd)
end
function idMove(dId,x,y,z)
    cmdString = "drone.move("..tostring(x)..","..tostring(y)..","..tostring(z)..")"
    m.broadcast(dId, cmdString)
end
function swarmMove(x,y,z)
    cmdString = "drone.move("..tostring(x)..","..tostring(y)..","..tostring(z)..")"
    m.broadcast(DS, cmdString)
end
function register(droneId, lightCol, dText) --register drone id lightcolor and the text to display dinamically
    local _, _, from, port, _, message = event.pull("modem_message")
    if message =="confirm" then
        m.broadcast(DS,droneId)
        os.sleep(0.1)
        m.broadcast(DS, lightCol)
        os.sleep(0.1)
        m.broadcast(DS, dText)
        local _, _, from, port, _, message = event.pull("modem_message")
        if message=="ok" then
            return true
        end
    end
end
if register(D1,0x0000FF,"1") == true then
    if register(D2,0xFa00F,"2") == true then
        if register(D3,0x00FAFF,"3") == true then
            if register(D4,0xFaFFFA,"4") == true then
                if register(D5,0xFF5555,"5") == true then
                    print("Registered all drones!")
                end
            end
        end
    end
end
--gpu = component.gpu
--gpu.setResolution(3,3)
m.broadcast(D1, "modem.open("..DS..")")
m.broadcast(D2, "modem.open("..DS..")")
m.broadcast(D3, "modem.open("..DS..")")
m.broadcast(D4, "modem.open("..DS..")")
m.broadcast(D5, "modem.open("..DS..")")
os.sleep(1)
sendCMD(DS, "drone.setLightColor(0xFF55F5)")
