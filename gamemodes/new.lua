require("/scripts/commands.lua");
require("/scripts/utility.lua");
require("/scripts/itemhandling.lua");
require("/scripts/login.lua");
require("/scripts/onserverworldtime.lua");

function OnGamemodeInit()
    SetServerDescription("Fluffy Server");
    SetGamemodeName("Fluff Local Test");
    EnableNickname(0);
    EnableExitGame(0);
    EnableChat(0);
    math.randomseed(os.time());
end