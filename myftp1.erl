-module(myftp1).

-export([get_file/2, segments/3, sustainable_copy/1, read_step/1]).

get_file(RemotePC, Filename) ->
    {ok, Fd} = rpc:call(RemotePC, myftp1, sustainable_read, [Filename]),
    Filesize = filelib:file_size(Filename),
    {Big_segment, _} = string:to_integer(integer_to_list(Filesize div 10) ++ "0"),
    Small_segment = Filesize rem 10,
    List_segments = segments(0, Big_segment, 10),
    {ok, Bin} = file:pread(Fd, 0, 10),
    file:pwrite(Fd, 0, Bin),
    file:close(Fd).

segments(Start, End, _Interval) when Start >= End ->
    [] ++ [End];
segments(Start, End, Interval) ->
    [Start | segments(Start+Interval, End, Interval)].

sustainable_read(FileName) ->
    file:open(FileName, [read,binary,raw]).
