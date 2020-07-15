# misc
For generic ideas. not util

## afile_server and afile_client (Erlang)

Call the shell inside of the source repository.

```erlang
c(afile_server).
c(afile_client).
FileServer = afile_server:start(".").
afile_client:new_dir(FileServer, "newdir").
```

## Connecting two erlang nodes and mnesia.

### Servers

* Both servers

```bash
cat /etc/hosts
127.0.0.1 localhost
1.1.1.1 innaky.erlang.erl
1.1.1.2 second.erlang.erl
...
```

```bash
cat ~/.erlang.cookie
innakycooking
```

## Connection

* From innaky server.

```bash
erl -name a -mnesia dir '"company/Mnesia.Company"'
Erlang/OTP 23 [erts-11.0.2] [source] [64-bit] [smp:4:4] [ds:4:4:10] [async-threads:1] [hipe]

Eshell V11.0.2  (abort with ^G)
(a@innaky.erlang.erl)1> net_adm:ping('b@second.erlang.erl').
pong
(a@innaky.erlang.erl)2> nodes().
['b@second.erlang.erl']
(a@innaky.erlang.erl)3>
```

* From second server

```bash
erl -name b -mnesia dir '"company/Mnesia.Company"'
(b@second.erlang.erl)1> nodes().
['a@innaky.erlang.erl']
(b@second.erlang.erl)2>

```