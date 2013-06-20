$c->{summary_page_metadata} = [qw/
	userid
	datestamp
	creators
	course
	raw_course_module
	themes
	subjects
	license
/];

# mrt - well, this is totally hardcoded to keywords
$c->{resourcemanager_filter_fields} = [
	'raw_course'
];

$c->{fields}->{eprint} = [@{$c->{fields}->{eprint}}, (
{
	'name' => 'raw_course',
	'type' => 'compound',
	'required' => 1,
	'fields' => [
		{
			'sub_name' => 'programme_year',
			'input_style' => 'medium',
			'type' => 'namedset',
			'set_name' => "medshare_programme_year",
			'required' => 1,
		},
		{
			'sub_name' => 'module',
			'type' => 'namedset',
			'set_name' => 'medshare_module',
			'required' => 1,
		}
	],
},

{
	'name' => 'course',
	'type' => 'compound',
	'required' => 1,	
	'multiple' => 1,
	'render_value' => 'EPrints::Plugin::MedShareUtils::render_course',
	'fields' => [
		{
			'sub_name' => 'programme',
			'type' => 'namedset',
			'set_name' => 'medshare_programme',
		},
		{
			'sub_name' => 'year',
			'type' => 'namedset',
			'set_name' => 'medshare_year',
		},
	],
},

{
	'name' => 'themes',
	'type' => 'namedset',
	'set_name' => 'medshare_theme',
	'multiple' => 1,
},

{
	'name' => 'subjects',
	'type' => 'namedset',
	'set_name' => 'medshare_subject',
	'multiple' => 1,
},

)];

$c->{plugins}->{"InputForm::Component::Field::MedShareModuleSelect"}->{params}->{disable} = 0;
$c->{plugins}->{"MedShareUtils"}->{params}->{disable} = 0;
