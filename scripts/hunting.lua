function huntingCheck(playerid)
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

    local icons = 1;
    local nontrophy = false;

    for _key, loot in pairs (NPCS[npcid].loot) do
        if (loot.trophy == 0 and nontrophy == false) then
            nontrophy = true;
            icons = icons + 1;
        else
            icons = icons + 1;
        end
    end

    setupMenu(playerid, true);
    local size = 270;
    local start = {x=math.ceil((1920-(icons*size))/2), y=350};
    local column = 0;

    createPlaintext(playerid, "Alles nehmen", 10+start.x+size*column, 10+start.y, 255,255,255);
    createClickableTexture(playerid, "FLUFF_HUNTERICON.TGA", start.x+column*size, start.y, size, size,
        "hunting", {npcid = npcid, all=true});
    column = column+1;

    for _key, loot in pairs (NPCS[npcid].loot) do
        if loot.trophy == 1 then
            items = DB_select("*", "items", "id = "..loot.itemid);
            for _key, item in pairs(items) do
                createPlaintext(playerid, loot.amount.."x "..item.name, 10+start.x+size*column, 10+start.y, 255,255,255);
                createClickableTexture(playerid, item.graphic, start.x+column*size, start.y, size, size,
                    "hunting", {npcid = npcid, amount = tonumber(loot.amount), itemname=item.name, itemid = tonumber(item.id), instance = item.instance, all=false});
                column = column+1;
            end
        end
        --- bar: 256x32
    end
    if (nontrophy) then    
        createPlaintext(playerid, "Durchsuchen", 10+start.x+size*column, 10+start.y, 255,255,255);
        createClickableTexture(playerid, "FLUFF_BAGICON.TGA", start.x+column*size, start.y, size, size,
            "hunting", {npcid = npcid, plunder=true});
        column = column+1;
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
    local duration = 5000;
    if GetDistancePlayers(playerid, args.npcid) > 500 then
        sendERRMessage(playerid, "Dafür bist du zu weit weg.");
        return;
    end
    if (args.all) then
        duration = 4500; -- get duration of first item available
        for key, loot in pairs (NPCS[args.npcid].loot) do
            if (loot.trophy == 1) then
                local items = DB_select("*", "items", "id = "..loot.itemid);
                for _key, item in pairs(items) do
                    craftingStart(
                        playerid,
                        "Alles: ("..item.name..")",
                        duration,
                        "huntingCreated",
                        {all = true, npcid = args.npcid, amount = tonumber(loot.amount), itemname=item.name, itemid = tonumber(item.id), instance = item.instance},
                        "T_PLUNDER");
                    return;
                end
            end
        end
        return;
    end
    if (args.plunder == true) then
        duration = 7800;
        craftingStart(playerid, "Dursuchen", duration, "plunderNPC", args, "T_PLUNDER");
        return;
    end
    craftingStart(playerid, "Test "..args.itemname..(" (2.5s)"), duration, "huntingCreated", args, "T_PLUNDER");
end

function huntingCreated(playerid)
    local args = PLAYERS[playerid].working.options;
    local amount = 0;
    GiveItem(playerid, args.instance, 1);
    for key, loot in pairs (NPCS[args.npcid].loot) do
        if (loot.itemid == args.itemid) then
            NPCS[args.npcid].loot[key].amount = NPCS[args.npcid].loot[key].amount - 1;
            if (NPCS[args.npcid].loot[key].amount < 1) then
                GiveItemById(playerid, loot.itemid, 1);
                table.remove(NPCS[args.npcid].loot, key);
                huntingMenu(playerid, args.npcid);
            else
                PLAYERS[playerid].working.next = {func = "hunting", args=args};
            end
            return;
        end
    end
end

function plunderNPC(playerid, npcid)
    for key, loot in pairs (NPCS[args.npcid].loot) do
        if (loot.trophy == 0) then
            GiveItemById(playerid, loot.itemid, loot.amount);
            table.remove(NPCS[args.npcid].loot, key);
            plunderNPC(playerid, npcid);
            return;
        end
    end
    huntingMenu(playerid, args.npcid);
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