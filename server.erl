-module(server).

-behaviour(gen_server).

-export([
    start_link/0,
    handle_call/3,
    code_change/3,
    handle_cast/2,
    terminate/2,
    handle_info/2,
    init/1
]).

-define(Port, 8080).
-define(Opts, [
    % Receives binary data.
    binary,
    % The first 2 bytes contains the lenght of the packet.
    {packet, 2},
    % The data needs to be received with gen_tcp:recv.
    {active, false}
]).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

% Initializes a tcp listener then casts accept to itself.
init([]) ->
    {ok, Listener} = gen_tcp:listen(?Port, ?Opts),
    gen_server:cast(self(), accept),
    {ok, Listener}.

% Accepts a Socket and receives the data with a timeout
% of 1 second, Then casts accept to itself.
handle_cast(accept, Listener) ->
    {ok, Socket} = gen_tcp:accept(Listener),
    {ok, Packet} = gen_tcp:recv(Socket, 0, 1000),
    io:format("Recv: ~w~n", [Packet]),
    ok = gen_tcp:close(Socket),
    gen_server:cast(self(), accept),
    {noreply, Listener}.

% Does nothing.
handle_call(_, _From, State) ->
    {noreply, State}.

terminate(_Reason, _State) -> ok.
handle_info(Info, State) ->
    io:format("Info: ~w~n", [Info]),
    {noreply, State}.
code_change(_OldVersion, State, _Extra) -> {ok, State}.
