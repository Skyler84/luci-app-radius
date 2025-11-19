local m, s, o

m = Map("radius_manager", translate("Edit Realm"))

s = m:section(NamedSection, arg[1], "realm", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "name", translate("Name"))
o.datatype = "string"
o.rmempty = false

o = s:option(ListValue, "type", translate("Type"))
o:value("local", translate("LOCAL"))
o:value("proxy", translate("Proxy to another server"))
o:value("virtual", translate("Virtual Server"))
o.rmempty = false
o.default = "local"

o = s:option(ListValue, "target", translate("Target Server"), translate("If 'Proxy' type is selected, specify the target server here. Leave blank for 'Local' or 'Virtual' types."))
o.optional = false
o:depends("type", "proxy")
o:value("LOCAL", translate("LOCAL"))

return m
