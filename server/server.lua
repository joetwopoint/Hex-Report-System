if Config == nil then
    print("Config is nil, failed to load configuration")
else
    print("Config loaded successfully")
end

RegisterCommand('report', function(source, args, rawCommand)
    local src = source
    TriggerClientEvent('report:openMenu', src)
end, false)

RegisterServerEvent('report:sendPlayerReport')
AddEventHandler('report:sendPlayerReport', function(serverName, playerName, reportTitle, reportDescription, discordName)
    local embed = {
        {
            ["title"] = "Sun Valley Report",
            ["description"] = "**New Player Report**",
            ["color"] = 16711935, -- Vaporwave-themed color (magenta)
            ["fields"] = {
                {
                    ["name"] = "Sun Valley",
                    ["value"] = serverName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Name",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Report Title",
                    ["value"] = reportTitle
                },
                {
                    ["name"] = "Report Description",
                    ["value"] = reportDescription
                },
                {
                    ["name"] = "Discord Name",
                    ["value"] = discordName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Timestamp",
                    ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Sun Valley"
            }
        }
    }

    local content = ""
    if Config.StaffRoleID and Config.StaffRoleID ~= "" then
        content = "<@&" .. Config.StaffRoleID .. ">"
    end

    local payload = json.encode({
        username = "Sun Valley Report System",
        content = content,
        embeds = embed
    })

    PerformHttpRequest(Config.PlayerReportWebhook, function(err, text, headers)
        if err ~= 204 and err ~= 200 then
            print("[Hex Report System] Player report webhook error: " .. tostring(err))
        end
    end, "POST", payload, { ["Content-Type"] = "application/json" })

    -- Notify online staff with the appropriate permission
    for _, playerId in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(playerId, "vMenu.ReceiveReports") then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {255, 0, 255},
                multiline = true,
                args = {"[Hex Report System]", "New player report received. Check the Discord for details."}
            })
        end
    end
end)


RegisterServerEvent('report:sendBugReport')
AddEventHandler('report:sendBugReport', function(serverName, playerName, bugDescription, discordName)
    local embed = {
        {
            ["title"] = "Sun Valley Report System",
            ["description"] = "**New Bug Report**",
            ["color"] = 16711935, -- Vaporwave-themed color (magenta)
            ["fields"] = {
                {
                    ["name"] = "Sun Valley",
                    ["value"] = serverName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Player Name",
                    ["value"] = playerName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Bug Description",
                    ["value"] = bugDescription
                },
                {
                    ["name"] = "Discord Name",
                    ["value"] = discordName,
                    ["inline"] = true
                },
                {
                    ["name"] = "Timestamp",
                    ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                    ["inline"] = true
                }
            },
            ["footer"] = {
                ["text"] = "Sun Valley Report System"
            }
        }
    }

    local content = ""
    if Config.DevRoleID and Config.DevRoleID ~= "" then
        content = "<@&" .. Config.DevRoleID .. ">"
    end

    local payload = json.encode({
        username = "Sun Valley Report System",
        content = content,
        embeds = embed
    })

    PerformHttpRequest(Config.BugReportWebhook, function(err, text, headers)
        if err ~= 204 and err ~= 200 then
            print("[Hex Report System] Bug report webhook error: " .. tostring(err))
        end
    end, "POST", payload, { ["Content-Type"] = "application/json" })

    -- Notify online staff with the appropriate permission
    for _, playerId in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(playerId, "vMenu.ReceiveReports") then
            TriggerClientEvent('chat:addMessage', playerId, {
                color = {255, 0, 255},
                multiline = true,
                args = {"[Report System]", "New bug report received. Check the Discord for details."}
            })
        end
    end
end)


