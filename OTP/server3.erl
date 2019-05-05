-module(server3).
-export([start/2, rpc/2, swap_code/2]).

start(Name, Mod) ->
    register(Name, spawn(fun() ->
				 loop(Name, Mod, Mod:init()) end)).

rpc(Name, Request) ->
    Name ! {self(), Request},
    receive
	{Name, Response} ->
	    Response
    end.

swap_code(Name, Mod) ->
    rpc(Name, {swap_code, Mod}).

loop(Name, Mod, OldState) ->
    receive
	{From, {swap_code, NewModule}} ->
	    From ! {Name, ack},
	    loop(Name, NewModule, OldState);
	{From, Request} ->
	    {Response, NewState} = Mod:handle(Request, OldState),
	    From ! {Name, Response},
	    loop(Name, Mod, NewState)
    end.
