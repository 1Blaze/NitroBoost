local NitroCooldown = 0

function ShowNotification( text )
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

RegisterCommand("nitro", function()
    if IsPedInAnyVehicle(PlayerPedId(), true) then
        ShowNotification("~r~You can't be in a vehicle!")
    else
        TriggerServerEvent("CheckNitro")
    end
end)

RegisterNetEvent("NotBoosing")
AddEventHandler("NotBoosing", function()
    ShowNotification("~r~You are not a nitro booster!")
end)

RegisterNetEvent("NoGuild")
AddEventHandler("NoGuild", function()
    ShowNotification("Discord doesnt seem to be installed/running.")
end)

RegisterNetEvent("SpawningNitro")
AddEventHandler("SpawningNitro", function()
    local pid = PlayerPedId()
    if IsPedDeadOrDying(PlayerPedId(), 1) then 
        ShowNotification("You are dead!")
        return
    end
    if NitroCooldown == 0 then
        local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
        local veh = bmx
        if veh == nil then veh = "bmx" end
        vehiclehash = GetHashKey(veh)
        RequestModel(vehiclehash)
        
        Citizen.CreateThread(function() 
            local waiting = 0
            while not HasModelLoaded(vehiclehash) do
                waiting = waiting + 100
                Citizen.Wait(100)
                if waiting > 5000 then
                    ShowNotification("~r~Could not load the vehicle model in time, a crash was prevented.")
                    break
                end
            end
            TaskStartScenarioInPlace(pid, 'WORLD_HUMAN_HAMMERING', false, true)
            FreezeEntityPosition(pid, true)
            Citizen.Wait(6000)
            ClearPedTasks(pid)
            FreezeEntityPosition(pid, false)
            NitroCooldown = 15
            CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
            ShowNotification("~g~ Spawned - Thanks for boosting!")
        end)
    else
        ShowNotification("~r~Stop Spamming!!!")
    end
end)


Citizen.CreateThread(function()
    while true do
        if NitroCooldown > 0 then
            NitroCooldown = NitroCooldown - 1
        end
        Wait(1000)
    end
end)