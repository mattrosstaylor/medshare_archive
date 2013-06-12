package EPrints::Plugin::InputForm::Component::Field::FacetCSV;

use EPrints;
use EPrints::Plugin::InputForm::Component::Field;


@ISA = ( 'EPrints::Plugin::InputForm::Component::Field');

use strict;

sub new
{
	my( $class, %opts ) = @_;

	my $self = $class->SUPER::new( %opts );
	$self->{name} = 'Facet CSV';
        $self->{visible} = "all";

	return $self;
}


sub parse_config
{
	my( $self, $config_dom ) = @_;

	$self->{config}->{fields} = [];
	$self->{config}->{title} = $self->{session}->make_doc_fragment;

	$self->{config}->{csv} = $config_dom->getAttribute("csv");

	foreach my $node ( $config_dom->getChildNodes )
	{
		if( $node->nodeName eq "field" )
		{
			my $field = $self->xml_to_metafield( $node );
			return if !defined $field;
			push @{$self->{config}->{fields}}, $field;
		}

		if( $node->nodeName eq "title" )
		{
			$self->{config}->{title} = EPrints::XML::contents_of( $node );
		}
		if ( $node->nodeName eq "help" )
		{
			my $phrase_ref = $node->getAttribute( "ref" );
			$self->{config}->{help} = $self->{session}->make_element( "div", class=>"ep_sr_help_chunk" );
                        if( EPrints::Utils::is_set( $phrase_ref ) )
                        {
                                $self->{config}->{help}->appendChild( $self->{session}->html_phrase( $phrase_ref ) );
                        }
                        else
                        {
                                $self->{config}->{help} = EPrints::XML::contents_of( $node );
                        }
		}
	}
}

sub update_from_form
{
	my( $self, $processor ) =@_;

	my $obj = $self->{dataobj};

	# process stuff
}


sub parse_csv
{
	my( $self ) = @_;

	my $column_list = {};

	# get the csv file
	my $csv_path = $self->{repository}->get_conf( "archiveroot" )."/cfg/static/".$self->{config}->{csv};
	open my $file, $csv_path;

	foreach my $line (<$file>)
	{
		my @option_set = split(" ", $line);
		my $column_no = 0;
		my $prerequisite = "";
		foreach my $option (@option_set)
		{
			# ensure that the array and hash elements exist to insert this option
			if ( not exists $column_list->{$column_no} )
			{
				$column_list->{$column_no} = {};
			}		
			if ( not exists $column_list->{$column_no}->{$option} )
			{
				$column_list->{$column_no}->{$option} = [];
			}

			# add the prerequisites for this option if it doesn't exist
			if ( not $prerequisite ~~ $column_list->{$column_no}->{$option} and not $prerequisite eq "" )
			{
				push( $column_list->{$column_no}->{$option}, $prerequisite );
			}
	
			# add this option as a prerequistite for future options in this group 
			if (not $prerequisite eq "")
			{
				$prerequisite = $prerequisite."_".$option;
			}
			else
			{
				$prerequisite = $option;
			}

			$column_no++;
		}
	}

	return $column_list;
}

sub render_content
{
	my( $self, $surround ) = @_;

	$self->parse_csv;

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

sub has_help
{
	my( $self ) = @_;
	return defined $self->{config}->{help};
}

sub render_title
{
	my( $self, $surround ) = @_;
	return $self->{session}->clone_for_me( $self->{config}->{title}, 1 );
}

