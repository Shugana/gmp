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
    testUpdateDB(playerid);
end

function testReadDB(playerid)
    local a = DB_select("*", "test", "1");
    for _, row in pairs(a) do
        sendINFOMessage(playerid, "bla: "..row.bla..", blubb: "..row.blubb..", fasel"..row.fasel);
    end
end

function testWriteDB(playerid)
    DB_insert("test", {
        bla="x",
        blubb="y",
        fasel="z"
    });
end

function testDeleteDB(playerid)
    DB_delete("test", "1");
end

function testUpdateDB(playerid)
    sendERRMessage(playerid, "new call a");
    local a = DB_update("test", {bla="a"}, "1"); -- everything
    if (a) then
        sendINFOMessage("a success");
    else
        sendINFOMessage("a fail");
    end

    sendERRMessage(playerid, "new call b");
    local b = DB_update("test", {bla="b"}, "blubb='b'"); -- one
    if (b) then
        sendINFOMessage("b success");
    else
        sendINFOMessage("b fail");
    end

    sendERRMessage(playerid, "new call c");
    local c = DB_update("test", {bla="c"}, "fasel='hurz'"); -- zero
    if (c) then
        sendINFOMessage("c success");
    else
        sendINFOMessage("c fail");
    end

    sendERRMessage(playerid, "new call d");
    local d = DB_update("test", {bla="d"}, "derp='hurz'"); -- derp does not exist
    if (d) then
        sendINFOMessage("d success");
    else
        sendINFOMessage("d fail");
    end

    sendERRMessage(playerid, "new call e");
    local e = DB_update("test", {derp="e"}, "1"); -- derp does not exist
    if (e) then
        sendINFOMessage("e success");
    else
        sendINFOMessage("e fail");
    end
end