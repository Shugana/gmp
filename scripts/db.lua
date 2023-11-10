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

function DB_select(selection, table, condition)
    local data = {};
    local query = "SELECT "..selection.." FROM "..table.." WHERE "..condition;
    local result = mysql_query(DB.HANDLER, query);
    local row = mysql_fetch_row(result);
    local length = 0;
    while row ~= nil do
        length = length + 1;
        data[length] = row;
        row = mysql_fetch_row(result);
    end
    mysql_free_result(DB.HANDLER);
    return data;
end