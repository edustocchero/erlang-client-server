all: server.erl client.erl
	erlc server.erl
	erlc client.erl

clean:
	rm -rf *.beam *.dump
