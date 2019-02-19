-module(variatefunc).
-export([greet/2, head/1, second/1, other_second/1, third_second/1, valid_time/1, insert/2]).

greet(male, Name) ->
    io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
    io:format("Hello, Mrs. ~s!~n", [Name]);
greet(_, Name) ->
    io:format("Hello, ~s!~n", [Name]).

head([H|_]) ->
    H.

%% generic function.
second([_,S|_]) ->
    S.

%% generic function.
other_second([_|[S|_]]) ->
    S.

%% Only for lists with length 3.
third_second([_|[S|[_|[]]]]) ->
    S.

valid_time({Date = {Y, M, D}, Time = {H, Min, S}}) ->
    io:format("The Date tuple (~p) says today is: ~p/~p/~p,~n", [Date, Y, M, D]),
    io:format("The time tuple (~p) indicates: ~p:~p:~p.~n", [Time, H, Min, S]);
valid_time(_) ->
    io:format("Stop feeding we wrong data!~n").

insert(X, []) ->
    [X];
insert(X, Set) ->
    case lists:member(X, Set) of
	true ->
	    Set;
	false ->
	    [X|Set]
end.
