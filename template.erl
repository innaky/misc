-module(template).
-compile(export_all).

start() ->
    spawn(?MODULE, loop, []).

%% remote procedure call
rpc(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.

loop(X) ->
    receive
	Any ->
	    io:format("Received: ~p~n", [Any]),
	    loop(X)
    end.

%% The receive loop is just any empty loop that receives and prints any message that I
%% send to it. As I develop the program, I’ll start sending messages to the processes.
%% Because I start with no patterns in the receive loop that match these messages, I’ll
%% get a printout from the code at the bottom of the receive statement. When this hap-
%% pens, I add a matching pattern to the receive loop and rerun the program. This
%% technique largely determines the order in which I write the program: I start with a
%% small program and slowly grow it, testing it as I go along.
