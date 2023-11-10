COMMANDS = {
    q = {
        func = "leaveGame",
        help = "Schlieﬂt das Game"
    },
    giveitem = {
        func = "giveitem",
        help = "Cheated ein Item"
    },
    help = {
        func = "help",
        help = "Zeigt diese Hilfe an"
    },
    loc = {
        func = "getLocation",
        help = "Zeigt dir an wo du bist"
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
        command = command:sub(2);
        if COMMANDS[command] then
            _G[COMMANDS[command].func](playerid, params or "");
        elses
            sendERRMessage(playerid, "Unbekannte Funktion: "..text);
        end
    end
end

function sendERRMessage(playerid, text)
    SendPlayerMessage(playerid, 255, 0, 0, text);
end

function sendINFOMessage(playerid, text)
    SendPlayerMessage(playerid, 207, 175, 55, text);
end