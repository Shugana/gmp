function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    respawnTickMonsters();
    if (newMinute == 0) then
        tickWeather();
    end
    debug(GetTickCount());
end