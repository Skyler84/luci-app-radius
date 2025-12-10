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

o = s:option(Flag, "vlans_enabled", translate("VLANs Enabled"))
o.default = o.disabled
o.disabled = 0
o.enabled = 1

o = s:option(Value, "vlan", translate("VLAN"), translate("VLAN ID assigned to the user."))
o.datatype = "uinteger"
o.rmempty = false
o:depends("vlans_enabled", "1")

return m
