require("settings/db");
require("settings/server");

require("scripts/db");
require("scripts/accounts");
require("scripts/commands");
require("scripts/utility");
require("scripts/itemhandling");
require("scripts/login");
require("scripts/menus");
require("scripts/characters");
require("scripts/onserverworldtime");


function OnGamemodeInit()
    SetServerDescription("Fluffy Server");
    SetGamemodeName("Fluff Local Test");
    EnableNickname(0);
    EnableExitGame(0);
    EnableChat(0);
    math.randomseed(os.time());
    ConnectDB();
    setupTimedraw();
end