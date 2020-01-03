-module(tcp_test).
-export([start_server/0, server/1, do_accept/1, do_serv/1, fac/1, client/1]).

-define(TCP_OPS, [binary, {packet, 0}, {active, false}, {reuseaddr, true}]).

start_server() ->
    spawn(fun () ->
		  server(6666) end).

server(Port) ->
    {ok, LSocket} = gen_tcp:listen(Port, ?TCP_OPS),
    do_accept(LSocket).

do_accept(LSocket) ->
    {ok, Socket} = gen_tcp:accept(LSocket),
    spawn(fun() ->
		  do_serv(Socket) end),
    do_accept(LSocket).

do_serv(Socket) ->
    case gen_tcp:recv(Socket, 0) of
	{ok, Data} ->
	    io:format("Server received (binary): ~p~n", [Data]),
	    N = binary_to_term(Data),
	    io:format("Server (unpacked): ~p~n", [N]),
	    Fac = fac(N),
	    gen_tcp:send(Socket, term_to_binary(Fac)),
	    do_serv(Socket);
	{error, closed} ->
	    io:format("Server socket closed~n")
    end.

fac(0) ->
    1;
fac(X) ->
    X * fac(X - 1).

client(N) ->
    {ok, Socket} = gen_tcp:connect("localhost", 6666, [binary, {packet, 0}]),
    ok = gen_tcp:send(Socket, term_to_binary(N)),
    receive
	{tcp, Socket, Bin} ->
	    %io:format("Client received (binary): ~p~n", [Bin]),
	    Val = binary_to_term(Bin),
	    io:format("Result: ~p~n", [Val]),
	    gen_tcp:close(Socket)
    end.
