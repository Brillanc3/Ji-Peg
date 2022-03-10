Citizen.CreateThread(function()
    local ox_inventory = exports.ox_inventory
    local source = source
    while true do
        exports.qtarget:Vehicle({
            options = {
                {
                    icon = 'fas fa-key',
                    label = Config.lang['start_n_stop_engin_label'],
                    action = function(entity)
                        local inventory = ox_inventory:Search('count', {'vehiclekeys'}, {plate = GetVehicleNumberPlateText(entity)})
                        local vehicleEngine = GetIsVehicleEngineRunning(entity)
                        if inventory and inventory ~= 0 then
                            SetVehicleEngineOn(entity, not vehicleEngine, true, false)
                            if vehicleEngine then
                                exports['okokNotify']:Alert(Config.Lang['start_n_stop_engine_title_notif'],
                                                            Config.lang['start_n_stop_engin_message'] .. vehicleEngine, 3000,
                                                            'warning')
                            else
                                exports['okokNotify']:Alert(Config.Lang['start_n_stop_engine_title_notif'],
                                                            Config.lang['start_n_stop_engin_message'] .. vehicleEngine , 3000,
                                                            'warning')
                            end
                        else
                            exports['okokNotify']:Alert(Config.lang['no_key_title'], Config.lang['no_key_message'], 3000, 'error')
                        end
                    end
                },
                {
                    icon = 'fas fa-key',
                    label = "Ouvrire / Fermer le véhicule",
                    action = function(entity)
                        local item = ox_inventory:Search('count', {'vehiclekeys'}, {plate = GetVehicleNumberPlateText(entity)})
                        if item and item ~= 0 then
                            if GetVehicleDoorLockStatus(entity) == 6 then
                                exports['okokNotify']:Alert("Doors Status","La serrure est cassé", 3000,'info')
                            elseif GetVehicleDoorLockStatus(entity) == 1 then
                                SetVehicleDoorsLocked(entity, 2)
                                exports['okokNotify']:Alert("Doors Status","Door lock", 3000,'warning')
                            else
                                SetVehicleDoorsLocked(entity, 1)
                                exports['okokNotify']:Alert("Doors Status","Door unlock", 3000,'warning')
                            end
                        else
                            exports['okokNotify']:Alert("Vehicle Alarm", "Attention, vous n'avez pas les clés du véhicule", 3000, 'error')
                        end
                    end
                },
                {
                    icon = 'fas fa-key',
                    label = "Police Menu",
                    job = {["police"] = 0},
                    num = 1,
                    canInteract = function(entity) return DoesEntityExist(entity) end,
                    action = function(entity)

                        exports.qtarget:AddTargetEntity(entity, {
                            options = {
                                {
                                    icon = "fas fa-box-circle-check",
                                    label = "Fermer le menu",
                                    num = 1,
                                    action = function(entity2)
                                        exports.qtarget:RemoveTargetEntity(entity, {
                                            'Forcer la porte véhicule', 'Fermer le menu'
                                        })
                                    end
                                },
                                {
                                    icon = "fas fa-box-circle-check",
                                    label = "Forcer la porte véhicule",
                                    num = 2,
                                    action = function(entity2)
                                        exports.qtarget:RemoveTargetEntity(entity, {
                                            'Forcer la porte véhicule', 'Fermer le menu'
                                        })
                                        local item = ox_inventory:Search('count', {'ecarteurhyd'})
                                        if item and item ~= 0 then
                                            if GetVehicleDoorLockStatus(entity2) == 2 then
                                                SetVehicleDoorsLocked(entity2, 6)
                                                exports['okokNotify']:Alert("Police","Porte forcée", 3000,'warning')
                                            else
                                                exports['okokNotify']:Alert("Police","Porte déjà ouverte.", 3000,'info')
                                            end
                                        else
                                            exports['okokNotify']:Alert("Police","Tu n'as pas d'écarteur hydraulique.", 3000,'error')
                                        end
                                    end
                                },
                            },
                            distance = 2
                        })

                        --[[
                        ]]
                    end
                },
                {
                    icon = 'fas fa-key',
                    label = "Réparer la serrure",
                    job = {["mechanic1"] = 1},
                    action = function(entity)
                        local item = ox_inventory:Search('count', {'vehserrure'}, {type="voiture"})
                        if item and item ~= 0 then
                            if GetVehicleDoorLockStatus(entity) == 6 then
                                exports['okokNotify']:Alert("Mechano","La serrure est réparé", 3000,'info')
                                SetVehicleDoorsLocked(entity, 2)
                                TriggerServerEvent('unh-vehicle/remove-item', 'vehserrure', 1, 1)
                            else
                                exports['okokNotify']:Alert("Mechano","La n'as pas de problème ! ", 3000,'error')
                            end
                        else
                            exports['okokNotify']:Alert("Mechano","Tu n'as pas de serrure de voiture.", 3000,'error')
                        end
                    end
                },
            },
            distance = 0.9
        })
        Citizen.Wait(250)
    end
end)
