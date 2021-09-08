#!/usr/bin/env perl
use strict;
use warnings;
use OpenNewsWire::Web;

my $app = OpenNewsWire::Web
    ->apply_default_middlewares(OpenNewsWire::Web->psgi_app);
$app;
