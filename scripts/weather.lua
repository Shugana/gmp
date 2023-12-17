TEMPERATURE = 15;
HUMIDITY = 30;
RAINING = 0;
STARTRAIN = 80;
STOPRAIN = 20;

WEATHER = 0;

function changeWeather(playerid, params)
    local result, wetter = sscanf(params, "d");
    if (result ~= 1) then
        sendERRMessage(playerid, "Du musst eine Zahl eingeben");
        return;
    end

    if (wetter == 1) then
        debug("Wetter kein Regen");
        TEMPERATURE = 15;
        HUMIDITY = 0;
        RAINING = 0;
    elseif (wetter == 2) then
        debug("Wetter Regen ohne Blitz");
        TEMPERATURE = 15;
        HUMIDITY = 100;
        RAINING = 1;
    elseif (wetter == 3) then
        debug("Wetter Regen mit Blitz");
        TEMPERATURE = 50;
        HUMIDITY = 100;
        RAINING = 1;
    elseif (wetter == 4) then
        debug("Wetter Schnee ohne Blitz");
        TEMPERATURE = -15;
        HUMIDITY = 100;
        RAINING = 1;
    else
        sendERRMessage("Unbekanntes Wetter. Versuche 1-4");
        return;
    end
    tickWeather();
end

function calculateTemperature(currentTemperature, hour)
    local amplitude = 15;
    local medianTemperature = 15;
    local noon = 12;
    local randomness = 10;
    local temperature = amplitude * math.cos((hour - noon) * (2 * math.pi) / 24) + medianTemperature;
    temperature = temperature + math.random(-randomness, randomness);
    temperature = (3*currentTemperature + temperature)/4;
    return temperature;
end

function tickWeather()
    local startraining = false;
    local stopraining = false;    
    local hour, minute = GetTime();
    local endHour = hour;
    local endMinute = (minute+1)%60;
    if (minute > 58) then
        local endHour = (hour+1)%24;
    end
    TEMPERATURE = calculateTemperature(TEMPERATURE, hour);
    HUMIDITY = HUMIDITY + (math.random(math.max(1, math.floor(TEMPERATURE*100)))/1000);
    if HUMIDITY > STARTRAIN then
        startraining = math.random(100) < HUMIDITY;
    end
    if (RAINING > 0 or startraining == true) then
        RAINING = RAINING + 1;
        TEMPERATURE = TEMPERATURE - (math.random(math.max(1, math.floor(RAINING*100)))/1000);
        HUMIDITY = HUMIDITY - math.random(RAINING);
        if (HUMIDITY < STOPRAIN) then
            stopraining = math.random(STOPRAIN) > HUMIDITY;
        end
        if (stopraining) then
            RAINING = 0;
        end
    end

    local tempText = "Es ist eiskalt";
    local r, g, b;

    if (TEMPERATURE > 30) then
        tempText = "Die Luft flirrt vor Hitze";
        r = 255; g = 124; b = 10; -- orange
    elseif (TEMPERATURE > 25) then
        tempText = "Es ist heiß";
        r = 255; g = 244; b = 104; -- gelb
    elseif (TEMPERATURE > 20) then
        tempText = "Es ist warm";
        r = 255; g = 244; b = 104; -- gelb
    elseif (TEMPERATURE > 15) then
        tempText = "Es ist angenehm";
        r = 255; g = 255; b = 255; -- weiß
    elseif (TEMPERATURE > 5) then
        tempText = "Es ist kühl";
        r = 63; g = 199; b = 235; -- hellbalu
    elseif (TEMPERATURE > 0) then
        tempText = "Es ist kalt";
        r = 0; g = 112; b = 221; -- blau
    end

    local rainText = "die Sonne scheint";
    local weather = 1;
    if (hour < 5 or hour > 20) then
        rainText = "der Mond strahlt";
    end
    if (RAINING > 0) then
        rainText = "es nieselt";
        weather = 2;
        if (RAINING > 3) then
            rainText = "es regnet";
        end
        if (RAINING > 7) then
            rainText = "es schüttet unentwegt";
        end
        if TEMPERATURE > 25 then
            rainText = "es gewittert";
            weather = 3;
        end
        if TEMPERATURE < 0 then
            rainText = "es schneit";
            weather = 4;
        end
    end

    SetDrawText(SERVERDRAWS.weather.id, tempText.." und "..rainText);
	SetDrawColor(SERVERDRAWS.weather.id, r, g, b);
    adjustWeather(weather, hour, minute, endHour, endMinute);
    log("weather", string.format("%02d", hour)..":"..string.format("%02d", minute).." - "..TEMPERATURE.." Grad @ "..HUMIDITY.."H, Regen seit: "..RAINING.." Stunden");
    DB_update("weather", {humidity=HUMIDITY, raining=RAINING, temperature=TEMPERATURE}, "id = 1");
end

function adjustWeather(weather, hour, minute, endHour, endMinute)
    if weather == WEATHER then
        return;
    end
    if (wetter == 1) then
        SetWeather(WEATHER_RAIN, 0, hour, minute, endHour, endMinute);
    elseif (wetter == 2) then
        SetWeather(WEATHER_RAIN, 0, endHour, endMinute, 11, 59);
    elseif (wetter == 3) then
        SetWeather(WEATHER_RAIN, 1, endHour, endMinute, 11, 59);
    elseif (wetter == 4) then
        SetWeather(WEATHER_SNOW, 0, endHour, endMinute, 11, 59);
    end
    WEATHER = weather;
end

function initWeather()
    local weathers = DB_select("*", "weather", "1");
    for _key, weather in pairs(weathers) do
        HUMIDITY = tonumber(weather.humidity);
        TEMPERATURE = tonumber(weather.temperature);
        RAINING = tonumber(weather.raining);
    end
    tickWeather();
end