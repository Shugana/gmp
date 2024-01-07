SEXES = {"male", "female"};
TORSOS = {
    male = {"HUM_BODY_NAKED0"},
    female = {"HUM_BODY_BABE0"}
};
TORSOSKINS = {
    male = {1,2,3,8,9,10,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,39,40,41,70,71,72,77,78,79,80,81,82,83,84,85,86,87,88,89,90,
        91,93,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,
        133,134,135,136,137,138,139,140,141,142,143,144,145,146,148},
    female = {4,5,6,7,11,12,37,38,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,73,74,75,76,92,117,147}
};
HEADS = {
    ---male = {"HUM_HEAD_PONY","HUM_HEAD_PSIONIC","HUM_HEAD_FATBALD","HUM_HEAD_BALD","HUM_HEAD_THIEF","HUM_HEAD_FIGHTER","HUM_HEAD_BART",
    --    "HUM_HEAD_BART2","HUM_HEAD_LANGEHAARE","HUM_HEAD_KOTELETTEN","HUM_HEAD_Piratfighter","HUM_HEAD_PIRATBALD","HUM_HEAD_PIRATFATBALD","HUM_HEAD_LUTTER",
    --    "HUM_HEAD_BART2CLEAN", "HUM_HEAD_BART2LONG","HUM_HEAD_BARTGOATEE","HUM_HEAD_NECKBEARD","HUM_HEAD_SCHNAUTZER1","HUM_HEAD_SCHNAUTZER2",
    --    "HUM_HEAD_SCHNAUTZER3", "HUM_HEAD_ZIEGENBART"},
    male = {"HUM_HEAD_PONY","HUM_HEAD_PSIONIC","HUM_HEAD_FATBALD","HUM_HEAD_BALD","HUM_HEAD_THIEF","HUM_HEAD_FIGHTER"},
    female = {"HUM_HEAD_BABE","HUM_HEAD_BABE1","HUM_HEAD_BABE2","HUM_HEAD_BABE3","HUM_HEAD_BABE4","HUM_HEAD_BABE5","HUM_HEAD_BABE6","HUM_HEAD_BABE7",
        "HUM_HEAD_BABE8","HUM_HEAD_BABE9", "HUM_HEAD_BABE12"}
};
HEADSKINS = {
    male = {1,2,3,5,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,
        55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,
        103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,159,160,161,
        163,164,165,166,167,168,169,170,173,174,175,176,177,178,179,180,181,183,184,185,186,187,188,191,195,196,197,198,199,203,204,205,206,207,209,210,211,
        212,213,214,215,216,217,218,223,224,225,226,227,228,229,231,232,233,234,235,236,238,239,240,241,246,247,248,249,250,251,252,253,255,256,257,258,259,
        261,262,263,264,265,266,267,268,269,270,271,272,273,274,275,276,277,278,279,280,281,282,283,284,285,286,287,288,289,290,291,292,293,294,295,296,297,
        298,299,300,301,302,303,304,305,306,307,308,309,310,311,312,313,314,315,316,317,318,319,320,321,322,324,325,326,327,328,329,330,333,334,336,337,338,
        339,341,342,344,345,346,347,348,349,350,352,353,355,356,357,361,362,363,364,365,366,367,368,369,370,371,372,373,374,375,376,377,378,379,380,381,382,
        383,384,385,386,387,388,389,390,391,392,393,394,395,396,397,398,399,400,401,402,403,404,405,406,407,408,411,412,413,414,415,416,417,418,419,420,421,
        422,423,424,425,426,427,428,429,430,431,432,433,2177,2178,2179,2180,2181,2182,2183,2184,2185,2186,2188,2189,2190,2191,2192,2193,2194,2195,2196,2197,
        2198,2199,2200,2202,2203,2204,2206,2207,2208,2209,2210,2211,2212,2213,2215,2216,2217,2218,2219,2220,2222,2223,2224,2225,2226,2227
        },
    female = {137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,171,182,189,192,193,194,200,201,202,208,230,243,244,245,
        323,331,332,335,340,343,354,358,359,360,409,410,2187,2201,2205,2214,2221}
};

function setupFacechange(playerid)
    if PLAYERS[playerid].character == nil then
        sendERRMessage(playerid, "Du musst auf einem Charakter sein");
    end
    local chardata = {};
    local response = DB_select("*", "characters", "id = "..PLAYERS[playerid].character);
    for _, character in pairs(response) do
        chardata = {
            id = tonumber(character.id),
            sex = character.sex,
            torso = character.torso,
            torsoskin = tonumber(character.torsoskin),
            head = character.head,
            headskin = tonumber(character.headskin),
            fatness = tonumber(character.fatness)
        };
    end

    if chardata.id == nil then
        return;
    end

    SetPlayerAngle(playerid, 0);
    local x, y, z = GetPlayerPos(playerid);
    local world = GetPlayerWorld(playerid);
    z = z + 150;

	local charactercreationvob = Vob.Create("Nix.3DS", world, x, y, z);
	charactercreationvob:SetRotation(0, 180, 0);
	SetCameraBehindVob(playerid, charactercreationvob);

    PLAYERS[playerid].facechange = {
        id = chardata.id,
        sexpick = indexOf(SEXES, chardata.sex),
        torsopick = indexOf(TORSOS[chardata.sex], chardata.torso),
        torsoskinpick = indexOf(TORSOSKINS[chardata.sex], chardata.torsoskin),
        headpick = indexOf(HEADS[chardata.sex], chardata.head),
        headskinpick = indexOf(HEADSKINS[chardata.sex], chardata.headskin),
        fatness = chardata.fatness,
        vob = charactercreationvob
    };
    
    ShowChat(playerid, 0);
    freeze(playerid, "facechange");
    showFacechangeMenu(playerid);
end

function showFacechangeMenu(playerid)
    local func = "alterFace";

    local x_start = 586;
    local x_size = 117;
    local y_start = 66;
    local y_size = 37;

    setupMenu(playerid, false);

    createText(playerid, "Facechange Menu", x_start+x_size*0, y_start+y_size*0, x_size*4, y_size, 255, 255, 255);

    createButton(playerid, "M / F", x_start+x_size*0, y_start+y_size*1, x_size, y_size, 255, 255, 255, func, {option = "sex", change=1});
    createText(playerid, " ", x_start+x_size*1, y_start+y_size*1, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "Zufällig", x_start+x_size*3, y_start+y_size*1, x_size, y_size, 255, 255, 255, func, {option = "random", change=1});

    createButton(playerid, "<----", x_start+x_size*0, y_start+y_size*2, x_size, y_size, 255, 255, 255, func, {option = "torsoskin", change=-1});
    createText(playerid, "Körper", x_start+x_size*1, y_start+y_size*2, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "---->", x_start+x_size*3, y_start+y_size*2, x_size, y_size, 255, 255, 255, func, {option = "torsoskin", change=1});

    createButton(playerid, "<----", x_start+x_size*0, y_start+y_size*3, x_size, y_size, 255, 255, 255, func, {option = "head", change=-1});
    createText(playerid, "Kopfmesh", x_start+x_size*1, y_start+y_size*3, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "---->", x_start+x_size*3, y_start+y_size*3, x_size, y_size, 255, 255, 255, func, {option = "head", change=1});

    createButton(playerid, "<----", x_start+x_size*0, y_start+y_size*4, x_size, y_size, 255, 255, 255, func, {option = "headskin", change=-1});
    createText(playerid, "Kopfskin", x_start+x_size*1, y_start+y_size*4, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "---->", x_start+x_size*3, y_start+y_size*4, x_size, y_size, 255, 255, 255, func, {option = "headskin", change=1});

    createButton(playerid, "<----", x_start+x_size*0, y_start+y_size*5, x_size, y_size, 255, 255, 255, func, {option = "fatness", change=-0.1});
    createText(playerid, "Gewicht", x_start+x_size*1, y_start+y_size*5, x_size*2, y_size, 255, 255, 255);
    createButton(playerid, "---->", x_start+x_size*3, y_start+y_size*5, x_size, y_size, 255, 255, 255, func, {option = "fatness", change=0.1});

    createButton(playerid, "Speichern", x_start+x_size*0, y_start+y_size*6, x_size*4, y_size, 255, 255, 255, "saveFacechange", {});
end

function alterFace(playerid, args)
    if args.option == "random" then
        PLAYERS[playerid].facechange.torsoskinpick = math.random(#TORSOSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]]);
        PLAYERS[playerid].facechange.headpick = math.random(#HEADS[SEXES[PLAYERS[playerid].facechange.sexpick]]);
        PLAYERS[playerid].facechange.headskinpick = math.random(#HEADSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]]);
        PLAYERS[playerid].facechange.fatness = math.random(-9,19)/10;
    elseif args.option == "sex" then
        PLAYERS[playerid].facechange.sexpick = PLAYERS[playerid].facechange.sexpick%(#SEXES)+1;
        PLAYERS[playerid].facechange.torsopick = 1;
        PLAYERS[playerid].facechange.torsoskinpick = 1;
        PLAYERS[playerid].facechange.headpick = 1;
        PLAYERS[playerid].facechange.headskinpick = 1;
    elseif args.option == "fatness" then
        PLAYERS[playerid].facechange.fatness = math.between(-0.9,PLAYERS[playerid].facechange.fatness+args.change,1.9);
    elseif args.option == "torsoskin" then
        PLAYERS[playerid].facechange.torsoskinpick = moduloTable(TORSOSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]], PLAYERS[playerid].facechange.torsoskinpick+args.change);
    elseif args.option == "head" then
        PLAYERS[playerid].facechange.headpick = moduloTable(HEADS[SEXES[PLAYERS[playerid].facechange.sexpick]], PLAYERS[playerid].facechange.headpick+args.change);
    elseif args.option == "headskin" then
        PLAYERS[playerid].facechange.headskinpick = moduloTable(HEADSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]], PLAYERS[playerid].facechange.headskinpick+args.change);
    end
    
	SetPlayerAdditionalVisual(playerid, 
        TORSOS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.torsopick],
        TORSOSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.torsoskinpick],
        HEADS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.headpick],
        HEADSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.headskinpick]
    );
    SetPlayerFatness(playerid, PLAYERS[playerid].facechange.fatness)
    showFacechangeMenu(playerid);
end

function saveFacechange(playerid, args)
    DB_update("characters", {
        torso = TORSOS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.torsopick],
        torsoskin = TORSOSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.torsoskinpick],
        head = HEADS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.headpick],
        headskin = HEADSKINS[SEXES[PLAYERS[playerid].facechange.sexpick]][PLAYERS[playerid].facechange.headskinpick],
        fatness = PLAYERS[playerid].facechange.fatness,
        sex = SEXES[PLAYERS[playerid].facechange.sexpick]
    }, "id = "..PLAYERS[playerid].facechange.id);

    SetDefaultCamera(playerid);
    local vob = PLAYERS[playerid].facechange.vob;
    vob:Destroy();
    PLAYERS[playerid].facechange = nil;
    clearMenu(playerid);
    ShowChat(playerid, 1);
    unfreeze(playerid, "facechange");
    sendINFOMessage(playerid, "Face erfolgreich gespeichert");
end

function newCharacter(playerid, params)
    local result, name = sscanf(params, "s");
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /newchar <Name>");
        return;
    end
    name = capitalize(name);
    if DB_exists("*", "characters", "name='"..mysql_escape_string(DB.HANDLER, name).."'") then
        sendERRMessage(playerid, "Charaktername ist '"..name.."' ist bereits vergeben.");
        return;
    end
    local character_id = DB_insert("characters", {name=name, accountid=PLAYERS[playerid].account});
    if (character_id < 0) then
        sendERRMessage(playerid, "Charaktererstellung fehlgeschlagen.");
        return;
    end
    local character_location_id = DB_insert("character_locations", {characterid=character_id});
    if (character_location_id < 0) then
        sendERRMessage(playerid, "Charaktererstellung fehlgeschlagen.");
        return;
    end
    local character_equip_id = DB_insert("character_equips", {characterid=character_id});
    if (character_equip_id < 0) then
        sendERRMessage(playerid, "Charaktererstellung fehlgeschlagen.");
        return;
    end
    switchCharakter(playerid, params);
    createStats(playerid);
    createJobs(playerid);
    facechange(playerid);
end

function facechange(playerid, params)
    if PLAYERS[playerid].character == nil then
        sendERRMessage(playerid, "Du musst auf einem Charakter sein");
        return;
    end
    setupFacechange(playerid);
end

function switchCharakter(playerid, params)
    local result, name = sscanf(params, "s");
    local responses;
    if (result ~= 1) then
        sendERRMessage(playerid, "Benutze /switch <Name>");
        local charnames = {};
        responses = DB_select("*", "characters", "accountid = "..PLAYERS[playerid].account);
        for _key, response in pairs(responses) do
            table.insert(charnames, "'"..response.name.."'");
        end
        if (#charnames > 0) then
            local charnamesstring = table.concat(charnames, ", ");
            sendINFOMessage(playerid, "Folgende Charaktere gehören dir: "..charnamesstring);
        end
        return;
    end
    name = capitalize(name);
    responses = DB_select("*", "characters", "accountid = "..PLAYERS[playerid].account.." AND name = '"..mysql_escape_string(DB.HANDLER, name).."'");
    for _key, response in pairs(responses) do
        switchCharacterById(playerid, response.id);
        return;
    end
    sendERRMessage(playerid, "Der Charakter '"..name.."' existiert nicht oder gehört dir nicht");
end

function switchCharacterById(playerid, characterid)
    responses = DB_select("*", "characters", "id = "..characterid);
    for _key, response in pairs(responses) do
        DB_update("account_autologins", {characterid=response.id}, "accountid = "..PLAYERS[playerid].account);
        clearMenu(playerid);
        saveChar(playerid)
        PLAYERS[playerid].character = response.id;
        loadChar(playerid);
        sendINFOMessage(playerid, "Erfolgreich auf Charakter '"..response.name.."' gewechselt.");
        return;
    end
end

function saveChar(playerid)
    savePosition(playerid);
    saveStats(playerid);
end

function loadChar(playerid)
    ClearInventory(playerid);
    loadFace(playerid);
    loadPosition(playerid);
    loadStats(playerid);
    loadInventory(playerid);
    loadEquip(playerid);
end

function savePosition(playerid)
    if (PLAYERS[playerid].character == nil) then
        return;
    end
    local world = GetPlayerWorld(playerid);
    local x, y, z = GetPlayerPos(playerid);
    local angle = GetPlayerAngle(playerid);
    DB_update("character_locations", {
        x = x,
        y = y,
        z = z,
        world = world,
        angle = angle
    }, "characterid = "..PLAYERS[playerid].character);
end

function loadPosition(playerid)
    if (PLAYERS[playerid].character == nil) then
        return;
    end
    local world = GetPlayerWorld(playerid);
    local characterid = PLAYERS[playerid].character;
    local responses = DB_select("*", "character_locations", "characterid = "..characterid);
    for _key, response in pairs(responses) do
        if (world ~= response.world) then
            SetPlayerWorld(playerid, response.world);
        end
        SetPlayerPos(playerid, tonumber(response.x), tonumber(response.y), tonumber(response.z));
        SetPlayerAngle(playerid, tonumber(response.angle));
        return;
    end
end

function loadFace(playerid)
    if (PLAYERS[playerid].character == nil) then
        sendERRMessage(playerid, "Face Laden fehlgeschlagen.");
        return;
    end
    SetPlayerInstance(playerid, "PC_HERO");
    local responses = DB_select("*", "characters", "accountid = "..PLAYERS[playerid].account.." AND id = "..PLAYERS[playerid].character);
    for _key, response in pairs(responses) do
        PLAYERS[playerid].character = response.id;
        SetPlayerAdditionalVisual(playerid, 
            response.torso,
            tonumber(response.torsoskin),
            response.head,
            tonumber(response.headskin)
        );
        SetPlayerFatness(playerid, response.fatness);
        SetPlayerName(playerid, response.name);
        return;
    end
    sendERRMessage(playerid, "Face Laden fehlgeschlagen.");
end

function tryAutologinCharacter(playerid)
    local mac = GetMacAddress(playerid);
    local responses = DB_select("*", "account_autologins", "characterid IS NOT NULL AND mac = '"..mac.."'");
    for _key, response in pairs(responses) do
        switchCharacterById(playerid, response.characterid);
        return;
    end
end

function loadEquip(playerid)
    local equips = DB_select("*",
        "character_equips",
        "characterid = "..PLAYERS[playerid].character);
    for _key, equip in pairs(responses) do
        local meleeid = tonumber(equip.melee);
        local rangedid = tonumber(equip.ranged);
        local armorid = tonumber(equip.armor);
        local spellid = tonumber(equip.spell);
        if (meleeid ~= 0) then
            local melees = DB_select("*", "items", "itemid = "..meleeid);
            for _key, melee in pairs(melees) do
                RemoveItem(playerid, melee.instance, 1);
                EquipMeleeWeapon(playerid, melee.instance);
            end
        end
        if (rangedid ~= 0) then
            local rangeds = DB_select("*", "items", "itemid = "..rangedid);
            for _key, ranged in pairs(rangeds) do
                RemoveItem(playerid, ranged.instance, 1);
                EquipRangedWeapon(playerid, ranged.instance);
            end
        end
        if (armorid ~= 0) then
            local armors = DB_select("*", "items", "itemid = "..armorid);
            for _key, armor in pairs(armors) do
                RemoveItem(playerid, armor.instance, 1);
                EquipArmor(playerid, armor.instance);
            end
        end
        if (spellid ~= 0) then
            local spells = DB_select("*", "items", "itemid = "..spellid);
            for _key, spell in pairs(spells) do
                RemoveItem(playerid, spell.instance, 1);
                EquipItem(playerid, spell.instance);
            end
        end
    end
end

function OnPlayerChangeMeleeWeapon(playerid, newWeapon, _oldWeapon)
    local itemid = 0;
    local items = DB_select("*", "items", "instance="..newWeapon);
    for _key, item in pairs(items) do
       itemid = tonumber(item.id);
    end
    DB_update("character_equips", {melee=itemid}, "characterid="..PLAYERS[playerid].character);
end

function OnPlayerChangeRangedWeapon(playerid, newWeapon, _oldWeapon)
    local itemid = 0;
    local items = DB_select("*", "items", "instance="..newWeapon);
    for _key, item in pairs(items) do
       itemid = tonumber(item.id);
    end
    DB_update("character_equips", {ranged=itemid}, "characterid="..PLAYERS[playerid].character);
end

function OnPlayerChangeArmor(playerid, newArmor, _oldArmor)
    local itemid = 0;
    local items = DB_select("*", "items", "instance="..newArmor);
    for _key, item in pairs(items) do
       itemid = tonumber(item.id);
    end
    DB_update("character_equips", {armor=itemid}, "characterid="..PLAYERS[playerid].character);
end