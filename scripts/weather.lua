WEATHER = 0;

function weather(playerid, params)
    local result, wetter = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Du musst eine Zahl eingeben");
        return;
    end
    
    local hour, minute = GetTime();

    if (wetter == 1) then
        debug("Wetter kein Regen");
        SetWeather(WEATHER_RAIN, 0, hour, minute, hour, minute+1);
    elseif (wetter == 2) then
        debug("Wetter Regen ohne Blitz");
        SetWeather(WEATHER_RAIN, 0, hour, minute, (hour+23)%24, (minute+59)%60);
    elseif (wetter == 3) then
        debug("Wetter Regen mit Blitz");
        SetWeather(WEATHER_RAIN, 1, hour, minute, (hour+23)%24, (minute+59)%60);
    elseif (wetter == 4) then
        debug("Wetter Schnee ohne Blitz");
        SetWeather(WEATHER_RAIN, 0, hour, minute, (hour+23)%24, (minute+59)%60);
    elseif (wetter == 5) then
        debug("Wetter Schnee mit Blitz");
        SetWeather(WEATHER_RAIN, 1, hour, minute, (hour+23)%24, (minute+59)%60);
    else
        sendERRMessage("Unbekanntes Wetter. Versuche 1-5");
    end
end