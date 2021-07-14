function require(x)
    return component.proxy(component.list(x)())
end
drone = require("drone")
modem = require("modem")
band = 900
modem.open(band)
drone.setStatusText("Registering...")
modem.broadcast(band, "confirm")
local evt,_,src,prt,_,msg,data = computer.pullSignal()
band2 = msg
local evt,_,src,prt,_,msg,data = computer.pullSignal()
cmd2 = msg
local evt,_,src,prt,_,msg,data = computer.pullSignal()
cmd3 = msg
modem.close(band)
drone.setLightColor(cmd2)
drone.setStatusText(cmd3)
modem.open(tonumber(band2))
modem.broadcast(band2, "ok")
while true do
    local evt,_,src,prt,_,msg,data = computer.pullSignal()
    load(msg)()
end
