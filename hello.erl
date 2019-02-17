-module(hello).
-export([start/0]).

start() ->
    io:format("Hello world.~n").

%% For compiling out of shell
%% $ erl hello.erl
%% $ erl -noshell -s hello start -s init stop
