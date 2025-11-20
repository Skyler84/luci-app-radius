local m, s, o

m = Map("radius_manager", translate("Radius - Clients"), translate("Radius Clients."))

s = m:section(TypedSection, "client", nil)
s.template = "cbi/tblsection"
s.anonymous = false
s.addremove = true
s.extedit = luci.dispatcher.build_url("admin", "services", "radius_manager", "clients", "edit", "%s")

o = s:option(DummyValue, "ipaddr", translate("IP Address"))

return m
