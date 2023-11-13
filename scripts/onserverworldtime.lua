function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    respawnTick();


end