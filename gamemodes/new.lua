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
  if IsPlayerConnected(recipientid) then
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