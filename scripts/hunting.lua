function huntingMenu(playerid)
    debug("hunting check");
    local focusid = GetFocus(playerid);
    if NPCS[focusid] == nil then
        return;
    end
    --setupMenu(playerid, true);
    local size = 250;
    local start = {x=300, y=300};

    local column = 0;

    local hunter = isHunter(playerid);

    -- loop through loot here
    -- check for teach
    -- show button
    -- show progress bar
    -- not learned -> give learn button
    -- learned --> craft

    for _key, loot in pairs (NPCS[focusid].loot) do
        debug(loot.itemid);
        debug(loot.trophy);
        debug(loot.amount);
    end

    --local responses = DB_select(
    --    "crafts.id AS id, items.instance, items.graphic, crafts.name, crafts.crafttime",
    --    "characters, character_crafts, crafts, craft_results, items",
    --    "characters.id = character_crafts.characterid AND character_crafts.craftid = crafts.id AND crafts.id = craft_results.craftid "..
    --    "AND craft_results.itemid = items.id AND characters.id = "..PLAYERS[playerid].character
    --);
    --for _key, response in pairs(responses) do
    --    createClickableTexture(playerid, response.graphic, start.x+column*8*size, start.y, size, size,
    --        "craftChosen", {mobsi="mobsi",recipe=response.id, name=response.name, graphic=response.graphic, duration=response.crafttime});
    --    createButton(playerid, response.name, start.x+(8*column+1)*size, start.y, size*7, size, 255, 255, 255,
    --        "craftChosen", {mobsi="mobsi",recipe=response.id, name=response.name, graphic=response.graphic, duration=response.crafttime});
    --    column = column + 1;
    --end
end

function huntingChosen(playerid, args)
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
    craftingStart(playerid, args.name, args.duration, "craftCreated", {name=args.name, recipe=args.recipe}, nil);
end

function huntingCreated(playerid)
    sendERRMessage(playerid, "Test. Noch keine Items ("..PLAYERS[playerid].working.options.name.." ("..PLAYERS[playerid].working.options.recipe..")) erstellt und auch kein Material verbraucht.");
    craftMenu(playerid, PLAYERS[playerid].working.options.mobsi);
end

function isHunter(playerid)
    local responses = DB_select("*", "characters, jobs, character_jobs", "jobs.name = 'Jäger' AND characters.id = character_jobs.characterid AND jobs.id = character_jobs.jobid AND characters.id ="..PLAYERS[playerid].character);
    for _key, _value in pair(responses) do
        return true;
    end
    return false;
end

function setHunter(playerid)

end