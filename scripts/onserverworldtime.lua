function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
    updateGametimeDraw(newHour, newMinute);
    local rnd = math.random(1, 5);
    if rnd ~= 3 then
        return;
    end
    for spawnid, spawndata in pairs(SPAWNS) do
        if (spawndata.spawned == false) then
            local itemid = CreateItem(spawndata.item, 1, spawndata.location.x, spawndata.location.y, spawndata.location.z, "NEWWORLD\\KHORINIS.ZEN");
            WORLDITEMS[itemid] = spawnid;
            SPAWNS[spawnid].spawned = true;
        end
    end
end