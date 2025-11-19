local m, s, o

m = Map("radius_manager", translate("Radius - Realms"), translate("Realm Management."))

s = m:section(TypedSection, "realm_format", translate("Realm Formats"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

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

s = m:section(TypedSection, "realm", translate("Realms"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

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