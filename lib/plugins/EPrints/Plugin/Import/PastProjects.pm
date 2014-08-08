package EPrints::Plugin::Import::PastProjects;

use EPrints;
use strict;

use Data::Dumper;
use File::Basename;
use File::BOM;
use Text::CSV;

our @ISA = qw/ EPrints::Plugin::Import::Compressed /;

sub new
{
	my( $class, %params ) = @_;
	my $self = $class->SUPER::new( %params );

	$self->{name} = "Import Past Projects";
	$self->{visible} = "all";
	$self->{advertise} = 0;
	$self->{produce} = [ "list/eprint" ];

	return $self;
}

sub input_file
{
	my( $self, %opts ) = @_;

	my $session = $self->{session};
	my $dataset = $opts{dataset};
	my $csv_path = $opts{filename};

	my $assignment_id;

	if ( basename( $csv_path, ".csv" ) =~ m/.*-([0-9]*)$/)
	{
		$assignment_id = $1;
	}
	else
	{
		$self->error( "Could not extract assignment_id" );
		return undef;
	}

	open( my $csv_file, '<:via(File::BOM)', $csv_path);

	my $csv = Text::CSV->new({
		binary => 1
	});

	# check the column headers are still correct

	my @expected_fields = ( 'SubmissionID','Student_Title','Student_Given_Name','Student_Family_Name','Project Report','Title','Field','Consent','Supervisor Name','Secondary Supervisor','Key words/phrases 1','Key words/phrases 2','Key words/phrases 3','Key words/phrases 4','Key words/phrases 5','Abstract','My Contribution','Main Body' );

	my $fields = $csv->getline( $csv_file );

	unless ( @expected_fields ~~ @$fields )
	{
		$self->error( "csv header mismatch." );
		close $csv_file;
		return undef;
	}
	$csv->column_names( $fields );

	# unpack the zip archive
	my $zip_path = $csv_path;
	$zip_path =~ s/csv$/zip/;
	my $fh;
	unless( open($fh, "<", $zip_path) )
	{
		$self->error("Could not open file $zip_path for import: $!");
		return undef;
	}
	binmode($fh);

	my( $type, $zipfile ) = $self->upload_archive($fh);
	my $dir = $self->add_archive($zipfile, $type );

	my @created;

	while ( my $row = $csv->getline_hr( $csv_file ) )
	{
		next unless $row->{Consent} eq "Yes";
		my $d = {};
		$d->{eprint_status} = "archive";
		$d->{type} = "project";
		$d->{validation_status} = "ok";
		$d->{project_assignment_id} = $assignment_id;
		$d->{project_submission_id} = $row->{SubmissionID};
		$d->{title} = $row->{Title};
		$d->{project_field} = $row->{Field};
		$d->{project_author} = {};
		$d->{project_author}->{honourific} = $row->{Student_Title};
		$d->{project_author}->{given} = $row->{Student_Given_Name};
		$d->{project_author}->{family} = $row->{Student_Family_Name};
		$d->{abstract} = "Research Project Report (2013-2014)";

		print $row->{Title}."\n";

		$d->{raw_keywords} = [];
		foreach ( 'Key words/phrases 1','Key words/phrases 2','Key words/phrases 3','Key words/phrases 4','Key words/phrases 5')
		{
			my $keyword = $row->{$_};
			$keyword =~ s/^\s+//m;
			$keyword =~ s/\s+$//m;
			push ( $d->{raw_keywords}, $keyword ) unless ( $keyword eq "" )
		}

		$d->{project_supervisor} = [];
		foreach ( 'Supervisor Name', 'Secondary Supervisor')
		{
			my $supervisor = $row->{$_};
			$supervisor =~ s/^\s+//m;
			$supervisor =~ s/\s+$//m;
			push ( $d->{project_supervisor}, $supervisor ) unless ( $supervisor eq "" )
		}

		$d->{view_permissions} = [];
		push $d->{view_permissions}, { type => 'restricted', value => 'restricted' };
		$d->{edit_permissions} = [];
		push $d->{edit_permissions}, { type => 'private', value => 'private' };

		# attempt to find the file
		my $file_found = 0;
		my $filename;
		my $filepath;

		eval { File::Find::find( {
			no_chdir => 1,
			wanted => sub {
				return if -d $File::Find::name;
				my $candidate = substr($File::Find::name, length($dir) + 1);

				if ( $candidate eq $row->{'Project Report'} )
				{
					$filepath = $File::Find::name;
					$filename = $candidate;
					$file_found = 1;
				}
			}
		}, $dir ) };

		if ( not $file_found )
		{
			$self->error($row->{'Project Report'} .' not found.');
			next;
		}
	
		$d->{documents} = [];
		my $media_info = {};
		$session->run_trigger( EPrints::Const::EP_TRIGGER_MEDIA_INFO,
			filename => $filename,
			filepath => $filepath,
			epdata => $media_info,
		);
		open(my $fh, "<", $filepath) or $self->error( "Error opening $filename: $!" );

		push $d->{documents}, {
			%$media_info,
			main => $filename,
			files => [{
				filename => $filename,
				filesize => -s $fh,
				mime_type => $media_info->{mime_type},
				_content => $fh,
			}],
		}; 
		push @created, $d;
	}
	close $csv_file;

	my @ids;
	foreach (@created)
	{
		my $dataobj = $self->epdata_to_dataobj( $dataset, $_ );
		push @ids, $dataobj->id if defined $dataobj;
	}

	return EPrints::List->new(
		session => $session,
		dataset => $dataset,
		ids => \@ids );

}
1;
