if Config == nil then
    print("Config is nil, failed to load configuration")
else
    print("Config loaded successfully")
end

local displayMessage = false
local messageText = Config.MessageText
local messageDisplayTime = Config.MessageDisplayTime -- Time in seconds
local messageStartTime = 0

RegisterNetEvent('report:showSuccessMessage')
AddEventHandler('report:showSuccessMessage', function()
    messageText = Config.MessageText
    displayMessage = true
    messageStartTime = GetGameTimer() -- Get the current game time
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if displayMessage then
            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            DrawText3D(coords.x, coords.y, coords.z + 1.0, messageText)
            
            -- Check if the message display time has passed
            if (GetGameTimer() - messageStartTime) > (messageDisplayTime * 100) then
                displayMessage = false
            end
        end
    end
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(table.unpack(Config.VaporwaveColor)) -- Vaporwave color scheme
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent('report:openMenu')
AddEventHandler('report:openMenu', function()
    print("Opening report menu")
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'openMenu'
    })
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'closeMenu'
    })
    cb('ok')
end)

RegisterNUICallback('submitPlayerReport', function(data, cb)
    local playerName = GetPlayerName(PlayerId())
    local reportTitle = data.title
    local reportDescription = data.description
    local discordName = data.discord

    if reportTitle ~= "" and reportDescription ~= "" and discordName ~= "" then
        TriggerServerEvent('report:sendPlayerReport', Config.ServerName, playerName, reportTitle, reportDescription, discordName)
        cb('ok')
    else
        cb('error')
    end
end)

RegisterNUICallback('submitBugReport', function(data, cb)
    local playerName = GetPlayerName(PlayerId())
    local bugDescription = data.description
    local discordName = data.discord

    if bugDescription ~= "" and discordName ~= "" then
        TriggerServerEvent('report:sendBugReport', Config.ServerName, playerName, bugDescription, discordName)
        cb('ok')
    else
        cb('error')
    end
end)
