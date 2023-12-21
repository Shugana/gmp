function sprint(playerid, params)
    local walk = GetPlayerWalk(playerid);
    debug(walk);
    SetPlayerWalk(playerid, "HUMANS_SPRINT.MDS");
end