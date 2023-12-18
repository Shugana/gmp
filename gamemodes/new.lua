require("settings/db");
require("settings/server");

require("scripts/db");
require("scripts/logging");
require("scripts/accounts");
require("scripts/commands");
require("scripts/chat");
require("scripts/utility");
require("scripts/itemhandling");
require("scripts/weather");
require("scripts/login");
require("scripts/menus");
require("scripts/characters");
require("scripts/stats");
require("scripts/crafting")
require("scripts/teleports");
require("scripts/monsters");
require("scripts/hunting");
require("scripts/monsterspawns");
require("scripts/focus");
require("scripts/teach");
require("scripts/damage");
require("scripts/onserverworldtime");
require("scripts/buffs");
require("scripts/timers");


function OnGamemodeInit()
    SetServerDescription("Fluffy Server");
    SetGamemodeName("Fluff Local Test");
    EnableNickname(0);
    EnableExitGame(0);
    EnableChat(0);
    math.randomseed(os.time());
    ConnectDB();
    initServerdraws();
    initWeather();
    spawnItemsOnServerInit();
    spawnMonstersOnServerInit();
    startTimers();
end