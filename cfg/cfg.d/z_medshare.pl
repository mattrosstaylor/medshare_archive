$c->{summary_page_metadata} = [qw/
	userid
	datestamp
	course_raw_programme_year
	course_raw_module
	keywords
	viewperms
/];

$c->{fields}->{eprint} = [@{$c->{fields}->{eprint}}, (
{
	'name' => 'course_raw',
	'type' => 'compound',
	'required' => '1',
	'fields' => [
		{
			'sub_name' => 'programme_year',
			'type' => 'namedset',
			'set_name' => "medshare_programme_year",
		},
		{
			'sub_name' => 'module',
			'type' => 'namedset',
			'set_name' => 'medshare_module',
		}
	],
},

{
	'name' => 'course',
	'type' => 'compound',
	'required' => 1,	
	'multiple' => 1,
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
		{
			'sub_name' => 'module',
			'type' => 'namedset',
			'set_name' => 'medshare_module',
		}
	],
}


)];

$c->{plugins}->{"InputForm::Component::Field::FacetCSV"}->{params}->{disable} = 0;

