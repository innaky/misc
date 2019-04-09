-module(myftp1).
-export([get_file/2, read_step/1, my_consult/1]).

get_file(RemotePC, File) ->
    {ok, Data} = rpc:call(RemotePC, myftp1, read_step, [File]),
    file:write_file(File ++ ".copy", [Data]).


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
% This function take an `Start' value, an `End' value and an `Interval' value, and
% return a list between `Start' to `End' in `Interval' segments.
% Similar to python [0, 10, 2] = [0, 2, 4, 6, 8, 10]
% but this function needs to more refinate, because the `End' is append in the last position
% and not always is correct [0, 12, 5] = [0, 5, 10, 12]
%segments(Start, End, _Interval) when Start >= End ->
%    [] ++ [End];
%segments(Start, End, Interval) ->
%    [Start | segments(Start+Interval, End, Interval)].

%is_multiple(Num, MultipleOf) ->
%    Div = Num rem MultipleOf,
%    if Div =:= 0 ->
%	    true;
%       Div =/= 0 ->
%	    false
%    end.

%read_step(Filename) ->
%    case file:open(Filename, [read,binary,raw]) of
%	{ok, Fd} ->
%	    Filesize = filelib:file_size(Filename),
%	    % extract the principal number of Filesize. Max size of a segment of 10 bytes.
%	    {Big_segment, _} = string:to_integer(integer_to_list(Filesize div 10) ++ "0"),
%	    % extract the last number of Filesize.
%	    Last_segment = Filesize rem 10,
%	    Byte_segment = pread(Fd, 0, 10),
%	    file:close(Fd),
%	    {ok, Data};
%	{error, Why} ->
%	    {error, Why}
%    end.
