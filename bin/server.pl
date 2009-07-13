#!/usr/bin/env perl
use strict;
use warnings;
use HTTP::Engine;

my $engine = HTTP::Engine->new(
    interface => {
        module => 'ServerSimple',
        args   => {
            host => 'localhost',
            port =>  8080,
        },
        request_handler => \&handle_request,
    },
);
$engine->run;

sub handle_request {
    my $req = shift;
    my $res = HTTP::Engine::Response->new;
    if ($req->uri->path eq '/redirect_to_foo') {
        $res->status(302);
        $res->headers->header(Location => 'http://localhost:8080/foo');
    }
    else {
        $res->body(sprintf('Hello, World! request uri is %s.', $req->uri));
    }
    return $res;
}
