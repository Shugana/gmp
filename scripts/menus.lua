FONTS = {
    standard = "Font_Old_10_White_Hi.tga",
    big = "Font_Old_20_White_Hi.tga",
    sequel = "Font_Old_10_White.tga",
    sequelbig = "Font_Old_20_White.tga"
};

-- Virtual Pixels for Draws / Texts: 0-8192

function convertToPixel(x, y)
    local sourceX = 1920;
    local sourceY = 1080;
    local TargetMax = 8192;
    return math.floor(x/sourceX*TargetMax+0.5),math.floor(y/sourceY*TargetMax+0.5);
end

function createButton(playerid, text, startx, starty, sizex, sizey, r, g, b, func, args)
    createText(playerid, text, startx, starty, sizex, sizey, r, g, b);
    table.insert(PLAYERS[playerid].menu.buttons, {
        x_min = startx,
        x_max = startx+sizex,
        y_min = starty,
        y_max = starty+sizey,
        func = func,
        args = args
    });
end

function createText(playerid, text, startx, starty, sizex, sizey, r, g, b)
    r = r or 255;
    g = g or 255;
    b = b or 255;
    local text = CreatePlayerDraw(playerid, startx+50, starty+50, text, FONTS.standard, r, g, b);
    table.insert(PLAYERS[playerid].menu.texts, text);
    --local texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "Data\\Textures\\Desktop\\nomip\\Menu_Ingame.tga")
    local texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\MENU_INGAME.TGA")
    
    table.insert(PLAYERS[playerid].menu.textures, texture);
    ShowPlayerDraw(playerid, text);   
    ShowTexture(playerid, texture);
end

function clearMenu(playerid)
    if PLAYERS[playerid].menu == nil then
        return;
    end
    for _, text in pairs(PLAYERS[playerid].menu.texts) do
        DestroyPlayerDraw(playerid, text);
    end
    for _, texture in pairs(PLAYERS[playerid].menu.textures) do
        DestroyTexture(texture);
    end
    SetCursorVisible(playerid, 0);
    PLAYERS[playerid].menu = nil;
end

function setupMenu(playerid, closable)
    clearMenu(playerid);
    PLAYERS[playerid].menu = {
        closable = closable,
        buttons = {},
        texts = {},
        textures = {}
    };
    SetCursorVisible(playerid, 1);
end

function OnPlayerMouse(playerid, mouse, pressed, pos_x, pos_y)
    if pressed ~= 1 then
        return;
    end
    for _, button in pairs(PLAYERS[playerid].menu.buttons) do
        if gotButton(button, pos_x, pos_y) then
            if mouse == MB_RIGHT and not(PLAYERS[playerid].menu.closable) then
                return;
            end
            clearMenu(playerid);
            SetCursorVisible(playerid, 0);
            if mouse == MB_LEFT then
                _G[button.func](playerid, button.args);
            end
            return;
        end
    end
end

function gotButton(button, pos_x, pos_y)
    return button.x_min <= pos_x and button.x_max >= pos_x and button.y_min <= pos_y and button.y_max >= pos_y;
end


function createClickableTexture(playerid, graphic, startx, starty, sizex, sizey, func, args)
    startx, starty = convertToPixel(startx, starty);
    sizex, sizey = convertToPixel(sizex, sizey);
    local texture;

    texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\MENU_INGAME.TGA")
    table.insert(PLAYERS[playerid].menu.textures, texture);
    ShowTexture(playerid, texture);

    texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "DATA\\TEXTURES\\DESKTOP\\SKORIP\\SKO_R_"..graphic);
    ShowTexture(playerid, texture);
    table.insert(PLAYERS[playerid].menu.textures, texture);

    table.insert(PLAYERS[playerid].menu.buttons, {
        x_min = startx,
        x_max = startx+sizex,
        y_min = starty,
        y_max = starty+sizey,
        func = func,
        args = args
    });
end

function testCraftmenu(playerid, params)
    setupMenu(playerid, true);

    createClickableTexture(playerid, "ITPO_MANA_01_3DS.TGA", 200, 200, 200, 200, "testClicked", {opt="Manaessenz",graphic="ITPO_MANA_01_3DS.TGA"});
    createClickableTexture(playerid, "ITPO_MANA_02_3DS.TGA", 400, 200, 200, 200, "testClicked", {opt="Manaessenz",graphic="ITPO_MANA_02_3DS.TGA"});
    createClickableTexture(playerid, "ITPO_HEALTH_01_3DS.TGA", 200, 400, 200, 200, "testClicked", {opt="Manaessenz",graphic="ITPO_HEALTH_01_3DS.TGA"});
    createClickableTexture(playerid, "ITPO_HEALTH_02_3DS.TGA", 400, 400, 200, 200, "testClicked", {opt="Manaessenz",graphic="ITPO_HEALTH_02_3DS.TGA"});
end

function testClicked(playerid, args)
    --sendINFOMessage(playerid, args.opt.." angeklickt, woohoooooo!");
    testCraftmenu(playerid, nil);

    createClickableTexture(playerid, args.graphic, 600, 200, 600, 600, "crafting", {opt=args.opt});

end

function crafting(playerid, args)
    sendINFOMessage(playerid, "Crafting begonnen");
    craftingStart(playerid, args.opt, 10000, "craftingdone", {name=args.opt}, nil);
end

function craftingdone()
    sendERRMessage(playerid, "Test. Noch keine Items ("..args.name..") erstellt oder verbraucht.");
end