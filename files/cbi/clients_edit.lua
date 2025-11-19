local m, s, o

m = Map("radius_manager", translate("Edit Client"))

s = m:section(NamedSection, arg[1], "client", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "ipaddr", translate("IP Address"))
o.datatype = "ipaddr"
o.rmempty = false

o = s:option(Value, "secret", translate("Secret"))
o.password = true
o.rmempty = false

return m
