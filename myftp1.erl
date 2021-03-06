-module(myftp1).
-export([get_file/3, segments/3, sustainable_read/2, rget_file/3]).

rget_file(_, _, []) ->
    [];
rget_file(RemotePC, Filename, [H|T]) ->
    [_, _, _, _, Data] = get_file(RemotePC, Filename, H),
    io:format("~s", [Data]),
    rget_file(RemotePC, Filename, T).

get_file(RemotePC, Filename, Num) ->
    rpc:call(RemotePC, myftp1, sustainable_read, [Filename, Num]).

segments(Start, End, _Interval) when Start >= End ->
    [] ++ [End];
segments(Start, End, Interval) ->
    [Start | segments(Start+Interval, End, Interval)].

sustainable_read(Filename, Num) ->
    {ok, Fd} = file:open(Filename, [read,binary,raw]),
    Filesize = filelib:file_size(Filename),
    {Big_segment, _} = string:to_integer(integer_to_list(Filesize div 10) ++ "0"),
    Small_segment = Filesize rem 10,
    List_segments = segments(0, Big_segment, 10),
    {ok, Bin} = file:pread(Fd, Num, 10),
    file:close(Fd),
    [Filesize, Big_segment, Small_segment, List_segments, Bin].
