local isLoggedIn = false
local CurrentCops = 0
local copsCalled = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000 * 45 * 5)
        if copsCalled then
            copsCalled = false
        end
    end
end)

local requiredItemsShowed = false
local requiredItemsShowed2 = false
local requiredItems = {}
local currentSpot = 0
local usingSafe = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(1)
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 3.0 and not Config.Locations["thermite"].isDone then
                DrawMarker(2, Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.25, 0.1, 255, 255, 255, 100, 0, 0, 0, 1, 0, 0, 0)
                if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
                    if not Config.Locations["thermite"].isDone then 
                        if not requiredItemsShowed then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                            }
                            requiredItemsShowed = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                    end
                end
            else
                if requiredItemsShowed then
                    requiredItems = {
                        [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                    }
                    requiredItemsShowed = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
            end
        else
            Citizen.Wait(3000)
        end
    end
end)

Citizen.CreateThread(function()
    local inRange = false
    while true do
        Citizen.Wait(1) 
        if isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            for spot, location in pairs(Config.Locations["takeables"]) do
                local dist = #(pos - vector3(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z))
                if dist < 1.0 then
                    inRange = true
                    if dist < 0.6 then
                        if not requiredItemsShowed2 then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed2 = true
                            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
                        end
                        if not Config.Locations["takeables"][spot].isBusy and not Config.Locations["takeables"][spot].isDone then
                            DrawText3Ds(Config.Locations["takeables"][spot].x, Config.Locations["takeables"][spot].y,Config.Locations["takeables"][spot].z, '~g~E~w~ To grab item')
                            if IsControlJustPressed(0, 38) then
                                if CurrentCops >= 0 then
                                    if Config.Locations["thermite"].isDone then 
                                        QBCore.Functions.TriggerCallback('QBCore:HasItem', function(hasItem)
                                            if hasItem then
                                                currentSpot = spot
                                                GrabItem(currentSpot)
                                            else
                                                QBCore.Functions.Notify("You are missing an advanced lockpick", "error")
                                            end
                                        end, "advancedlockpick")
                                    else
                                        QBCore.Functions.Notify("Security is still active..", "error")
                                    end
                                else
                                    QBCore.Functions.Notify("Not enough Police", "error")
                                end
                            end
                        end
                    else
                        if requiredItemsShowed2 then
                            requiredItems = {
                                [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                            }
                            requiredItemsShowed2 = false
                            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                        end
                    end
                end
            end

            if not inRange then
                if requiredItemsShowed2 then
                    requiredItems = {
                        [1] = {name = QBCore.Shared.Items["advancedlockpick"]["name"], image = QBCore.Shared.Items["advancedlockpick"]["image"]},
                    }
                    requiredItemsShowed2 = false
                    TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                end
                Citizen.Wait(2000)
            end
        end
    end
end)

function lockpickDone(success)
    local pos = GetEntityCoords(PlayerPedId())
    if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
        TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
    end
    if success then
        GrabItem(currentSpot)
    else
        if math.random(1, 100) <= 40 and IsWearingHandshoes() then
            TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            QBCore.Functions.Notify("You ripped your glove..")
        end
        if math.random(1, 100) <= 10 then
            TriggerServerEvent("QBCore:Server:RemoveItem", "advancedlockpick", 1)
            TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["advancedlockpick"], "remove")
        end
    end
end

function GrabItem(spot)
    local pos = GetEntityCoords(PlayerPedId())
    if requiredItemsShowed2 then
        requiredItemsShowed2 = false
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
    QBCore.Functions.Progressbar("grab_ifruititem", "Disconnecting Item", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "anim@gangops@facility@servers@",
        anim = "hotwire",
        flags = 16,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('qb-cyber:server:setSpotState', "isDone", true, spot)
        TriggerServerEvent('qb-cyber:server:setSpotState', "isBusy", false, spot)
        TriggerServerEvent('qb-cyber:server:itemReward', spot)
        TriggerServerEvent("qb-cyber:server:PoliceAlertMessage")
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        TriggerServerEvent('qb-cyber:server:setSpotState', "isBusy", false, spot)
        QBCore.Functions.Notify("Canceled..", "error")
    end)
end

RegisterNetEvent('SafeCracker:EndMinigame')
AddEventHandler('SafeCracker:EndMinigame', function(won)
    if usingSafe then
        if won then
            if not Config.Locations["safe"].isDone then
                SetNuiFocus(false, false)
                TriggerServerEvent("qb-cyber:server:SafeReward")
                TriggerServerEvent("qb-cyber:server:SetSafeStatus", "isBusy", false)
                TriggerServerEvent("qb-cyber:server:SetSafeStatus", "isDone", false)
                takeAnim()
            end
        end
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    TriggerServerEvent("qb-cyber:server:LoadLocationList")
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload')
AddEventHandler('QBCore:Client:OnPlayerUnload', function()
    isLoggedIn = false
end)

RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-cyber:client:LoadList')
AddEventHandler('qb-cyber:client:LoadList', function(list)
    Config.Locations = list
end)

RegisterNetEvent('thermite:UseThermite')
AddEventHandler('thermite:UseThermite', function()
    local pos = GetEntityCoords(PlayerPedId())
    if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
        if CurrentCops >= 0 then
            local pos = GetEntityCoords(PlayerPedId())
            if math.random(1, 100) <= 80 and not IsWearingHandshoes() then
                TriggerServerEvent("evidence:server:CreateFingerDrop", pos)
            end
            if requiredItemsShowed then
                requiredItems = {
                    [1] = {name = QBCore.Shared.Items["thermite"]["name"], image = QBCore.Shared.Items["thermite"]["image"]},
                }
                requiredItemsShowed = false
                TriggerEvent('inventory:client:requiredItems', requiredItems, false)
                TriggerServerEvent("qb-cyber:server:SetThermiteStatus", "isBusy", true)
                SetNuiFocus(true, true)
                SendNUIMessage({
                    action = "openThermite",
                    amount = math.random(5, 6),
                })
            end
        else
            QBCore.Functions.Notify("Not enough police", "error")
        end
    end
end)

RegisterNetEvent('qb-cyber:client:setSpotState')
AddEventHandler('qb-cyber:client:setSpotState', function(stateType, state, spot)
    if stateType == "isBusy" then
        Config.Locations["takeables"][spot].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["takeables"][spot].isDone = state
    end
end)

RegisterNetEvent('qb-cyber:client:SetSafeStatus')
AddEventHandler('qb-cyber:client:SetSafeStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["safe"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["safe"].isDone = state
    end
end)

RegisterNetEvent('qb-cyber:client:SetThermiteStatus')
AddEventHandler('qb-cyber:client:SetThermiteStatus', function(stateType, state)
    if stateType == "isBusy" then
        Config.Locations["thermite"].isBusy = state
    elseif stateType == "isDone" then
        Config.Locations["thermite"].isDone = state
    end
end)

RegisterNUICallback('thermiteclick', function()
    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)
end)

RegisterNUICallback('thermitefailed', function()
    TriggerServerEvent('qb-cyber:server:PoliceAlertMessage2')
    PlaySound(-1, "Place_Prop_Fail", "DLC_Dmod_Prop_Editor_Sounds", 0, 0, 1)
    TriggerServerEvent("qb-cyber:server:SetThermiteStatus", "isBusy", false)
    TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["thermite"], "remove")
    local coords = GetEntityCoords(PlayerPedId())
    local randTime = math.random(10000, 15000)
    CreateFire(coords, randTime)
end)

RegisterNUICallback('thermitesuccess', function()
    QBCore.Functions.Notify("The fuses are broken", "success")
    TriggerServerEvent('qb-cyber:server:PoliceAlertMessage3')
    TriggerServerEvent("QBCore:Server:RemoveItem", "thermite", 1)
    local pos = GetEntityCoords(PlayerPedId())
    if #(pos - vector3(Config.Locations["thermite"].x, Config.Locations["thermite"].y,Config.Locations["thermite"].z)) < 1.0 then
        TriggerServerEvent("qb-cyber:server:SetThermiteStatus", "isDone", true)
        TriggerServerEvent("qb-cyber:server:SetThermiteStatus", "isBusy", false)
    end
end)

RegisterNUICallback('closethermite', function()
    SetNuiFocus(false, false)
end)

function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

function IsWearingHandshoes()
    local armIndex = GetPedDrawableVariation(PlayerPedId(), 3)
    local model = GetEntityModel(PlayerPedId())
    local retval = true
    if model == GetHashKey("mp_m_freemode_01") then
        if Config.MaleNoHandshoes[armIndex] ~= nil and Config.MaleNoHandshoes[armIndex] then
            retval = false
        end
    else
        if Config.FemaleNoHandshoes[armIndex] ~= nil and Config.FemaleNoHandshoes[armIndex] then
            retval = false
        end
    end
    return retval
end

function takeAnim()
    local ped = PlayerPedId()
    while (not HasAnimDictLoaded("amb@prop_human_bum_bin@idle_b")) do
        RequestAnimDict("amb@prop_human_bum_bin@idle_b")
        Citizen.Wait(100)
    end
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "idle_d", 8.0, 8.0, -1, 50, 0, false, false, false)
    Citizen.Wait(2500)
    TaskPlayAnim(ped, "amb@prop_human_bum_bin@idle_b", "exit", 8.0, 8.0, -1, 50, 0, false, false, false)
end

function CreateFire(coords, time)
    for i = 1, math.random(1, 7), 1 do
        TriggerServerEvent("thermite:StartServerFire", coords, 24, false)
    end
    Citizen.Wait(time)
    TriggerServerEvent("thermite:StopFires")
end


Citizen.CreateThread(function()
    local blip = AddBlipForCoord(335.77, -912.55, 29.26)
    SetBlipSprite(blip, 775)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 84)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cyber Bar")
    EndTextCommandSetBlipName(blip)
end)
