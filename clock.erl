-module(clock).
-export([start/2, stop/0]).

start(Time, F) ->
    register(clock, spawn(fun() -> tick(Time, F) end)).

stop() ->
    %% Not use Pid (see smalltimer.erl in this repository) as parameter, because, the name
    %% `clock' is the reference or direction of the function `start' Pid.
    clock ! stop.

tick(Time, F) ->
    receive
	stop ->
	    void
    after Time ->
	    F(),
	    tick(Time, F)
    end.

%% clock:start(4000, fun() -> io:format("Tick: ~p~n", [erlang:now()]) end).
