local m, s, o

m = Map("radius_manager", translate("Radius - Users"), translate("User Accounts."))

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
