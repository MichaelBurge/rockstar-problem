use strict;

my $complete_graph = {
    vertices => [qw/ a b c d e /],
    edges => sub {
	return 1;
    },
};

my $empty_graph = {
    vertices => [qw/ a b c d e /],
    edges => sub {
	return 0;
    },
};

my $hub_graph = {
    vertices => [qw/ a b c d e /],
    edges => sub {
	my (undef, $vertex) = @_;
	return $vertex eq 'a';
    },
};

# Complete graph except that:
# * a is connected to every vertex(a is a rockstar)
# * Every other vertex has exactly 1 missing connection
my @froms = split //, "abcdefghijklmnopqrstuvwxyz";
my @tos = split //,    "bcdefghijklmnopqrstuvwxyz";
my $almost_complete_graph = sub {
    my ($n) = @_;
    my @indices = (0..$n-1);
    my %missings =
	map { $froms[$_] => $tos[$_] }
          @indices;
    return {
	vertices => [ @froms[@indices] ],
	edges => sub {
	    my ($a, $b) = @_;
	    return 0 if $b eq $missings{$a};
	    return 1;
	},
    };
};

sub set_intersection {
    my ($a, $b) = @_;
    my %accum;
    for my $key (keys %$a) {
	$accum{$key} = 1 if exists($b->{$key});
    }
    return %accum;
}

sub find_rockstars {
    my ($graph) = @_;

    my @vertices = @{ $graph->{vertices} };
    my %popular = map { $_ => 1 } @vertices;
    for my $v1 (@vertices) {
	for my $v2 (@vertices) {
	    if (!($graph->{edges}->($v1, $v2))) {
		delete $popular{$v2};
	    }
	}
    }
    return keys %popular;
}

sub print_results {
    my ($name, $graph) = @_;
    print "$name: " . join(',', find_rockstars($graph));
    print "\n";
}

sub print_graph {
    my ($graph) = @_;
    my @vertices = @{ $graph->{vertices} };
    print "Vertices: " . join(',', @vertices) . "\n";
    print "Edges:\n";
    for my $a (@vertices) {
	for my $b (@vertices) {
	    next unless $graph->{edges}->($a, $b);
	    print "$a|$b\n";
	}
    }
}

print_results(Complete => $complete_graph);
print_results(Empty => $empty_graph);
print_results(Hub => $hub_graph);
print_results(Almost => $almost_complete_graph->(5));

#print_graph($almost_complete_graph->(5));
