$c->{browse_views} = [@{$c->{browse_views}}, (
{
	id => "programme_year",
	menus => [
	{
		fields => [ "course_programme_year" ],
		reverse_order => 1,
		new_column_at => [10,10],
	}
	],
	order => "title",
	citation => "result",
},
{
	id => "module",
	menus => [
	{
		fields => [ "course_module" ],
		new_column_at => [10,10],
	}
	],
	order => "title",
	citation => "result",
},

{
	id => "subjects",
	menus => [
	{
		fields => [ "subjects" ],
		new_column_at => [10,10],
	}
	],
	order => "title",
	citation => "result",
},


{
	id => "themes",
	menus => [
	{
		fields => [ "themes" ],
		new_column_at => [10,10],
	}
	],
	order => "title",
	citation => "result",
},

{
	id => "project_field",
	menus => [
	{
		fields => [ "project_field" ],
		new_column_at => [10, 10],
	}
	],
	order => "title",
	citation => "result",
},
)];
