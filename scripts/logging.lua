function log(msgtype, msg)
	local cur_date = os.date("%Y_%m_%d")
	if not(os.rename("logs/"..msgtype.."/","logs/"..msgtype.."/") and true or false) then
		os.execute("mkdir -pv logs/"..msgtype);
	end
	LogString("logs/" .. string.lower(msgtype) .."/"..string.lower(msgtype).. "_" .. cur_date, msg);
end