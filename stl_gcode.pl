use strict;
use warnings;

use StlParser;

my $parser = StlParser->new($ARGV[0]);

my $facets = $parser->parse();


#foreach z layer:
#   foreach facet:
#       if facet is in current z layer:
#           get intersect line, and add it to the list of lines in this layer
#   take first line
#   find the line whose beginning point is within acceptable distance from the current point
#   repeat previous line until no lines can be found
#   if the beginning of the first line and the end of the last point don't match, die due to incomplete structure
#   if there are still unordered lines, repeat from 'take first line'
