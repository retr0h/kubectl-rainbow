# rainbow

Simple binary to colorize output.

## Dependencies

    $ go get github.com/golang/dep/cmd/dep

## Installation

    $ go get github.com/retr0h/rainbow

## Usage

    $ function kubectl() { $(which kubectl) $* | rainbow }

![Alt text](img/rainbow.png?raw=true "Rainbow")

## Building

    $ make build
    $ tree .build/

## License

MIT
