-module(simple_server).
-export([start/0, store/2, lookup/1]).
-export([loop/0]).

%% client zone
start() ->
    register(kvs, spawn(fun() ->
				loop() end)).

store(Key, Value) ->
    rpc({store, Key, Value}).

lookup(Key) ->
    rpc({lookup, Key}).

rpc(Q) ->
    kvs ! {self(), Q},
    receive
	{kvs, Reply} ->
	    Reply
    end.

%% server zone
loop() ->
    receive
	{From, {store, Key, Value}} ->
	    put(Key, {ok, Value}),
	    From ! {kvs, true},
	    loop();
	{From, {lookup, Key}} ->
	    From ! {kvs, get(Key)},
	    loop()
    end.
