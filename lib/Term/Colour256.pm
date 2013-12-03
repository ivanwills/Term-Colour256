package Term::Colour256;

# Created on: 2010-10-11 13:31:47
# Create by:  Ivan Wills
# $Id$
# $Revision$, $HeadURL$, $Date$
# $Revision$, $Source$, $Date$

use strict;
use warnings;
use version;
use Carp qw/confess longmess/;
use Data::Dumper qw/Dumper/;
use English qw/ -no_match_vars /;
use base qw/Exporter/;

our $VERSION     = version->new('0.0.1');
our @EXPORT_OK   = qw/colour coloured color colored push_colour push_color pop_colour pop_color/;
our %EXPORT_TAGS = ();

my $global;

sub new {
    my ($class) = @_;
    return bless $class, { colours => [] };
}

sub colour {
    my @colours = map { split /\s+|_/, $_ || '0' } @_;
    my $out = '';

    for ( my $i = 0; $i < @colours; $i++ ) {
        my $colour;
        my $on;
        if ( $colours[$i] eq 'on' ) {
            $i++;
            $colour = $colours[$i];
            $on = 1;
        }
        else {
            $colour = $colours[$i];
        }
        $out .= map_colour($colour, $on);
    }

    return $out;
}

*Term::Colour256::color = \&colour;

sub coloured {
    my ( $colours, @string ) = @_;

    return join '', colour( ref $colours eq 'ARRAY' ? @{ $colours } : $colours ), @string, colour('reset');
}

*Term::Colour256::colored = \&coloured;

sub push_colour {
    my @colours = @_;
    my $self;
    my $out;

    if ( $colours[0] eq __PACKAGE__ || ! ref $colours[0] || !$colours[0]->isa(__PACKAGE__) ) {
        $global ||= __PACKAGE__->new;
        $self = $global;
    }
    else {
        $self = shift @colours;
    }

    push @{$self->colours}, '';
    for ( my $i = 0; $i < @colours; $i++ ) {
        my $colour;
        my $on;
        if ( $colours[$i] eq 'on' ) {
            $i++;
            $colour = $colours[$i];
            $on = 1;
        }
        else {
            $colour = $colours[$i];
        }
        $self->colours->[-1] .= map_colour($colour, $on);
    }

    return $self->colours->[-1];
}

*Term::Colour256::push_color = \&push_colour;

sub pop_colour {
    my @colours = @_;
    my $self;
    my $out;

    if ( $colours[0] eq __PACKAGE__ || ! ref $colours[0] || !$colours[0]->isa(__PACKAGE__) ) {
        $global ||= __PACKAGE__->new;
        $self = $global;
    }
    else {
        $self = shift @colours;
    }
    pop @{$self->colours};

    return "\e[0m;" . join '', @{$self->colours};
}

*Term::Colour256::pop_color = \&pop_colour;

sub map_colour {
    my ($colour, $on) = @_;
    my $value;

    if ( $colour =~ /^\d+$/ ) {
        $value = $colour;
    }
    elsif ( $colour =~ /^[a-zA-Z]/ ) {
        $value = map_names()->{$colour} || confess "Unknown colour $colour!";
    }
    elsif ( my ($rgb) = $colour =~ /^\#( [0-9A-Fa-f]+ )$/xms ) {
        my ($r, $g, $b);
        my $map_rgb = map_rgb();
        if ( length $rgb == 3 ) {
            ($r, $g, $b) = split //, $rgb;
            $r .= $r;
            $g .= $g;
            $b .= $b;
        }
        elsif ( length $rgb == 6 ) {
            $r = substr $rgb, 0, 2;
            $g = substr $rgb, 2, 2;
            $b = substr $rgb, 4, 2;
        }
        else {
            confess "Bad RGB value #$rgb\n";
        }

        $r = lc $r;
        $g = lc $g;
        $b = lc $b;

        if ( $map_rgb->{$r}{$g}{$b} ) {
            $value = $map_rgb->{$r}{$g}{$b};
        }
        else {
            confess "Haven't yet worked out this logic ";
        }
    }

    $colour = ref $value ? "\e[${$value}m" : $on ? "\e[48;5;${value}m" : "\e[38;5;${value}m";

    return $colour;
}

sub map_names {
    return {
        clear      => \'0',
        reset      => \'0',
        bold       => \'1',
        dark       => \'2',
        faint      => \'2',
        underline  => \'4',
        underscore => \'4',
        blink      => \'5',
        reverse    => \'7',
        concealed  => \'8',

        red           => 1,
        green         => 2,
        orange        => 3,
        blue          => 4,
        magenta       => 5,
        cyan          => 6,
        silver        => 7,
        grey          => 8,
        light_red     => 9,
        light_green   => 10,
        yellow        => 11,
        light_blue    => 12,
        light_magenta => 13,
        light_cyan    => 14,
        white         => 15,
        black         => 16,
    };
}

sub map_numbers {
    return {
        # NO_COLOUR   => "\e[0m"
        # BLACK       => "\e[0;30m"
        # RED         => "\e[0;31m"
        # GREEN       => "\e[0;32m"
        # BROWN       => "\e[0;33m"
        # BLUE        => "\e[0;34m"
        # PURPLE      => "\e[0;35m"
        # CYAN        => "\e[0;36m"
        # LIGHT_GRAY  => "\e[0;37m"
        # DARK_GRAY   => "\e[1;30m"
        # LIGHT_RED   => "\e[1;31m"
        # LIGHT_GREEN => "\e[1;32m"
        # YELLOW      => "\e[1;33m"
        # LIGHT_BLUE  => "\e[1;34m"
        # LIGHT_PURPLE=> "\e[1;35m"
        # LIGHT_CYAN  => "\e[1;36m"
        # WHITE       => "\e[1;37m"
         1   => { rgb => [qw/ff 00 00/], },
         2   => { rgb => [qw/00 00 00/], },
         3   => { rgb => [qw/00 00 00/], },
         4   => { rgb => [qw/00 00 00/], },
         5   => { rgb => [qw/00 00 00/], },
         6   => { rgb => [qw/00 00 00/], },
         7   => { rgb => [qw/00 00 00/], },
         8   => { rgb => [qw/00 00 00/], },
         9   => { rgb => [qw/00 00 00/], },
        10   => { rgb => [qw/00 00 00/], },
        11   => { rgb => [qw/00 00 00/], },
        12   => { rgb => [qw/00 00 00/], },
        13   => { rgb => [qw/00 00 00/], },
        14   => { rgb => [qw/00 00 00/], },
        15   => { rgb => [qw/00 00 00/], },
        16   => { rgb => [qw/00 00 00/], },
        17   => { rgb => [qw/00 00 5f/], },
        18   => { rgb => [qw/00 00 87/], },
        19   => { rgb => [qw/00 00 af/], },
        20   => { rgb => [qw/00 00 d7/], },
        21   => { rgb => [qw/00 00 ff/], },
        22   => { rgb => [qw/00 5f 00/], },
        23   => { rgb => [qw/00 5f 5f/], },
        24   => { rgb => [qw/00 5f 87/], },
        25   => { rgb => [qw/00 5f af/], },
        26   => { rgb => [qw/00 5f d7/], },
        27   => { rgb => [qw/00 5f ff/], },
        28   => { rgb => [qw/00 87 00/], },
        29   => { rgb => [qw/00 87 5f/], },
        30   => { rgb => [qw/00 87 87/], },
        31   => { rgb => [qw/00 87 af/], },
        32   => { rgb => [qw/00 87 d7/], },
        33   => { rgb => [qw/00 87 ff/], },
        34   => { rgb => [qw/00 af 00/], },
        35   => { rgb => [qw/00 af 5f/], },
        36   => { rgb => [qw/00 af 87/], },
        37   => { rgb => [qw/00 af af/], },
        38   => { rgb => [qw/00 af d7/], },
        39   => { rgb => [qw/00 af ff/], },
        40   => { rgb => [qw/00 d7 00/], },
        41   => { rgb => [qw/00 d7 5f/], },
        42   => { rgb => [qw/00 d7 87/], },
        43   => { rgb => [qw/00 d7 af/], },
        44   => { rgb => [qw/00 d7 d7/], },
        45   => { rgb => [qw/00 d7 ff/], },
        46   => { rgb => [qw/00 ff 00/], },
        47   => { rgb => [qw/00 ff 5f/], },
        48   => { rgb => [qw/00 ff 87/], },
        49   => { rgb => [qw/00 ff af/], },
        50   => { rgb => [qw/00 ff d7/], },
        51   => { rgb => [qw/00 ff ff/], },
        52   => { rgb => [qw/5f 00 00/], },
        53   => { rgb => [qw/5f 00 5f/], },
        54   => { rgb => [qw/5f 00 87/], },
        55   => { rgb => [qw/5f 00 af/], },
        56   => { rgb => [qw/5f 00 d7/], },
        57   => { rgb => [qw/5f 00 ff/], },
        58   => { rgb => [qw/5f 5f 00/], },
        59   => { rgb => [qw/5f 5f 5f/], },
        60   => { rgb => [qw/5f 5f 87/], },
        61   => { rgb => [qw/5f 5f af/], },
        62   => { rgb => [qw/5f 5f d7/], },
        63   => { rgb => [qw/5f 5f ff/], },
        64   => { rgb => [qw/5f 87 00/], },
        65   => { rgb => [qw/5f 87 5f/], },
        66   => { rgb => [qw/5f 87 87/], },
        67   => { rgb => [qw/5f 87 af/], },
        68   => { rgb => [qw/5f 87 d7/], },
        69   => { rgb => [qw/5f 87 ff/], },
        70   => { rgb => [qw/5f af 00/], },
        71   => { rgb => [qw/5f af 5f/], },
        72   => { rgb => [qw/5f af 87/], },
        73   => { rgb => [qw/5f af af/], },
        74   => { rgb => [qw/5f af d7/], },
        75   => { rgb => [qw/5f af ff/], },
        76   => { rgb => [qw/5f d7 00/], },
        77   => { rgb => [qw/5f d7 5f/], },
        78   => { rgb => [qw/5f d7 87/], },
        79   => { rgb => [qw/5f d7 af/], },
        80   => { rgb => [qw/5f d7 d7/], },
        81   => { rgb => [qw/5f d7 ff/], },
        82   => { rgb => [qw/5f ff 00/], },
        83   => { rgb => [qw/5f ff 5f/], },
        84   => { rgb => [qw/5f ff 87/], },
        85   => { rgb => [qw/5f ff af/], },
        86   => { rgb => [qw/5f ff d7/], },
        87   => { rgb => [qw/5f ff ff/], },
        88   => { rgb => [qw/87 00 00/], },
        89   => { rgb => [qw/87 00 5f/], },
        90   => { rgb => [qw/87 00 87/], },
        91   => { rgb => [qw/87 00 af/], },
        92   => { rgb => [qw/87 00 d7/], },
        93   => { rgb => [qw/87 00 ff/], },
        94   => { rgb => [qw/87 5f 00/], },
        95   => { rgb => [qw/87 5f 5f/], },
        96   => { rgb => [qw/87 5f 87/], },
        97   => { rgb => [qw/87 5f af/], },
        98   => { rgb => [qw/87 5f d7/], },
        99   => { rgb => [qw/87 5f ff/], },
        100  => { rgb => [qw/87 87 00/], },
        101  => { rgb => [qw/87 87 5f/], },
        102  => { rgb => [qw/87 87 87/], },
        103  => { rgb => [qw/87 87 af/], },
        104  => { rgb => [qw/87 87 d7/], },
        105  => { rgb => [qw/87 87 ff/], },
        106  => { rgb => [qw/87 af 00/], },
        107  => { rgb => [qw/87 af 5f/], },
        108  => { rgb => [qw/87 af 87/], },
        109  => { rgb => [qw/87 af af/], },
        110  => { rgb => [qw/87 af d7/], },
        111  => { rgb => [qw/87 af ff/], },
        112  => { rgb => [qw/87 d7 00/], },
        113  => { rgb => [qw/87 d7 5f/], },
        114  => { rgb => [qw/87 d7 87/], },
        115  => { rgb => [qw/87 d7 af/], },
        116  => { rgb => [qw/87 d7 d7/], },
        117  => { rgb => [qw/87 d7 ff/], },
        118  => { rgb => [qw/87 ff 00/], },
        119  => { rgb => [qw/87 ff 5f/], },
        120  => { rgb => [qw/87 ff 87/], },
        121  => { rgb => [qw/87 ff af/], },
        122  => { rgb => [qw/87 ff d7/], },
        123  => { rgb => [qw/87 ff ff/], },
        124  => { rgb => [qw/af 00 00/], },
        125  => { rgb => [qw/af 00 5f/], },
        126  => { rgb => [qw/af 00 87/], },
        127  => { rgb => [qw/af 00 af/], },
        128  => { rgb => [qw/af 00 d7/], },
        129  => { rgb => [qw/af 00 ff/], },
        130  => { rgb => [qw/af 5f 00/], },
        131  => { rgb => [qw/af 5f 5f/], },
        132  => { rgb => [qw/af 5f 87/], },
        133  => { rgb => [qw/af 5f af/], },
        134  => { rgb => [qw/af 5f d7/], },
        135  => { rgb => [qw/af 5f ff/], },
        136  => { rgb => [qw/af 87 00/], },
        137  => { rgb => [qw/af 87 5f/], },
        138  => { rgb => [qw/af 87 87/], },
        139  => { rgb => [qw/af 87 af/], },
        140  => { rgb => [qw/af 87 d7/], },
        141  => { rgb => [qw/af 87 ff/], },
        142  => { rgb => [qw/af af 00/], },
        143  => { rgb => [qw/af af 5f/], },
        144  => { rgb => [qw/af af 87/], },
        145  => { rgb => [qw/af af af/], },
        146  => { rgb => [qw/af af d7/], },
        147  => { rgb => [qw/af af ff/], },
        148  => { rgb => [qw/af d7 00/], },
        149  => { rgb => [qw/af d7 5f/], },
        150  => { rgb => [qw/af d7 87/], },
        151  => { rgb => [qw/af d7 af/], },
        152  => { rgb => [qw/af d7 d7/], },
        153  => { rgb => [qw/af d7 ff/], },
        154  => { rgb => [qw/af ff 00/], },
        155  => { rgb => [qw/af ff 5f/], },
        156  => { rgb => [qw/af ff 87/], },
        157  => { rgb => [qw/af ff af/], },
        158  => { rgb => [qw/af ff d7/], },
        159  => { rgb => [qw/af ff ff/], },
        160  => { rgb => [qw/d7 00 00/], },
        161  => { rgb => [qw/d7 00 5f/], },
        162  => { rgb => [qw/d7 00 87/], },
        163  => { rgb => [qw/d7 00 af/], },
        164  => { rgb => [qw/d7 00 d7/], },
        165  => { rgb => [qw/d7 00 ff/], },
        166  => { rgb => [qw/d7 5f 00/], },
        167  => { rgb => [qw/d7 5f 5f/], },
        168  => { rgb => [qw/d7 5f 87/], },
        169  => { rgb => [qw/d7 5f af/], },
        170  => { rgb => [qw/d7 5f d7/], },
        171  => { rgb => [qw/d7 5f ff/], },
        172  => { rgb => [qw/d7 87 00/], },
        173  => { rgb => [qw/d7 87 5f/], },
        174  => { rgb => [qw/d7 87 87/], },
        175  => { rgb => [qw/d7 87 af/], },
        176  => { rgb => [qw/d7 87 d7/], },
        177  => { rgb => [qw/d7 87 ff/], },
        178  => { rgb => [qw/d7 af 00/], },
        179  => { rgb => [qw/d7 af 5f/], },
        180  => { rgb => [qw/d7 af 87/], },
        181  => { rgb => [qw/d7 af af/], },
        182  => { rgb => [qw/d7 af d7/], },
        183  => { rgb => [qw/d7 af ff/], },
        184  => { rgb => [qw/d7 d7 00/], },
        185  => { rgb => [qw/d7 d7 5f/], },
        186  => { rgb => [qw/d7 d7 87/], },
        187  => { rgb => [qw/d7 d7 af/], },
        188  => { rgb => [qw/d7 d7 d7/], },
        189  => { rgb => [qw/d7 d7 ff/], },
        190  => { rgb => [qw/d7 ff 00/], },
        191  => { rgb => [qw/d7 ff 5f/], },
        192  => { rgb => [qw/d7 ff 87/], },
        193  => { rgb => [qw/d7 ff af/], },
        194  => { rgb => [qw/d7 ff d7/], },
        195  => { rgb => [qw/d7 ff ff/], },
        196  => { rgb => [qw/ff 00 00/], },
        197  => { rgb => [qw/ff 00 5f/], },
        198  => { rgb => [qw/ff 00 87/], },
        199  => { rgb => [qw/ff 00 af/], },
        200  => { rgb => [qw/ff 00 d7/], },
        201  => { rgb => [qw/ff 00 ff/], },
        202  => { rgb => [qw/ff 5f 00/], },
        203  => { rgb => [qw/ff 5f 5f/], },
        204  => { rgb => [qw/ff 5f 87/], },
        205  => { rgb => [qw/ff 5f af/], },
        206  => { rgb => [qw/ff 5f d7/], },
        207  => { rgb => [qw/ff 5f ff/], },
        208  => { rgb => [qw/ff 87 00/], },
        209  => { rgb => [qw/ff 87 5f/], },
        210  => { rgb => [qw/ff 87 87/], },
        211  => { rgb => [qw/ff 87 af/], },
        212  => { rgb => [qw/ff 87 d7/], },
        213  => { rgb => [qw/ff 87 ff/], },
        214  => { rgb => [qw/ff af 00/], },
        215  => { rgb => [qw/ff af 5f/], },
        216  => { rgb => [qw/ff af 87/], },
        217  => { rgb => [qw/ff af af/], },
        218  => { rgb => [qw/ff af d7/], },
        219  => { rgb => [qw/ff af ff/], },
        220  => { rgb => [qw/ff d7 00/], },
        221  => { rgb => [qw/ff d7 5f/], },
        222  => { rgb => [qw/ff d7 87/], },
        223  => { rgb => [qw/ff d7 af/], },
        224  => { rgb => [qw/ff d7 d7/], },
        225  => { rgb => [qw/ff d7 ff/], },
        226  => { rgb => [qw/ff ff 00/], },
        227  => { rgb => [qw/ff ff 5f/], },
        228  => { rgb => [qw/ff ff 87/], },
        229  => { rgb => [qw/ff ff af/], },
        230  => { rgb => [qw/ff ff d7/], },
        231  => { rgb => [qw/ff ff ff/], },
        232  => { rgb => [qw/08 08 08/], },
        233  => { rgb => [qw/12 12 12/], },
        234  => { rgb => [qw/1c 1c 1c/], },
        235  => { rgb => [qw/26 26 26/], },
        236  => { rgb => [qw/30 30 30/], },
        237  => { rgb => [qw/3a 3a 3a/], },
        238  => { rgb => [qw/44 44 44/], },
        239  => { rgb => [qw/4e 4e 4e/], },
        240  => { rgb => [qw/58 58 58/], },
        241  => { rgb => [qw/62 62 62/], },
        242  => { rgb => [qw/6c 6c 6c/], },
        243  => { rgb => [qw/76 76 76/], },
        244  => { rgb => [qw/80 80 80/], },
        245  => { rgb => [qw/8a 8a 8a/], },
        246  => { rgb => [qw/94 94 94/], },
        247  => { rgb => [qw/9e 9e 9e/], },
        248  => { rgb => [qw/a8 a8 a8/], },
        249  => { rgb => [qw/b2 b2 b2/], },
        250  => { rgb => [qw/bc bc bc/], },
        251  => { rgb => [qw/c6 c6 c6/], },
        252  => { rgb => [qw/d0 d0 d0/], },
        253  => { rgb => [qw/da da da/], },
        254  => { rgb => [qw/e4 e4 e4/], },
        255  => { rgb => [qw/ee ee ee/], },
    };
}

{
    my $rgb;
    sub map_rgb {
        return $rgb if $rgb;
        $rgb = {};

        my $numbers = map_numbers();

        for my $number ( keys %{ $numbers } ) {
            $rgb->{ $numbers->{$number}{rgb}[0] }{ $numbers->{$number}{rgb}[1] }{ $numbers->{$number}{rgb}[2] } = $number;
        }

        return $rgb;
    }
}

1;

__END__

=head1 NAME

Term::Colour256 - Automates generating of colours for 256 colour terminals

=head1 VERSION

This documentation refers to Term::Colour256 version 0.1.

=head1 SYNOPSIS

   use Term::Colour256;

   # colour some text
   print colour('128') . "colour 128" . colour('reset');
   # or equivantly
   print coloured(['128'], 'colour 128');

   print push_color('on' => 96) . ' bg is 96 ' . push_color('192') . ' bg 96, fg 192 ' . pop_color() . ' now just bg 96 ' . pop_color() . 'back to default';

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=head3 C<new ()>

Return: Term::Colour256 - new object

Description: Creates a new object for pushing and popping colours

=head3 C<colour ( @colours )>

Param: @colours - list colours to out put, each element

Return: string - terminal code to produce the colours

=head3 C<color ( @colours )>

Alias for colour.

=head3 C<coloured ( $colours, @strings )>

Param: $colours - arrayref or string- see C<colour>

Param: @strings - the text to be coloured

Return: string - coloured text

Description: Colours the text and resets the colours after

=head3 C<colored ( $colours, @strings )>

Alias for coloured

=head3 C<push_colour (@colours)>

=head3 C<push_color (@colours)>

Alias for push_colour

=head3 C<pop_colour (@colours)>

=head3 C<pop_color (@colours)>

Alias for pop_colour

=head3 C<map_colour ($colour, $on)>

Maps the C<$colour> to the escape sequence. The C<$on> flags that the colour is
a background colour if true.

=head3 C<map_names ()>

Returns a hash mapping colour names to colour numbers.

=head3 C<map_numbers ()>

Returns a hash of mappings between escape code and approximate RGB values.

=head3 C<map_rgb ()>

Reverse of C<map_numbers>

=head1 DIAGNOSTICS

A list of every error and warning message that the module can generate (even
the ones that will "never happen"), with a full explanation of each problem,
one or more likely causes, and any suggested remedies.

=head1 CONFIGURATION AND ENVIRONMENT

A full explanation of any configuration system(s) used by the module, including
the names and locations of any configuration files, and the meaning of any
environment variables or properties that can be set. These descriptions must
also include details of any configuration language used.

=head1 DEPENDENCIES

A list of all of the other modules that this module relies upon, including any
restrictions on versions, and an indication of whether these required modules
are part of the standard Perl distribution, part of the module's distribution,
or must be installed separately.

=head1 INCOMPATIBILITIES

A list of any modules that this module cannot be used in conjunction with.
This may be due to name conflicts in the interface, or competition for system
or program resources, or due to internal limitations of Perl (for example, many
modules that use source code filters are mutually incompatible).

=head1 BUGS AND LIMITATIONS

A list of known problems with the module, together with some indication of
whether they are likely to be fixed in an upcoming release.

Also, a list of restrictions on the features the module does provide: data types
that cannot be handled, performance issues and the circumstances in which they
may arise, practical limitations on the size of data sets, special cases that
are not (yet) handled, etc.

The initial template usually just has:

There are no known bugs in this module.

Please report problems to Ivan Wills (ivan.wills@gmail.com).

Patches are welcome.

=head1 AUTHOR

Ivan Wills - (ivan.wills@gmail.com)
<Author name(s)>  (<contact address>)

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2010 Ivan Wills (14 Mullion Close, Hornsby Heights, NSW Australia 2077).
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut
