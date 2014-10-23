# Pod::Text::Color -- Convert POD data to formatted color ASCII text
# $Id: Color.pm,v 0.2 1999/07/29 15:42:19 eagle Exp $
#
# Copyright 1999 by Russ Allbery <rra@stanford.edu>
#
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.
#
# This is just a basic proof of concept.  It should later be modified to
# make better use of color, take options changing what colors are used for
# what text, and the like.

############################################################################
# Modules and declarations
############################################################################

package Pod::Text::Color;

require 5.004;

use Pod::PlainText ();
use Term::ANSIColor qw(colored);

use strict;
use vars qw(@ISA $VERSION);

@ISA = qw(Pod::SimpleText);

# Use the CVS revision of this file as its version number.
($VERSION = (split (' ', q$Revision: 0.2 $ ))[1]) =~ s/\.(\d)$/.0$1/;


############################################################################
# Overrides
############################################################################

# Make level one headings bold.
sub cmd_head1 {
    my $self = shift;
    local $_ = shift;
    s/\s+$//;
    $self->SUPER::cmd_head1 (colored ($_, 'bold'));
}

# Make level two headings bold.
sub cmd_head2 {
    my $self = shift;
    local $_ = shift;
    s/\s+$//;
    $self->SUPER::cmd_head2 (colored ($_, 'bold'));
}

# Fix the various interior sequences.
sub seq_b { return colored ($_[1], 'bold')   }
sub seq_f { return colored ($_[1], 'cyan')   }
sub seq_i { return colored ($_[1], 'yellow') }

# We unfortunately have to override the wrapping code here, since the normal
# wrapping code gets really confused by all the escape sequences.
sub wrap {
    my $self = shift;
    local $_ = shift;
    my $output = '';
    my $spaces = ' ' x $$self{MARGIN};
    my $width = $$self{width} - $$self{MARGIN};
    while (length > $width) {
        if (s/^((?:(?:\e\[[\d;]+m)?[^\n]){0,$width})\s+//
            || s/^((?:(?:\e\[[\d;]+m)?[^\n]){$width})//) {
            $output .= $spaces . $1 . "\n";
        } else {
            last;
        }
    }
    $output .= $spaces . $_;
    $output =~ s/\s+$/\n\n/;
    $output;
}

############################################################################
# Module return value and documentation
############################################################################

1;
__END__

=head1 NAME

Pod::Text::Color - Convert POD data to formatted color ASCII text

=head1 SYNOPSIS

    use Pod::Text::Color;
    my $parser = Pod::Text::Color->new (sentence => 0, width => 78);

    # Read POD from STDIN and write to STDOUT.
    $parser->parse_from_filehandle;

    # Read POD from file.pod and write to file.txt.
    $parser->parse_from_file ('file.pod', 'file.txt');

=head1 DESCRIPTION

Pod::Text::Color is a simple subclass of Pod::SimpleText that highlights
output text using ANSI color escape sequences.  Apart from the color, it in
all ways functions like Pod::SimpleText.  See L<Pod::SimpleText> for details
and available options.

=head1 SEE ALSO

L<Pod::PlainText|Pod::PlainText>, L<Pod::Parser|Pod::Parser>

=head1 AUTHOR

Russ Allbery E<lt>rra@stanford.eduE<gt>.

=cut
