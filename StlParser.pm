package StlParser;

use strict;
use warnings;

sub new {
    my $class = shift;
    my $infile = shift;
    my %options = @_;
    my $self = {
        infile  =>  $infile,
        %options
    };
    bless $class, $self;
    return $self;
}

sub parser {
    my $self = shift;
    my %options = @_;
    $self{$_} = $options{$_} foreach (sort keys %options);
# parse file
}
