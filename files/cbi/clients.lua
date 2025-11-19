local m, s, o

m = Map("radius_manager", translate("Radius - Clients"), translate("Radius Clients."))

s = m:section(TypedSection, "client", nil)
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

o = s:option(Value, "name", translate("Short Name"))
o.datatype = "uciname"
o.rmempty = false

o = s:option(Value, "ipaddr", translate("IP Address"))
o.datatype = "ipaddr"
o.rmempty = false

o = s:option(Value, "secret", translate("Secret"))
o.password = true
o.rmempty = false

return m
