SERVERDRAWS = {
    time = {
        id = nil,
        pos = {x=130, y=7400},
        color = {r=255,g=255,b=255}
    }
}

SPAWNTICKS = {
    items = 0,
    itemsmax = 30,
    monsters = 0,
    monstersmax = 180
};

function setupTimedraw()
    SERVERDRAWS.time.id = CreateDraw(SERVERDRAWS.time.pos.x, SERVERDRAWS.time.pos.y, "IG: 00:00 Uhr || RL: 00:00 Uhr", FONTS.sequel, SERVERDRAWS.time.color.r, SERVERDRAWS.time.color.g, SERVERDRAWS.time.color.b);
end

function updateGametimeDraw(hour, minute)
    hour = string.format("%02d", hour);
    minute = string.format("%02d", minute)
    local rltime = os.date("%H:%M");
    SetDrawText(SERVERDRAWS.time.id, "IG: "..hour..":"..minute.." Uhr || RL: "..rltime.." Uhr");
end