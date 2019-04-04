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

% 1> c(simple_server).
% {ok,simple_server}
% 2> simple_server:start().
% true
% 3> simple_server:st
% start/0  store/2
% 3> simple_server:store({name, innaky}, "my_name").
% true
% 4> simple_server:lookup({name, innaky}).
% {ok,"my_name"}
% 5> simple_server:lookup({name, other_name}).
% undefined
