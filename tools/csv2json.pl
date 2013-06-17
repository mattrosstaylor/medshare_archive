#!/usr/bin/perl

use JSON;
use strict;

my $column_list = {};

# get the csv file
my $path = $ARGV[0];

open FILE, $path;
my @lines = <FILE>;

# get the header line
my @headings = split(" ", shift(@lines));

foreach my $line (@lines)
{
	my @option_set = split(" ", $line);
	my $column_no = 0;
	my $prerequisite = "";
	foreach my $option (@option_set)
	{
		my $column_name = $headings[$column_no];
		# ensure that the array and hash elements exist to insert this option
		if ( not exists $column_list->{$column_name} )
		{
			$column_list->{$column_name} = {};
		}		
		if ( not exists $column_list->{$column_name}->{$option} )
		{
			$column_list->{$column_name}->{$option} = [];
		}

		# add the prerequisites for this option if it doesn't exist
		if ( not $prerequisite ~~ $column_list->{$column_name}->{$option} and not $prerequisite eq "" )
		{
			push( $column_list->{$column_name}->{$option}, $prerequisite );
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
print "var medshare_modules = ";
print to_json($column_list);
print ";
";
