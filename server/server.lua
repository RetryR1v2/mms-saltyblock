-----------------------------------------------------------------------
-- version checker
-----------------------------------------------------------------------
local function versionCheckPrint(_type, log)
    local color = _type == 'success' and '^2' or '^1'

    print(('^5['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
end

local function CheckVersion()
    PerformHttpRequest('https://raw.githubusercontent.com/RetryR1v2/mms-saltyblock/main/version.txt', function(err, text, headers)
        local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

        if not text then 
            versionCheckPrint('error', 'Currently unable to run a version check.')
            return 
        end

      
        if text == currentVersion then
            versionCheckPrint('success', 'You are running the latest version.')
        else
            versionCheckPrint('error', ('Current Version: %s'):format(currentVersion))
            versionCheckPrint('success', ('Latest Version: %s'):format(text))
            versionCheckPrint('error', ('You are currently running an outdated version, please update to version %s'):format(text))
        end
    end)
end

local VORPcore = exports.vorp_core:GetCore()

RegisterServerEvent('mms-saltyblock:server:dropplayer',function ()
    local src = source
    DropPlayer(src,Config.KickReason)
end)

RegisterServerEvent('mms-saltyblock:server:PlayerDead',function()
    local src = source
    exports.saltychat:SetPlayerAlive(src,false)
end)

RegisterServerEvent('mms-saltyblock:server:PlayerAlive',function()
    local src = source
    exports.saltychat:SetPlayerAlive(src,true)
end)

RegisterServerEvent('mms-saltyblock:server:GetPlayerGourp',function()
    local src = source
    local Character = VORPcore.getUser(src).getUsedCharacter
    local Group = Character.group
    TriggerClientEvent('mms-saltyblock:client:ReciveUserGroup',src,Group)
end)
--------------------------------------------------------------------------------------------------
-- start version check
--------------------------------------------------------------------------------------------------
CheckVersion()