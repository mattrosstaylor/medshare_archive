$c->{summary_page_metadata} = [qw/
	userid
	datestamp
	creators
	course_programme_year
	course_module
	themes
	subjects
	keywords
	license
/];

# mrt - well, this is totally hardcoded to keywords
$c->{resourcemanager_filter_fields} = [
	'raw_course'
];

$c->{fields}->{eprint} = [@{$c->{fields}->{eprint}}, (
{
	'name' => 'course',
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
	'name' => 'themes',
	'type' => 'namedset',
	'set_name' => 'medshare_theme',
	'multiple' => 1,
	'input_style' => 'checkbox',
},

{
	'name' => 'subjects',
	'type' => 'namedset',
	'set_name' => 'medshare_subject',
	'multiple' => 1,
	'input_style' => 'checkbox',
},

)];


$c->{search}->{advanced} = 
{
# EdShare - Made new fields searchable and added some new order methods
	search_fields => [
		{ meta_fields => [ $EPrints::Utils::FULLTEXT ] },
		{ meta_fields => [ "title" ] },
		{ meta_fields => [ "creators_name" ] },
		{ meta_fields => [ "abstract" ] },
		{ meta_fields => [ "raw_course_programme_year" ] },
		{ meta_fields => [ "raw_course_module" ] },
		{ meta_fields => [ "themes" ] },
		{ meta_fields => [ "subjects" ] },
		{ meta_fields => [ "keywords" ] },
		{ meta_fields => [ "documents.format" ] },
	],
	preamble_phrase => "cgi/advsearch:preamble",
	title_phrase => "cgi/advsearch:adv_search",
	citation => "result",
	page_size => 20,
	order_methods => {
		"byyear" 	 => "-datestamp/creators_name/title",
		"byyearoldest"	 => "datestamp/creators_name/title",
		"byname"  	 => "creators_name/-datestamp/title",
		"bytitle" 	 => "title/creators_name/-datestamp"
	},
	default_order => "byyear",
	show_zero_results => 1,
};

$c->{plugins}->{"InputForm::Component::Field::MedShareModuleSelect"}->{params}->{disable} = 0;
$c->{plugins}->{"MedShareUtils"}->{params}->{disable} = 0;
