function sprint(playerid, params)
    local walk = GetPlayerWalk(playerid);
    if (walk == "HUMANS_SPRINT.MDS") then
        RemovePlayerOverlay(playerid, "HUMANS_SPRINT.MDS");
    else
        SetPlayerWalk(playerid, "HUMANS_SPRINT.MDS");
    end
end