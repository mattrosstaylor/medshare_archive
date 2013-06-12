$c->{summary_page_metadata} = [qw/
	userid
	datestamp
	medshare_programme
	medshare_year
	medshare_module
	keywords
	viewperms
/];

$c->{fields}->{eprint} = [@{$c->{fields}->{eprint}}, (
{
	'name' => 'medshare_programme',
	'required' => 1,	
	'type' => 'set',
	'options' => [
		'bm1',
		'bm2',
		'bm2_alt',
		'bm3',
	],
},
{
	'name' => 'medshare_year',
	'required' => 1,	
	'type' => 'set',
	'options' => [
		'y1',
		'y2',
		'y0',
	],
},
{
	'name' => 'medshare_module',
	'required' => 1,	
	'type' => 'set',
	'options' => [
		'module1',
		'module2',
		'module3',
		'module4',
		'module6',
		'module7',
		'module8',
		'module9',
	],
}


)];

$c->{plugins}->{"InputForm::Component::Field::FacetCSV"}->{params}->{disable} = 0;

