$c->{browse_views} = [@{$c->{browse_views}}, (
{
	id => "programme_year",
	menus => [
	{
		fields => [ "course_programme_year" ],
		reverse_order => 1,
		allow_null => 1,
		new_column_at => [10,10],
	}
	],
	order => "creators_name/title",
	citation => "result",
	variations => [
		"creators_name;first_letter",
#		"type",
		"DEFAULT"
	],
},
{
	id => "module",
	menus => [
	{
		fields => [ "course_module" ],
		reverse_order => 1,
		allow_null => 1,
		new_column_at => [10,10],
	}
	],
	order => "creators_name/title",
	citation => "result",
	variations => [
		"creators_name;first_letter",
#		"type",
		"DEFAULT"
	],
},

{
	id => "subjects",
	menus => [
	{
		fields => [ "subjects" ],
		reverse_order => 1,
		allow_null => 1,
		new_column_at => [10,10],
	}
	],
	order => "creators_name/title",
	citation => "result",
	variations => [
		"creators_name;first_letter",
#		"type",
		"DEFAULT"
	],
},


{
	id => "themes",
	menus => [
	{
		fields => [ "themes" ],
		reverse_order => 1,
		allow_null => 1,
		new_column_at => [10,10],
	}
	],
	order => "creators_name/title",
	citation => "result",
	variations => [
		"creators_name;first_letter",
#		"type",
		"DEFAULT"
	],
},

)];
