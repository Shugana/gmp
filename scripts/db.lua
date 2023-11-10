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
	print("Connection to database established");
end