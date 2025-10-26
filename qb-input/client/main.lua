local properties = nil

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

RegisterNUICallback('buttonSubmit', function(data, cb)
    SetNuiFocus(false)
    properties:resolve(data.data)
    properties = nil
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false)
    properties:resolve(nil)
    properties = nil
    cb('ok')
end)

local function ShowInput(data)
    Wait(150)
    if not data then return end
    if properties then return end

    properties = promise.new()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'OPEN_MENU',
        data = data
    })

    return Citizen.Await(properties)
end

exports('ShowInput', ShowInput)


-- RegisterCommand('testinput', function()
--     local data = {
--         header = "QB Input Test Form",
--         submitText = "Submit Test",
--         inputs = {
--             {
--                 type = "text",
--                 text = "Enter your name",
--                 name = "name",
--                 isRequired = true
--             },
--             {
--                 type = "password",
--                 text = "Enter a password",
--                 name = "password"
--             },
--             {
--                 type = "number",
--                 text = "Enter your age",
--                 name = "age",
--                 default = 18
--             },
--             {
--                 type = "radio",
--                 text = "Choose your gender",
--                 name = "gender",
--                 options = {
--                     { value = "male", text = "Male" },
--                     { value = "female", text = "Female" },
--                     { value = "other", text = "Other" }
--                 }
--             },
--             {
--                 type = "select",
--                 text = "Choose your country",
--                 name = "country",
--                 options = {
--                     { value = "us", text = "United States" },
--                     { value = "ca", text = "Canada" },
--                     { value = "uk", text = "United Kingdom" }
--                 }
--             },
--             {
--                 type = "checkbox",
--                 text = "Select your interests",
--                 name = "interests",
--                 options = {
--                     { value = "sports", text = "Sports", checked = true },
--                     { value = "music", text = "Music" },
--                     { value = "gaming", text = "Gaming" }
--                 }
--             },
--             {
--                 type = "color",
--                 text = "Choose your favorite color",
--                 name = "color",
--                 default = "#ff0000"
--             }
--         }
--     }

--     local result = exports['qb-input']:ShowInput(data)
--     if result then
--         print("Form submitted with data: " .. json.encode(result))
--     else
--         print("Form was cancelled")
--     end
-- end, false)