module("luci.controller.radius_manager", package.seeall)

function index()
        if not nixio.fs.access("/etc/config/radius_manager") then
                return
        end

        entry({"admin", "services", "radius_manager"},
                alias("admin", "services", "radius_manager", "users"),
                _("Radius"), 70)

        entry({"admin", "services", "radius_manager", "users"},
                cbi("radius_manager/users"), _("Users"), 10)

        entry({"admin", "services", "radius_manager", "users", "edit"},
                cbi("radius_manager/users_edit")).leaf = true

        entry({"admin", "services", "radius_manager", "clients"},
                cbi("radius_manager/clients"), _("Clients"), 20)

        entry({"admin", "services", "radius_manager", "clients", "edit"},
                cbi("radius_manager/clients_edit")).leaf = true

        entry({"admin", "services", "radius_manager", "realms"},
                cbi("radius_manager/realms"), _("Realms"), 30)

        entry({"admin", "services", "radius_manager", "realms", "format_edit"},
                cbi("radius_manager/realms_format_edit")).leaf = true

        entry({"admin", "services", "radius_manager", "realms", "realm_edit"},
                cbi("radius_manager/realms_edit")).leaf = true

        entry({"admin", "services", "radius_manager", "servers"},
                cbi("radius_manager/servers"), _("Servers"), 40)

        entry({"admin", "services", "radius_manager", "servers", "edit"},
                cbi("radius_manager/servers_edit")).leaf = true

        entry({"admin", "services", "radius_manager", "settings"},
                cbi("radius_manager/settings"), _("Settings"), 50).leaf = true
end
