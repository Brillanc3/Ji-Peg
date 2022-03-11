local needtime          = 0
local loop = false
local PlayerData        = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        Citizen.Wait(0)
        PlayerData = ESX.GetPlayerData()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

Citizen.CreateThread(function()
    while ESX.IsPlayerLoaded() == false do
        Citizen.Wait(0)
    end
    while true do
        ESX.TriggerServerCallback("unh-salary:getSalaryData", function(data)
            if data and data > 0 and not loop then
                needtime = data
                loop = true
            end
        end)
        Wait(1000)
        needtime = needtime - 1
        if needtime == 0 then
            TriggerServerEvent("unh-salarysystems:update")
        end
    end
end)