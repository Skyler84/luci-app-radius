local m, s, o

m = Map("radius_manager", translate("Radius - Realms"), translate("Realm Management."))

s = m:section(TypedSection, "realm_format", translate("Realm Formats"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.extedit = luci.dispatcher.build_url("admin", "services", "radius_manager", "realms", "format_edit", "%s")

o = s:option(DummyValue, "name", translate("Name"))

o = s:option(DummyValue, "type", translate("Type"))

o = s:option(DummyValue, "delimiter", translate("Delimiter"))

o = s:option(DummyValue, "enabled", translate("Enabled"))

s = m:section(TypedSection, "realm", translate("Realms"))
s.template = "cbi/tblsection"
s.anonymous = true
s.addremove = true
s.extedit = luci.dispatcher.build_url("admin", "services", "radius_manager", "realms", "realm_edit", "%s")

o = s:option(DummyValue, "name", translate("Name"))

o = s:option(DummyValue, "type", translate("Type"))

o = s:option(DummyValue, "target", translate("Target Server"))



return m