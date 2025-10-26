local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Client:UpdateObject', function() QBCore = exports['qb-core']:GetCoreObject() end)

local headerShown = false
local sendData = nil

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end
    Wait(1000)
    SendNUIMessage({
        action = 'SET_STYLE',
        data = Config.Style,
        themeColor = Config.ThemeColor
    })
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    SendNUIMessage({
        action = 'SET_STYLE',
        data = Config.Style,
        themeColor = Config.ThemeColor
    })
end)

-- Functions
function sortData(data, skipfirst)
    local header = data[1]
    local tempData = data
    if skipfirst then table.remove(tempData,1) end
    table.sort(tempData, function(a,b) return a.header < b.header end)
    if skipfirst then table.insert(tempData,1,header) end
    return tempData
end

function openMenu(data, sort, skipFirst)
    if not data or not next(data) then return end
    if sort then data = sortData(data, skipFirst) end
	for _, v in pairs(data) do
		if v.icon then
			if QBCore.Shared.Items[tostring(v.icon)] then
				if not string.find(QBCore.Shared.Items[tostring(v.icon)].image, "//") and not string.find(v.icon, "//") then
                    v.icon = "https://qb-inventory/html/images/"..QBCore.Shared.Items[tostring(v.icon)].image
				end
			end
		end
	end
    headerShown = false
    sendData = data
    SetNuiFocus(true, true)
    SendNUIMessage({action = "openMenu", data = table.clone(data), themeColor = Config.ThemeColor})
end

function closeMenu()
    sendData = nil
    headerShown = false
    SetNuiFocus(false)
    SendNUIMessage({action = 'closeMenu'})
end

function showHeader(data)
    if not data or not next(data) then return end
    headerShown = true
    sendData = data
    SendNUIMessage({action = 'openMenu', data = table.clone(data), themeColor = Config.ThemeColor})
end

-- Events
RegisterNetEvent('qb-menu:client:openMenu', function(data, sort, skipFirst)
    openMenu(data, sort, skipFirst)
end)

RegisterNetEvent('qb-menu:client:closeMenu', function()
    closeMenu()
end)

-- NUI Callbacks
RegisterNUICallback('clickedButton', function(option, cb)
    if headerShown then headerShown = false end
    PlaySoundFrontend(-1, 'Highlight_Cancel', 'DLC_HEIST_PLANNING_BOARD_SOUNDS', 1)
    SetNuiFocus(false)
    if sendData then
        local data = sendData[tonumber(option)]
        sendData = nil
        if data then
            if data.params.event then
                if data.params.isServer then
                    TriggerServerEvent(data.params.event, data.params.args)
                elseif data.params.isCommand then
                    ExecuteCommand(data.params.event)
                elseif data.params.isQBCommand then
                    TriggerServerEvent('QBCore:CallCommand', data.params.event, data.params.args)
                elseif data.params.isAction then
                    data.params.event(data.params.args)
                else
                    TriggerEvent(data.params.event, data.params.args)
                end
            end
        end
    end
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    headerShown = false
    sendData = nil
    SetNuiFocus(false, false)
    cb('ok')
    TriggerEvent("qb-menu:client:menuClosed")
end)

-- Command and Keymapping
RegisterCommand('playerfocus', function()
    if headerShown then
        SetNuiFocus(true, true)
    end
end)
RegisterKeyMapping('playerFocus', 'Give Menu Focus', 'keyboard', 'LMENU')

-- Exports
exports('openMenu', openMenu)
exports('closeMenu', closeMenu)
exports('showHeader', showHeader)

RegisterCommand('menutest', function()
    local testMenu = {
        {
            header = "Test Menu",
            isMenuHeader = true -- This makes it a header
            -- icon = "fas fa-ferry"
        },
        {
            header = "Inventory",
            txt = "Opens your inventory",
            icon = "fa fa-ferry", -- This will pull the image from qb-inventory
            params = {
                event = "inventory:client:openInventory",
                args = {}
            }
        },
        {
            header = "Stash",
            txt = "Opens stash",
            icon = "fa fa-ferry", -- Another example item icon
            params = {
                event = "inventory:client:openStash",
                args = {stash = "teststash"}
            }
        },
        {
            header = "Call Police",
            txt = "Trigger a police event",
            icon = "fa fa-ferry",
            disabled = true,
            params = {
                event = "police:client:SendPoliceAlert",
                args = {message = "Test emergency!"}
            }
        },
        {
            header = "Trigger Explosion",
            txt = "Client-side explosion (for test only)",
            icon = "fa fa-ferry",
            params = {
                isAction = true,
                event = function()
                    local coords = GetEntityCoords(PlayerPedId())
                    AddExplosion(coords.x, coords.y, coords.z, 2, 1.0, true, false, 0.0)
                end
            }
        },
        {
            header = "Close",
            txt = "Close this menu",
            icon = "fa fa-close",
            params = {
                event = "qb-menu:client:closeMenu"
            }
        }
    }

    TriggerEvent('qb-menu:client:openMenu', testMenu)
end, false)


