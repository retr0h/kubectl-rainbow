# rainbow

Simple binary to colorize output.

## Dependencies

    $ go get github.com/golang/dep/cmd/dep

## Building

    $ make build
    $ tree .build/

## Usage

    $ function kubectl() { $(which kubectl) $* | .build/rainbow_darwin_amd64 }

![Alt text](img/rainbow.png?raw=true "Rainbow")

## License

MIT
