COMMANDS = {
    q = {
        func = "leaveGame",
        help = "Schließt das Game",
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
        help = "Ändert das Aussehen deines Charakters",
        minadminlevel = ADMINRANKS.Spieler
    },
    settime = {
        func = "setTime",
        help = "Setzt die Zeit auf <Stunden> <Minuten>",
        minadminlevel = ADMINRANKS.Support
    },
    spawn = {
        func = "spawnMonster"
        help = "Spawned on Tier in dein Umfeld",
        minadminlevel = ADMINRANKS.Support
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
        sendINFOMessage(playerid, "chat "..text);
    end
end