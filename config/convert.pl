#!/usr/bin/env perl
use strict;
use warnings;
use File::Copy;

open IN, "<engrammer.keymap" or die;
open OUT, ">glove80.km1" or die;
print OUT '#define ZMK_MACRO(a,...) a: a { compatible = "zmk,behavior-macro"; xxxbinding-cells = <0>; __VA_ARGS__ };', "\n";
while (<IN>) {
    s/#include/xxxinclude/g;
    s/#bind/xxxbind/g;
    print OUT;
}
close IN;
close OUT;

system("cpp", "-E", "glove80.km1", "-o", "glove80.km2");

open IN, "<glove80.km2" or die;
open OUT, ">glove80.km3" or die;
while (<IN>) {
    next if m/^\s*#\s*\d+\s*/;
    s/xxxinclude/#include/g;
    s/xxxbind/#bind/g;
    print OUT;
}
close IN;
close OUT;

copy("glove80.km3","glove80.keymap");
for (1..3) { unlink("glove80.km".$_); }
