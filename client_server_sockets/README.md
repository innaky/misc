# client server with sockets
An client server architecture

# Process
![Image Process](https://raw.githubusercontent.com/innaky/misc/master/client_server_sockets/server_client.png)

# Echo server

 One client:

- ### Server zone
```erlang
> c(echo_serv).
{ok,echo_serv}
> echo_serv:listen(5678).
ok
```

- ### Client zone (with GNU/Linux, BSD*)
```bash
echo -n "send data over TCP" | nc 127.0.0.1 5678
send data over TCP
```
