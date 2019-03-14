-module(cal).
-export([start/0, server/0, ask/2]).
-export([triangle_area/2, rectangle/2]). %% for independent computing with triangle_area and rectangle

start() ->
    spawn(?MODULE, server, []).

%% who is self()?
%% It is the "Pid" of who sends the message.
%% If the client sends a message you must also send your "Pid"
%%   so that the server knows who to respond to.
%% The same explanation for the serve: If the server sends a
%%   message to a client, you must also send your "Pid"
%% This is because there are child processes (which have different "Pid")
%%   and because communication between the processes is like sending letters,
%%   you need a recipient address and who sends it.

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

%% Pid1 = cal:start().
%% cal:ask(Pid1, {triangle, 2, 3}).
%% cal:ask(Pid1, {rectangle, 4, 2}).
%% cal:ask(Pid1, {circle, 33}).
