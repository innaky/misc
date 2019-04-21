-module(file_md5).
-export([start/0, server/0, ask/2]).
-export([md5_small_file/1, files_md5/1, files/1]).

start() ->
    spawn(?MODULE, server, []).

ask(Pid, Ask) ->
    client(Pid, Ask).

client(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.

server() ->
    receive
	{FromPid, {files, Dir}} ->
	    FromPid ! {self(), files(Dir)},
	    server();
	{FromPid, Other} ->
	    FromPid ! {self(), {error, Other}},
	    server()
    end.

md5_small_file(File) ->
    case filelib:file_size(File) of
	Size when Size < 10240 ->
	    {File, erlang:md5(File)};
	_ ->
	    {ok, big_file}
    end.

files_md5([]) ->
    [];
files_md5([File|T]) ->
    [md5_small_file(File) | files_md5(T)].

files(Dir) ->
    case file:list_dir(Dir) of
	{ok, Files} ->
	    files_md5(Files);
	{error, _} ->
	    error
    end.
