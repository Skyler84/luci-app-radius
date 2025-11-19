local m, s, o

m = Map("radius_manager", translate("Radius - Servers"), translate("Server Management."))

s = m:section(TypedSection, "server", translate("Servers"))

return m