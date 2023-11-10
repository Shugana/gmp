function OnGamemodeInit()
  SetServerDescription("Fluffy Server");
  SetGamemodeName("Fluff Local Test");
  EnableNickname(0);
  EnableExitGame(0);
  EnableChat(0);
  math.randomseed(os.time());
end

function OnPlayerConnect(playerid)
  SetPlayerWorld(playerid, "NEWWORLD\\KHORINIS.ZEN");
  SetPlayerPos(playerid, 0, 0, 0);
  SpawnPlayer(playerid);
end

function OnPlayerText(playerid, text)
  OnPlayerCommandText(playerid, text);
  return 0;
end

function OnPlayerCommandText(playerid, command)
  if not(command) then
    return 0;
  end
  local cmd, params = GetCommand(command);
  if cmd:sub(1,1) == "/" then
    cmd = cmd:sub(2);
    if FUNCTIONS[cmd] then
      _G[FUNCTIONS[cmd].func](playerid, params or "");
    else
      sendERRMessage(playerid, "Unbekannte Funktion: "..command);
    end
  end
end

function sendERRMessage(playerid, text)
  SendPlayerMessage(playerid, 255, 0, 0, text);
end

function sendINFOMessage(playerid, text)
  SendPlayerMessage(playerid, 207, 175,  55, text);
end

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

function leaveGame(playerid, params)
  ExitGame(playerid);
end

function help(playerid, params)
  for funcname, funcvalues in pairs(FUNCTIONS) do
    sendINFOMessage(playerid, funcname..": "..funcvalues.help);
  end
end

function getLocation(playerid, _params)
  local world = GetPlayerWorld(playerid);
  local x, y, z = GetPlayerPos(playerid);
  sendINFOMessage(playerid, "Du bist in "..world.." bei "..math.ceil(x)..", "..math.ceil(y)..", "..math.ceil(z));
end

function OnServerWorldTime(oldHour, oldMinute, newHour, newMinute)
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

function OnPlayerTakeItem(playerid, itemid, item_instance, amount, x, y, z, worldName)
  if (itemid < 0) then
    return;
  end
  sendINFOMessage(playerid, "DEBUG OnPlayerTakeItem - Playerid: "..playerid..", itemid: "..itemid..", item_instance: "..item_instance..", amount: "..amount..", x: "..x..", y: "..y..", z: "..z..", worldName: "..worldName);
  GiveItem(playerid, item_instance, amount);
  SPAWNS[WORLDITEMS[itemid]].spawned = false;
  WORLDITEMS[itemid] = nil;
end

WORLDITEMS = {};

FUNCTIONS = {
  q = {
    func = "leaveGame",
    help = "Schließt das Game"
  },
  giveitem = {
    func = "giveitem",
    help = "Cheated ein Item"
  },
  help = {
    func = "help",
    help = "Zeigt diese Hilfe an"
  },
  loc = {
    func = "getLocation",
    help = "Zeigt dir an wo du bist"
  }
};

SPAWNS = {
  [1] = {
    item = "ItPl_Beet",
    location = {
      x = 311,
      y = -88,
      z = -1552
    },
    spawned = false
  },
  [2] = {
    item = "ItPl_Mana_Herb_01",
    location = {
      x = 310,
      y = -96,
      z = -1800
    },
    spawned = false
  }
}