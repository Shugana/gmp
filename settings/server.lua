SERVERDRAWS = {
    time = {
        id = nil,
        pos = {x=130, y=7400},
        color = {r=255,g=255,b=255}
    },
    craftingbackground = {
        id = nil,
        pos = {x=3450, y=7850},
        size = {x=4550, y=8050},
        graphic = "Data\\Textures\\Desktop\\nomip\\Bar_Back.tga"
    },
    craftingbar = {
        id = nil,
        pos = {x=3500, y=7875},
        size = {x=3500, y=8025},
        graphic = "Data\\Textures\\Desktop\\nomip\\Bar_Misc.tga"
    },
    weather = {
        id = nil,
        pos = {x=130, y=7600},
        color = {r=255,g=255,b=0}
    }
}

SPAWNTICKS = {
    items = 0,
    itemsmax = 30,
    monsters = 0,
    monstersmax = 180
};

function initServerdraws()
    SERVERDRAWS.time.id = CreateDraw(
        SERVERDRAWS.time.pos.x,
        SERVERDRAWS.time.pos.y,
        "IG: 00:00 Uhr || RL: 00:00 Uhr",
        FONTS.sequel,
        SERVERDRAWS.time.color.r,
        SERVERDRAWS.time.color.g,
        SERVERDRAWS.time.color.b
    );
    SERVERDRAWS.craftingbackground.id = CreateTexture(
        SERVERDRAWS.craftingbackground.pos.x,
        SERVERDRAWS.craftingbackground.pos.y,
        SERVERDRAWS.craftingbackground.size.x,
        SERVERDRAWS.craftingbackground.size.y,
        SERVERDRAWS.craftingbackground.graphic
    );
    SERVERDRAWS.weather.id = CreateDraw(
        SERVERDRAWS.weather.pos.x,
        SERVERDRAWS.weather.pos.y,
        "Wetter Platzhalter",
        FONTS.sequel,
        SERVERDRAWS.weather.color.r,
        SERVERDRAWS.weather.color.g,
        SERVERDRAWS.weather.color.b
    );
end

function OnPlayerTriggerMob(playerid, scheme, objectName, trigger)
    --debug("Triggered Mobsi - playerid: "..playerid..", scheme: "..scheme..", objectName: "..objectName..", trigger: "..trigger);
    if (trigger == 1) then
        freeze(playerid, "mobsi");
        local responses = DB_select("*", "craft_mobsis", "name = '"..scheme.."'");
        for _key, _value in pairs(responses) do
            craftMenu(playerid, scheme);
            return;
        end
        --- here non workmobsis
    end
end

function OnPlayerKey(playerid, keyDown, keyUp)
    if (keyDown == KEY_BACK or keyDown == KEY_S) 
            and PLAYERS[playerid] ~= nil
            and PLAYERS[playerid].freezes ~= nil then
        if PLAYERS[playerid].freezes.mobsi ~= nil then
            clearMenu(playerid);
            unfreeze(playerid, "mobsi");

        end
        if PLAYERS[playerid].freezes.crafting ~= nil then
            clearMenu(playerid);
            craftingStop(playerid);
            unfreeze(playerid, "crafting");
        end
    end
    if (keyDown == KEY_BACK or keyDown == KEY_S) 
        and PLAYERS[playerid] ~= nil
        and PLAYERS[playerid].freezes ~= nil
        and PLAYERS[playerid].freezes.cr == "mobsi" then
    craftingStop(playerid);
    clearMenu(playerid);
    unfreeze(playerid, "mobsi");
    end
    if (keyDown == KEY_NUMPAD0) then
        callNumpad(playerid, 0);
    end
    if (keyDown == KEY_NUMPAD1) then
        callNumpad(playerid, 1);
    end
    if (keyDown == KEY_NUMPAD2) then
        callNumpad(playerid, 2);
    end
    if (keyDown == KEY_NUMPAD3) then
        callNumpad(playerid, 3);
    end
    if (keyDown == KEY_NUMPAD4) then
        callNumpad(playerid, 4);
    end
    if (keyDown == KEY_NUMPAD5) then
        callNumpad(playerid, 5);
    end
    if (keyDown == KEY_NUMPAD6) then
        callNumpad(playerid, 6);
    end
    if (keyDown == KEY_NUMPAD7) then
        callNumpad(playerid, 7);
    end
    if (keyDown == KEY_NUMPAD8) then
        callNumpad(playerid, 8);
    end
    if (keyDown == KEY_NUMPAD9) then
        callNumpad(playerid, 9);
    end
end

function updateGametimeDraw(hour, minute)
    hour = string.format("%02d", hour);
    minute = string.format("%02d", minute)
    local rltime = os.date("%H:%M");
    SetDrawText(SERVERDRAWS.time.id, "IG: "..hour..":"..minute.." Uhr || RL: "..rltime.." Uhr");
end

function spawnMob(playerid, params)
    local result, asc, scheme = sscanf(params, "ss");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /spawnMob <ASC> <Scheme>");
        return;
    end
    local x,y,z = GetPlayerPos(playerid);
    local world = GetPlayerWorld(playerid);
    Mob.Create(
        asc,
        "mobsiname",
        OCMOBINTER,
        scheme,
        "",
        world,
        x,
        y,
        z,
        "Placeholder"
    );
end

function spawnVob(playerid, params)
    local result, asc = sscanf(params, "s");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /spawnVob <3DS>");
        return;
    end
    local x,y,z = GetPlayerPos(playerid);
    local world = GetPlayerWorld(playerid);
    Vob.Create(asc, world, x, y, z);
end