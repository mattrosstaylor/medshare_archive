package EPrints::Plugin::MedShareUtils;

@ISA = ( "EPrints::Plugin" );

use strict;
use warnings;

sub render_course
{
        my ( $session , $field , $value, $alllangs, $nolink, $object ) = @_;

        if( scalar(@$value) == 0)
        {
                return $session->make_doc_fragment;
        }

        # let's not rendered a list for only a single name
        if(scalar(@$value) == 1)
        {
                my $course = $$value[0];

                return _render_single_course( $session, $course );
        }

        my $ul = $session->make_element( "ul", class=>"medshare_course");

        foreach my $course ( @$value )
        {
                my $li = $session->make_element( "li" );
                $ul->appendChild( $li );
                $li->appendChild( _render_single_course( $session, $course) );
        }

        return $ul;
}

sub _render_single_course
{
	my ( $session, $course) = @_;

	my $programme = $course->{programme};
	my $year = $course->{year};

	my $frag = $session->make_doc_fragment;

	my $course_text = $session->phrase("medshare_programme_typename_".$programme) ." ". $session->phrase("medshare_year_typename_".$year);

	$frag->appendChild( $session->make_text($course_text) );

	return $frag;
}

1;

