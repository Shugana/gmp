function OnGamemodeInit()
  SetServerDescription("Fluffy Server");
  SetGamemodeName("Fluff Local Test");
  EnableNickname(0);
  EnableExitGame(0);
  EnableChat(0);
  math.randomseed(os.time());
end

function OnPlayerConnect(playerid)
  SendPlayerMessage(playerid, 207,175,55, "connected to the fluff server, woop woop");
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
      SendPlayerMessage(playerid, 255,0,0, "Unbekannte Funktion: "..command);
    end
  end
end

function giveitem(playerid, params)
  local result, itemid = sscanf(params, "s");
  if (result ~= 1) then
    SendPlayerMessage(playerid, 255,0,0, "invalid params");
    return;
  end
  GiveItem(playerid, itemid, 1);
end

function leaveGame(playerid, params)
  ExitGame(playerid);
end

function help(playerid, params)
  for funcname, funcvalues in pairs(FUNCTIONS) do
    SendPlayerMessage(playerid, 207, 175, 55, funcname..": "..funcvalues.help);
  end
end

FUNCTIONS = {
  q = {
    func = "leaveGame",
    help = "Schlieﬂt das Game"
  },
  giveitem = {
    func = "giveitem",
    help = "Cheated ein Item"
  },
  help = {
    func = "help",
    help = "Zeigt diese Hilfe an"
  }
};