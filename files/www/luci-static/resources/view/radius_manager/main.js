'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	load: function() {
		return uci.load('radius_manager');
	},

	render: function() {
		var m, s, o;

		m = new form.Map('radius_manager', _('Radius Manager'), _('Manage RADIUS server configuration.'));
		m.tabbed = true;

		// ============ Users Tab ============
		s = m.section(form.GridSection, 'user', _('Users'));
		s.addremove = true;
		s.anonymous = false;
		s.modaltitle = function(section_id) {
			return _('Edit User') + ' » ' + section_id;
		};

		o = s.option(form.Flag, 'enabled', _('Enabled'));
		o.default = '0';
		o.editable = true;

		o = s.option(form.DummyValue, 'password_updated', _('Password Last Updated'));

		o = s.option(form.DummyValue, 'password_type', _('Password Type'));

		o = s.option(form.Value, 'password', _('Password'), 
			_('Leave blank to keep existing password.'));
		o.password = true;
		o.rmempty = true;
		o.modalonly = true;

		o = s.option(form.Flag, 'vlans_enabled', _('VLANs Enabled'));
		o.default = '0';
		o.modalonly = true;

		o = s.option(form.Value, 'vlan', _('VLAN'), _('VLAN ID assigned to the user.'));
		o.datatype = 'uinteger';
		o.rmempty = false;
		o.depends('vlans_enabled', '1');
		o.modalonly = true;

		// ============ Clients Tab ============
		s = m.section(form.GridSection, 'client', _('RADIUS Clients'));
		s.anonymous = false;
		s.addremove = true;
		s.modaltitle = function(section_id) {
			return _('Edit Client') + ' » ' + section_id;
		};

		o = s.option(form.Value, 'ipaddr', _('IP Address'));
		o.datatype = 'ipaddr';
		o.rmempty = false;

		o = s.option(form.Value, 'secret', _('Secret'));
		o.password = true;
		o.rmempty = false;
		o.modalonly = true;

		// ============ Realms Tab ============
		s = m.section(form.GridSection, 'realm_format', _('Realm Formats'));
		s.anonymous = true;
		s.addremove = true;
		s.modaltitle = function(section_id) {
			return _('Edit Realm Format');
		};

		o = s.option(form.Value, 'name', _('Name'));
		o.datatype = 'string';
		o.rmempty = false;

		o = s.option(form.ListValue, 'type', _('Type'));
		o.value('prefix', _('Prefix'));
		o.value('suffix', _('Suffix'));
		o.rmempty = false;

		o = s.option(form.Value, 'delimiter', _('Delimiter'));
		o.datatype = 'string';
		o.rmempty = false;
		o.modalonly = true;

		o = s.option(form.Flag, 'enabled', _('Enabled'));
		o.default = '0';
		o.editable = true;

		// Realms section (same tab)
		s = m.section(form.GridSection, 'realm', _('Realms'));
		s.anonymous = false;
		s.addremove = true;
		s.modaltitle = function(section_id) {
			return _('Edit Realm') + ' » ' + section_id;
		};

		o = s.option(form.Value, 'match', _('Matches'));
		o.datatype = 'string';
		o.rmempty = false;

		o = s.option(form.Flag, 'nostrip', _('No Strip Realm'));
		o.default = '0';
		o.editable = true;

		o = s.option(form.ListValue, 'type', _('Type'));
		o.value('local', _('LOCAL'));
		o.value('proxy', _('Proxy to another server'));
		o.value('virtual', _('Virtual Server'));
		o.default = 'local';
		o.rmempty = false;

		o = s.option(form.ListValue, 'target', _('Target Server'), 
			_('If \'Proxy\' type is selected, specify the target server here. Leave blank for \'Local\' or \'Virtual\' types.'));
		o.depends('type', 'proxy');
		o.value('LOCAL', _('LOCAL'));
		// Add server options dynamically
		uci.sections('radius_manager', 'server', function(s) {
			o.value(s['.name'], s['.name']);
		});
		o.optional = false;
		o.modalonly = true;

		// ============ Servers Tab ============
		s = m.section(form.GridSection, 'server', _('RADIUS Servers'));
		s.addremove = true;
		s.anonymous = true;
		s.modaltitle = function(section_id) {
			return _('Edit Server') + ' » ' + section_id;
		};

		o = s.option(form.Value, 'host', _('Host'));
		o.datatype = 'host';
		o.rmempty = false;

		o = s.option(form.Value, 'port', _('Port'));
		o.datatype = 'port';
		o.rmempty = false;

		o = s.option(form.ListValue, 'type', _('Type'));
		o.value('auth', _('Authentication Server'));
		o.value('acct', _('Accounting Server'));
		o.value('auth+acct', _('Authentication + Accounting Server'));
		o.rmempty = false;

		// ============ Settings Tab ============
		s = m.section(form.NamedSection, 'settings', _('Settings'));

		o = s.option(form.Flag, 'users_enabled', _('Enable User Management'), 
			_('Set to \'1\' to enable user management. Set to \'0\' to disable it.'));
		o.default = '1';

		o = s.option(form.ListValue, 'password_storage', _('Password Storage Method'), 
			_('Choose how user passwords are stored in the Radius server. \nOnly new or updated passwords will be affected by this setting.'));
		o.value('clear', _('Cleartext (not recommended, most flexible)'));
		o.value('bcrypt', _('Bcrypt (secure, limits authentication methods)'));
		o.value('ntlm', _('NTLM (legacy, supports PEAP-MSCHAPV2)'));
		o.default = 'ntlm';

		return m.render();
	}
});
