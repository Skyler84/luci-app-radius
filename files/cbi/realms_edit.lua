local m, s, o

m = Map("radius_manager", translate("Edit Realm - ") .. arg[1])

s = m:section(NamedSection, arg[1], "realm", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "match", translate("Match"))
o.datatype = "string"
o.rmempty = false

o = s:option(Flag, "nostrip", translate("No Strip Realm"), translate("If enabled, the realm will not be stripped from the username during authentication."))
o.default = o.disabled
o.disabled = 0
o.enabled = 1

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
-- find all NamedSections of type "server"
-- and add their uciname as a value option
local uci = require("luci.model.uci").cursor()
uci:foreach("radius_manager", "server",
    function(s)
        o:value(s['.name'], s['.name'])
    end
)

return m
