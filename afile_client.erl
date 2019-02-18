-module(afile_client).
-export([ls/1, get_file/2, new_dir/2]).

ls(Server) ->
    Server ! {self(), list_dir},
    receive
	{Server, FileList} ->
	    FileList
    end.

get_file(Server, File) ->
    Server ! {self(), {get_file, File}},
    receive
	{Server, Content} ->
	    Content
    end.

%% make a newdirectory
new_dir(Server, Makedir) ->
    Server ! {self(), {make_directory, Makedir}},
    receive
	{Server, Namedir} ->
	    Namedir
    end.
