use strict;
use warnings;

use StlParser;

my $parser = StlParser->new($ARGV[0]);
my $facets = $parser->parse();

my ($xmin, $ymin, $zmin, $xmax, $ymax, $zmax);

my $offset = 0.1;

my @facets;
my @loops;

#foreach z layer:
for (my $z = $zmin; $z < $zmax; $z += $offset) {
    my $loops = make_loops($z);
    my $fill_lines = make_fill_lines($z);
    export($loops, $fill_lines);
}

sub make_fill_lines {
    my $z = shift;
    my $fill_lines = [];
    for (my $x = $xmin; $x <= $xmax, $x += $offset) {
        my @points;
        foreach my @loop (@loops) {
            foreach my @line (@loop) {
#               $x must be less than one point but greater than the other. if it is less than/greater than BOTH points, skip it
                next if ($x < $line[0]{x} && $x < $line[1]{x});
                next if ($x > $line[0]{x} && $x > $line[1]{x});
                my $slope = ($line[1]{y} - $line[0]{y})/($line[1]{x} - $line[0]{x});
                my $y = $slope * ($x - $line[0]{x}) + $line[0]{y};
                push @points, {x => $x, y => $y};
            }
        }
        @points = sort {$a->{y} <=> $b->{y}} @points;
        for ($i = 0; $i < @points; $i++) {
            push @{$fill_lines->[$i]}, $points[$i];
        }
    }
    return $fill_lines;
}
