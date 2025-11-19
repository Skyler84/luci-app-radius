local m, s, o

m = Map("radius_manager", translate("Edit User"))

s = m:section(NamedSection, arg[1], "user", nil)
s.anonymous = true
s.addremove = false

o = s:option(Value, "password", translate("Password"), translate("Leave blank to keep existing password."))
o.password = true
o.rmempty = true

o = s:option(DummyValue, "password_updated", translate("Password Last Updated"))
o = s:option(DummyValue, "password_type", translate("Password Type"))

return m
