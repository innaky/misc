-module(cal).
-export([start/0, server/0]).
-export([triangle_area/2, rectangle/2]).

start() ->
    spawn(?MODULE, server, []).

client(Pid, Request) ->
    Pid ! {self(), Request},
    receive
	{Pid, Response} ->
	    Response
    end.

server() ->
    receive
	{FromPid, {triangle, FirstElem, SecondElem}} ->
	    FromPid ! {self(), triangle_area(FirstElem, SecondElem)},
	    server();
	{FromPid, {rectangle, FirstElem, SecondElem}} ->
	    FromPid ! {self(), rectangle(FirstElem, SecondElem)},
	    server();
	{FromPid, Other} ->
	    FromPid ! {self(), {error, Other}},
	    server()
    end.

triangle_area(Base, Height) ->
    (Base * Height)/2.

rectangle(Long, Width) ->
    Long * Width.

%% Pid = spawn(cal, server, []).
%% Pid ! {triangle, 2, 5}.
