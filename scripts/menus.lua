FONTS = {
    standard = "Font_Old_10_White_Hi.tga",
    big = "Font_Old_20_White_Hi.tga",
    sequel = "Font_Old_10_White.tga",
    sequelbig = "Font_Old_20_White.tga"
};

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
    local texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "Data\\Textures\\Desktop\\nomip\\Menu_Ingame.tga")
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

function setupMenu(playerid)
    clearMenu(playerid);
    PLAYERS[playerid].menu = {
        buttons = {},
        texts = {},
        textures = {}
    };
    SetCursorVisible(playerid, 1);
end

function OnPlayerMouse(playerid, button, pressed, pos_x, pos_y)
    if button == MB_LEFT and pressed == 1 then
        for _, button in pairs(PLAYER[playerid].menu.buttons) do
            if (button.min_x <= pos_x and button.max_x >= pos_x and button.min_y <= pos_y and button.max_y) then
                _G[button.func](playerid, button.args);
                SetCursorVisible(playerid, 0);
                return;
            end
        end
    end
    if button == MB_RIGHT and pressed == 1 then        
        for _, button in pairs(PLAYER[playerid].menu.buttons) do
            if (button.min_x <= pos_x and button.max_x >= pos_x and button.min_y <= pos_y and button.max_y) then
                clearMenu(playerid);
                SetCursorVisible(playerid, 0);
                return;
            end
        end
    end
end