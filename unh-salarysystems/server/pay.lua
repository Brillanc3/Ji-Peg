paytime = function(source)
    local _source = source
    local license = getLicense(_source)
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total_salary = cumultative_salary(_source) + xPlayer.getJob().grade_salary
    xPlayer.addAccountMoney('bank', total_salary)
    MySQL.scalar.await('UPDATE cumultative_salary = ? FROM salary WHERE identifier = ?', {0, license})
end