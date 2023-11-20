function huntingCheck(playerid)
    debug("hunting check");
    local focusid = GetFocus(playerid);
    if NPCS[focusid] == nil then
        return;
    end
    if GetPlayerHealth(focusid) > 0 then
        sendERRMessage(playerid, "Lebend hätte dein Ziel wohl etwas dagegen...");
        return;
    end
    huntingMenu(playerid, focusid);
end

function huntingMenu(playerid, npcid)
    local hunter = isHunter(playerid);

    local items, teaches;
    
    setupMenu(playerid, true);
    local size = 275;
    local start = {x=270, y=400};
    local column = 0;

    for _key, loot in pairs (NPCS[npcid].loot) do
        items = DB_select("*", "items", "id = "..loot.itemid);
        for _key, item in pairs(items) do
            createPlaintext(playerid, loot.amount.."x "..item.name, 10+start.x+size*column, 10+start.y, 255,255,255);
            createClickableTexture(playerid, item.graphic, start.x+column*size, start.y, size, size,
                "hunting", {npcid = npcid, amount = tonumber(loot.amount), itemname=item.name, itemid = tonumber(item.id), instance = item.instance});
            column = column+1;
        end
        --- bar: 256x32
    end
end

function huntingChosen(playerid, args)
    if (args.debug == 1) then
        sendERRMessage(playerid, "Geklickt");
        huntingMenu(playerid);
        return;
    end
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
    createClickableTexture(playerid, args.graphic, 700, 200, 400, 400, "craft", {name=args.name, recipe=args.recipe, duration=args.duration, mobsi=args.mobsi});
end

function hunting(playerid, args)
    debug("hunt started");
    --amount = tonumber(loot.amount), item=item.name, itemid = tonumber(item.id), instance = item.instance}
    local duration = 10000;
    craftingStart(playerid, args.itemname, duration, "huntingCreated", {npcid = args.npcid, amount = args.amount, itemname=args.name, itemid = args.itemid, instance = args.instance}, nil);
end

function huntingCreated(playerid)
    local args = PLAYERS[playerid].working.options;
    for key, value in pairs (args) do
        debug(value);
    end
    local amount = 0;
    debug("hunt complete");
    GiveItem(playerid, args.instance, 1);
    for key, loot in pairs (NPCS[args.npcid].loot) do
        if (loot.itemid == args.id) then
            NPCS[args.npcid][key].amount = NPCS[args.npcid][key].amount - 1;
            if (NPCS[args.npcid][key].amount < 1) then
                table.remove(NPCS[args.npcid], key);
                huntingMenu(playerid, npcid)
            else
                hunting(playerid, args);
            end
            return;
        end
    end
end

function isHunter(playerid)
    local responses = DB_select("*", "characters, jobs, character_jobs", "jobs.name = 'Jäger' AND characters.id = character_jobs.characterid AND jobs.id = character_jobs.jobid AND characters.id ="..PLAYERS[playerid].character);
    for _key, _value in pairs(responses) do
        return true;
    end
    return false;
end

function setHunter(playerid)

end