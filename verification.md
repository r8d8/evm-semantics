KEVM Verification
=================

Using K's reachability logic theorem prover, we're able to verify many properties about EVM programs as reachability claims.
This module defines some helpers which make writing specifications simpler.

```{.k .java}
requires "evm.k"

module VERIFICATION
    imports EVM
```

Sum to N
--------

As a demonstration of simple reachability claims involing a circularity, we prove the EVM [Sum to N](proofs/sum-to-n.md) program correct.
This program sums the numbers from 1 to N (for sufficiently small N), including pre-conditions dis-allowing integer under/overflow and stack overflow.

```{.k .java}
    syntax Map ::= "sumTo" "(" Int ")" [function]
 // ---------------------------------------------
    rule sumTo(N)
      => #asMapOpCodes( PUSH(1, 0) ; PUSH(32, N)                // s = 0 ; n = N
                      ; JUMPDEST                                // label:loop
                      ; DUP(1) ; ISZERO ; PUSH(1, 52) ; JUMPI   // if n == 0, jump to end
                      ; DUP(1) ; SWAP(2) ; ADD                  // s = s + n
                      ; SWAP(1) ; PUSH(1, 1) ; SWAP(1) ; SUB    // n = n - 1
                      ; PUSH(1, 35) ; JUMP                      // jump to loop
                      ; JUMPDEST                                // label:end
                      ; .OpCodes
                      ) [macro]
```

Abstraction
-----------

We design abstractions that capture the EVM low-level specific details, allowing to specify specifications and reason about properties in a higher level similar to that of the surface languages (e.g., Solidity or Viper) in which smart contracts are written.

### Memory Abstraction

We present an abstraction for the EVM memory to allow the word-level reasoning since the word is considered as the smallest unit of values in the surface language level, while the EVM memory is byte-addressable.

Specifically, we introduce uninterpreted function abstractions and refinements for the word-level reasoning.

The term nthbyteof(v, i, n) represents the i-th byte of the two's complement representation of v in n bytes (0 being MSB), with discarding high-order bytes when v is not fit in n bytes.

```{.k .java}
  syntax Int ::= nthbyteof(Int, Int, Int) [function, smtlib(smt_nthbyteof)]
```

Precisely it can be defined as follows.

```{.k .java}
  rule nthbyteof(V, I, N) => nthbyteof(V /Int 256, I, N -Int 1) when N  >Int (I +Int 1) [concrete]
  rule nthbyteof(V, I, N) =>           V %Int 256               when N ==Int (I +Int 1) [concrete]
```

However, we'd like to keep it uninterpreted to avoid the non-linear arithmetic during the reasoning.

Instead, we introduce lemmas over the uninterpreted functional terms and the semantic functions over them.

```{.k .java}
  rule 0 <=Int nthbyteof(V, I, N)          => true
  rule         nthbyteof(V, I, N) <Int 256 => true

  rule #asWord( nthbyteof(V,  0, 32)
              : nthbyteof(V,  1, 32)
              : nthbyteof(V,  2, 32)
              : nthbyteof(V,  3, 32)
              : nthbyteof(V,  4, 32)
              : nthbyteof(V,  5, 32)
              : nthbyteof(V,  6, 32)
              : nthbyteof(V,  7, 32)
              : nthbyteof(V,  8, 32)
              : nthbyteof(V,  9, 32)
              : nthbyteof(V, 10, 32)
              : nthbyteof(V, 11, 32)
              : nthbyteof(V, 12, 32)
              : nthbyteof(V, 13, 32)
              : nthbyteof(V, 14, 32)
              : nthbyteof(V, 15, 32)
              : nthbyteof(V, 16, 32)
              : nthbyteof(V, 17, 32)
              : nthbyteof(V, 18, 32)
              : nthbyteof(V, 19, 32)
              : nthbyteof(V, 20, 32)
              : nthbyteof(V, 21, 32)
              : nthbyteof(V, 22, 32)
              : nthbyteof(V, 23, 32)
              : nthbyteof(V, 24, 32)
              : nthbyteof(V, 25, 32)
              : nthbyteof(V, 26, 32)
              : nthbyteof(V, 27, 32)
              : nthbyteof(V, 28, 32)
              : nthbyteof(V, 29, 32)
              : nthbyteof(V, 30, 32)
              : nthbyteof(V, 31, 32)
              : .WordStack ) => V
    requires 0 <=Int V andBool V <Int (2 ^Int 256)

  rule #padToWidth(32, #asByteStack(V)) => #asByteStackInWidth(V, 32)
    requires 0 <=Int V andBool V <Int (2 ^Int 256)

  // for extracting first four bytes of function signature
  rule #padToWidth(N, #asByteStack(#asWord(WS))) => WS
    requires noOverflow(WS) andBool N ==Int #sizeWordStack(WS)

  syntax Bool ::= noOverflow(WordStack)    [function]
                | noOverflowAux(WordStack) [function]
  rule noOverflow(WS) => #sizeWordStack(WS) <=Int 32 andBool noOverflowAux(WS)
  rule noOverflowAux(W : WS) => 0 <=Int W andBool W <Int 256 andBool noOverflowAux(WS)
  rule noOverflowAux(.WordStack) => true

  // syntactic sugar
  syntax WordStack ::= #asByteStackInWidth(Int, Int) [function]
                     | #asByteStackInWidthaux(Int, Int, Int, WordStack) [function]
  rule #asByteStackInWidth(X, N) => #asByteStackInWidthaux(X, N -Int 1, N, .WordStack)
  rule #asByteStackInWidthaux(X, I, N, WS) => #asByteStackInWidthaux(X, I -Int 1, N, nthbyteof(X, I, N) : WS) when I >Int 0
  rule #asByteStackInWidthaux(X, 0, N, WS) => nthbyteof(X, 0, N) : WS
```

### Abstraction for Hash

We do not model the hash function as an injective function simply because it is not true due to the pigeonhole principle.

Instead, we abstract it as an uninterpreted function that captures the possibility of the hash collision.

```{.k .java}
  syntax Int ::= hash(Int) [smtlib(smt_hash)]
```

In the specification, however, one can avoid reasoning about the collision by assuming all the hashed values appearing during the execution are disjoint.

In another word, we instantiate the injectivity property only for the terms appearing during the symbolic execution and reasoning, similarly as the universal quantifier instantiation does.

```{.k .java}
  rule keccak( nthbyteof(V,  0, 32)
             : nthbyteof(V,  1, 32)
             : nthbyteof(V,  2, 32)
             : nthbyteof(V,  3, 32)
             : nthbyteof(V,  4, 32)
             : nthbyteof(V,  5, 32)
             : nthbyteof(V,  6, 32)
             : nthbyteof(V,  7, 32)
             : nthbyteof(V,  8, 32)
             : nthbyteof(V,  9, 32)
             : nthbyteof(V, 10, 32)
             : nthbyteof(V, 11, 32)
             : nthbyteof(V, 12, 32)
             : nthbyteof(V, 13, 32)
             : nthbyteof(V, 14, 32)
             : nthbyteof(V, 15, 32)
             : nthbyteof(V, 16, 32)
             : nthbyteof(V, 17, 32)
             : nthbyteof(V, 18, 32)
             : nthbyteof(V, 19, 32)
             : nthbyteof(V, 20, 32)
             : nthbyteof(V, 21, 32)
             : nthbyteof(V, 22, 32)
             : nthbyteof(V, 23, 32)
             : nthbyteof(V, 24, 32)
             : nthbyteof(V, 25, 32)
             : nthbyteof(V, 26, 32)
             : nthbyteof(V, 27, 32)
             : nthbyteof(V, 28, 32)
             : nthbyteof(V, 29, 32)
             : nthbyteof(V, 30, 32)
             : nthbyteof(V, 31, 32)
             : .WordStack ) => hash(V)
    requires 0 <=Int V andBool V <Int (2 ^Int 256)

  syntax Int ::= sha3(Int) [function]
  rule sha3(V) => keccak(#padToWidth(32, #asByteStack(V)))
    requires 0 <=Int V andBool V <Int (2 ^Int 256)
```

### Guided Simplification

We introduce (guided) simplification rules that capture arithmetic properties, which lead to smaller terms in size.

```{.k .java}
  rule 0 +Int N => N
  rule N +Int 0 => N

  rule N -Int 0 => N

  rule 1 *Int N => N
  rule N *Int 1 => N
  rule 0 *Int _ => 0
  rule _ *Int 0 => 0

  rule N /Int 1 => N

  rule 0 |Int N => N
  rule N |Int 0 => N
  rule N |Int N => N

  rule 0 &Int N => 0
  rule N &Int 0 => 0
  rule N &Int N => N

  syntax Bool ::= #isConcrete(K) [function, hook(KREFLECTION.isConcrete)]

  rule (I1 +Int I2) +Int I3 => I1 +Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
  rule (I1 +Int I2) -Int I3 => I1 +Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
  rule (I1 -Int I2) +Int I3 => I1 -Int (I2 -Int I3) when #isConcrete(I2) andBool #isConcrete(I3)
  rule (I1 -Int I2) -Int I3 => I1 -Int (I2 +Int I3) when #isConcrete(I2) andBool #isConcrete(I3)

  // for gas calculation
  rule A -Int (#ifInt C #then B1 #else B2 #fi) => #ifInt C #then (A -Int B1) #else (A -Int B2) #fi
  rule (#ifInt C #then B1 #else B2 #fi) -Int A => #ifInt C #then (B1 -Int A) #else (B2 -Int A) #fi
```

### Boolean

In EVM, no boolean value exist but instead, 1 and 0 are used to represent true and false respectively.

We introduce an abstraction for that, bool2int, as an uninterpreted function, and provide lemmas over it.

```{.k .java}
  syntax Int ::= bool2int(Bool) [function] // [smtlib(smt_bool2int)]
  rule bool2int(B) => 1 requires B
  rule bool2int(B) => 0 requires notBool(B)

  rule bool2int(A) |Int bool2int(B) => bool2int(A  orBool B)
  rule bool2int(A) &Int bool2int(B) => bool2int(A andBool B)

  rule bool2int(A)  ==K 0 => notBool(A)
  rule bool2int(A)  ==K 1 => A
  rule bool2int(A) =/=K 0 => A
  rule bool2int(A) =/=K 1 => notBool(A)

  rule chop(bool2int(B)) => bool2int(B)
```

### Modulo Reduction

Simple lemmas for the modulo reduction.

```{.k .java}
  // TODO: change semantics
  rule chop(I) => I modInt /* pow256 */ 115792089237316195423570985008687907853269984665640564039457584007913129639936 [concrete, smt-lemma]

  rule 0 <=Int chop(V)                     => true
  rule         chop(V) <Int /* 2 ^Int 256 */ 115792089237316195423570985008687907853269984665640564039457584007913129639936 => true
```

ABI Calls
---------

The ABI Call mechanism provides syntatic sugar to make writing proofs easier.
Instead of manually populating the `<callData>` cell and `<pc>` cell with the right values,
we the sugar allows following conveniences -

 `#abiCallData(*FUNCTION_NAME*, TypedArgs)`, where the typed args to have be of the
 `#uint160(*DATA*)` where the types are from the ABI specification, and enclose
 the data.

The above constructs place the correct values (in accordance with the ABI) in the `<callData>`
cell, allowing proofs of ABI-compliant EVM program to begin at `<pc> 0 </pc>`.

```{.k .java}
    syntax TypedArg ::= "#uint160"      "(" Int ")"
                      | "#address"      "(" Int ")"
                      | "#uint256"      "(" Int ")"

    syntax TypedArgs ::= List{TypedArg, ","}

    syntax WordStack ::= #abiCallData( String , TypedArgs ) [function]
    rule #abiCallData( FNAME , ARGS )
      => #parseByteStack(substrString(Keccak256(#generateSignature(FNAME, ARGS)), 0, 8))
      ++ #encodeArgs(ARGS)

    syntax String ::= #generateSignature        ( String, TypedArgs)    [function]
                    | #generateSignatureAux     ( String, TypedArgs)    [function]
    rule #generateSignature( FNAME , ARGS ) => #generateSignatureAux(FNAME +String "(", ARGS)
    //
    rule #generateSignatureAux(SIGN, TARGA, TARGB, TARGS)  => #generateSignatureAux(SIGN +String #typeName(TARGA) +String ",", TARGB, TARGS)
    rule #generateSignatureAux(SIGN, TARG, .TypedArgs)     => #generateSignatureAux(SIGN +String #typeName(TARG), .TypedArgs)
    rule #generateSignatureAux(SIGN, .TypedArgs)           => SIGN +String ")"

    syntax String ::= #typeName ( TypedArg ) [function]
    rule #typeName(#uint160( _ ))  => "uint160"
    rule #typeName(#address( _ ))  => "address"
    rule #typeName(#uint256( _ ))  => "uint256"

    syntax WordStack ::= "#encodeArgs" "(" TypedArgs ")" [function]
    rule #encodeArgs(ARG, ARGS)    => #getData(ARG) ++ #encodeArgs(ARGS)
    rule #encodeArgs(.TypedArgs)   => .WordStack

    syntax WordStack ::= "#getData" "(" TypedArg ")" [function]
    rule #getData(#uint160( DATA )) => #asByteStackInWidth( DATA , 32 )
    rule #getData(#address( DATA )) => #asByteStackInWidth( DATA , 32 )
    rule #getData(#uint256( DATA )) => #asByteStackInWidth( DATA , 32 )
```

```{.k .java}
    syntax WordStack ::= "%HKG_ProgramBytes"       [function]
                       | "%HKG_ProgramBytes_buggy" [function]
    syntax Map ::= "%HKG_Program"       [function]
                 | "%HKG_Program_buggy" [function]

    rule %HKG_ProgramBytes       => #parseByteStack("0x60606040526004361061006d576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063095ea7b31461007257806323b872dd146100cc57806370a0823114610145578063a9059cbb14610192578063dd62ed3e146101ec575b600080fd5b341561007d57600080fd5b6100b2600480803573ffffffffffffffffffffffffffffffffffffffff16906020019091908035906020019091905050610258565b604051808215151515815260200191505060405180910390f35b34156100d757600080fd5b61012b600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803590602001909190505061034a565b604051808215151515815260200191505060405180910390f35b341561015057600080fd5b61017c600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506105c6565b6040518082815260200191505060405180910390f35b341561019d57600080fd5b6101d2600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803590602001909190505061060f565b604051808215151515815260200191505060405180910390f35b34156101f757600080fd5b610242600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803573ffffffffffffffffffffffffffffffffffffffff16906020019091905050610778565b6040518082815260200191505060405180910390f35b600081600260003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a36001905092915050565b600081600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410158015610417575081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410155b80156104235750600082115b156105ba5781600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825403925050819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3600190506105bf565b600090505b9392505050565b6000600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050919050565b600081600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002054101580156106605750600082115b1561076d5781600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825401925050819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a360019050610772565b600090505b92915050565b6000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020549050929150505600a165627a7a723058207e0ec45a8f499af74c964dd2887d82a5b0f9522a60a1df3f107bddccf74118470029")                 [macro]
    rule %HKG_ProgramBytes_buggy => #parseByteStack("60606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff168063095ea7b31461006a57806323b872dd146100c457806370a082311461013d578063a9059cbb1461018a578063dd62ed3e146101e4575b600080fd5b341561007557600080fd5b6100aa600480803573ffffffffffffffffffffffffffffffffffffffff16906020019091908035906020019091905050610250565b604051808215151515815260200191505060405180910390f35b34156100cf57600080fd5b610123600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803573ffffffffffffffffffffffffffffffffffffffff16906020019091908035906020019091905050610343565b604051808215151515815260200191505060405180910390f35b341561014857600080fd5b610174600480803573ffffffffffffffffffffffffffffffffffffffff169060200190919050506105c4565b6040518082815260200191505060405180910390f35b341561019557600080fd5b6101ca600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803590602001909190505061060e565b604051808215151515815260200191505060405180910390f35b34156101ef57600080fd5b61023a600480803573ffffffffffffffffffffffffffffffffffffffff1690602001909190803573ffffffffffffffffffffffffffffffffffffffff16906020019091905050610773565b6040518082815260200191505060405180910390f35b600081600260003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a3600190505b92915050565b600081600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410158015610410575081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205410155b801561041c5750600082115b156105b35781600160008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254019250508190555081600260008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600082825403925050819055508273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3600190506105bd565b600090506105bd565b5b9392505050565b6000600160008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205490505b919050565b600081600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020541015801561065f5750600082115b156107635781600160003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000206000828254039250508190555081600160008573ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020819055508273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a36001905061076d565b6000905061076d565b5b92915050565b6000600260008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205490505b929150505600a165627a7a7230582093e640afb442869193a08cf82ed9577e403c7c53a6a95f589e2b673195da102e0029") [macro]

    rule %HKG_Program => #asMapOpCodes(#dasmOpCodes(%HKG_ProgramBytes, DEFAULT))
    rule %HKG_Program_buggy => #asMapOpCodes(#dasmOpCodes(%HKG_ProgramBytes_buggy, DEFAULT))

```
The corresponding operations perform manipulations on
byte represetnations of words.

- An aligned division operation can be attained via byte shifts.
- Consider `B1: B2: B3: .WordStack` is bytes based word stack. Division by
256 is `B1: B2: .WordStack`. It doesn't matter if B3 is symbolic, as long as B3 <= 255.
- The rule only applies on `#asWord`, which only operates over byte-stacks.

```{.k .java}

  rule chop( #asWord( WS ) /Int D ) => #asWord( #take(#sizeWordStack( WS ) -Int log256Int( D ), WS) )
    requires D %Int 256 ==Int 0

```
- The corresponding Lemmas operate over `&Int` and `chop`
- X &Int (2^a - 1) == X, given X <= (2^a - 1)

```{.k .java}
   rule chop(X &Int Y)    => X &Int Y    requires (X <Int pow256) orBool (Y <Int pow256)

   // &Int Associativity
   rule X &Int (Y &Int Z) => (X &Int Y) &Int Z

   rule X &Int Y          => Y           requires    (((2 ^Int (log2Int(X) +Int 1)) -Int 1) ==Int X)
                                          andBool      (Y <=Int X)

endmodule
```
