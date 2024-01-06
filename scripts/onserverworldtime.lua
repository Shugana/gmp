function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    respawnTickMonsters();
    if (newMinute == 0) then
        tickWeather();
    end

	local rlHour = tonumber(os.date("%H"));
    local rlMinute = tonumber(os.date("%M"));
    if (rlHour == 0 and rlMinute == 0) then
        resetLPCap();
    end
    if (rlMinute ~= LASTLPLOOP and rlMinute%15 == 5) then
        LASTLPLOOP = rlMinute;
        gainLPLoop();
    end
end