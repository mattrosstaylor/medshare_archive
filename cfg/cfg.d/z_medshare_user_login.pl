
# This function allows you to override the default username/password
# authentication. For example, you could apply different authentication rules to 
# different types of user.
#
# Example: LDAP Authentication (Quick Start)
#
# Tip: use the test script to determine your LDAP parameters first!
# Tip: remove the set-password priviledge from users and editors in
# user_roles.pl. Also consider removing edit-own-record and 
# change-email.
#
$c->{check_user_password} = sub {
	my( $session, $username, $password ) = @_;

	my $user = EPrints::DataObj::User::user_with_username( $session, $username );
	return unless $user;

	my $whitelist_status = $user->value( 'whitelist_status' );

	if ( $whitelist_status eq 'blocked' )
	{
		return;
	}

	my $login_method = $user->value( 'login_method' );
	if( $login_method eq 'internal' )
	{
		# internal authentication for "admin" type
		return $session->get_database->valid_login( $username, $password );
	}
	elsif ( $login_method eq 'ldap' )
	{
		my $ldap_host = "ldaps://nlbldap.soton.ac.uk";
		my $ldap_dn = $user->value( 'ldap_distinguished_name' );

		use Net::LDAP; 

		my $ldap = Net::LDAP->new ( $ldap_host, version => 3 );
		unless( $ldap )
		{
			print STDERR "LDAP error: $@\n";
			return;
		}

		# Check password
		my $mesg = $ldap->bind( $ldap_dn, password => $password );
		if( $mesg->code() )
		{
			return;
		}
		return $username;
	}
	return;
}
# Advanced LDAP Configuration
#
# 1. It is also possible to define additional user types, each with a different
# authentication mechanism. For example, you could keep the default user, 
# editor and admin types and add ldapuser, ldapeditor and ldapadmin types with
# LDAP authentication - this would suit an arrangement where internal staff are 
# authenticated against the LDAP server but user accounts can still be granted 
# to external users.
#
# 2. Sometimes the distinguished name of the user is not computable from the 
# username. You may need to use values from the user metadata (e.g. name_given,
# name_family):
#
#	my $name = $user->get_value( "name" );
#	my $ldap_dn = $name->{family} . ", " . $name->{given} .", ou=yourorg, dc=yourdomain";
#
# or perform an LDAP lookup to determine it (more complicated):
#
#	my $base = "ou=yourorg, dc=yourdomain";
#	my $result = $ldap->search (
#		base    => "$base",
#		scope   => "sub",
#		filter  => "cn=$username",
#		attrs   =>  ['DN'],
#		sizelimit=>1
#	);
#
#	my $entr = $result->pop_entry;
#	unless( defined $entr )
#	{
#		return 0;
#	}
#	my $ldap_dn = $entr->dn
#
#Alternatively Alternatively, you could store the distinguished name as part of the user 
# metadata when the user account is imported 
