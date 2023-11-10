COMMANDS = {
    q = {
        func = "leaveGame",
        help = "Schließt das Game",
        minadminlevel = ADMINRANKS.Ausgelogged
    },
    giveitem = {
        func = "giveitem",
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
        help = "Legt einen neuen Accounts an",
        minadminlevel = ADMINRANKS.Ausgelogged,
        adminlevel = ADMINRANKS.Ausgelogged
    },
    login = {
        func = "loginAccount",
        help = "Logged in einen Account ein",
        minadminlevel = ADMINRANKS.Ausgelogged,
        adminlevel = ADMINRANKS.Ausgelogged
    }
};

function OnPlayerText(playerid, text)
    OnPlayerCommandText(playerid, text);
end
  
function OnPlayerCommandText(playerid, text)
    if not(text) then
        return 0;
    end
    local command, params = GetCommand(text);
    if command:sub(1,1) == "/" then
        command = command:sub(2).lower();
        if not(COMMANDS[command]) 
        or not(PLAYERS[playerid].adminlevel > funcvalues.minadminlevel and (not(funcvalues.adminlevel) or PLAYERS[playerid].adminlevel == funcvalues.adminlevel)) then
            sendERRMessage(playerid, "Unbekannte Funktion: "..text);
            return;
        end
        _G[COMMANDS[command].func](playerid, params or "");
        end
    else
        sendINFOMessage(playerid, "used "..text);
    end
end

function sendERRMessage(playerid, text)
    SendPlayerMessage(playerid, 255, 0, 0, text);
end

function sendINFOMessage(playerid, text)
    SendPlayerMessage(playerid, 207, 175, 55, text);
end