# lambdee-board-console-server

## Setup

```sh
$ bundle
```

## Run the example server and client

```sh
$ ruby server.rb
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
