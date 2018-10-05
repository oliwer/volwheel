#!/usr/bin/perl

use strict;
use warnings;
use Shell qw(install cp);

my $package = "volwheel";

my $destdir = "";
my $prefix  = "/usr/local";

if (@ARGV > 0) {
	foreach my $arg (@ARGV) {
		if ($arg =~ /destdir/) {
			my @value = split('=', $arg);
			$destdir = $value[1];
		}
		elsif ($arg =~ /prefix/) {
			my @value = split('=', $arg);
			$prefix = $value[1];
		}
	}
}

my $path    = $destdir.$prefix;
my $bindir  = "$path/bin";
my $libdir  = "$path/lib/$package";
my $datadir = "$path/share/$package";
my $hicolor = "$destdir/usr/share/icons/hicolor/scalable/apps";
my $desktop = "$destdir/usr/share/applications";

if ($prefix ne "/usr/local") {
	system("sed -i 's|/usr/local|$prefix|g\' volwheel");
}

my $output = install ("-v -d {$bindir,$libdir,$datadir,$hicolor,$desktop}");
print $output;
$output = install ("-v -m755 volwheel $bindir");
print $output;
$output = install ("-v -m644 lib/* $libdir");
print $output;
$output = cp      ("-v -r icons $datadir/");
print $output;
$output = install ("-v -m644 icons/volwheel.svg $hicolor");
print $output;
$output = install ("-v -m644 volwheel.desktop $desktop");

print "\nVolWheel has been succesfully installed.\n\n";

