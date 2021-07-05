

RegisterServerEvent("CheckNitro")
AddEventHandler("CheckNitro", function()
    local source = source
    exports["discordroles"]:isRolePresent(source, {'yourRoleHere'} --[[ can be a table or just a string. ]], function(hasRole, roles)
        if (not roles) then 
            TriggerClientEvent("nitro_notify", source, "~r~Err it seems you don't have discord running or installed try restart fivem if this issue persists contact your server owner.")
        end
        if hasRole == true then
            TriggerClientEvent("SpawningNitro", source)
        else
            TriggerClientEvent("nitro_notify", source, "~r~Sorry but it dosn't look like your boosting the discord server.")
        end
    end)
end)