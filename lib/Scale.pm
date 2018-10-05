package Scale;

# VolWheel - set the volume with your mousewheel
# Author : Olivier Duclos <olivier.duclos gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

use strict;
use Time::HiRes qw(gettimeofday tv_interval);
our @ISA = 'Gtk2::VBox';

sub new {
	my $class = shift;
	my $self  = Gtk2::VBox->new(0,8);
	$self->{_channel} = shift;
	$self->{_scale}   = Gtk2::VScale->new_with_range(0, 100, 1);
	$self->{_label}   = Gtk2::Label->new($self->{_channel});
	$self->{_tv}      = [ gettimeofday ];

	$self->{_scale}->set_digits(0);
	$self->{_scale}->set_value_pos('bottom');
	$self->{_scale}->set_inverted(1);
	$self->{_scale}->set_size_request(0,120);
	$self->{_scale}->set_update_policy("continuous");
	$self->{_scale}->set_value(main::get_volume($self->{_channel}));
	$self->{_scale}->signal_connect('value-changed' => sub {
					#print("interval: " . tv_interval($self->{_tv}) . "\n");
					if (tv_interval($self->{_tv}) < $::intrval) { return; }
					main::set_volume( $self->{_scale}->get_value, $self->{_channel} );
					if ($self->{_channel} eq $::opt->channel) {
						main::update_icon();
					}
					$self->{_tv} = [ gettimeofday ];
					});

	$self->add($self->{_scale});
	$self->add($self->{_label});

    bless ($self, $class);
    return $self;
}

sub value {
    my $self = shift;
    if (@_) { $self->{_scale}->set_value(shift) }
    return $self->{_scale}->get_value;
}

sub channel {
    my $self = shift;
    if (@_) { $self->{_channel} = shift }
    return $self->{_channel};
}

sub update {
	my $self = shift;
	$self->value(main::get_volume($self->channel));
}

1;
