KEVM: Semantics of EVM in K
===========================

In this repository we provide a model of the EVM in K.

Documentation/Support
---------------------

These may be useful for learning KEVM and K (newest to oldest):

-   [Jello Paper](https://jellopaper.org/), generated using [Sphinx Documentation Generation].
-   [20 minute tour of the semantics](https://www.youtube.com/watch?v=tIq_xECoicQNov) at [Devcon3](https://ethereumfoundation.org/devcon3/).
-   [KEVM 1.0 technical report](http://hdl.handle.net/2142/97207), especially sections 3 and 5.

To get support for KEVM, please join our [Riot Room](https://riot.im/app/#/room/#k:matrix.org).

This Repository
---------------

The following files constitute the KEVM semantics:

-   [krypto.md](krypto) sets up some basic cryptographic primitives.
-   [data.md](data) provides the (functional) data of EVM (256 bit words, wordstacks, etc...).
-   [evm.md](evm) is the main KEVM semantics, containing the configuration and transition rules of EVM.

These additional files extend the semantics to make the repository more useful:

-   [driver.md](driver) is an execution harness for KEVM, providing a simple language for describing tests/programs.
-   [analysis.md](analysis) contains any automated analysis tools we develop.

Finally, these files pertain to the [K Reachability Logic Prover]:

-   [verification.md](verification) adds helpers for verification efforts.
-   [proofs/README.md](proofs/README) documents proofs we have performed.

Using the Definition
--------------------

### Dependencies

-   `./Build` requires `xmllint` to pretty-print configurations when running programs/tests.
-   When developing, the `*.k` files are generated from the `*.md` files using [Pandoc](https://pandoc.org).
-   For generating the Jello Paper, the [Sphinx Documentation Generation] tool is used.
    Additionally, you'll need to install the Python `pygments` for K available in the [K Editor Support] repository.

### K Backends

There are two backends of K available, the OCAML backend for concrete execution and the Java backend for symbolic reasoning and proofs.
This repository contains the build-products for both backends in `.build/java/` and `.build/ocaml/`.

### Installing and building

See [INSTALL.md](INSTALL.md) for installation and build instructions.

### Example Runs

Run the file `tests/VMTests/vmArithmeticTest/add0.json`:

```sh
$ ./Build run tests/VMTests/vmArithmeticTest/add0.json

# Which actually calls:
$ krun --directory .build/uiuck/ -cSCHEDULE=DEFAULT -cMODE=VMTESTS tests/VMTests/vmArithmeticTest/add0.json
```

Run the same file as a test:

```sh
$ ./Build test tests/VMTests/vmArithmeticTest/add0.json
```

To run proofs, you can similarly use `./Build`.
For example, to prove the specification `tests/proofs/hkg/transfer-else-spec.k`:

```sh
$ ./Build prove tests/proofs/hkg/transfer-else-spec.k

# Which actually calls:
$ krun --directory .build/uiuck/ -cSCHEDULE=DEFAULT -cMODE=NORMAL \
         --z3-executable tests/templates/dummy-proof-input.json --prove tests/proofs/hkg/transferFrom-else-spec.k \
         </dev/null
```

Finally, if you want to debug a given program (by stepping through its execution), you can use the `debug` option:

```sh
$ ./Build debug tests/VMTests/vmArithmeticTest/add0.json
...
KDebug> s
1 Step(s) Taken.
KDebug> p
... Big Configuration Here ...
KDebug>
```

Contributing
------------

Any pull requests into this repository will not be reviewed until at least some conditions are met.
Here we'll accumulate the standards that this repository is held to.

Code style guidelines, while somewhat subjective, will still be inspected before going to review.
In general, read the rest of the definition for examples about how to style new K code; we collect a few common flubs here.

Writing tests and more contract proofs is **always** appreciated.
Tests can come in the form of proofs done over contracts too :).

### Hard - Every Commit

These are hard requirements (**must** be met before review), and they **must** be true for **every** commit in the PR.

-   If a new feature is introduced in the PR, and later a bug is fixed in the new feature, the bug fix must be squashed back into the feature introduction.
    The *only* exceptions to this are if you want to document the bug because it was quite tricky or is something you believe should be fixed about K.
    In these exceptional cases, place the bug-fix commit directly after the feature introduction commit and leave useful commit messages.
    In addition, mark the feature introduction commit with `[skip-ci]` if tests will fail on that commit so that we know not to waste time testing it.

-   No tab characters, 4 spaces instead.
    Linux-style line endings; if you're on a Windows machine make sure to run `dos2unix` on the files.
    No whitespace at the end of any lines.

### Hard - PR Tip

These are hard requirements (**must** be met before review), but they only have to be true for the tip of the PR before review.

-   Every test in the repository must pass.
    We will test this with `./tests/ci/with-k bothk ./Build test-all` (or `./tests/ci/with-k bothk ./Build partest-all` on parallel machines).

### Soft - Every Commit

These are soft requirements (review **may** start without these being met), and they will be considered for **every** commit in the PR.

-   Comments do not live in the K code blocks, but rather in the surrounding Markdown (unless there is a really good reason to localize the comment).

-   You should consider prefixing "internal" symbols (symbols that a user would not write in a program) with a hash (`#`).

-   Place a line of `-` after each block of syntax declarations.

    ```{.k}
        syntax Foo ::= "newSymbol"
     // --------------------------
        rule <k> newSymbol => . ... </k>
    ```

    Notice that if there are rules immediately following the syntax declaration, a commented-out line of `-` is inserted afterward.
    Notice that the width of the line of `-` matches that of the preceding line.

-   Place spaces around parentheses and commas in K's pretty functional-style syntax declarations.

    ```{.k}
        syntax Foo ::= newFunctionalSyntax ( Int , String )
     // ---------------------------------------------------
    ```

-   When multiple structurally-similar rules are present, line up as much as possible (and makes sense).

    ```{.k}
        rule <k> #do1       => . ... </k> <cell1> not-done => done        </cell1>
        rule <k> #do1Longer => . ... </k> <cell1> not-done => done-longer </cell1>

        rule <k> #do2     => . ... </k> <cell2> not-done => done2 </cell2>
        rule <k> #doShort => . ... </k> <cell2> nd       => done2 </cell2>
    ```

    This makes it simpler to make changes to entire groups of rules at a time using sufficiently modern editors.
    Notice that if we break alignment (eg. from the `#do1` group above to the `#do2` group), we put an extra line between the groups of rules.

-   Line up the `r` in `requires` with the `l` in `rule` (if it's not all on one line).
    Similarly, line up the end of `andBool` for extra side-conditions with the end of `requires`.

    ```{.k}
        rule <k> A => B ... </k>
             SOME_LARGE_CONFIGURATION

          requires A > 3
           andBool isPrime(A)
    ```

Resources
=========

-   [EVM Yellowpaper](https://github.com/ethereum/yellowpaper): Original specification of EVM.
-   [LEM Semantics of EVM](https://github.com/pirapira/eth-isabelle)
-   [Ethereum Test Set](https://github.com/ethereum/tests)

For more information about [The K Framework](http://kframework.org), refer to these sources:

-   [The K Tutorial](https://github.com/kframework/k/tree/master/k-distribution/tutorial)
-   [Semantics-Based Program Verifiers for All Languages](http://fsl.cs.illinois.edu/index.php/Semantics-Based_Program_Verifiers_for_All_Languages)
-   [Reachability Logic Resources](http://fsl.cs.illinois.edu/index.php/Reachability_Logic_in_K)
-   [Matching Logic Resources](http://fsl.cs.illinois.edu/index.php/Matching_Logic)
-   [Logical Frameworks](http://dl.acm.org/citation.cfm?id=208700): Discussion of logical frameworks.

We are using [GNU Parallel](https://www.gnu.org/software/parallel/) to assist in testing these semantics in parallel.

[Sphinx Documentation Generation]: <http://sphinx-doc.org>
[K Reachability Logic Prover]: <http://fsl.cs.illinois.edu/FSL/papers/2016/stefanescu-park-yuwen-li-rosu-2016-oopsla/stefanescu-park-yuwen-li-rosu-2016-oopsla-public.pdf>
[K Editor Support]: <https://github.com/kframework/k-editor-support>
