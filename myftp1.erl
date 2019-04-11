-module(myftp1).

-export([get_file/2, segments/3, sustainable_read/1]).

get_file(RemotePC, Filename) ->
    rpc:call(RemotePC, myftp1, sustainable_read, [Filename]).

segments(Start, End, _Interval) when Start >= End ->
    [] ++ [End];
segments(Start, End, Interval) ->
    [Start | segments(Start+Interval, End, Interval)].

sustainable_read(Filename) ->
    {ok, Fd} = file:open(Filename, [read,binary,raw]),
    Filesize = filelib:file_size(Filename),
    {Big_segment, _} = string:to_integer(integer_to_list(Filesize div 10) ++ "0"),
    Small_segment = Filesize rem 10,
    List_segments = segments(0, Big_segment, 10),
    {ok, Bin} = file:pread(Fd, 0, 10),
    file:close(Fd),
    [Filesize, Big_segment, Small_segment, List_segments, Bin].
