-module(monitorandaction).
-export([if_down_exec/2]).

%% if_down_exec: creates a monitor and if the monitoring process down, this function
%% exec other function
if_down_exec(Pid, F) ->
    spawn(fun() ->
		  % erlang:monitor(process, Pid) -> Ref
		  Ref = monitor(process, Pid),
		  receive
		      {'DOWN', Ref, process, Pid, Why} ->
			  F(Why)
		  end
          end).

%%% Closure
%F = fun() ->
%	     receive
%		 X ->
%		     list_to_atom(X)
%	     end
%    end.


%Pid = spawn(F).
%<0.85.0>
%
%monitorandaction:if_down_exec(Pid, fun(Why) ->
%					   io:format(" ~p dies with: ~p~n",[Pid, Why])
%				    end).
%<0.87.0>
%
%Pid ! hi.

%% Output:
%<0.85.0> died with: {badarg,[{erlang,list_to_atom,[hi],[]}]}
%hi
% =ERROR REPORT==== ... ===
%Error in process <0.85.0> with exit value:
%{badarg,[{erlang,list_to_atom,[hi],[]}]}
