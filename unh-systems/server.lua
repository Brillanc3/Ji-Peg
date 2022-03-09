RegisterServerEvent('unh-vehicle/remove-item')
AddEventHandler('unh-vehicle/remove-item', function(item, count, num)
    local ox_inventory = exports.ox_inventory
    local source = source
    local items = ox_inventory:Search(source, 'count', {item})
    if items and items >= num then
        ox_inventory:RemoveItem(source, item, num)
    end
end)