# Spam report app

## Frontend

Front-end is built in Vue.js and is located in ./frontend

## Backend

Back-end is built in Erlang, using Cowboy as server (https://ninenines.eu).

Erlang.mk is used as build tool (Makefile based).

To start server on port 8080, run the following in ./backend:

```
make run
```

To run tests:

```
make eunit
```