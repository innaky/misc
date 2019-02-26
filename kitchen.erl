-module(kitchen).
-compile(export_all).

%% return only not found, this function is very poor
fridge1() ->
    receive
	{From, {store, _Food}} ->
	    From ! {self(), ok},
	    fridge1();
	{From, {take, _Food}} ->
	    From ! {self(), not_found},
	    fridge1();
	terminate ->
	    ok
    end.

%% more versatile and recursive function
%% server

start2(FoodList) ->
    spawn(kitchen, fridge2, [FoodList]).

fridge2(FoodList) ->
    receive
	%% match first receive
	{From, {store, Food}} ->
            %% first answer
	    From ! {self(), {ok, Food}},
	    fridge2([Food|FoodList]);
	{From, {list_all, ok}} ->
	    From ! {self(), {ok, FoodList}},
	    fridge2(FoodList);
        %% match other receive
	{From, {take, Food}} ->
            %% conditional answer
	    case lists:member(Food, FoodList) of
		true ->
		    From ! {self(), {ok, Food}},
		    fridge2(lists:delete(Food, FoodList));
		false ->
		    From ! {self(), not_found},
		    fridge2(FoodList)
	    end;
	terminate ->
	    ok
    end.

%%% clients
%% store a food
store(Pid, Food) ->
    Pid ! {self(), {store, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    after 3000 ->
	timeout
    end.

%% take a food
take(Pid, Food) ->
    Pid ! {self(), {take, Food}},
    receive
	{Pid, Msg} ->
	    Msg
    after 30000 ->
        timeout
    end.

%% list all food
list_products(Pid) ->
    Pid ! {self(), {list_all, ok}},
    receive
	{Pid, Msg} ->
	    Msg
    after 3000 ->
        timeout
    end.
