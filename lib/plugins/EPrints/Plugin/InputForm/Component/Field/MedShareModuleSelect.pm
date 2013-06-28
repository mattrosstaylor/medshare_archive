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
	my $table = $session->make_element("table", class=>"ep_multi");
	my $row = $session->make_element("tr");
	$table->appendChild($row);

	foreach my $fieldname ( "programme_year", "module" )
	{
		my $field = $self->{dataobj}->{dataset}->field("course_".$fieldname);

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

		my $title = $session->make_element("th", class=>"ep_multi_heading");
		$title->appendChild( $field->render_name );
		$title->appendChild( $session->make_text(":"));
		$row->appendChild( $title );
		my $area = $session->make_element("td", class=>"medshare_module_select_area_".$fieldname);
		$row->appendChild($area);
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
	$javascript->appendChild($session->make_text("var medshare_component='".$self->{prefix}."';"));
	$table->appendChild($javascript);
        return $table;

}
