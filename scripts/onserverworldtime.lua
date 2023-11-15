function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    respawnTickItems();
    respawnTickMonsters();
end