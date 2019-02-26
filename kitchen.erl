-module(kitchen).
-compile(export_all).

fridge1() ->
    receive
	{From, {store, _Food}} ->
	    From ! {self(), ok},
	    fridge1();
	{From, {take, _Food}} ->
	    From ! {self(), not_found},
	    fridge1();
	terminate ->
	    ok
    end.
