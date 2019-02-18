-module(recursion).
-export([fact/1, factmatch/1, my_length/1, tail_fact/1, tail_len/1, repeat/2, tail_repeat/2]).

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
