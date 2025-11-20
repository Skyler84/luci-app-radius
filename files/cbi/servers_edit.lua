local m, s, o

m = Map("radius_manager", translate("Edit Server - ") .. arg[1])

s = m:section(NamedSection, arg[1], "server", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "host", translate("Host"))
o.datatype = "host"

o = s:option(Value, "port", translate("Port"))
o.datatype = "port"

o = s:option(ListValue, "type", translate("Type"))
o:value("auth", translate("Authentication Server"))
o:value("acct", translate("Accounting Server"))
o:value("auth+acct", translate("Authentication + Accounting Server"))


return m
