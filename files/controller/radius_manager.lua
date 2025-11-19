module("luci.controller.radius_manager", package.seeall)

function index()
        if not nixio.fs.access("/etc/config/radius_manager") then
                return
        end

        entry({"admin", "services", "radius_manager"},
                alias("admin", "services", "radius_manager", "users"),
                _("Radius"), 70)

        entry({"admin", "services", "radius_manager", "users"},
                cbi("radius_manager/users"), _("Users"), 10).leaf = true

        entry({"admin", "services", "radius_manager", "clients"},
                cbi("radius_manager/clients"), _("Clients"), 20).leaf = true

        entry({"admin", "services", "radius_manager", "realms"},
                cbi("radius_manager/realms"), _("Realms"), 30).leaf = true

        entry({"admin", "services", "radius_manager", "servers"},
                cbi("radius_manager/servers"), _("Servers"), 40).leaf = true

        entry({"admin", "services", "radius_manager", "settings"},
                cbi("radius_manager/settings"), _("Settings"), 50).leaf = true
end
