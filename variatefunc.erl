-module(variatefunc).
-export([greet/2, head/1, second/1, other_second/1, third_second/1]).

greet(male, Name) ->
    io:format("Hello, Mr. ~s!~n", [Name]);
greet(female, Name) ->
    io:format("Hello, Mrs. ~s!~n", [Name]);
greet(_, Name) ->
    io:format("Hello, ~s~n!", [Name]).

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
