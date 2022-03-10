Citizen.CreateThread(function()
    while true do
        TriggerServerEvent("unh-salary/update")
        Citizen.Wait(60 * 1000)
    end
end)