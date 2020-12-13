# rainbow

Simple binary to colorize output.

## Dependencies

    $ go get github.com/golang/dep/cmd/dep

## Installation

    $ go get github.com/retr0h/kubectl-rainbow

## Usage

    $ cat <<'EOL' >kubectl-color
    #!/bin/sh
    exec kubectl $* | $GOPATH/bin/kubectl-rainbow
    EOL

    $ chmod +x kubectl-color
    $ mv kubectl-color ~/bin/
    $ kubectl color get po nginx

    $ alias k='kubectl color'

![Alt text](img/rainbow.png?raw=true "Rainbow")

## Building

    $ make build
    $ tree .build/

## License

MIT
