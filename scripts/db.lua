function ConnectDB()
	DB.HANDLER = mysql_connect(
		DB.IP,
		DB.USER,
		DB.PASSWORD,
		DB.DBNAME,
		DB.PORT,
		DB.SOCKET
    );
	if not(DB.HANDLER) then
		io.stderr:write("Failed to connect to database!\n");
		os.exit(1);
    end
end

function DB_select(selection, tablename, condition)
    local result = {};
    local query = "SELECT "..mysql_escape_string(DB.HANDLER, selection)
        .." FROM "..mysql_escape_string(DB.HANDLER, tablename)
        .." WHERE "..condition;
    local response = mysql_query(DB.HANDLER, query);
    local row = mysql_fetch_assoc(response);
    local length = 0;
    while row ~= nil do
        length = length + 1;
        result[length] = row;
        row = mysql_fetch_assoc(response);
    end
    mysql_free_result(response);
    return result;
end

function DB_insert(tablename, data)
    local result = -1;
    local keys = {};
    local values = {};
    local row = 1;
    for key,value in pairs(data) do
        keys[row] = "`"..mysql_escape_string(DB.HANDLER, key).."`";
        values[row] = "'"..mysql_escape_string(DB.HANDLER, value).."'";
        row = row + 1;
    end
    local keysstring = table.concat(keys, ", ");
    local valuesstring = table.concat(values, ", ");
    local query = "INSERT INTO `"..mysql_escape_string(DB.HANDLER, tablename).."` ("..keysstring..") VALUES ("..valuesstring..")";
    local response = mysql_query(DB.HANDLER, query);
    if response then
        result = tonumber(mysql_insert_id(DB.HANDLER));
    end
    return result;
end

function DB_delete(tablename, condition)
	local query = "DELETE FROM `"..tablename.."` WHERE "..condition..";";
    local response = mysql_query(DB.HANDLER, query);
	mysql_free_result(response);
    local affected = mysql_affected_rows(DB.HANDLER);
	return tonumer(affected);
end

function DB_update(tablename, data, condition)
    local updates = {};
    local row = 1;
	for key, value in pairs(data) do
        updates[row] = "`"..mysql_escape_string(DB.HANDLER, key).."` = '"..mysql_escape_string(DB.HANDLER, value).."'";
	end
    local updatesstring = table.concat(updates, ", ");

	local query = "UPDATE `"..mysql_escape_string(DB.HANDLER, tablename).."` SET "..updatesstring.." WHERE "..condition..";";
	local response = mysql_query(DB.HANDLER, query);
	if not(response) then
        return false;
    end
    mysql_free_result(response);
    local affected = tonumber(mysql_affected_rows(DB.HANDLER));
    if affected < 1 then
        return false;
    end
    return true;
end

function DB_exists(selection, tablename, condition)
    local responses = DB_select(selection, tablename, condition);
    for _key, _response in pairs(responses) do
        return true;
    end
    return false;
end