local m, s, o

m = Map("radius_manager", translate("Radius - Realms"), translate("Realm Management."))

s = m:section(TypedSection, "realm", nil)
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true