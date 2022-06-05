# lambdee-board-script-service

A web server which acts as a service providing Ruby code execution through its REST API
and via WebSockets.

It provides an API for interacting with the main `lambdee-board` server
which is available for use in the scripts it executes.

## Setup

```sh
$ bundle
```

## Run

### Start the server

```sh
$ bin/server
```

### Open the client
```sh
$ open client.html
```

## Problems

### eventmachine

> Installing eventmachine 1.2.7 with native extensions
> Gem::Ext::BuildError: ERROR: Failed to build gem native extension.
> An error occurred while installing eventmachine (1.2.7), and Bundler cannot continue.

```sh
$ gem install eventmachine  -- --with-cppflags=-I/usr/local/opt/openssl/include
```
