local m, s, o

m = Map("radius_manager", translate("Radius - Users"), translate("User Accounts."))

s = m:section(NamedSection, "settings", translate("User Management Settings"))
o = s:option(Flag, "users_enabled", translate("Enable User Management"), translate("Set to '1' to enable user management. Set to '0' to disable it."))
o.default = o.enabled
o.enabled = 1
o.disabled = 0

s = m:section(TypedSection, "user", nil)
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true

o = s:option(Value, "username", translate("Username"))
o.datatype = "uciname"
o.rmempty = false

o = s:option(Value, "password", translate("Password"), translate("Leave blank to keep existing password."))
o.password = true
o.rmempty = true

s:option(DummyValue, "password_updated", translate("Password Last Updated"))
s:option(DummyValue, "password_type", translate("Password Type"))


return m
