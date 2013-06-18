package EPrints::Plugin::InputForm::Component::Field::MedShareModuleSelect;

use EPrints;
use EPrints::Plugin::InputForm::Component::Field;

@ISA = ( 'EPrints::Plugin::InputForm::Component::Field');

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );
	$self->{name} = 'MedShare Module Select';
        $self->{visible} = "all";

	return $self;
}

sub render_content
{
	my( $self, $surround ) = @_;
	my $session = $self->{session};

	my $frag = $session->make_doc_fragment;

	foreach my $fieldname ( "programme_year", "module" )
	{
		my $field = $self->{dataobj}->{dataset}->field("course_raw_".$fieldname);


		print STDERR $field;
		# Get the field and its value/default
		my $value;

		if( $self->{dataobj} )
		{
			$value = $self->{dataobj}->get_value( $field->{name} );
		}
		else
		{
			$value = $self->{default};
		}

		my $area = $session->make_element("div", class=>"medshare_module_select_area_".$fieldname);
		$frag->appendChild($area);
		$area->appendChild( $field->render_name );
		$area->appendChild( $field->render_input_field(
			$self->{session},
			$value,
			undef,
			0,
			undef,
			$self->{dataobj},
			$self->{prefix},
		));
	}


	my $javascript = $session->make_element("script", type=>"text/javascript");
	$javascript->appendChild($session->make_text("var medshare_component=".$self->{prefix}.";"));
	$frag->appendChild($javascript);
        return $frag;

}


sub render_content2
{
	my( $self, $surround ) = @_;

        my $frag = $self->{session}->make_doc_fragment;

        my $table = $self->{session}->make_element( "table", class => "ep_multi" );
        $frag->appendChild( $table );

        my $tbody = $self->{session}->make_element( "tbody" );
        $table->appendChild( $tbody );
        my $first = 1;
        foreach my $field ( @{$self->{config}->{fields}} )
        {
                my %parts;
                $parts{class} = "";
                $parts{class} = "ep_first" if $first;
                $first = 0;

                $parts{label} = $field->render_name( $self->{session} );

                if( $field->{required} ) # moj: Handle for_archive
                {
                        $parts{label} = $self->{session}->html_phrase(
                                "sys:ep_form_required",
                                label=>$parts{label} );
                }

                $parts{help} = $field->render_help( $self->{session} );


                # Get the field and its value/default
                my $value;
                if( $self->{dataobj} )
                {
                        $value = $self->{dataobj}->get_value( $field->{name} );
                }
                else
                {
                        $value = $self->{default};
                }
                $parts{field} = $field->render_input_field(
                        $self->{session},
                        $value,
                        undef,
                        0,
                        undef,
                        $self->{dataobj},
                        $self->{prefix},

                  );

                @parts{qw( no_help no_toggle )} = @$self{qw( no_help no_toggle )};

                $parts{help_prefix} = $self->{prefix}."_help_".$field->get_name;

                $table->appendChild( $self->{session}->render_row_with_help( %parts ) );
        }

        $frag->appendChild( $self->{session}->make_javascript( <<EOJ ) );
new Component_Field ('$self->{prefix}');
EOJ

        return $frag;
}
