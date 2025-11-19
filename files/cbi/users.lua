local m, s, o

m = Map("radius_manager", translate("Radius - Users"), translate("User Accounts."))

s = m:section(NamedSection, "settings", translate("User Management Settings"))
o = s:option(Flag, "users_enabled", translate("Enable User Management"), translate("Set to '1' to enable user management. Set to '0' to disable it."))
o.default = o.enabled
o.enabled = 1
o.disabled = 0

s = m:section(TypedSection, "user", nil)
s.template = "cbi/tblsection"
s.addremove = true
s.extedit = luci.dispatcher.build_url("admin", "services", "radius_manager", "users", "edit", "%s")

s:option(DummyValue, "password", translate("Password"))
s:option(DummyValue, "password_updated", translate("Password Last Updated"))
s:option(DummyValue, "password_type", translate("Password Type"))


return m
