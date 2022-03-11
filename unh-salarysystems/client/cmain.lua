local needtime = 0
local loop, connected = false, false
local playerLicense = ""
local needtime = nil

Citizen.CreateThread(function()
    while true do
        while playerLicense == "" do
            ESX.TriggerServerCallback('esx:getPlayerData', function(data)
                playerLicense = "license:" .. data.identifier
                connected = true
            end)
            Citizen.Wait(0)
        end
        if connected then
            TriggerServerEvent("unh-salarysystems:connected", playerLicense)
            connected = not connected
        end
        if needtime == nil or needtime <= 0 then
            ESX.TriggerServerCallback("unh-salary:getSalaryData", function(data)
                while needtime == nil do
                    needtime = data
                    Citizen.Wait(0)
                end
            end)
        end
        Citizen.Wait(1000)
        needtime = needtime - 1
        print("NeedTime :", needtime)
        if needtime <= 0 then
            TriggerServerEvent("unh-salarysystems:update", playerLicense)
            needtime = 3600
        end
    end
end)
