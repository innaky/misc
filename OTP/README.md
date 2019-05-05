# OTP :D
This zone is the exercises with OTP/Erlang!

# {server1, name_server}

```erlang
c(server1).
c(name_server).
server1:start(name_server, name_server).
> true
name_server:add(innaky, "programming").
> ok
name_server:find(innaky).
> {ok, "Erlang programmer"}
```

# {server2, name_server}

You can change the server zone without efect in the functional zone.

```erlang
c(server2).
c(name_server).
server2:start(name_server, name_server).
> true
name_server:add(innaky, "Erlang programmer").
> ok
name_server:find(innaky).
> {ok, "Erlang programmer"}
```

# {server3, name_server1} and hot update {server3, new_name_server}.

```erlang
c(server3).
c(name_server1).
server3:start(name_server, name_server1).
> true
name_server1:add(innaky, "Erlang lover :D").
> ok
name_server1:add(sapkowski, "Writer").
> ok
c(new_name_server).
{ok, new_name_server}
server3:swap_code(name_server, new_name_server).
> ack
new_name_server:all_names().
[innaky, sapkowski]
```