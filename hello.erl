-module(hello).
-export([start/0, loop/0]).

start() ->
    Pid = spawn(hello, loop, []),
    Pid ! hello.

loop() ->
    receive 
	hello ->
	    io:format("Hello World!, The Erlang way! :D~n"),
	    loop()
    end.

%% For compiling out of shell
%% $ erl hello.erl
%% $ erl -noshell -s hello start -s init stop
