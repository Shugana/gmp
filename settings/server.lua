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
	SetDrawText(SERVERDRAWS.time.id, "IG: "..hour..":"..minute.." Uhr || RL: "..rltime.." Uhr");
end


SetDrawText(ig_time, string.format("IG: %02d:%02d Uhr || RL: %s Uhr", newHour, newMinute, os.date('%H:%M')));