COMMANDS = {
    q = {
        func = "leaveGame",
        help = "Schließt das Game",
        minadminlevel = ADMINRANKS.Ausgelogged
    },
    giveitem = {
        func = "cheatItem",
        help = "Cheated ein Item",
        minadminlevel = ADMINRANKS.Spielleiter
    },
    giveall = {
        func = "cheatItemAll",
        help = "Gibt dir Testweise alle Items",
        minadminlevel = ADMINRANKS.Spielleiter
    },
    help = {
        func = "help",
        help = "Zeigt diese Hilfe an",
        minadminlevel = ADMINRANKS.Ausgelogged
    },
    loc = {
        func = "getLocation",
        help = "Zeigt dir an wo du bist",
        minadminlevel = ADMINRANKS.Eventler
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
        func = "spawnMonsterOnPlayer",
        help = "Spawned ein Tier in dein Umfeld",
        minadminlevel = ADMINRANKS.Eventler
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
        help = "Tier bewegt sich vorwärts",
        minadminlevel = ADMINRANKS.Support
    },
    ani = {
        func = "playAni",
        help = "<ID> macht Animation",
        minadminlevel = ADMINRANKS.Eventler
    },
    follow = {
        func = "follow",
        help = "<ID> folgt dir",
        minadminlevel = ADMINRANKS.Eventler
    },
    unfollow = {
        func = "unfollow",
        help = "<ID> folgt dir nicht mehr",
        minadminlevel = ADMINRANKS.Eventler
    },
    showani = {
        func = "showAni",
        help = "Zeigt dir deine aktuelle Ani an",
        minadminlevel = ADMINRANKS.Eventler
    },
    w = {
        func = "chatw",
        help = "Flüstert",
        minadminlevel = ADMINRANKS.Spieler
    },
    wme = {
        func = "chatwme",
        help = "Schreibt ein Emote, etwas das dein Charakter tut in Flüsterreichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    wms = {
        func = "chatwms",
        help = "Schreibt einen Satz beginnend mit deinem Charakter im Genitiv in Flüsterreichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    ['/w'] = {
        func = "chatwooc",
        help = "Schreibt OOC Chat in Flüsterreichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    u = {
        func = "chatu",
        help = "Spricht halblaut",
        minadminlevel = ADMINRANKS.Spieler
    },
    ume = {
        func = "chatume",
        help = "Schreibt ein Emote, etwas das dein Charakter tut in halber Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    ums = {
        func = "chatums",
        help = "Schreibt einen Satz beginnend mit deinem Charakter im Genitiv in halber Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    ['/u'] = {
        func = "chatuooc",
        help = "Schreibt OOC Chat in halber Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    me = {
        func = "chatme",
        help = "Schreibt ein Emote, etwas das dein Charakter tut",
        minadminlevel = ADMINRANKS.Spieler
    },
    ms = {
        func = "chatms",
        help = "Schreibt einen Satz beginnend mit deinem Charakter im Genitiv",
        minadminlevel = ADMINRANKS.Spieler
    },
    ['/'] = {
        func = "chatooc",
        help = "Schreibt OOC Chat",
        minadminlevel = ADMINRANKS.Spieler
    },
    shout = {
        func = "chatshout",
        help = "Schreit etwas",
        minadminlevel = ADMINRANKS.Spieler
    },
    shoutme = {
        func = "chatshoutme",
        help = "Schreibt ein Emote, etwas das dein Charakter tut in hoher Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    shoutms = {
        func = "chatshoutms",
        help = "Schreibt einen Satz beginnend mit deinem Charakter im Genitiv in hoher Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    ['/shout'] = {
        func = "chatshoutooc",
        help = "Schreibt OOC Chat in hoher Reichweite",
        minadminlevel = ADMINRANKS.Spieler
    },
    pm = {
        func = "pm",
        help = "Schreibt einem Spieler oder einer ID eine private Nachricht. Diese wird NICHT gelogged.",
        minadminlevel = ADMINRANKS.Spieler
    },
    report = {
        func = "report",
        help = "Schreibt einen Report. Dies können Supporter und Admins lesen",
        minadminlevel = ADMINRANKS.Spieler
    },
    tp = {
        func = "tp",
        help = "Teleportere <ID1> zu <ID2>. Gibst du nur eine ID an, wirst du zu der ID teleportiert",
        minadminlevel = ADMINRANKS.Eventler
    },
    ["goto"] = {
        func = "useGoto",
        help = "Teleport dich zu einem Ort mit Namen",
        minadminlevel = ADMINRANKS.Eventler
    },
    newgoto = {
        func = "createGoto",
        help = "Speichert einen neuen Ort für /goto in der DB",
        minadminlevel = ADMINRANKS.Eventler
    },
    teachsimulator = {
        func = "teachsimulator",
        help = "Gibts dir ein Menü zum Probeweise LP verteilen",
        minadminlevel = ADMINRANKS.Eventler
    },
    bufftest = {
        func = "bufftest",
        help = "Zeigt eine Bufftextur an (Test)",
        minadminlevel = ADMINRANKS.Spieler
    },
    spawnvob = {
        func = "spawnVob",
        help = "Spawned ein Vob bei dir",
        minadminlevel = ADMINRANKS.Support
    },
    spawnmob = {
        func = "spawnMob",
        help = "Spawned ein Mob bei dir",
        minadminlevel = ADMINRANKS.Support
    },
    wetter = {
        func = "changeWeather",
        help = "Ändert das Wetter",
        minadminlevel = ADMINRANKS.Support
    },
    wurf = {
        func = "roll",
        help = "Würfelt die Angabe (Standard W20)",
        minadminlevel = ADMINRANKS.Spieler
    },
    revive = {
        func = "revive",
        help = "Belebt dich oder ein Ziel (ID/Name) wieder",
        minadminlevel = ADMINRANKS.Eventler
    },
    heal = {
        func = "heal",
        help = "Heilt dich oder ein Ziel (ID/Name) voll",
        minadminlevel = ADMINRANKS.Eventler
    },
    sprint = {
        func = "sprint",
        help = "Aktiviert oder deaktiviert Sprintfunktion (Geschwindigkeitstrank)",
        minadminlevel = ADMINRANKS.Eventler
    },
    itemspawn = {
        func = "createItemSpawn",
        help = "Setzt ein Item als Respawn in die DB und spawned das ding direkt",
        minadminlevel = ADMINRANKS.Support
    },
    showitemspawns = {
        func = "showItemSpawns",
        help = "Zeigt dir alle Itemspawns im Umkreis mit Itemname und Spawn-ID",
        minadminlevel = ADMINRANKS.Support
    },
    deleteitemspawn = {
        func = "deleteItemSpawn",
        help = "Löscht ein Item und den zugehörigen Spawn aus der ID",
        minadminlevel = ADMINRANKS.Support
    },
    showroom = {
        func = "showroom",
        help = "Spawned NPCs mit sämtlichen Rüstungen in einer Reihe vor dir";
        minadminlevel = ADMINRANKS.Support
    },
    changeattribute = {
        func = "changeAttribute",
        help = "Ändert deine eigenen Stats";
        minadminlevel = ADMINRANKS.Spielleiter
    },
    keilschrift = {
        func = "cuneiform",
        help = "Schreibt text in Keilschrift auf den Screen";
        minadminlevel = ADMINRANKS.Admin
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