-module(myftp).
-export([get_file/2]).

get_file(RemotePC, F) ->
    {ok, Bin} = rpc:call(RemotePC, file, read_file, [F]),
    file:write_file(F ++ ".copy", [Bin]).

%% The remote pc is: server@innaky
% > erl -sname client -setcookie abc
% > c(myftp).
% {ok,myftp}
% > > myftp:get_file(server@innaky, "monitors.erl").
% ok
