package Alsa;

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

sub volume {

	my $channel = shift;

	my $volume = `amixer get "$channel" | grep -m1 %`;
	$volume =~ /^.*\[([0-9]*)%.*$/;
	return $1;

}


sub is_muted {

	my $channel = shift;

	if (`amixer get "$channel" | grep off` ne "") {
		return (1); # real mute
	}
	elsif ( volume($channel) == 0 ) {
		return (2); # fake mute
	}
	else {
		return (0); # normal
	}

}


# Returns both the volume and if muted
sub status {

	my $channel = shift;

	my $volume = volume($channel);

	if (`amixer get "$channel" | grep off` ne "") {
		return (1, $volume); # real mute
	}
	elsif ( $volume == 0 ) {
		return (1, $volume); # fake mute
	}
	else {
		return (0, $volume); # normal
	}

}


sub mute {

	my $channel = shift;

	my ($muted, $volume) = status($channel);

	# We can't mute if it's already muted !
	if ($muted) { return -1 }

	if (`amixer get "$channel" | grep pswitch` ne "") {
		# The channel pswitch and thus we can do a real mute
		system "amixer set \"$channel\" toggle > /dev/null";
	}
	else {
		# Fake mute
		system "amixer set \"$channel\" 100%- > /dev/null";
	}

	return $volume;

}


sub unmute {

	my ($channel, $old_volume) = @_;

	my $muted = is_muted($channel);

	if ($muted == 1) {
		system "amixer set \"$channel\" toggle > /dev/null";
	}
	elsif ($muted == 2) {
		system "amixer set \"$channel\" $old_volume%+ > /dev/null";
	}
	else {
		return -1; # The channel is not muted !
	}

}


sub volume_up {

	my ($channel, $increment) = @_;
	system "amixer set \"$channel\" $increment%+ > /dev/null";

}


sub volume_down {

	my ($channel, $increment) = @_;
	system "amixer set \"$channel\" $increment%- > /dev/null";

}

sub set_volume {

	my ($channel, $value) = @_;

	unmute($channel, 0);
	system("amixer set \"$channel\" $value% > /dev/null");

}


sub get_channels {

	my @text = `amixer scontrols`;
	my @channels;

	foreach my $line (@text) {
		$line =~ /^.*'(.*)',(\d)$/;
		my $chan = $1;
		if ($2 != 0) { $chan .= ",$2"; }
		push (@channels,$chan);
	}

	return @channels;

}

1;
