-module(hof).
-export([increment/1, increment_t/1, decrement/1, decrement_t/1, addone/1, lessone/1]).
-export([map/2, even/1, old_woman/1, filter/2, maxm/1, sum/1, fold/3]).

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

%% Anonymous functions
%% Now i have more power
%% hof:map(fun(X) -> X +1 end, [34,13,67,15,27,26]).

%% Only even numbers
even(List) ->
    even(List, []).
even([], Acc) ->
    Acc;
%% Predicate
even([H|T], Acc) when H rem 2 == 0 ->
    even(T, Acc++[H]);
%% next value (normal recursion)
even([_|T], Acc) ->
    even(T, Acc).

%% Only > 60 years
old_woman(List) ->
    old_woman(List, []).
old_woman([], Acc) ->
    Acc;
%% Person = Head, People = Tail
old_woman([Person = {female, Age}|People], Acc) when Age > 60 ->
    old_woman(People, [Person|Acc]);
old_woman([_|People], Acc) ->
    old_woman(People, Acc).

filter(Pred, List) ->
    lists:reverse(filter(Pred, List, [])).
filter(_, [], Acc) ->
    Acc;
filter(Pred, [H|T], Acc) ->
    case Pred(H) of
	true ->
	    filter(Pred, T, [H|Acc]);
	false ->
	    filter(Pred, T, Acc)
    end.

%% maximum value of a list
maxm([H|T]) ->
    maxm2(T, H).
maxm2([], MaxVal) ->
    MaxVal;
maxm2([H|T], MaxVal) when H > MaxVal ->
    maxm2(T, H);
maxm2([_|T], MaxVal) ->
    maxm2(T, MaxVal).

sum(List) ->
    sum(List, 0).
sum([], Acc) ->
    Acc;
sum([H|T], Acc) ->
    sum(T, Acc+H).

fold(_, InitValue, [])->
    InitValue;
fold(F, InitValue, [H|T]) ->
    fold(F, F(H,InitValue), T).

%% If the acumulator function is a list you can build hof using
%% fold, because fold is an universal abstraction

%%% The internal function (anonymous function) is the base case
%%% it only applies to the `Head` of the `List`, the `Tail` is
%%% acumulated in the empthy list [].
reverse(List) ->
    fold(fun(X, Acc) -> [X|Acc] end, [], List).

map2(Func, Lst) ->
    reverse(fold(fun(X, Acc) -> [Func(X)|Acc] end, [], Lst).

filter2(Pred, Lst) ->
    F = fun(X, Acc) ->
		case Pred(X) of
		    true ->
			[X|Acc];
		    false ->
			Acc
		end
	end,
    reverse(fold(F, [], L)).
