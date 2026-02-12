local ResetStress = false

Bridge.RegisterCommand('cash', 'Check Cash Balance', {}, false, function(source, _)
    local Player = Bridge.GetPlayer(source)
    if not Player then return end
    local cashamount = Player:GetMoney('cash')
    TriggerClientEvent('hud:client:ShowAccounts', source, 'cash', cashamount)
end)

Bridge.RegisterCommand('bank', 'Check Bank Balance', {}, false, function(source, _)
    local Player = Bridge.GetPlayer(source)
    if not Player then return end
    local bankamount = Player:GetMoney('bank')
    TriggerClientEvent('hud:client:ShowAccounts', source, 'bank', bankamount)
end)

Bridge.RegisterCommand('dev', 'Enable/Disable developer Mode', {}, false, function(source, _)
    TriggerClientEvent('qb-admin:client:ToggleDevmode', source)
end, 'admin')

RegisterNetEvent('hud:server:GainStress', function(amount)
    if Config.DisableStress then return end
    local src = source
    local Player = Bridge.GetPlayer(src)
    if not Player then return end
    local job = Player:GetJob()
    local Job = job.name
    local JobType = job.type
    local newStress
    if Config.WhitelistedJobs[JobType] or Config.WhitelistedJobs[Job] then return end
    if not ResetStress then
        local currentStress = Player:GetMeta('stress') or 0
        newStress = currentStress + amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player:SetMeta('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    Bridge.Notify(src, Lang:t('notify.stress_gain'), 'error', 1500)
end)

RegisterNetEvent('hud:server:RelieveStress', function(amount)
    if Config.DisableStress then return end
    local src = source
    local Player = Bridge.GetPlayer(src)
    local newStress
    if not Player then return end
    if not ResetStress then
        local currentStress = Player:GetMeta('stress') or 0
        newStress = currentStress - amount
        if newStress <= 0 then newStress = 0 end
    else
        newStress = 0
    end
    if newStress > 100 then
        newStress = 100
    end
    Player:SetMeta('stress', newStress)
    TriggerClientEvent('hud:client:UpdateStress', src, newStress)
    Bridge.Notify(src, Lang:t('notify.stress_removed'))
end)

Bridge.CreateCallback('hud:server:getMenu', function(_, cb)
    cb(Config.Menu)
end)
