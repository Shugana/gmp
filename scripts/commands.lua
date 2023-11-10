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
    },
    testdb = {
        func = "testdb",
        help = "test the database"
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
        else
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

function testdb(playerid, params)
    local a = DB_select("*", "test", "1");
    sendERRMessage(playerid, "Table A");
    for _, row in pairs(a) do
        sendINFOMessage(playerid, "bla: "..row.bla..", blubb: "..row.blubb..", fasel"..row.fasel);
    end
    local b = DB_select("*", "test", "id=2");
    sendERRMessage(playerid, "Table B");
    for _, row in pairs(b) do
        sendINFOMessage(playerid, "bla: "..row.bla..", blubb: "..row.blubb..", fasel"..row.fasel);
    end
    local c = DB_select("*", "test", "id=6");
    sendERRMessage(playerid, "Table C");
    for _, row in pairs(c) do
        sendINFOMessage(playerid, "bla: "..row.bla..", blubb: "..row.blubb..", fasel"..row.fasel);
    end
end