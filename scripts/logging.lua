function log(msgtype, msg)
	msg = msg
        :gsub("�", "ae")
        :gsub("�", "oe")
        :gsub("�", "ue")
        :gsub("�", "ss")
        :gsub("�", "AE")
        :gsub("�", "OE")
        :gsub("�", "UE");
	local cur_date = os.date("%Y_%m_%d")
	if not(os.rename("logs/"..msgtype.."/","logs/"..msgtype.."/") and true or false) then
		os.execute("mkdir -pv logs/"..msgtype);
	end
	LogString("logs/" .. string.lower(msgtype) .."/"..string.lower(msgtype).. "_" .. cur_date, msg);
end