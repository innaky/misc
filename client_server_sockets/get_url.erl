-module(get_url).
-export([nano_get_url/0, receive_data/2]).

nano_get_url() ->
    nano_get_url("www.google.com").

nano_get_url(Host) ->
    {ok, Socket} = gen_tcp:connect(Host, 80, [binary, {packet, 0}]),
    ok = gen_tcp:send(Socket, "GET / HTTP/1.0\r\n\r\n"),
    receive_data(Socket, []).

receive_data(Socket, Data) ->
    receive 
	{tcp, Socket, BinData} ->
	    receive_data(Socket, [BinData|Data]);
	{tcp_closed, Socket} ->
	    list_to_binary(lists:reverse(Data))
    end.

% 1> c(get_url).
% {ok, get_url}
% 2> get_url:nano_get_url().
% <<"HTTP/1.0 200 OK\r\nDate: Fri, 20 Dec 2019 17:32:22 GMT\r\nExpires: -1\r\\nCache-Control: private, max-age=0\r\nContent-Type: "...>>
% 3> Bin = get_ulr:nano_get_url().
%<<"HTTP/1.0 200 OK\r\nDate: Fri, 20 Dec 2019 17:32:22"...>>
% 4> io:format("~p~n", [Bin]).
% print the binary
% 5> binary_to_list(Bin).
% print a list with the elements
% 6> string:tokens(binary_to_list(Bin), "\r\n").
