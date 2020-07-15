-module(company).
-include_lib("stdlib/include/qlc.hrl").
-include("company.hrl").
-export([init/0, insert_emp/3, raise/2, included/0, females_mnesia/0, females_qlc/0, raise_females/1]).

% checking the included company.hrl
included() ->
Emp = #employee{emp_no=0, name="innaky", salary=0, sex="female", phone=5432, room_no={7,13}},
insert_emp(Emp, 'Algorith/Math', [erlang, mnesia, otp, hacking]).

init() ->
    mnesia:create_table(employee, [{attributes, record_info(fields, employee)}]),
    mnesia:create_table(dept, [{attributes, record_info(fields, dept)}]),
    mnesia:create_table(project, [{attributes, record_info(fields, project)}]),
    mnesia:create_table(manager, [{type, bag}, {attributes, record_info(fields, manager)}]),
    mnesia:create_table(at_dep, [{attributes, record_info(fields, at_dep)}]),
    mnesia:create_table(in_proj, [{type, bag}, {attributes, record_info(fields, in_proj)}]).

insert_emp(Emp, DepId, ProjNames) ->
    Ename = Emp#employee.name,
    Fun = fun() ->
		  mnesia:write(Emp),
		  AtDep = #at_dep{emp = Ename, dept_id = DepId},
		  mnesia:write(AtDep),
		  make_projs(Ename, ProjNames)
	  end,
    mnesia:transaction(Fun).

make_projs(_, []) ->
    ok;
make_projs(Emp, [First_Project | Rest_Projects]) ->
    mnesia:write(#in_proj{emp = Emp, proj_name = First_Project}),
    make_projs(Emp, Rest_Projects).

% update
raise(Eno, Raise) ->
    F = fun() ->
		[Em] = mnesia:read(employee, Eno, write),
		Salary = Em#employee.salary + Raise,
		New = Em#employee{salary = Salary},
		mnesia:write(New)
	end,
    mnesia:transaction(F).

% mnesia query
females_mnesia() ->
    F = fun() ->
		Female = #employee{sex="female", name='$1', _ = '_'},
		mnesia:select(employee, [{Female, [], ['$1']}])
	end,
    mnesia:transaction(F).

females_qlc() ->
    F = fun() ->
		Q = qlc:q([E#employee.name || E <- mnesia:table(employee),
					      E#employee.sex == "female"]),
		qlc:e(Q)
	end,
    mnesia:transaction(F).

raise_females(Amount) ->
    F = fun()->
		Q = qlc:q([E || E <- mnesia:table(employee), 
                                E#employee.sex == "female"]),
		Fs = qlc:e(Q),
		over_write(Fs, Amount)
	end,
    mnesia:transaction(F).

over_write([], _) ->
    0;
over_write([H|T], Amount) ->
    Salary = H#employee.salary + Amount,
    New = H#employee{salary = Salary},
    mnesia:write(New),
    1 + over_write(T, Amount).
