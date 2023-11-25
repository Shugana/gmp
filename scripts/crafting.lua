function CraftingLoop()
    for playerid, playerdata in pairs(PLAYERS) do
        if (playerdata.working ~= nil) then
            craftingTick(playerid);
        end
    end
end

function craftingStart(playerid, name, duration, finishFunc, options, animation)
    freeze(playerid, "crafting");
    duration = math.max(duration, 1);
    if not(canWork(playerid)) then
        sendERRMessage(playerid, "Du bist gerade nicht fit genug, um zu arbeiten.");
        return;
    end
    local totalticks = math.ceil(duration/100);
    local totaltime = totalticks/10;
    PLAYERS[playerid].working = {
        duration = totalticks,
        progress = 0,
        progressbar = nil,
        finishFunc = finishFunc,
        options = options,
        animation = animation
    };
    ShowTexture(playerid, SERVERDRAWS.craftingbackground.id);
    sendINFOMessage(playerid, "Du hast begonnen mit "..name..", dafür wirst du ca. "..totaltime.." Sekunden brauchen.")
end

function craftingTick(playerid);
    PLAYERS[playerid].working.progress = PLAYERS[playerid].working.progress + 1;
    if (PLAYERS[playerid].working.progressbar ~= nil) then
        DestroyTexture(PLAYERS[playerid].working.progressbar);
    end
    local updatelength = math.floor(PLAYERS[playerid].working.progress/PLAYERS[playerid].working.duration*1000);
    PLAYERS[playerid].working.progressbar = CreateTexture(
        SERVERDRAWS.craftingbar.pos.x,
        SERVERDRAWS.craftingbar.pos.y,
        SERVERDRAWS.craftingbar.size.x+updatelength,
        SERVERDRAWS.craftingbar.size.y,
        SERVERDRAWS.craftingbar.graphic
    );
    if (PLAYERS[playerid].working.animation ~= nil) then
        PlayAnimation(playerid, PLAYERS[playerid].working.animation);
    end
    ShowTexture(playerid, PLAYERS[playerid].working.progressbar);
    if (PLAYERS[playerid].working.progress >= PLAYERS[playerid].working.duration) then
        craftingFinish(playerid);
    end
end

function craftingFinish(playerid)
    _G[PLAYERS[playerid].working.finishFunc](playerid);
    craftingStop(playerid);
end    

function craftingStop(playerid)
    if PLAYERS[playerid].working == nil then
        return;
    end
    local next = PLAYERS[playerid].working.next;
    HideTexture(playerid, SERVERDRAWS.craftingbackground.id);
    if (PLAYERS[playerid].working.progressbar ~= nil) then
        DestroyTexture(PLAYERS[playerid].working.progressbar);
    end
    PLAYERS[playerid].working = nil;
    unfreeze(playerid, "crafting");
    if next ~= nil then
        _G[next.func](playerid, next.args);
    end
end

function canWork(playerid)
    if (PLAYERS[playerid].working ~= nil) then
        return false;
    end
    return true; -- for now... later: check hunger, check illness, etc.
end

function createJobs(playerid)
    local characterjobid = DB_insert("character_jobs", {characterid=PLAYERS[playerid].character});
    if (characterjobid < 0) then
        sendERRMessage(playerid, "Charakter Berufzuweisung fehlgeschlagen.");
        return;
    end
end

function craftMenu(playerid, mobsi)
    setupMenu(playerid, true);
    local size = 50;
    local start = {x=1100, y=200};

    local column = 0;
    local row = 0;

    local responses = DB_select(
        "crafts.id AS id, items.instance, items.graphic, crafts.name, crafts.crafttime",
        "characters, character_crafts, crafts, craft_results, craft_mobsis, items",
        "characters.id = character_crafts.characterid AND character_crafts.craftid = crafts.id AND crafts.id = craft_results.craftid "..
        "AND craft_results.itemid = items.id AND characters.id = "..PLAYERS[playerid].character.. " AND craft_mobsis.id = crafts.mobsiid AND craft_mobsis.name = '"..mobsi.."'"
    );
    for _key, response in pairs(responses) do
        createClickableTexture(playerid, response.graphic, start.x+column*8*size, start.y+row*size, size, size,
            "craftChosen", {mobsi=mobsi,recipe=response.id, name=response.name, graphic=response.graphic, duration=response.crafttime});
        createButton(playerid, response.name, start.x+(8*column+1)*size, start.y+row*size+7, size*7, size, 255, 255, 255,
            "craftChosen", {mobsi=mobsi,recipe=response.id, name=response.name, graphic=response.graphic, duration=response.crafttime});
        column = column + 1;
        if column > 1 then
            column = 0;
            row = row + 1;
        end
    end
end

function craftChosen(playerid, args)
    local size = 40;
    local start = {x=700, y=600};
    local row = 0;
    local r, g, b;
    craftMenu(playerid, args.mobsi);
    createPlaintext(playerid, args.name, start.x+25, 225, 255, 255, 255);
    local ingredients = DB_select(
        "items.id, items.name, items.graphic, craft_ingredients.amount",
        "crafts, craft_ingredients, items",
        "crafts.id = craft_ingredients.craftid AND craft_ingredients.itemid = items.id AND crafts.id = "..args.recipe);
    for _key, ingredient in pairs(ingredients) do
        local available = 0;
        local items = DB_select(
            "*",
            "character_inventory",
            "characterid = "..PLAYERS[playerid].character.." AND itemid = "..ingredient.id);
        for _key, item in pairs(items) do
            available = tonumber(item.amount);
        end
        if (available < tonumber(ingredient.amount)) then
            r, g, b = 196, 30, 58;
        else
            r, g, b = 0, 255, 152;
        end
        createClickableTexture(playerid, ingredient.graphic, start.x, start.y+size*row, size, size,
            "craft", {name=args.name, recipe=args.recipe, duration=args.duration, mobsi=args.mobsi});
        createText(playerid, ingredient.name..": "..available.." / "..ingredient.amount, start.x+size, start.y+size*row, 400-size, size, r, g, b);
        row = row + 1;
    end


    local percent = 100;


    createClickableTexture(playerid, args.graphic, 700, 200, 400, 400, "craft", {name=args.name, recipe=args.recipe, duration=args.duration, mobsi=args.mobsi});
    createClickableTexture(playerid, SERVERDRAWS.craftingbackground.graphic, 710, 550, 380, 32, "craft", {name=args.name, recipe=args.recipe, duration=args.duration, mobsi=args.mobsi});
    createClickableTexture(playerid, "Data\\Textures\\BAR_XP.tga", 725, 558, math.floor(351/percent*100), 16, "craft", {name=args.name, recipe=args.recipe, duration=args.duration, mobsi=args.mobsi});
    createPlaintext(playerid, math.floor(percent).."%", 877, 552, 255, 255, 255);
end

function craft(playerid, args)
    craftingStart(playerid, args.name, args.duration, "craftCreated", {name=args.name, recipe=args.recipe, mobsi=args.mobsi}, nil);
end

function craftCreated(playerid)
    sendERRMessage(playerid, "Test. Noch keine Items ("..PLAYERS[playerid].working.options.name.." ("..PLAYERS[playerid].working.options.recipe..")) erstellt und auch kein Material verbraucht.");
    craftMenu(playerid, PLAYERS[playerid].working.options.mobsi);
end