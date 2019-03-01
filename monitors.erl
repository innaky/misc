-module(monitors).
-compile(export_all).

start_critic() ->
    spawn(?MODULE, critic, []).

%% normal runnig but if exit send critic with {Pid, Criticism} pattern, the function
%% timeout before 2 seconds.
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

%% run a new logic with a name process and a trap_exit flag using
%% a patern matching with the exit message.
start_critic2() ->
    spawn(?MODULE, restarter, []).

restarter() ->
    process_flag(trap_exit, true),
    Pid = spawn_link(?MODULE, critic2, []),
    register(critic, Pid),
    receive
	{'EXIT', Pid, normal} ->
	    ok; % not a crash
	{'EXIT', Pid, shutdown} ->
	    ok; % manual kill, not a crash
	{'EXIT', Pid, _} ->
	    restarter()
    end.

judge2(Band, Album) ->
    Ref = make_ref(),
    critic ! {self(), Ref, {Band, Album}},
    receive
	{Ref, Criticism} -> Criticism
    after 2000 ->
	    timeout
    end.

critic2() ->
    receive
	{From, Ref, {"Rage Against the Turing Machine", "Unit Testify"}} ->
	    From ! {Ref, "They are great!"};
	{From, Ref, {"System of a Downtime", "Memoize"}}  ->
	    From ! {Ref, "They're not Johnny Crash but they're good."};
	{From, Ref, {"Johnny Crash", "The Token Ring of Fire"}} ->
	    From ! {Ref, "Simply incredible."};
	{From, Ref, {_Band, _Album}} ->
	    From ! {Ref, "They are terrible!"}
    end,
    critic2().
