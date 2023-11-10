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
    testWriteDB(playerid);
    testReadDB(playerid);
end

function testReadDB(playerid)
    local a = DB_select("*", "test", "1");
    for _, row in pairs(a) do
        sendINFOMessage(playerid, "bla: "..row.bla..", blubb: "..row.blubb..", fasel"..row.fasel);
    end
end

function testWriteDB(playerid)
    sendERRMessage(playerid, "Start Writing");
    DB_insert("test", {
        bla="x",
        blubb="y",
        fasel="z"
    });
    DB_insert("test", {
        bla="a",
        blubb="b",
        fasel="c"
    });
    DB_insert("test", {
        bla="d",
        blubb="ff",
        fasel="ggg"
    });
    sendERRMessage(playerid, "End Writing");
end