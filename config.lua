Config = {}

Config.Debug = true

Config.IgnoreAdmins = true
Config.AdminGroups = {
    { AdminGroup = 'owner' },
    { AdminGroup = 'admin' },
    { AdminGroup = 'support' },
    { AdminGroup = 'guide' },

}

Config.InitialWaitTime = 4  -- For Players with bad Computer you Should let it 60 Seconds 
Config.CheckTime = 10  -- Time in Sec 10 Seconds to check if player is in SaltyChat or not 
Config.JoinTeamspeak = 'Du musst auf unserem Teamspeak sein um zu Spielen!'
Config.PrintSaltyStatus = false
Config.KickAfterXMin = true -- if true you get kicked after x min
Config.KickTime = 5 -- Time in Min before a Player gets kicked
Config.KickReason = 'Du musst auf unserem Teamspeak sein um zu Spielen! Für Hilfe komm auf unseren Discord'
Config.CountDownText = ' Sekunden Verbleibend bevor du gekickt wirst komme auf unseren Teamspeak um zu Spielen'

Config.UsePicture = true
Config.PictureLink = 'https://i.postimg.cc/2SjVkKZ2/1400x722.png'

-- Check for Death and Block Communication
Config.BlockDeathCom = true
Config.YouAreDead = 'Saltyblock: Du bist Gestorben und Kannst nicht mehr Sprechen.'


--- Draw SaltyCircle

Config.UseSaltyCircle = true
Config.DrawTime = 1000  --- 1000 = 1 Sek

Config.MarkerType = 0x94FDAE17
--RGB Color
Config.Red = 255
Config.Green = 0
Config.Blue = 0
Config.Alpha = 0.5  -- 0.1 - 1.0

Config.Show3dText = true
Config.TextDrawn = 'Neue Sprachreichweite: '