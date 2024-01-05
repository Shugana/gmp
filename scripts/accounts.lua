PLAYERS = {};

ADMINRANKS = {
    [0] = "Ausgelogged",
    Ausgelogged = 0,
    [1] = "Spieler",
    Spieler = 1,
    [2] = "Gildenleiter",
    Gildenleiter = 2,
    [3] = "Eventler",
    Eventler = 3,
    [4] = "Techniker",
    Techniker = 4,
    [5] = "Spielleiter",
    Spielleiter = 5,
    [6] = "Support",
    Support = 6,
    [7] = "Admin",
    Admin = 7
}

function registerAccount(playerid, params)
    local result, name, password = sscanf(params, "ss");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /register <Account> <Password>");
        return;
    end
    name = capitalize(name);
    local hashed = MD5(password);
    if DB_exists("*", "accounts", "name='"..mysql_escape_string(DB.HANDLER, name).."'") then
        sendERRMessage(playerid, "Account besteht bereits");
        return;
    end
    DB_insert("accounts", {name=name, password=hashed});
    sendINFOMessage(playerid, "Dein Account '"..name.."' wurde erfolgreich erstellt. Merke dir dein Passwort: '"..password.."' gut, es wird dir nur dieses eine mal angezeigt.");
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
        loginAccountById(playerid, account.id);
        return;
    end
    sendERRMessage(playerid, "Kein Account mit dieser Name/Passwort Kombination vorhanden.");
end

function loginAccountById(playerid, accountid)
    local mac = GetMacAddress(playerid);
    local accounts = DB_select("*", "accounts", "id="..accountid);
    for _, account in pairs(accounts) do
        PLAYERS[playerid] = {
            account = tonumber(account.id),
            adminlevel = tonumber(account.adminlevel),
            stats = {
                hp = 1,
                maxhp = 1,
                mana = 0,
                maxmana = 0,
                protections = {
                    blunt = 0,
                    edge = 0,
                    point = 0,
                    fire = 0,
                    water = 0,
                    earth = 0,
                    air = 0
                }
            }
        }
        if not(DB_exists("*","account_autologins", "accountid="..accountid)) then
            DB_insert("account_autologins", {accountid=accountid, mac=mac});
        else
            DB_update("account_autologins", {mac=mac}, "accountid="..accountid);
        end
        sendINFOMessage(playerid, "Erfolgreich eingelogged mit Account '"..account.name.."' ("..ADMINRANKS[PLAYERS[playerid].adminlevel]..")");
        tryAutologinCharacter(playerid);
        return;
    end
end

function tryAutologinAccount(playerid)
    local mac = GetMacAddress(playerid);
    local responses = DB_select("*", "account_autologins", "mac = '"..mac.."'");
    for _key, response in pairs(responses) do
        loginAccountById(playerid, response.accountid);
        return;
    end
end