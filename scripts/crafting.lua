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

function craftMenu(playerid, mobsi)
    local charjob = getJob(playerid);
    
    local character_crafts = {};
    local teaches = DB_select("*", "character_crafts", "characterid = "..PLAYERS[playerid].character);
    for _key, teach in pairs(teaches) do
        character_crafts[tonumber(teach.craftid)] = tonumber(teach.experience);
        debug("storing xp "..tonumber(teach.craftid).. " = "..tonumber(teach.experience));
    end

    local completed = {};
    local researching = {};
    local canResearch = {};

    local crafts = DB_select("crafts.*", "crafts, craft_mobsis", "crafts.mobsiid = craft_mobsis.id AND craft_mobsis.name = '"..mobsi.."'");
    for _key, craft in pairs(crafts) do
        local craftid = tonumber(craft.id);
        local xp = tonumber(craft.experience);
        if (character_crafts[craftid] ~= nil and character_crafts[craftid] >= xp) then
            table.insert(completed, craft);
            debug("completed "..craftid);
        end
        if (character_crafts[craftid] ~= nil and character_crafts[craftid] < xp) then
            table.insert(researching, craft);
            debug("researching "..craftid);
        end
        if (character_crafts[craftid] == nil and (charjob == 0 or charjob == tonumber(craft.jobid))) then
            local allowed = true;
            local requirements = DB_select("craft_requirements.requirementid, crafts.experience", "crafts, craft_requirements", "crafts.id = craft_requirements.id AND craftid = "..craftid);
            for _key, requirement in pairs(requirements) do
                local reqid = tonumber(requirement.requirementid);
                if (character_crafts[reqid] == nil or character_crafts[reqid] < tonumber(requirement.experience)) then
                    allowed = false;
                    debug("missing "..reqid.." for "..craftid);
                end
            end
            if (allowed == true)  then
                table.insert(canResearch, craft);
                debug("allowed "..craftid);
            end
        end
    end

    setupMenu(playerid, true);

    local position = craftAppendList(playerid, completed, 0, "craftChosen", mobsi, "", false);
    position = craftAppendList(playerid, researching, position, "craftChosen", mobsi, "Forschen: ", false);
    position = craftAppendList(playerid, canResearch, position, "learnCraft", mobsi, "Neu: ", true);
end

function craftAppendList(playerid, craftgroup, position, func, mobsi, prefix, showLP)
    local size = 50;
    local start = {x=1100, y=200};
    local text;
    for _key, craft in pairs(craftgroup) do
        column = position %2;
        row = math.floor(position/2);
        text = prefix..craft.name;
        if (showLP) then
            text = text.." ("..tonumber(craft.lp).." LP)";
        end
        createClickableTexture(playerid, craft.graphic, start.x+column*8*size, start.y+row*size, size, size,
            func, {mobsi=mobsi, recipe=craft.id});
        createButton(playerid, text, start.x+(8*column+1)*size, start.y+row*size+7, size*7, size, 255, 255, 255,
            func, {mobsi=mobsi, recipe=craft.id});
        position = position +1;
    end
    return position;
end

function craftChosen(playerid, args)
    craftMenu(playerid, args.mobsi);

    local crafts = DB_select(
        "crafts.name, crafts.graphic, character_crafts.experience AS xpgained, crafts.experience AS xptotal, crafts.crafttime, character_crafts.amount",
        "crafts, character_crafts",
        "crafts.id = character_crafts.craftid AND crafts.id = "..args.recipe
    );
    local data;
    for _key, craft in pairs(crafts) do
        data = craft;
    end

    if (data == nil) then
        sendERRMessage(playerid, "Du willst ein Rezept anzeigen, was du nicht kannst. Melde diesen Bug bitte dem Team");
        return;
    end

    local start = {x=700, y=600};
    local size = 40;

    local duration = tonumber(data.crafttime);
    local xpgained = tonumber(data.xpgained);
    local xptotal = tonumber(data.xptotal);
    local percent = xpgained/xptotal*100;

    if (xpgained < xptotal) then
        createClickableTexture(playerid, data.graphic, start.x, start.y-(size*10), size*10, size*10, "craftChosen", args);
        createPlaintext(playerid, "Forschung: "..data.name, start.x+25, start.y-(size*10)+25, 255, 255, 255);
        createClickableTexture(playerid, SERVERDRAWS.craftingbackground.graphic, 710, 550, 380, 32, "craftChosen", args);
        createClickableTexture(playerid, "Data\\Textures\\BAR_XP.tga", 725, 558, math.floor(percent*351/100), 16, "craftChosen", args);
        createPlaintext(playerid, math.floor(percent).."%", 877, 552, 255, 255, 255);
    else
        createPlaintext(playerid, data.name, start.x+25, 225, 255, 255, 255);
        createClickableTexture(playerid, data.graphic, start.x, start.y-(size*10), size*10, size*10, "craft", {name=data.name, recipe=args.recipe, duration=duration, mobsi=args.mobsi});
    end
    
    local row = 0;
    local r, g, b;
    local ingredients = DB_select(
        "items.id, items.name, items.graphic, craft_ingredients.amount",
        "crafts, craft_ingredients, items",
        "crafts.id = craft_ingredients.craftid AND craft_ingredients.itemid = items.id AND crafts.id = "..args.recipe);
    for _key, ingredient in pairs(ingredients) do
        local available = 0;
        local required = tonumber(ingredient.amount);
        local items = DB_select(
            "*",
            "character_inventory",
            "characterid = "..PLAYERS[playerid].character.." AND itemid = "..ingredient.id);
        for _key, item in pairs(items) do
            available = tonumber(item.amount);
        end

        local text = ingredient.name..": "..available.." / "..ingredient.amount;
        local func = "craft";
        local func_args = {recipe=args.recipe, ingredient=tonumber(ingredient.id), mobsi=args.mobsi};

        if (xpgained < xptotal) then
            required = 1;
            text = "Forschen: "..ingredient.name;
            func = "research";
        end

        if (available < required) then
            r, g, b = 196, 30, 58;
        else
            r, g, b = 0, 255, 152;
        end

        createClickableTexture(playerid, ingredient.graphic, start.x, start.y+size*row, size, size, func, func_args);
        createButton(playerid, text, start.x+size, start.y+size*row, size*9, size, r, g, b, func, func_args);
        row = row + 1;
    end
end

function craft(playerid, args)
    local crafts = DB_select("*", "crafts", "crafts.id = "..args.recipe);
    local data;
    for _key, craft in pairs(crafts) do
        data = craft;
    end
    if (data == nil) or (hasAllIngredients(playerid, args.recipe) == false) then
        sendERRMessage(playerid, "Du hast nicht alles bei dir.");
        craftChosen(playerid, args)
        return;
    end
    craftingStart(playerid, data.name, data.crafttime, "craftCreated", args, nil);
end

function research(playerid, args)
    local crafts = DB_select("*", "crafts", "id = "..args.recipe);
    local data;
    for _key, craft in pairs(crafts) do
        data = craft;
    end
    if (data == nil) or (hasIngredient(playerid, args.ingredient) == false) then
        sendERRMessage(playerid, "Du hast nicht alles bei dir.");
        craftChosen(playerid, args);
        return;
    end
    craftingStart(playerid, "Forschen an "..data.name, data.crafttime, "researchDone", args, nil);
end

function hasAllIngredients(playerid, recipeid)
    local crafts = DB_select("*", "crafts", "crafts.id = "..recipeid);
    local data;
    for _key, craft in pairs(crafts) do
        data = craft;
    end
    if (data == nil) then
        return false;
    end

    local ingredients = DB_select(
        "items.id, items.name, items.graphic, craft_ingredients.amount",
        "crafts, craft_ingredients, items",
        "crafts.id = craft_ingredients.craftid AND craft_ingredients.itemid = items.id AND crafts.id = "..recipeid);
    for _key, ingredient in pairs(ingredients) do
        local available = 0;
        local required = tonumber(ingredient.amount);
        local items = DB_select(
            "*",
            "character_inventory",
            "characterid = "..PLAYERS[playerid].character.." AND itemid = "..ingredient.id);
        for _key, item in pairs(items) do
            available = tonumber(item.amount);
        end
        if available < required then
            return false;
        end
    end
    return true;
end

function hasIngredient(playerid, ingredientid)
    local items = DB_select(
        "*",
        "character_inventory",
        "characterid = "..PLAYERS[playerid].character.." AND itemid = "..ingredientid);
    for _key, item in pairs(items) do
        if (tonumber(item.amount) > 0) then
            return true;
        end
    end
    return false;
end

function craftCreated(playerid)
    local args = PLAYERS[playerid].working.options;
    if hasAllIngredients(playerid, args.recipe) == false then
        sendERRMessage(playerid, "Du hast nicht alle Zutaten bei dir");
        craftChosen(playerid, args);
        return;
    end
    local xpgained = 0;
    local ingredients = DB_select(
        "craft_ingredients.itemid, craft_ingredients.amount, items.value as experience",
        "items, craft_ingredients",
        "items.id = craft_ingredients.itemid AND craft_ingredients.craftid = "..args.recipe);
    for _key, ingredient in pairs(ingredients) do
        RemoveItemById(playerid, tonumber(ingredient.itemid), tonumber(ingredient.amount));
        xpgained = xpgained + tonumber(ingredient.experience);
    end
    local results = DB_select("*", "craft_results", "craftid = "..args.recipe);
    for _key, result in pairs(results) do
        GiveItemById(playerid, tonumber(result.itemid), tonumber(result.amount));
    end
    local charcrafts = DB_select("*", "character_crafts", "craftid = "..args.recipe);
    for _key, charcraft in pairs(charcrafts) do
        DB_update("character_crafts", {experience=tonumber(charcraft.experience)+xpgained, amount=tonumber(charcraft.amount)+1}, "craftid = "..args.recipe.." AND characterid = "..PLAYERS[playerid].character);
    end
    craftChosen(playerid, args);
end

function researchDone(playerid)
    local args = PLAYERS[playerid].working.options;
    
    local xpgained = 0;
    local ingredients = DB_select(
        "craft_ingredients.itemid, craft_ingredients.amount, items.value as experience",
        "items, craft_ingredients",
        "items.id = craft_ingredients.itemid AND craft_ingredients.craftid = "..args.recipe.. " AND craft_ingredients.itemid = "..args.ingredient);
    for _key, ingredient in pairs(ingredients) do
        RemoveItemById(playerid, tonumber(ingredient.itemid), 1);
        xpgained = xpgained + tonumber(ingredient.experience);
    end
    local charcrafts = DB_select("*", "character_crafts", "craftid = "..args.recipe);
    for _key, charcraft in pairs(charcrafts) do
        DB_update("character_crafts", {experience=tonumber(charcraft.experience)+xpgained}, "craftid = "..args.recipe.." AND characterid = "..PLAYERS[playerid].character)
    end
    craftChosen(playerid, args);
end

function learnCraft(playerid, args)
    local name = "";
    local lp = 0;
    local job = "Taugenichts";
    local responses = DB_select("crafts.name as name, jobs.name as job, crafts.lp", "crafts, jobs", "jobs.id = crafts.jobid AND crafts.id = "..args.recipe);
    for _key, response in pairs(responses) do
        name = response.name;
        job = response.job;
        lp = tonumber(response.lp);
    end
    setupMenu(playerid);

    createText(playerid, "'"..name.."' zu erforschen verbraucht "..lp.." Lernpunkte.", 600, 300, 720, 37, 255, 255, 255);
    createText(playerid, "Diese Forschung kann nur ein "..job.. " durchführen.", 600, 337, 720, 37, 255, 255, 255);
    createText(playerid, "Möchtest du die Forschung starten?", 600, 374, 720, 37, 255, 255, 255);

    createButton(playerid, "-------- Ja --------", 600, 411, 360, 37, 255, 255, 255, "acceptLearning", args);
    createButton(playerid, "------- Nein -------", 960, 411, 360, 37, 255, 255, 255, "declineLearning", {mobsi=args.mobsi});
end

function acceptLearning(playerid, args)
    local name = "";
    local lpcost = 0;
    local job = "Taugenichts";
    local jobid = 0;
    local crafts = DB_select("crafts.name as name, jobs.name as job, jobs.id as jobid, crafts.lp", "crafts, jobs", "jobs.id = crafts.jobid AND crafts.id = "..args.recipe);
    for _key, craft in pairs(crafts) do
        name = craft.name;
        job = craft.job;
        jobid = tonumber(craft.jobid);
        lpcost = tonumber(craft.lp);
    end

    local lp = 0;
    local characters = DB_select("*", "character_stats", "characterid = "..PLAYERS[playerid].character)
    for _key, character in pairs(characters) do
        lp = tonumber(character.lp);
    end

    if (lp < lpcost) then
        sendERRMessage(playerid, "Du hast keine "..lpcost.." Lernpunkte.");
        craftMenu(playerid, args.mobsi);
        return;
    end
    DB_update("character_stats", {lp = lp-lpcost}, "characterid = "..PLAYERS[playerid].character);
    SetPlayerLearnPoints(playerid, lp-lpcost);
    DB_update("character_jobs", {jobid = jobid}, "characterid = "..PLAYERS[playerid].character);
    DB_insert("character_crafts", {characterid = PLAYERS[playerid].character, craftid = args.recipe});
    PlaySound(playerid, LEVELUPSOUND);
    craftChosen(playerid, args);
end

function declineLearning(playerid, args)
    craftMenu(playerid, args.mobsi);
end

function createJobs(playerid)
    local characterjobid = DB_insert("character_jobs", {characterid=PLAYERS[playerid].character});
    if (characterjobid < 0) then
        sendERRMessage(playerid, "Charakter Berufzuweisung fehlgeschlagen.");
        return;
    end
end

function getJob(playerid)
    local jobid = 0;
    local jobs = DB_select("*", "character_jobs", "characterid = "..PLAYERS[playerid].character);
    for _key, job in pairs(jobs) do
        charjob = tonumber(job.jobid);
    end
    return jobid;
end