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

		m = new form.Map('radius_manager', _('Radius - Realms'), _('Realm Management.'));

		// Realm Formats section
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

		// Realms section
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

		return m.render();
	}
});
