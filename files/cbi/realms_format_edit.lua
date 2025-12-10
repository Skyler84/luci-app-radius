local m, s, o

m = Map("radius_manager", translate("Edit Realm Format"))

s = m:section(NamedSection, arg[1], "realm_format", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "name", translate("Name"))
o.datatype = "string"
o.rmempty = false

o = s:option(ListValue, "type", translate("Type"))
o:value("prefix", translate("Prefix"))
o:value("suffix", translate("Suffix"))
o.rmempty = false

o = s:option(Value, "delimiter", translate("Delimiter"))
o.datatype = "string"
o.rmempty = false

o = s:option(Flag, "enabled", translate("Enabled"))
o.default = o.disabled
o.disabled = 0
o.enabled = 1

return m
