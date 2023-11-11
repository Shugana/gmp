function createButton(playerid, menu, text, startx, starty, sizex, sizey, r, g, b, func, args)
    createText(playerid, menu, text, startx, starty, sizex, sizey, r, g, b);
    LoadButtonAction(playerid,startx,starty,startx+sizex,starty+sizey,menu,func,playerid..","..args);
end

function createText(playerid, menu, text, startx, starty, sizex, sizey, r, g, b)
    r = r or 255;
    g = g or 255;
    b = b or 255;
    local text = CreatePlayerDraw(playerid, startx+50, starty+50, text, Fonts.standard, r, g, b);
    ShowPlayerDraw(playerid, text);
    table.insert(PlayerClickableMenu[playerid][menu]["texts"], text);
    local texture = CreateTexture(startx, starty, startx+sizex, starty+sizey, "Data\\Textures\\Desktop\\nomip\\Menu_Ingame.tga")
    ShowTexture(playerid, texture);
    table.insert(PlayerClickableMenu[playerid][menu]["textures"], texture);
end

function clearOldMenus(playerid, _)
    if not(PlayerClickableMenu)
    or not(PlayerClickableMenu[playerid])
    or not(PlayerClickableMenu[playerid].menuactive) then
        return
    end

    local menu = PlayerClickableMenu[playerid].menuactive;

    
    for _, text in pairs(PlayerClickableMenu[playerid][menu]["texts"]) do
        DestroyPlayerDraw(playerid, text);
    end
    for _, texture in pairs(PlayerClickableMenu[playerid][menu]["textures"]) do
        DestroyTexture(texture);
    end
    
    PlayerClickableMenu[playerid][menu] = nil;
    PlayerClickableMenu[playerid].menuactive = nil;
    PlayerClickableMenu[playerid].isdrawvisible = 0;
    SetCursorVisible(playerid, 0);
	Player[playerid].cursor = 0;
end

function setupnewMenu(playerid, menu)
	PlayerClickableMenu[playerid][menu] = {};
	PlayerClickableMenu[playerid][menu]["buttonactions"] = {};
    PlayerClickableMenu[playerid][menu]["texts"] = {};
    PlayerClickableMenu[playerid][menu]["textures"] = {};

    SetCursorSensitivity(playerid, Player[playerid].cursorsens or 1);
	SetCursorVisible(playerid, 1);
	Player[playerid].cursor = 1; 

    PlayerClickableMenu[playerid].menuactive = menu;
    PlayerClickableMenu[playerid].isdrawvisible = 1;
end

function OnPlayerMouse(playerid, button, pressed, pos_x, pos_y)
    if button == MB_LEFT and pressed == 1 then
        sendINFOMessage(playerid, "Linksklick bei "..pos_x..", "..pos_y);
    end
    if button == MB_RIGHT and pressed == 1 then
        sendINFOMessage(playerid, "Rechtsklick bei "..pos_x..", "..pos_y);
    end
    SetCursorVisible(playerid, 0);
end