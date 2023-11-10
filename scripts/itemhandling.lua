WORLDITEMS = {};

SPAWNS = {
    [1] = {
        item = "ItPl_Beet",
        spawned = false,
        location = {
            x = 311,
            y = -88,
            z = -1552
        }
    },
    [2] = {
        item = "ItPl_Mana_Herb_01",
        spawned = false,
        location = {
            x = 310,
            y = -96,
            z = -1800
        }
    }
};

function giveitem(playerid, params)
    local result, recipientid, itemid, amount = sscanf(params, "dsd");
    if (result ~= 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemid> <anzahl>");
        return;
    end
    if (amount < 1) then
        sendERRMessage(playerid, "Ungültige Eingabe: versuche /giveitem <playerid> <itemid> <anzahl>");
        return;
    end
    if not(IsPlayerConnected(recipientid)) then
        sendERRMessage(playerid, "Spieler mit id "..recipientid.." ist nicht verbunden.");
        return;
    end
    sendINFOMessage(playerid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemid);
    if (recipientid ~= playerid) then
        sendINFOMessage(recipientid, GetPlayerName(playerid).." cheated "..GetPlayerName(recipientid).." "..amount.."x "..itemid);
    end
    GiveItem(recipientid, itemid, amount);
end

function OnPlayerTakeItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
    if (itemid < 0) then
        sendERRMessage(playerid, "itemid "..itemid.." below 0");
        return;
    end
    sendINFOMessage(playerid, "DEBUG OnPlayerTakeItem - Playerid: "..playerid..", itemid: "..itemid..", item_instance: "..item_instance..", amount: "..amount..", x: "..x..", y: "..y..", z: "..z..", worldName: "..worldName);
    SPAWNS[WORLDITEMS[itemid]].spawned = false;
    WORLDITEMS[itemid] = nil;
end