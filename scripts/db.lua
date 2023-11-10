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
        .." WHERE "..mysql_escape_string(DB.HANDLER, condition);
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
    keysstring = table.concat(keys, ", ");
    valuesstring = table.concat(values, ", ");
    
    local query = "INSERT INTO `"..mysql_escape_string(DB.HANDLER, tablename).."` ("..keysstring..") VALUES ("..valuesstring..")";
    sendINFOMessage(0, query);
    local response = mysql_query(DB.HANDLER, query);
    if response then
        result = mysql_insert_id(DB.HANDLER);
    end
    return result;
end