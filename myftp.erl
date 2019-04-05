-module(myftp).
-export([get_file/1]).

get_file(RemotePC, F) ->
    {ok, Bin} = rpc:call(RemotePc, file, read_file, [F]),
    file:write_file(F ++ ".copy", [Bin]).
