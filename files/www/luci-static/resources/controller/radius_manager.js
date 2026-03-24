'use strict';
'require baseclass';

return baseclass.extend({
	title: _('Radius'),
	order: 70,

	hasRadiusConfig: function() {
		return L.resolveDefault(L.fs.stat('/etc/config/radius_manager'), null).then(function(stat) {
			return (stat != null);
		});
	},

	index: function() {
		var self = this;
		
		return this.hasRadiusConfig().then(function(hasConfig) {
			if (!hasConfig)
				return;

			var page = entry(['admin', 'services', 'radius_manager'], 
				alias('admin', 'services', 'radius_manager', 'users'), 
				self.title, self.order);

			entry(['admin', 'services', 'radius_manager', 'users'], 
				view('radius_manager/users'), _('Users'), 10);

			entry(['admin', 'services', 'radius_manager', 'clients'], 
				view('radius_manager/clients'), _('Clients'), 20);

			entry(['admin', 'services', 'radius_manager', 'realms'], 
				view('radius_manager/realms'), _('Realms'), 30);

			entry(['admin', 'services', 'radius_manager', 'servers'], 
				view('radius_manager/servers'), _('Servers'), 40);

			entry(['admin', 'services', 'radius_manager', 'settings'], 
				view('radius_manager/settings'), _('Settings'), 50);
		});
	}
});
