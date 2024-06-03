local speedLimited = false
local maxSpeed = 0
local defaultSpeedLimit = 80
ESX = exports['es_extended']:getSharedObject()

RegisterKeyMapping('togglespeedlimiter', 'Tempomat', 'keyboard', 'F5')

RegisterCommand('togglespeedlimiter', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        if speedLimited then
            speedLimited = false
            ESX.ShowNotification('Du hast den Tempomat deaktiviert.')
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            SetEntityMaxSpeed(vehicle, GetVehicleHandlingFloat(vehicle, "CHandlingData", "fInitialDriveMaxFlatVel"))
        else
            OpenSpeedLimiterMenu()
        end
    else
        ESX.ShowNotification('Du bist in keinem Fahrzeug')
    end
end, false)

function OpenSpeedLimiterMenu()
    ESX.UI.Menu.Open(
        'dialog', GetCurrentResourceName(), 'speed_limiter',
        {
            title = 'Geschwindigkeit'
        },
        function(data, menu)
            local speed = tonumber(data.value)
            if speed == nil then
                ESX.ShowNotification('Ungültige Geschwindigkeit')
            else
                maxSpeed = speed / 3.6
                speedLimited = true
                ESX.ShowNotification('Speedlimiter aktiviert: ' .. speed .. ' km/h')
                local playerPed = GetPlayerPed(-1)
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(vehicle, maxSpeed)
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if speedLimited then
            local playerPed = GetPlayerPed(-1)
            if IsPedInAnyVehicle(playerPed, false) then
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(vehicle, maxSpeed)
                DrawTextOnScreen('Speedlimiter: ' .. math.floor(maxSpeed * 3.6) .. ' km/h', 0.5, 0.9)
            end
        end
    end
end)

function DrawTextOnScreen(text, x, y)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.45, 0.45)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end