-module(datastruct).
-compile(export_all).

-record(robot, {name,
		type=industrial,
		hobbies,
		details=[]}).

first_robot() ->
    #robot{name="Examplebot",
	   type=friend,
	   details=["Have bugs xD."]}.
