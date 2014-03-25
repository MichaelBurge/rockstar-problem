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

    my %maybe_rockstars;
    my %not_munchkins = map { $_ => 1 } @{ $graph->{vertices} };
    for my $v1 (@{ $graph->{vertices} }) {
	for my $v2 (keys %not_munchkins) {
	    if ($graph->{edges}->($v1, $v2)) {
		$maybe_rockstars{$v2} = 1;
	    } else {
		undef $not_munchkins{$v2};
	    }
	}
    }
    my %rockstars = set_intersection(\%maybe_rockstars, \%not_munchkins);
    return keys %rockstars;
}

sub print_results {
    my ($name, $graph) = @_;
    print "$name: " . join(',', find_rockstars($graph));
    print "\n";
}

print_results(Complete => $complete_graph);
print_results(Empty => $empty_graph);
