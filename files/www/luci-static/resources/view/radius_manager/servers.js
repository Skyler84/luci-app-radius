'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('radius_manager', _('Radius - Servers'), _('Server Management.'));

		s = m.section(form.GridSection, 'server', _('Servers'));
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

		return m.render();
	}
});
