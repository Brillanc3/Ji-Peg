RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    local license = ESX.GetPlayerData().identifier
    local connection = os.time()
    print("Salary System")
    print("identifier", license)
    local result =
        "SELECT `identifier` FROM `salary` WHERE EXISTS (SELECT identifier FROM salary WHERE salary.identifier = ?)"
    local newPlayer = 'INSERT INTO `salary` SET `identifier` = ?, `connection` = ?, `needtime` = ?, `salarytime` = ?'
    local nice = MySQL.scalar.await(result, {license})
    if nice == nil then
        local salarytime = connection + 3600
        MySQL.prepare(newPlayer, {license, connection, tonumber(3600), salarytime}, function()
            print("New user into Salary System")
            print("identifier", license)
            print("os.time", connection)
            print("needtime", tonumber(3600))
            print("salarytime", salarytime)
        end)
    else
        local uptodate = 'UPDATE salary SET connection = ?, salarytime = ? WHERE identifier = ?'
        local needtime = MySQL.scalar.await('SELECT needtime FROM salary WHERE identifier = ?', {license})
        local salarytime = connection + needtime
        MySQL.Async.prepare(uptodate, {{connection, salarytime, license}}, function(affectedRows)
            if affectedRows == 1 then
                print(('[^2INFO^7] Updated player ^5"%s^7"'):format(license))
            end
            if cb then
                cb()
            end
        end)
    end
end)

RegisterNetEvent('playerDropped')
AddEventHandler('playerDropped', function(reason)
    local license = getLicense(source)
    local uptodate = 'UPDATE salary SET deconnection = ?, needtime = ? WHERE identifier = ?'
    local deconnection = os.time()
    local salarytime = MySQL.scalar.await('SELECT salarytime FROM salary WHERE identifier = ?', {license})
    local needtime = salarytime - deconnection

    MySQL.Async.prepare(uptodate, {{os.time(), needtime, license}}, function(affectedRows)
        if affectedRows == 1 then
            print(('[^2INFO^7] Saved player "^5%s^7"'):format(license))
        end
        if cb then
            cb()
        end
    end)
end)

updateSalary = function(license)
    local uptodate = 'UPDATE salary SET needtime = ? WHERE identifier = ?'
    local salarytime = MySQL.scalar.await('SELECT salarytime FROM salary WHERE identifier = ?', {license})
    local needtime = salarytime - os.time()
    MySQL.Async.prepare(uptodate, {{needtime, license}}, function(affectedRows)
        if cb then
            cb()
        end
    end)
    print(needtime, license)
    if needtime <= 2 then
        paytime(license)
    end
end

Givepay = function(license, price)
    if price and type(price) == "number" then
        MySQL.scalar.await('UPDATE cumultative_salary = cumultative_salary + ? FROM salary WHERE identifier = ?', {price, license})
    else
        print("Error")
    end
end

RegisterServerEvent("unh-salarysystems:update")
AddEventHandler("unh-salarysystems:update", function(source)
    local source = source
    local license = getLicense(source)
    updateSalary(license)
end)

cumultative_salary = function(license)
    local csalary = MySQL.scalar.await('SELECT cumultative_salary FROM salary WHERE identifier = ?', {license})
    return csalary
end

RegisterNetEvent('unh-salarysystems:Givepay')
AddEventHandler('unh-salarysystems:Givepay', function(source, price)
    Givepay(getLicense(source), price)
end)

getLicense = function(source)
    local player = source
    local playerIdentifier = GetPlayerIdentifiers(player)
    local license = nil
    for k, v in ipairs(playerIdentifier) do
        if string.match(v, "license:") then
            license = v
            break
        end
    end
    return license
end

getTime = function(source)
    local license = getLicense(source)
    local needtime = MySQL.scalar.await('SELECT needtime FROM salary WHERE identifier = ?', {license})
    local h = math.floor(needtime / 3600)
    local m = math.floor(needtime / 60)
    local s = math.floor(needtime % 60)
    return h .."h" ..m .."m" .. s .."s"
end

getNeedTimeToTimestamp = function(license)
    local needtimetotimestamp = MySQL.scalar.await('SELECT needtime FROM salary WHERE identifier = ?', {license})
    return needtimetotimestamp
end

paytime = function(license)
    local total_salary = cumultative_salary(license)
    print("total_salary : ", total_salary)
    --xPlayer.addAccountMoney('bank', tonumber(total_salary))
    MySQL.update.await('UPDATE salary SET cumultative_salary = ?, needtime = ?, salarytime = ? WHERE identifier = ? ', {tonumber(0), tonumber(3600), os.time() + 3600, license})
end

RegisterCommand("paycheck", function(source,args)
    updateSalary(getLicense(source))
    TriggerClientEvent('okokNotify:Alert', source, "Salaire", getTime(source).. " à attendre.", 6000, 'info')
end, true)