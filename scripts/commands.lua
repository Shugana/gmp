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
    logout = {
        func = "logoutAccount",
        help = "Logged aus einem Account aus",
        minadminlevel = ADMINRANKS.Spieler
    },
    testmenu = {
        func = "testmenu",
        help = "Zeigt ein Testmenü",
        minadminlevel = ADMINRANKS.Ausgelogged
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

function testmenu(playerid, params)
    local func = "handleTestmenu";

    local x_start = 500;
    local x_size = 1500;
    local y_start = 2250;
    local y_size = 280;

    setupMenu(playerid);
    createText(playerid, "Testmenü", x_start, y_start, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "Button A", x_start, y_start+y_size, x_size, y_size, 255, 255, 255, func, {pressed = "Button A"});
    createButton(playerid, "Button B", x_start+x_size, y_start+y_size, x_size, y_size, 255, 255, 255, func, {pressed = "Button B"});
    createButton(playerid, "Button C", x_start, y_start+y_size+y_size, x_size, y_size, 255, 255, 255, func, {pressed = "Button C"});
    createButton(playerid, "Button D", x_start+x_size, y_start+y_size+y_size, x_size, y_size, 255, 255, 255, func, {pressed = "Button D"});   
end

function handleTestmenu(playerid, params)
    sendINFOMessage(playerid, "Gedrückt: "..params.pressed);
end