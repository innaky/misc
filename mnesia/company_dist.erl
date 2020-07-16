-module(company_dist).
-include_lib("stdlib/include/qlc.hrl").
-include("company.hrl").
-export([init/0]).

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
