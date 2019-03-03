-module(smalltimer).
-export([start/2, cancel/1]).

start(Time, Fun) ->
    spawn(fun() -> timer(Time, Fun) end).

cancel(Pid) ->
    Pid ! cancel.

timer(Time, Fun) ->
    receive
	cancel ->
	    void
    after Time ->
	    Fun()
    end.

%% Pid = smalltimer:start(6000, fun() -> io:format("time"~n) end).

%% Pid1 = smalltimer:start(3800, fun() -> io:format("time"~n) end).
%% smalltimer:cancel(Pid1).

%% Timeouts and timers are central to the implementation of many
%% communications protocols. When we wait for a message, we don't
%% want to wait forever, so we add a timeout as in the examples.
