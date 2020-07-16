-module(company_dist).
-include_lib("stdlib/include/qlc.hrl").
-include("company.hrl").
-export([init/0, insert_emp/3, included/0]).

init() ->
    mnesia:create_table(employee, [{ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']}, 
                                   {attributes, record_info(fields, employee)}]),
    mnesia:create_table(dept, [{ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']},
                               {attributes, record_info(fields, dept)}]),
    mnesia:create_table(project, [{ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']},
                                  {attributes, record_info(fields, project)}]),
    mnesia:create_table(manager, [{type, bag},
                                  {ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']},
                                  {attributes, record_info(fields, manager)}]),
    mnesia:create_table(at_dep, [{ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']},
                                 {attributes, record_info(fields, at_dep)}]),
    mnesia:create_table(in_proj, [{ram_copies, ['a@innaky.erlang.erl', 'b@second.erlang.erl']},
                                  {attributes, record_info(fields, in_proj)}]).

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

included() ->
    Emp = #employee{emp_no=0, name="innaky", salary=0, sex="female", phone=5432, room_no={7, 13}},
    insert_emp(Emp, 'Algoritm/Math', [erlang, mnesia, otp, lisp]).
