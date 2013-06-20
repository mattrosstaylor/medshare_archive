$c->{medshare_raw_course_expansion} = {
	"bm6_y0" => [
		{ "programme" => "bm6", "year" => "y0" },
	],
	"bm5_y1" => [

		{ "programme" => "bm5", "year" => "y1" },
		{ "programme" => "bm6", "year" => "y1" },
	],
	"bm5_y2" => [
		{ "programme" => "bm5", "year" => "y2" },
		{ "programme" => "bm6", "year" => "y2" },
	],
	"bm5_y3" => [
		{ "programme" => "bm5", "year" => "y3" },
		{ "programme" => "bm6", "year" => "y3" },
	],
	"bm5_y4" => [
		{ "programme" => "bm4", "year" => "y3" },
		{ "programme" => "bm5", "year" => "y4" },
		{ "programme" => "bm6", "year" => "y4" },
	],
	"bm5_y5" => [
		{ "programme" => "bm4", "year" => "y4" },
		{ "programme" => "bm5", "year" => "y5" },
		{ "programme" => "bm6", "year" => "y5" },
	],
	"bm4_y1" => [
		{ "programme" => "bm4", "year" => "y1" },
	],
	"bm4_y2" => [
		{ "programme" => "bm4", "year" => "y2" },
	],
};



# extra actions for eprint_automatic_fields
$c->{medshare_archive_set_eprint_automatic_fields} = $c->{set_eprint_automatic_fields}; 
$c->{set_eprint_automatic_fields} = sub
{
	my ($eprint) = @_;
	my $repo = $eprint->{session};

	$repo->call('medshare_archive_set_eprint_automatic_fields', $eprint);

	# expand out the course_raw field
	my $raw_course = $eprint->get_value( "raw_course_programme_year" ); 
	unless( EPrints::Utils::is_set( $raw_course ) )
	{ 
		$eprint->set_value( "course", undef ); 
	}
	else
	{
		my $relevant_expansion = $repo->get_conf("medshare_raw_course_expansion")->{$raw_course};
	
		$eprint->set_value( "course", $relevant_expansion );

	}

};

