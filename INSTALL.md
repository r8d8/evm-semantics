Installing KEVM
===============

### Dependencies

-   Bison
-   Flex
-   Java 8 JDK
-   Opam
-   libmpfr
-   autotools/autoconf
-   libtool
-   Z3

On Ubuntu:

```sh
sudo apt-get update
sudo apt-get install make gcc maven openjdk-8-jdk flex opam pkg-config libmpfr-dev autoconf libtool pandoc zlib1g-dev z3
```

### Installation

In a nutshell, to install KEVM on an Ubuntu 16.04 machine, run:

```sh
make deps               # Build dependencies not installed by package manager
eval `opam config env`  # add OCAML installation to path
make build              # Build Project
```

To run the Ethereum VMTests and GeneralStateTests, run `make test`
To run one of the proofs, run `./Build prove $specfile`
