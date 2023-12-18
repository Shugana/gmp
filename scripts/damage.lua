function OnPlayerHit(playerid, attackerid)
    debug(attackerid.." attacked "..playerid);
    local weaponmode = GetPlayerWeaponMode(attackerid);
    debug("Weaponmode of attacker: "..weaponmode);

    if (weaponmode == WEAPON_NONE) then
        debug ("Nicht im Kampf...?!");
    end
    if (weaponmode == WEAPON_FIST) then
        debug ("Faustkampf...?!");
    end
    if (weaponmode == WEAPON_1H) then
        debug ("Einhand...?!");
    end
    if (weaponmode == WEAPON_2H) then
        debug ("Zweihand...?!");
    end
    if (weaponmode == WEAPON_BOW) then
        debug ("Bogen...?!");
    end
    if (weaponmode == WEAPON_CBOW) then
        debug ("Armbrust...?!");
    end
    if (weaponmode == WEAPON_MAGIC) then
        debug ("Magie...?!");
    end
end