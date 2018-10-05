package MiniMixer;

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
use Gtk2;
use Scale;

our $winscale;
our @scale_list;

sub show {

	$winscale = Gtk2::Window->new('toplevel');
	$winscale->set_type_hint('normal');
	$winscale->set_keep_above(1);
	$winscale->set_skip_taskbar_hint(1);
	$winscale->set_modal(1);
	$winscale->set_decorated(0);
	$winscale->set_border_width(10);
	$winscale->set_position('mouse');
	$winscale->signal_connect('hide' => sub{
			$::opt->show_scale(0);
			});
	$winscale->signal_connect('focus-out-event' => sub{
			$winscale->hide;
			});

	my $vbox = Gtk2::VBox->new(0, 4);

	my $btn_mixer = Gtk2::Button->new_with_label("Mixer");
	$btn_mixer->signal_connect('clicked' => \&main::launch_mixer);
	$vbox->pack_start($btn_mixer, 0, 0, 0);

	my $separator = Gtk2::HSeparator->new;
	$vbox->pack_start($separator, 0, 0, 0);

	my $scale_hbox = Gtk2::HBox->new(0,2);

	foreach my $channel ($::opt->channel_list) {
		my $scale_vbox = Scale->new($channel);
		push (@scale_list, $scale_vbox);
		$scale_hbox->pack_start($scale_vbox, 0, 0, 8);
	}

	$vbox->pack_start($scale_hbox, 0, 0, 0);

	$winscale->add($vbox);
	$winscale->show_all;
	$winscale->set_focus;
	$::opt->show_scale(1);

}

sub update {
	foreach my $scl (@scale_list) {
		$scl->update;
	}
}

1;
