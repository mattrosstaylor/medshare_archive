
# extra actions for eprint_automatic_fields
$c->{medshare_archive_set_eprint_automatic_fields} = $c->{set_eprint_automatic_fields}; 
$c->{set_eprint_automatic_fields} = sub
{
	my ($eprint) = @_;
	my $repo = $eprint->{session};

	$repo->call('medshare_archive_set_eprint_automatic_fields', $eprint);

	my $programme_year = $eprint->value( "course_programme_year" );
	# check for special case programme/year/module selection
	if ( defined $programme_year and ( $programme_year eq 'bm4_y1' or $programme_year eq 'bm4_y2' or $programme_year eq 'pg' ) )
	{
		$eprint->set_value( 'course_module', 'unspecified' );
	} 


};

