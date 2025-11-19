local m, s, o, v

m = Map("radius_manager", translate("Radius - Settings"), translate("General settings."))

s = m:section(TypedSection, "settings", nil)
s.anonymous = true

o = s:option(ListValue, "password_storage", translate("Password Storage Method"), translate("Choose how user passwords are stored in the Radius server. \nOnly new or updated passwords will be affected by this setting."))
o:value("clear", translate("Cleartext (not recommended, most flexible)"))
o:value("bcrypt", translate("Bcrypt (secure, limits authentication methods)"))
o:value("ntlm", translate("NTLM (legacy, supports PEAP-MSCHAPV2)"))
o.default = "ntlm"

return m