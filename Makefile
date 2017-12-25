.PHONY: all build test credo

all: build

build:
	MIX_ENV=prod mix compile
	MIX_ENV=prod mix escript.build

test:
	mix test

credo:
	mix credo
