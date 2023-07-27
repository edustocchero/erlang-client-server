-module(client).

-export([
    say_hello/0
]).

-define(Host, "localhost").
-define(Port, 8080).
-define(Opts, [
    binary,
    {packet, 2}
]).

% Sends Hello to the server.
say_hello() ->
    {ok, Socket} = gen_tcp:connect(?Host, ?Port, ?Opts),
    ok = gen_tcp:send(Socket, <<"Hello!">>),
    ok = gen_tcp:close(Socket),
    ok.
