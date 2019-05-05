-module(name_server1).
-export([init/0, find/1, add/2, handle/2]).
-import(server3, [rpc/2]).

add(Name, Place) ->
    rpc(name_server, {add, Name, Place}).

find(Name) ->
    rpc(name_server, {find, Name}).

handle({add, Name, Place}, Dict) ->
    {ok, dict:store(Name, Place, Dict)};
handle({find, Name}, Dict) ->
    {dict:find(Name, Dict), Dict}.

init() ->
    dict:new().
