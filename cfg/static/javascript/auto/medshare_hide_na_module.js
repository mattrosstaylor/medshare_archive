// hide the na module from advanced search
document.observe( 'dom:loaded', function() {
	$$('#course_module_help_outer > table > tbody > tr > td > div > label > input[value="unspecified"]').each(function(i) {
		i.up('label').up('div').hide();
	});
});
