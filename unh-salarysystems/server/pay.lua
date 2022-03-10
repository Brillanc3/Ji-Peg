pay = function()
    local xPlayers = ESX.GetPlayers()
    for _, xPlayer in pairs(xPlayers) do
        local job    		= xPlayer.job.grade_name
        local salary  		= xPlayer.job.grade_salary + cumultative_salary(xPlayer.license)
        local license       = xPlayer.license
        local 
        if salary > 0 then
        end
    end
end