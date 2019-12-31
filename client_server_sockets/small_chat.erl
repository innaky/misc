-module(small_chat).
-export([listen/1]).

-define(TCP_OPS, [list, {packet, 0}, {active, false}, {reuseaddr, true}]).

listen(Port) ->
    Pid = spawn(fun() ->
			manage_clients([]) end),
    register(client_manager, Pid),
    {ok, ListenSocket} = gen_tcp:listen(Port, ?TCP_OPS),
    do_accept(ListenSocket).

do_accept(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() ->
		  handle_client(Socket) end),
    client_manager ! {connect, Socket},
    do_accept(ListenSocket).

handle_client(Socket) ->
    case gen_tcp:recv(Socket, 0) of
	{ok, Data} ->
	    client_manager ! {data, Data},
	    handle_client(Socket);
	{error, closed} ->
	    client_manager ! {disconnect, Socket}
    end.

% Sockets it's a list
manage_clients(Sockets) ->
    receive
	{connect, Socket} ->
	    io:fwrite("Sockect connected: ~w~n", [Socket]),
	    NewSockets = [Socket | Sockets];
	{disconnect, Socket} ->
	    io:fwrite("Socket disconnected: ~w~n", [Socket]),
	    NewSockets = lists:delete(Socket, Sockets);
	{data, Data} ->
	    send_data(Sockets, Data),
	    NewSockets = Sockets
    end,
    manage_clients(NewSockets).

send_data(Sockets, Data) ->
    SendData = fun(Socket) ->
		       gen_tcp:send(Socket, Data)
	       end,
    lists:foreach(SendData, Sockets).
	    
