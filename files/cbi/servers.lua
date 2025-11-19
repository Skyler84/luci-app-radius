local m, s, o

m = Map("radius_manager", translate("Radius - Servers"), translate("Server Management."))

s = m:section(TypedSection, "server", translate("Servers"))
s.template = "cbi/tblsection"
s.addremove = true
s.extedit = luci.dispatcher.build_url("admin", "services", "radius_manager", "servers", "edit", "%s")

return m