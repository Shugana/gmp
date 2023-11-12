SERVERDRAWS = {
    time = {
        id = nil,
        pos = {130, 7400},
        color = {255,255,255}
    }
}

function setupTimedraw()
    SERVERDRAWS.time.id = CreateDraw(SERVERDRAWS.time.pos, "IG: 00:00 Uhr || RL: 00:00 Uhr", FONTS.sequel, SERVERDRAWS.time.color);
end

function updateGametimeDraw(hour, minute)
    hour = string.format("%02d", hour);
    minute = string.format("%02d", minute)
    local rltime = os.date("%H:%M");
    if (SERVERDRAWS.time.id ~= nil) then
	    SetDrawText(SERVERDRAWS.time.id, "IG: "..hour..":"..minute.." Uhr || RL: "..rltime.." Uhr");
    else
        SendMessageToAll(255,255,255,"WTF");
    end
end