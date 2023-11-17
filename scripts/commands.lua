COMMANDS = {
    q = {
        func = "leaveGame",
        help = "Schlie�t das Game",
        minadminlevel = ADMINRANKS.Ausgelogged
    },
    giveitem = {
        func = "cheatItem",
        help = "Cheated ein Item",
        minadminlevel = ADMINRANKS.Admin
    },
    help = {
        func = "help",
        help = "Zeigt diese Hilfe an",
        minadminlevel = ADMINRANKS.Ausgelogged
    },
    loc = {
        func = "getLocation",
        help = "Zeigt dir an wo du bist",
        minadminlevel = ADMINRANKS.Support
    },
    register = {
        func = "registerAccount",
        help = "Legt einen neuen Account an",
        minadminlevel = ADMINRANKS.Ausgelogged,
        adminlevel = ADMINRANKS.Ausgelogged
    },
    login = {
        func = "loginAccount",
        help = "Logged in einen Account ein",
        minadminlevel = ADMINRANKS.Ausgelogged,
        adminlevel = ADMINRANKS.Ausgelogged
    },
    newchar = {
        func = "newCharacter",
        help = "Erstellt einen neuen Charakter",
        minadminlevel = ADMINRANKS.Spieler
    },
    switch = {
        func = "switchCharakter",
        help = "Wechselt auf einen anderen deiner Charaktere",
        minadminlevel = ADMINRANKS.Spieler
    },
    facechange = {
        func = "facechange",
        help = "�ndert das Aussehen deines Charakters",
        minadminlevel = ADMINRANKS.Spieler
    },
    settime = {
        func = "setTime",
        help = "Setzt die Zeit auf <Stunden> <Minuten>",
        minadminlevel = ADMINRANKS.Support
    },
    spawn = {
        func = "spawnMonsterOnPlayer",
        help = "Spawned ein Tier in dein Umfeld",
        minadminlevel = ADMINRANKS.Support
    },
    hit = {
        func = "testhit",
        help = "Tier haut dich",
        minadminlevel = ADMINRANKS.Support
    },
    look = {
        func = "lookAtMe",
        help = "Tier schaut dich an",
        minadminlevel = ADMINRANKS.Support
    },
    move = {
        func = "moveMonster",
        help = "Tier bewegt sich vorw�rts",
        minadminlevel = ADMINRANKS.Support
    },
    ani = {
        func = "playAni",
        help = "<ID> macht Animation",
        minadminlevel = ADMINRANKS.Support
    },
    follow = {
        func = "follow",
        help = "<ID> folgt dir",
        minadminlevel = ADMINRANKS.Support
    },
    unfollow = {
        func = "unfollow",
        help = "<ID> folgt dir nicht mehr",
        minadminlevel = ADMINRANKS.Support
    },
    showani = {
        func = "showAni",
        help = "Zeigt dir deine aktuelle Ani an",
        minadminlevel = ADMINRANKS.Support
    },
    testtimer = {
        func = "testWorktimer",
        help = "Testet Craftingtimer - Angabe in ms (1000 ms = 1 Sekunde)",
        minadminlevel = ADMINRANKS.Spieler
    },
    testcraftmenu = {
        func = "testCraftmenu",
        help = "Zeigt ein Men�hintergrund",
        minadminlevel = ADMINRANKS.Spieler
    }
};

function OnPlayerText(playerid, text)
    OnPlayerCommandText(playerid, text);
end
  
function OnPlayerCommandText(playerid, text)
    if not(text) then
        return;
    end
    local command, params = GetCommand(text);
    if command:sub(1,1) == "/" then
        command = command:sub(2):lower();
        if not(COMMANDS[command]) 
        or not(PLAYERS[playerid].adminlevel >= COMMANDS[command].minadminlevel and (not(COMMANDS[command].adminlevel) or PLAYERS[playerid].adminlevel == COMMANDS[command].adminlevel)) then
            sendERRMessage(playerid, "Unbekannte Funktion: "..text);
            return;
        end
        _G[COMMANDS[command].func](playerid, params or "");
    else
        chat(playerid, text);
    end
end