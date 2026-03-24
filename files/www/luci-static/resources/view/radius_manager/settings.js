'use strict';
'require view';
'require form';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('radius_manager', _('Radius - Settings'), _('General settings.'));

		s = m.section(form.NamedSection, 'settings', 'settings', null);
		s.anonymous = true;

		o = s.option(form.ListValue, 'password_storage', _('Password Storage Method'), 
			_('Choose how user passwords are stored in the Radius server. \nOnly new or updated passwords will be affected by this setting.'));
		o.value('clear', _('Cleartext (not recommended, most flexible)'));
		o.value('bcrypt', _('Bcrypt (secure, limits authentication methods)'));
		o.value('ntlm', _('NTLM (legacy, supports PEAP-MSCHAPV2)'));
		o.default = 'ntlm';

		return m.render();
	}
});
