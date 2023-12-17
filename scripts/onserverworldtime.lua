function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    respawnTickItems();
    respawnTickMonsters();
    if (newMinute == 0) then
        tickWeather();
    end
end