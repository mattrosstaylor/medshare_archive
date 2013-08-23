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
	'keywords',
	'course_programme_year',
	'view_permissions_type',
	'validation_status',
];

$c->{fields}->{eprint} = [@{$c->{fields}->{eprint}}, (
{
	name => 'course',
	type => 'compound',
	required => 1,
	fields => [
		{
			sub_name => 'programme_year',
			input_style => 'medium',
			type => 'namedset',
			set_name => "medshare_programme_year",
			required => 1,
			browse_link => 'programme_year',
		},
		{
			sub_name => 'module',
			type => 'namedset',
			set_name => 'medshare_module',
			required => 1,
			browse_link => 'module',
		}
	],
},

{
	name => 'themes',
	type => 'namedset',
	set_name => 'medshare_theme',
	multiple => 1,
	input_style => 'checkbox',
	'browse_link' => 'themes',
},

{
	name => 'subjects',
	type => 'namedset',
	set_name => 'medshare_subject',
	multiple => 1,
	input_style => 'checkbox',
	'browse_link' => 'subjects',
},

)];

# add ldap specific fields
push @{$c->{fields}->{user}},
{
	name => 'login_method',
	type => 'set',
	required => '1',
	options => [
		'internal',
		'ldap',
	],
	input_style => 'radio',
	allow_null => 0,
},
{
	name => 'ldap',
	type => 'compound',
	fields => [
		{
			sub_name => 'host',
			type => 'text',
		},
		{
			sub_name => 'distinguished_name',
			type => 'text',
		},
	],
};
;

$c->{allow_web_signup} = 0;

$c->{plugins}->{"InputForm::Component::Field::MedShareModuleSelect"}->{params}->{disable} = 0;
$c->{plugins}->{"MedShareUtils"}->{params}->{disable} = 0;
