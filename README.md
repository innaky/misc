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