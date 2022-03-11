local needtime          = 0
local loop              = false
local playerLicense     = ""

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    Citizen.CreateThread(function()
        while true do
            while playerLicense == "" do
                ESX.TriggerServerCallback('esx:getPlayerData', function(data)
                    playerLicense = "license:"..data.identifier
                end)
                Citizen.Wait(1)
            end
            ESX.TriggerServerCallback("unh-salary:getSalaryData", function(data)
                if data and data > 0 and not loop then
                    needtime = data
                    loop = not loop
                end
            end)
            Citizen.Wait(1000)
            needtime = needtime - 1
            print("NeedTime :", needtime)
            if needtime == 0 then
                loop = not loop
                TriggerServerEvent("unh-salarysystems:update", license)
            end
        end
    end)
end)

