local m, s, o

m = Map("radius_manager", translate("Edit Server"))

s = m:section(NamedSection, arg[1], "server", nil)
s.anonymous = true
s.addremove = false

-- Add server-specific options here based on your configuration needs
-- For example:
-- o = s:option(Value, "host", translate("Host"))
-- o.datatype = "host"
-- o.rmempty = false

return m
