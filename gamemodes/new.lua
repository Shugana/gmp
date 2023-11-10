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
  SendPlayerMessage(playerid, 207,175,55, "command send was: "..command);
  local cmd, params = GetCommand(cmdtext);
  if cmd:sub(1,1) == "/" then
    cmd = cmd:sub(2);
    if FUNCTIONS[cmd] then
      _G[cmd](playerid, params);
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

FUNCTIONS = {
  q = "ExitGame",
  giveitem = "giveitem"
};