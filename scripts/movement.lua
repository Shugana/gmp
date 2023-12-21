function sprint(playerid, params)
    local walk = GetPlayerWalk(playerid);
    if (walk == "HUMANS_SPRINT.MDS" then)
        RemovePlayerOverlay(playerid, overlay)
    else
        SetPlayerWalk(playerid, "HUMANS_SPRINT.MDS");
    end
end