-module(myftp1).
-export([get_file/2, read_step/1, my_consult/1]).

get_file(RemotePC, File) ->
    {ok, Data} = rpc:call(RemotePC, myftp1, get_file, [RemotePC, File]),
    file:write_file(File ++ ".copy", Data, append).

% Helper
read_step(File) ->
    case file:open(File, read) of
	{ok, Fd} ->
	    Data = my_consult(Fd),
	    file:close(Fd),
	    {ok, Data};
	{error, Why} ->
	    {error, Why}
    end.

my_consult(Fd) ->
    case io:read(Fd, '') of
	{ok, Term} ->
	    [Term|my_consult(Fd)];
	eof ->
	    [];
	Error ->
	    Error
    end.
