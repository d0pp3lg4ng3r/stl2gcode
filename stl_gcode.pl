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
for(my $i = $zmin; $i < $zmax; $i += $offset) {
    my @lines;
#   foreach facet:
#       if facet is in current z layer:
#           get intersect line, and add it to the list of lines in this layer
#   take first line
    my $start_line = shift @lines;
    my @current_loop = ($start_line);
    push @loops, \@current_loop;
    my $line_found = 0;
#   find the line whose beginning point is within acceptable distance from the current point
    do {
        for (my $i = 0; $i < scalar @lines; $i++) {
            my $line = $lines[$i];
            if (abs($start_line->{x} - $line->{x}) < $offset) {
                if (abs($start_line->{y} - $line->{y}) < $offset) {
                    push @current_loop, $line;
                    splice @lines, $i, 1; #delete 1 item at offset $i from @lines (remove $lines[$i])
                    $start_line = $line;
                    $line_found = 1;
                    last;
                }
            }
        }
        if (!$line_found) {
#   if the beginning of the first line and the end of the last point don't match, die due to incomplete structure
            die "bad loop\n$!" if($current_loop[0]->{x} - $current_loop[-1]->{x} > $offset);
            die "bad loop\n$!" if($current_loop[0]->{y} - $current_loop[-1]->{y} > $offset);
#   if there are still unordered lines, repeat from 'take first line'
            $start_line = shift @lines;
            @current_loop = ($start_line);
            push @loops, \@current_loop;
        }
    } while (scalar @lines > 0);
        
#   repeat previous line until no lines can be found
}
