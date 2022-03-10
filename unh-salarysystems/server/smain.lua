Citizen.CreateThread(function()
    while true do
      Citizen.Wait(1000) -- 1second
    end
end)

RegisterNetEvent('playerConnecting')
AddEventHandler('playerConnecting', function()
    local license = getLicense(source)
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
            print(('[^2INFO^7] Saved player ^5"%s^7"'):format(license))
        end
        if cb then
            cb()
        end
    end)
end)

updateSalary = function(source)
    local license = getLicense(source)
    local uptodate = 'UPDATE salary SET needtime = ? WHERE identifier = ?'
    local salarytime = MySQL.scalar.await('SELECT salarytime FROM salary WHERE identifier = ?', {license})
    local needtime = salarytime - os.time()
    MySQL.Async.prepare(uptodate, {{needtime, license}}, function(affectedRows)
        if cb then
            cb()
        end
    end)
    if needtime <= 0 then
        paytime(source)
    end
end

Givepay = function(license, price)
    if price and type(price) == "number" then
        return MySQL.scalar.await('UPDATE cumultative_salary = cumultative_salary + ? FROM salary WHERE identifier = ?', {price, license})
    else
        return "Error"
    end
end

cumultative_salary = function(source)
    local license = getLicense(source)
    return MySQL.scalar.await('SELECT cumultative_salary FROM salary WHERE identifier = ?', {license})
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

RegisterServerEvent("unh-salary/update")
AddEventHandler("unh-salary/update", function()
    local source = source
    updateSalary(source)
end)

RegisterCommand("paycheck", function(source,args)
    updateSalary(source)
    TriggerClientEvent('okokNotify:Alert', source, "Salaire", getTime(source).. " à attendre.", 6000, 'info')
end, true)