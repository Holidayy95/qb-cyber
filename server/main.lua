local alarmTriggered = false
local certificateAmount = 43

RegisterServerEvent('qb-cyber:server:LoadLocationList')
AddEventHandler('qb-cyber:server:LoadLocationList', function()
    local src = source 
    TriggerClientEvent("qb-cyber:server:LoadLocationList", src, Config.Locations)
end)

RegisterServerEvent('qb-cyber:server:setSpotState')
AddEventHandler('qb-cyber:server:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
    TriggerClientEvent('qb-cyber:client:setSpotState', -1, stateType, state, spot)
end)

RegisterServerEvent('qb-cyber:server:SetThermiteStatus')
AddEventHandler('qb-cyber:server:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
    TriggerClientEvent('qb-cyber:client:SetThermiteStatus', -1, stateType, state)
end)

RegisterServerEvent('qb-cyber:server:SafeReward')
AddEventHandler('qb-cyber:server:SafeReward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', math.random(1500, 2000), "robbery-ifruit")
    Player.Functions.AddItem("certificate", certificateAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["certificate"], "add")
    Citizen.Wait(500)
    local luck = math.random(1, 100)
    if luck <= 10 then
        Player.Functions.AddItem("goldbar", math.random(1, 2))
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["goldbar"], "add")
    end
end)

RegisterServerEvent('qb-cyber:server:SetSafeStatus')
AddEventHandler('qb-cyber:server:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
    TriggerClientEvent('qb-cyber:client:SetSafeStatus', -1, stateType, state)
end)

RegisterServerEvent('qb-cyber:server:itemReward')
AddEventHandler('qb-cyber:server:itemReward', function(spot)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local item = Config.Locations["takeables"][spot].reward

    if Player.Functions.AddItem(item.name, item.amount) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item.name], 'add')
    else
        TriggerClientEvent('QBCore:Notify', src, 'You have to much in your pocket ..', 'error')
    end    
end)

RegisterServerEvent('qb-cyber:server:PoliceAlertMessage')
AddEventHandler('qb-cyber:server:PoliceAlertMessage', function()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police") then  
                local data = {displayCode = '10-11A', description = 'Cyber Bar Robbery', isImportant = 1, recipientList = {'police'}, length = '10000', infoM = 'fas fa-mobile', info = 'Cyber Bar Robbery On Going', 
                blipSprite = 775, blipColour = 50, blipScale = 1.0}
                local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(335.69, -910.86, 29.25)}
                TriggerEvent('wf-alerts:svNotify', dispatchData)
            end
        end
    end
end)

RegisterServerEvent('qb-cyber:server:PoliceAlertMessage2')
AddEventHandler('qb-cyber:server:PoliceAlertMessage2', function()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police") then  
                local data = {displayCode = '10-11B', description = 'Power Box Tampering', isImportant = 0, recipientList = {'police'}, length = '5000', infoM = 'fas fa-bolt', info = 'Someone is tamptering with the Cyber Bar Power Box', 
                blipSprite = 769, blipColour = 66, blipScale = 0.7}
                local dispatchData = {dispatchData = data, caller = 'Local', coords = vector3(379.07, -904.43, 29.42)}
                TriggerEvent('wf-alerts:svNotify', dispatchData)
            end
        end
    end
end)

RegisterServerEvent('qb-cyber:server:PoliceAlertMessage3')
AddEventHandler('qb-cyber:server:PoliceAlertMessage3', function()
    local src = source
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then 
            if (Player.PlayerData.job.name == "police") then  
                local data = {displayCode = '10-11C', description = 'Power Cut', isImportant = 0, recipientList = {'police'}, length = '5000', infoM = 'fas fa-bolt', info = 'The power has gone out unexpectedly at the Cyber Bar', 
                blipSprite = 769, blipColour = 66, blipScale = 0.4}
                local dispatchData = {dispatchData = data, caller = 'Alarm', coords = vector3(379.07, -904.43, 29.42)}
                TriggerEvent('wf-alerts:svNotify', dispatchData)
            end
        end
    end
end)