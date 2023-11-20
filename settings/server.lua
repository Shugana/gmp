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

    Mob.Create(
        "LAB_PSI.ASC",
        "mobsiname",
        OCMOBINTER,
        "LAB",
        "",
        "NEWWORLD\\KHORINIS.ZEN",
        -876,
        -166,
        -4251,
        "Strandlabor"
    );

end

function OnPlayerTriggerMob(playerid, scheme, objectName, trigger)
    --debug("Triggered Mobsi - playerid: "..playerid..", scheme: "..scheme..", objectName: "..objectName..", trigger: "..trigger);
    if (trigger == 1) then
        freeze(playerid, "mobsi");
        craftMenu(playerid, scheme);
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
    if (keyDown == KEY_F3) then
        huntingCheck(playerid);
    end
end

function updateGametimeDraw(hour, minute)
    hour = string.format("%02d", hour);
    minute = string.format("%02d", minute)
    local rltime = os.date("%H:%M");
    SetDrawText(SERVERDRAWS.time.id, "IG: "..hour..":"..minute.." Uhr || RL: "..rltime.." Uhr");
end