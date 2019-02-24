-module(datastruct).
-compile(export_all).
-include("record.hrl").

-record(robot, {name,
		type=industrial,
		hobbies,
		details=[]}).

included() ->
    #included{x=10,y=20}.

first_robot() ->
    #robot{name="Examplebot",
	   type=friend,
	   details=["Have bugs xD."]}.

%% defaults values

car_factory(CorpName)->
    #robot{name=CorpName, hobbies="building cars :)"}.

-record(user, {id, name, group, age}).

%% using the struct in a function with pattern matching
admin_panel(#user{name=Name, group=admin}) ->
    Name ++ " is allowed!";
admin_panel(#user{name=Name}) ->
    Name ++ " is not allowed".

adult_section(U = #user{}) when U#user.age >= 18 ->
    allowed;
adult_section(_) ->
    forbidden.
