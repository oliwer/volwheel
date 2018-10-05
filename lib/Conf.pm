package Conf;

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

sub new {
	my $class = shift;
	my $self  = {};
	$self->{_driver}        = "Alsa";
	$self->{_channel}       = "PCM";
	$self->{_mixer}         = "xterm -e 'alsamixer'";
	$self->{_increment}     = 3;
	$self->{_icon_theme}    = "simple-blue";
	$self->{_icon_path}     = "$::prefix/share/volwheel/icons/volwheel.png";
	$self->{_icon_static}   = 0;
	$self->{_loop_time}     = 2;
	$self->{_before_mute}   = $self->{_increment};
	$self->{_show_scale}    = 0;
	$self->{_channel_list}  = [$self->{_channel},"Master","Capture"];
	bless ($self, $class);
	return $self;
}


sub get_conf_path {

	my $self = shift;

	my $path = $ENV{XDG_CONFIG_HOME};
	if ($path eq "") { $path = $ENV{HOME}."/.config" }
	unless (-d $path) {
		mkdir $path or die "Cannot create the configuration directory $path\n";
	}

	return $path;

}

sub read_conf {

	my $self = shift;
	my $path = get_conf_path();
	my $line7;

	if (-r "$path/volwheel") {
		open (CONFIG, "$path/volwheel");
		my @config = <CONFIG>;
		if ($config[0] && $config[0] ne "")        { $self->{_channel}     = $config[0]; }
		if ($config[1] && $config[1] ne "")        { $self->{_mixer}       = $config[1]; }
		if ($config[2] && $config[2] =~ /^\d+$/)   { $self->{_increment}   = $config[2]; }
		if ($config[3] && $config[3] ne "")        { $self->{_icon_theme}  = $config[3]; }
		if ($config[4] && $config[4] ne "")        { $self->{_icon_path}   = $config[4]; }
		if ($config[5] && $config[5] =~ /^(0|1)$/) { $self->{_icon_static} = $config[5]; }
		if ($config[6] && $config[6] ne "")        { $self->{_driver}      = $config[6]; }
		if ($config[7] && $config[7] =~ /:/)       { $line7 = $config[7]; }
		close CONFIG;
		chomp %{$self};
		chomp $line7;
		$self->channel_list( split(":", $line7) );
	}
	else {
		# autodetect the mixer
		if (-x "/usr/bin/gnome-alsamixer") { $self->{_mixer} = "gnome-alsamixer"; }
		if (-x "/usr/bin/xfce4-mixer")     { $self->{_mixer} = "xfce4-mixer"; }
		if (-x "/usr/bin/ossxmix")         { $self->{_mixer} = "ossxmix"; }
	}

}

sub write_conf {

	my $self = shift;
	my $path = get_conf_path();

	open (CONFIG, ">$path/volwheel")
		or warn "Error : Cannot open/create configuration file $path/volwheel\n";
	print CONFIG $self->{_channel}             . $/ .
	             $self->{_mixer}               . $/ .
	             $self->{_increment}           . $/ .
	             $self->{_icon_theme}          . $/ .
	             $self->{_icon_path}           . $/ .
	             $self->{_icon_static}         . $/ .
	             $self->{_driver}              . $/ .
	             join(":", $self->channel_list).":$/";
	close CONFIG;

}


sub driver {
    my $self = shift;
    if (@_) { $self->{_driver} = shift }
    return $self->{_driver};
}

sub channel {
    my $self = shift;
    if (@_) { $self->{_channel} = shift }
    return $self->{_channel};
}

sub mixer {
    my $self = shift;
    if (@_) { $self->{_mixer} = shift }
    return $self->{_mixer};
}

sub increment {
    my $self = shift;
    if (@_) { $self->{_increment} = shift }
    return $self->{_increment};
}

sub icon_theme {
    my $self = shift;
    if (@_) { $self->{_icon_theme} = shift }
    return $self->{_icon_theme};
}

sub icon_path {
    my $self = shift;
    if (@_) { $self->{_icon_path} = shift }
    return $self->{_icon_path};
}

sub icon_static {
    my $self = shift;
    if (@_) { $self->{_icon_static} = shift }
    return $self->{_icon_static};
}

sub loop_time {
    my $self = shift;
    if (@_) { $self->{_loop_time} = shift }
    return $self->{_loop_time};
}

sub before_mute {
    my $self = shift;
    if (@_) { $self->{_before_mute} = shift }
    return $self->{_before_mute};
}

sub show_scale {
    my $self = shift;
    if (@_) { $self->{_show_scale} = shift }
    return $self->{_show_scale};
}

sub channel_list {
    my $self = shift;
    if (@_) { @{ $self->{_channel_list} } = @_ }
    return @{ $self->{_channel_list} };
}

1;
