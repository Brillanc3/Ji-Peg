ESX.RegisterServerCallback("unh-salary:getSalaryData", function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer then
        local needtime = getNeedTimeToTimestamp("license:"..xPlayer.getIdentifier())
        cb(needtime)
    end
end)


-- CreateThread(function()
--     while true do
--         Wait(1000)
--         local xPlayers = ESX.GetExtendedPlayers()
-- 		for _, xPlayer in pairs(xPlayers) do
--             local licence = "license:"..xPlayer.getIdentifier()
--             print("license:" .. licence)
--             updateSalary("license:"..xPlayer.getIdentifier())
--         end
--     end
-- end)