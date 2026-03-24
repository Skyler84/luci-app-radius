'use strict';
'require view';
'require form';
'require uci';

return view.extend({
	render: function() {
		var m, s, o;

		m = new form.Map('radius_manager', _('Radius - Clients'), _('Radius Clients.'));

		s = m.section(form.GridSection, 'client', null);
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

		return m.render();
	}
});
