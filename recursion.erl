-module(recursion).
-export([fact/1, factmatch/1, my_length/1, tail_fact/1, tail_len/1]).
-export([repeat/2, tail_repeat/2, reverse/1, tail_reverse/1, tail_reverser/1, sublist/2, tail_sublist/2]).
-export([zip/2, tail_zip/2, partition/4, quicksort/1]).

fact(X) when X == 0 ->
    1;
fact(X) when X > 0 ->
    X * fact(X-1).

%% Factorial with pattern matching
factmatch(0) ->
    1;
factmatch(X) when X > 0 ->
    X * factmatch(X-1).

my_length([]) ->
    0;
my_length([_|T]) ->
    1 + my_length(T).

tail_fact(X) ->
    tail_fact(X,1).
tail_fact(0, Acc) ->
    Acc;
tail_fact(X,Acc) when X > 0 ->
    tail_fact(X-1, X*Acc).

tail_len(List) ->
    tail_len(List, 0).
tail_len([], Acc) ->
    Acc;
tail_len([_|T], Acc) ->
    tail_len(T, Acc+1).

repeat(_, Times) when Times == 0 ->
    [];
%% | is cons in Common lisp
repeat(Num, Times) ->
    [Num | repeat(Num, Times-1)].

tail_repeat(Num, Times) ->
    tail_repeat(Num, Times, []).
tail_repeat(_, Times, Acc) when Times == 0 ->
    Acc;
tail_repeat(Num, Times, Acc) ->
    tail_repeat(Num, Times-1, [Num|Acc]).

reverse([]) ->
    [];
reverse([H|T]) ->
    reverse(T)++[H].

tail_reverse(List) ->
    tail_reverse(List, []).
tail_reverse(List, Acc) when List == [] ->
    Acc;
tail_reverse([H|T], Acc) ->
    tail_reverse(T, [H|Acc]).

tail_reverser(List)->
    tail_reverser(List, []).
tail_reverser([], Acc) ->
    Acc;
tail_reverser([H|T],Acc) ->
    tail_reverser(T, [H|Acc]).

sublist(_, 0) ->
    [];
sublist([H|T], Num) when Num >= 0 ->
    [H]++sublist(T, Num-1).

tail_sublist(List, Num) ->
    tail_sublist(List, Num, []).
tail_sublist(_, 0, Acc) ->
    Acc;
tail_sublist([], _, Acc) ->
    Acc;
tail_sublist([H|T], Num, Acc) when Num > 0 ->
    tail_sublist(T, Num-1, Acc++[H]).

zip([], _) ->
    [];
zip(_, []) ->
    [];
zip([Hx|Tx], [Hy|Ty]) ->
    [{Hx, Hy}]++zip(Tx, Ty).

tail_zip(Flist, Slist) ->
    tail_zip(Flist, Slist, []).
tail_zip(_, [], Acc) ->
    Acc;
tail_zip([], _, Acc) ->
    Acc;
tail_zip([Hx|Tx], [Hy|Ty], Acc) ->
    [{Hx,Hy}]++tail_zip(Tx, Ty, Acc).

partition(_, [], Smaller, Larger) ->
    {Smaller, Larger};
partition(Pivot, [H|T], Smaller, Larger) ->
    if H >= Pivot ->
    partition(Pivot, T, [H|Smaller], Larger);
       H < Pivot ->
    partition(Pivot, T, Smaller, [H|Larger])
    end.

quicksort([]) ->
    [];
quicksort([Pivot|T]) ->
    {Smaller, Larger} = partition(Pivot, T, [], []),
    quicksort(Smaller) ++ [Pivot] ++ quicksort(Larger).
