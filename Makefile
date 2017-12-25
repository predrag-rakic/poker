.PHONY: all build test

all: build

build:
	MIX_ENV=prod mix compile
	MIX_ENV=prod mix escript.build

test:
	mix test
