-module(hof).
-export([increment/1, increment_t/1, decrement/1, decrement_t/1, addone/1, lessone/1]).
-export([map/2]).

increment([]) ->
    [];
increment([H|T]) ->
    [H+1|increment(T)].

increment_t(List) ->
    increment_t(List, []).
increment_t([], Acc) ->
    Acc;
increment_t([H|T], Acc) ->
    [H+1]++increment_t(T, Acc).

decrement([]) ->
    [];
decrement([H|T]) ->
    [H-1|decrement(T)].

decrement_t(List) ->
    decrement_t(List, []).
decrement_t([], Acc) ->
    Acc;
decrement_t([H|T], Acc) ->
    [H-1]++decrement_t(T, Acc).

%% higher order function
map(_, []) ->
    [];
map(F, [H|T]) ->
    [F(H)| map(F, T)].

addone(Num) ->
    Num + 1.

lessone(Num) ->
    Num - 1.
