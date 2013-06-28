
# extra actions for eprint_automatic_fields
$c->{medshare_archive_set_eprint_automatic_fields} = $c->{set_eprint_automatic_fields}; 
$c->{set_eprint_automatic_fields} = sub
{
	my ($eprint) = @_;
	my $repo = $eprint->{session};

	$repo->call('medshare_archive_set_eprint_automatic_fields', $eprint);


	# mrt - this might be redundent now, but I'll leave it in case i need it later

};

