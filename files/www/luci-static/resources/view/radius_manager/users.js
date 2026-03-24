'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('radius_manager', _('Radius - Users'), _('User Accounts.'));

		s = m.section(form.NamedSection, 'settings', 'settings', _('User Management Settings'));
		o = s.option(form.Flag, 'users_enabled', _('Enable User Management'), 
			_('Set to \'1\' to enable user management. Set to \'0\' to disable it.'));
		o.default = '1';

		s = m.section(form.GridSection, 'user', null);
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

		return m.render();
	}
});
