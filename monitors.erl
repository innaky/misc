-module(monitors).
-compile(export_all).

start_critic() ->
    spawn(?MODULE, critic, []).

judge(Pid, Band, Album) ->
    Pid ! {self(), {Band, Album}},
    receive
	{Pid, Criticism} ->
	    Criticism
    after 2000 ->
	    timeout
    end.

critic() ->
    receive
	{From, {"Rage Against the Turing Machine", "Unit Testify"}} ->
	    From ! {self(), "They are great!"};
	{From, {"System of a Downtime", "Memoize"}} ->
	    From ! {self(), "They're no Johnny Crash but they're good."};
	{From, {"Jonny Crash", "The Token Ring of Fire"}} ->
	    From ! {self(), "Simply incredible."};
	{From, {_Band, _Album}} ->
	    From ! {self(), "They are terrible!"}
    end,
    critic().
