local VORPcore = exports.vorp_core:GetCore()
local FeatherMenu =  exports['feather-menu'].initiate()
local BccUtils = exports['bcc-utils'].initiate()

local SaltyStatus = 0
local Dead = false
local DoDrawMarker = false
---------------------------------------------------------------------------------------------------------
--------------------------------------------- Main Menu -------------------------------------------------
---------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function ()
    SaltyBlockMenu = FeatherMenu:RegisterMenu('SaltyBlockMenu', {
        top = '13%',
        left = '11%',
        ['720width'] = '1000px',
        ['1080width'] = '1500px',
        ['2kwidth'] = '2400px',
        ['4kwidth'] = '4400px',
        style = {
            ['border'] = '5px solid orange',
            ['background-color'] = '#FF8C00'
        },
        contentslot = {
            style = {
                ['height'] = '800px',
                ['min-height'] = '800px'
            }
        },
        draggable = true,
        canclose = false
}, {
    opened = function()
        --print("MENU OPENED!")
    end,
    closed = function()
        --print("MENU CLOSED!")
    end,
    topage = function(data)
        --print("PAGE CHANGED ", data.pageid)
    end
})
SaltyBlockMenuPage1 = SaltyBlockMenu:RegisterPage('seite1')
    SaltyBlockMenuPage1:RegisterElement('line', {
        slot = 'header',
        style = {
        ['color'] = 'orange',
        }
    })
    SaltyBlockMenuPage1:RegisterElement("html", {
        slot = 'content',
        value = {
            [[
                <img width="1400px" height="800px" style="margin: 0 auto;" src="]] .. Config.PictureLink .. [[" />
            ]]
       }
    })
    SaltyBlockMenuPage1:RegisterElement('line', {
        slot = 'footer',
        style = {
        ['color'] = 'orange',
        }
    })
end)


function CheckSaltyStatus()
    while true do
        Citizen.Wait(Config.CheckTime * 1000)
        SaltyStatus = exports.saltychat:GetPluginState()
        if SaltyStatus ~= 2 and Config.KickAfterXMin == true then
            TriggerEvent('mms-saltyblock:client:KickAfterXMin')

        elseif SaltyStatus ~= 2 then -- Without Kick Function
            if Config.UsePicture then
                SaltyBlockMenu:Open({
                    startupPage = SaltyBlockMenuPage1,
                })
            else
                AnimpostfxPlay('skytl_0000_01clear')
                VORPcore.NotifyTip(Config.JoinTeamspeak, 5000)
            end
        elseif SaltyStatus == 2 then
            if Config.UsePicture then
                SaltyBlockMenu:Close({})
            else
                AnimpostfxStop('skytl_0000_01clear')
            end
        end
        
        
        -- Just Prints
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
    while SaltyStatus ~= 2 do
        SaltyStatus = exports.saltychat:GetPluginState()
        if Config.UsePicture then
            SaltyBlockMenu:Open({
                startupPage = SaltyBlockMenuPage1,
            })
            VORPcore.NotifyTip(counter .. Config.CountDownText, 5000)
            Citizen.Wait(5000)
            counter = counter -5
        else
        AnimpostfxPlay('skytl_0000_01clear')
        VORPcore.NotifyTip(counter .. Config.CountDownText, 5000)
        Citizen.Wait(5000)
        counter = counter -5
        end
        -- Back to SaltyStatus Check
        if SaltyStatus == 2 then
            CheckSaltyStatus()
        end

        -- Drop Player is Counter = 0
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


if Config.Debug then
Citizen.CreateThread(function()
    Citizen.Wait(Config.InitialWaitTime * 1000)
    CheckSaltyStatus()
end)
end


AddEventHandler("vorp_core:Client:OnPlayerDeath",function(killerserverid,causeofdeath)
    if Config.BlockDeathCom then
        TriggerServerEvent('mms-saltyblock:server:PlayerDead')
        Citizen.Wait(5000)
        VORPcore.NotifyDead(Config.YouAreDead,nil,nil,10000)
    end
end)

RegisterNetEvent("vorp_core:Client:OnPlayerRevive",function()
    if Config.BlockDeathCom then
        TriggerServerEvent('mms-saltyblock:server:PlayerAlive')
    end
end)

RegisterNetEvent("vorp_core:Client:OnPlayerRespawn",function()
    if Config.BlockDeathCom then
        TriggerServerEvent('mms-saltyblock:server:PlayerAlive')
    end
end)

RegisterNetEvent('SaltyChat_VoiceRangeChanged')
AddEventHandler('SaltyChat_VoiceRangeChanged', function(VoiceRange)
    if Config.UseSaltyCircle then
        Range = tonumber(VoiceRange)
        local myPos = GetEntityCoords(PlayerPedId())
        DrawIt(Range,myPos)
        Citizen.Wait(250)
    end
end)

function DrawIt(Range,myPos)
    local Counter = 0
    while Counter < Config.DrawTime do
        if Config.Show3dText then
            BccUtils.Misc.DrawText3D(myPos.x, myPos.y, myPos.z, Config.TextDrawn .. Range)
        end
        Citizen.Wait(3)
        DrawMarker(Config.MarkerType, myPos.x, myPos.y, myPos.z - 0.7, 0, 0, 0, 0, 0,0, Range * 2, Range * 2, 0.80, Config.Red, Config.Green, Config.Blue, Config.Alpha, 0, 0, 0)
        Counter = Counter + 14
    end
end