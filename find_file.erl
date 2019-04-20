% From programming erlang (2° edition).
-module(find_file).
-export([files/3, files/5]).
-import(lists, [reverse/1]).

-include_lib("kernel/include/file.hrl").

% `file' function with implicit `Fun' and `Acc'.
files(Dir, Re, Flag) ->
    Re1 = xmerl_regexp:sh_to_awk(Re),
    reverse(files(Dir, Re1, Flag, fun(File, Acc) ->
					  [File|Acc] end, [])).

% `file' function with more generic `Fun' and List `Acc'umulator.
files(Dir, Reg, Recursive, Fun, Acc) ->
    case file:list_dir(Dir) of
	{ok, Files} ->
	    % calling the recursive function `find_files'.
	    find_files(Files, Dir, Reg, Recursive, Fun, Acc);
	{error, _}  ->
	    Acc
    end.

%% process the list of files and directories in "." directory
find_files([File|T], Dir, Reg, Recursive, Fun, Acc0) ->
    % capture the path of the filename in `FullName'.
    FullName = filename:join([Dir, File]),
    case file_type(FullName) of
	% if the file type check return `regular'
	regular ->
	    case re:run(FullName, Reg, [{capture, none}]) of
		% if the file is regular and `match' with the regex
		% accumulate this in `Acc'.
		match ->
		    Acc = Fun(FullName, Acc0),
		    find_files(T, Dir, Reg, Recursive, Fun, Acc);
		% if the file is regular and `nomatch' with the regex
		% accumulate this in `Acc0'
		nomatch ->
		    find_files(T, Dir, Reg, Recursive, Fun, Acc0)
	    end;
	directory ->
	    % if the file type check return `directory'
	    case Recursive of
		% if the file type is `directory' and `Recursive'
		% is `true', search the directories accumulated in
		% `Acc0', capture this in `Acc1' and apply `find_files'
		% inside of this.
		true ->
		    Acc1 = files(FullName, Reg, Recursive, Fun, Acc0),
		    find_files(T, Dir, Reg, Recursive, Fun, Acc1);
		% if the file type is `directory' and `Recursive'
		% is `false', accumulate this file paths in `Acc0'.
		false ->
		    find_files(T, Dir, Reg, Recursive, Fun, Acc0)
	    end;
	error ->
	    find_files(T, Dir, Reg, Recursive, Fun, Acc0)
    end;
find_files([], _, _, _, _, A) ->
    A.

% check the type file. Return `regular',
% `directory' or `error'.
file_type(File) ->
    case file:read_file_info(File) of
	{ok, Facts} ->
	    case Facts#file_info.type of
		regular ->
		    regular;
		directory ->
		    directory;
		_ ->
		    error
	    end;
	_ ->
	    error
    end.
