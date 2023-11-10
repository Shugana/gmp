PLAYERS = {};

ADMINRANKS = {
    [0] = "Ausgelogged",
    Ausgelogged = 0,
    [1] = "Spieler",
    Spieler = 1,
    [2] = "Support",
    Support = 2,
    [3] = "Admin",
    Admin = 3
}

function registerAccount(playerid, params)
    local result, name, password = sscanf(params, "ss");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /register <Account> <Password>");
        return;
    end
    name = capitalize(name);
    local hashed = MD5(password);
    local accounts = DB_select("*", "accounts", "name='"..mysql_escape_string(DB.HANDLER, name).."'");
    for _, _account in pairs(accounts) do
        sendERRMessage(playerid, "Account besteht bereits");
        return;
    end
    DB_insert("accounts", {name=name, password=hashed});
    sendINFOMessage(playerid, "Dein Account "..name.." wurde erfolgreich erstellt. Merke dir dein Passwort: '"..password.."' gut, es wird dir nur dieses eine mal angezeigt.");
    loginAccount(playerid, params);
end

function loginAccount(playerid, params)
    local result, name, password = sscanf(params, "ss");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /login <Account> <Password>");
        return;
    end
    name = capitalize(name);
    local hashed = MD5(password);
    local accounts = DB_select("*", "accounts", "name='"..mysql_escape_string(DB.HANDLER, name).."' AND password='"..mysql_escape_string(DB.HANDLER, hashed).."'");
    for _, account in pairs(accounts) do
        PLAYERS[playerid] = {
            account = account.id,
            adminlevel = account.adminlevel
        }
        sendINFOMessage(playerid, "Erfolgreich eingelogged als "..account.name..". Du hast den Adminrang "..ADMINRANKS[account.adminlevel]);
        return;
    end
    sendERRMessage(playerid, "Kein Account mit dieser Name/Passwort Kombination vorhanden.");
end

function logoutAccount(playerid, params)
    sendERRMessage(playerid, "stub");
end