local VORPcore = exports.vorp_core:GetCore()

local SaltyStatus = 0

function CheckSaltyStatus()
    while true do
        Citizen.Wait(Config.CheckTime * 1000)
        SaltyStatus = exports.saltychat:GetPluginState()
        if SaltyStatus ~= 2 and Config.KickAfterXMin == true then
            TriggerEvent('mms-saltyblock:client:KickAfterXMin')
        elseif SaltyStatus ~= 2 then
            AnimpostfxPlay('skytl_0000_01clear')
            VORPcore.NotifyTip(Config.JoinTeamspeak, 10000)
        elseif SaltyStatus == 2 then
            AnimpostfxStop('skytl_0000_01clear')
        end
        if Config.PrintSaltyStatus == true then
            if SaltyStatus == 0 then 
                print('Teamspeak Not Connected')
            elseif SaltyStatus == 1 then
                print('Teamspeak Connected but not Moved')
            elseif SaltyStatus == 2 then
                print('Teamspeak Connected and Sucessfully Moved to Ingame Channel')
            elseif SaltyStatus == 3 then
                print('Teamspeak Connected but in Swiss Channel')
            end
        end
    end
end

RegisterNetEvent('mms-saltyblock:client:KickAfterXMin',function ()
    local counter = Config.KickTime * 60
    while SaltyStatus ~=2 do
        SaltyStatus = exports.saltychat:GetPluginState()
        AnimpostfxPlay('skytl_0000_01clear')
        VORPcore.NotifyTip(counter .. Config.CountDownText, 5000)
        Citizen.Wait(5000)
        counter = counter -5
        if SaltyStatus == 2 then
            CheckSaltyStatus()
        end
        if counter <= 0 then
            TriggerServerEvent('mms-saltyblock:server:dropplayer')
        end
    end
end)


RegisterNetEvent('vorp:SelectedCharacter')
AddEventHandler('vorp:SelectedCharacter', function()
    Citizen.Wait(Config.InitialWaitTime * 1000)
    CheckSaltyStatus()
end)