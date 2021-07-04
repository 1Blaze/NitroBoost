vehicle_model = "bmx" -- { YOUR SPAWN CODE OF VEHICLE HERE}

RegisterCommand("nitro", function()
    TriggerServerEvent("CheckNitro")
end)

function notify(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterNetEvent("nitro_notify")
AddEventHandler("nitro_notify", function(text)
    notify(text)
end)

nitro_cooldown = 0
RegisterNetEvent("SpawningNitro")
AddEventHandler("SpawningNitro", function()
    local pid = PlayerPedId()
    if IsPedInAnyVehicle(pid, true) then
        notify("~r~You can't be in a vehicle!")
        return
    end
    if IsPedDeadOrDying(pid, 1) then 
        notify("~r~Can't do that when your dead.")
        return
    end
    if nitro_cooldown == 0 then
        nitro_cooldown = 15
        local modelHash = GetHashKey(vehicle_model)
        if not HasModelLoaded(modelHash) then
            RequestModel(modelHash)
            while not HasModelLoaded(modelHash) do
                Wait(0)
            end
        end
        TaskStartScenarioInPlace(pid, "WORLD_HUMAN_HAMMERING", false, true)
        FreezeEntityPosition(pid, true)
        Citizen.Wait(6000)
        ClearPedTasks(pid)
        FreezeEntityPosition(pid, false)
        local vehicle = CreateVehicle(modelHash, GetEntityCoords(pid), GetEntityHeading(pid), true, false)
        SetVehicleOnGroundProperly(vehicle)
        SetPedIntoVehicle(pid, vehicle, -1)
        notify("~g~Spawned - Thanks for boosting!")
    else
        notify("~r~You can spawn another "..vehicle_model.." in "..nitro_cooldown.." seconds.")
    end
end)

Citizen.CreateThread(function()
    while true do
        if nitro_cooldown > 0 then
            nitro_cooldown = nitro_cooldown - 1
        end
        Wait(1000)
    end
end)