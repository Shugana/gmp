WORLDMONSTERS = {};

function handleDeadMonsters()
    for npcid, dbid in pairs(WORLDMONSTERS) do
        if(GetPlayerHealth(npcid) < 1) then
            if (NPCS[npcid].deathTimer == nil) then
                NPCS[npcid].deathTimer = 120;
            end
            NPCS[npcid].deathTimer = NPCS[npcid].deathTimer -1;
            if (NPCS[npcid].deathTimer < 1) then
                DestroyNPC(npcid);
                WORLDMONSTERS[npcid] = nil;
                DB_update("monster_spawns", {spawned=0}, "id="..dbid);
            end
        end
    end
end

function respawnTickMonsters()
    handleDeadMonsters();
    SPAWNTICKS.monsters = (SPAWNTICKS.monsters+1)%SPAWNTICKS.monstersmax;
    debug("Monsterticks "..SPAWNTICKS.monsters);
    if (SPAWNTICKS.monsters == 1) then
        local responses = DB_select(
            "monsters.name AS name, monster_spawns.id as id, monster_spawns.x AS x, monster_spawns.y AS y, monster_spawns.z AS z, monster_spawns.world AS world",
            "monsters, monster_spawns",
            "monsters.id = monster_spawns.monsterid AND monster_spawns.spawned=0"
        );
        for _key, response in pairs(responses) do
            local monsterid = spawnMonster(response.name, response.world, response.x, response.y, response.z);
            if (monsterid < 0) then
                return;
            end
            WORLDMONSTERS[monsterid] = response.id;
            DB_update("monster_spawns", {spawned=1}, "id="..response.id);
        end
    end
end

function spawnMonstersOnServerInit()
    local responses = DB_select(
        "monsters.name AS name, monster_spawns.id as id, monster_spawns.x AS x, monster_spawns.y AS y, monster_spawns.z AS z, monster_spawns.world AS world",
        "monsters, monster_spawns",
        "monsters.id = monster_spawns.monsterid AND monster_spawns.spawned=1"
    );
    for _key, response in pairs(responses) do
        local monsterid = spawnMonster(response.name, response.world, response.x, response.y, response.z);
        if (monsterid < 0) then
            DB_update("monster_spawns", {spawned=0}, "id="..response.id);
            return;
        end
        WORLDMONSTERS[monsterid] = response.id;
    end
end