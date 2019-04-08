-module(myftp1).
-export([get_file/2]).

get_file(RemotePC, File) ->
    {ok, Data} = rpc:call(RemotePC, file, my_consult, [File]),
    file:write_file(File ++ ".copy", [Data]).

% Helper
my_consult(Fd) ->
    case io:read(Fd, '') of
	{ok, Term} ->
	    [Term|my_consult(Fd)];
	eof ->
	    [];
	Error ->
	    Error
    end.
