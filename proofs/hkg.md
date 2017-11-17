The Hacker Gold (HKG) Token Smart Contract
==========================================

Transfer Function
-----------------

These parts of the state are constant throughout the proof.

```{.k .transfer-then .transfer-else}
module TRANSFER-SPEC
    imports ETHEREUM-SIMULATION

    rule <k> #execute => (RETURN _ _ ~> _) </k>
         <pc> 0 => _ </pc>
         <exit-code> 1 </exit-code>
         <mode>     NORMAL  </mode>
         <schedule> DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    0 => _     </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List => _ </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>
         <wordStack> .WordStack => _ </wordStack>

         <program>   %HKG_Program </program>
         <id>        %ACCT_ID     </id>
         <caller>    %ORIGIN_ID   </caller>
         <callData>  #abiCallData("transfer",#address(%CALLER_ID),#uint256(TRANSFER)) </callData>
         <callValue> 0            </callValue>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <selfDestruct>   .Set                 </selfDestruct>
         <log>            .Set => _            </log>
         <activeAccounts> SetItem ( %ACCT_ID ) </activeAccounts>
         <messages>       .Bag                 </messages>
```

These parts of the proof change, but we would like to avoid specifying exactly how (abstract over their state change).

```{.k .transfer-then .transfer-else}
         <localMem>    .Map => _ </localMem>
         <previousGas> _    => _ </previousGas>
         <refund>      0    => _ </refund>
```

### Then Branch

```{.k .transfer-then}
         <gas>  G => G -Int 12705 </gas>

         <accounts>
           <account>
             <acctID>   %ACCT_ID     </acctID>
             <balance>  BAL          </balance>
             <code>     %HKG_Program </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> ...
                       (%ACCT_1_BALANCE |-> (B1 => B1 -Int TRANSFER))
                       (%ACCT_1_ALLOWED |-> A1)
                       (%ACCT_2_BALANCE |-> (B2 => B2 +Int TRANSFER))
                       (%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool B2 +Int TRANSFER <Int pow256
       andBool B1 -Int TRANSFER >=Int 0
       andBool G >=Int 12705
endmodule
```

### Else Branch

```{.k .transfer-else}
         <gas> G => G1   </gas>

         <accounts>
           <account>
             <acctID>   %ACCT_ID     </acctID>
             <balance>  BAL          </balance>
             <code>     %HKG_Program </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> ...
                       (%ACCT_1_BALANCE |-> B1:Int)
                       (%ACCT_1_ALLOWED |-> A1:Int)
                       (%ACCT_2_BALANCE |-> B2:Int)
                       (%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >=Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool (B1 <Int TRANSFER orBool TRANSFER ==Int 0)
       andBool (G >=Int 533)
      ensures (G1 ==Int G -Int 533) orBool (G1 ==Int G -Int 522)
endmodule
```

TransferFrom Function
---------------------

These parts of the state are constant throughout the proof.

```{.k .transferFrom-then .transferFrom-else}
module TRANSFER-FROM-SPEC
    imports ETHEREUM-SIMULATION

    rule <k> #execute => (RETURN _ _ ~> _) </k>
         <pc> 0 => _ </pc>
         <exit-code> 1 </exit-code>
         <mode>     NORMAL  </mode>
         <schedule> DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    0 => _     </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List => _ </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>
         <wordStack> .WordStack => _ </wordStack>

         <program>   %HKG_Program </program>
         <id>        %ACCT_ID     </id>
         <caller>    %CALLER_ID   </caller>
         <callData>  #abiCallData("transferFrom",#address(%ORIGIN_ID),#address(%CALLER_ID),#uint256(TRANSFER)) </callData>
         <callValue> 0            </callValue>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <selfDestruct>   .Set                 </selfDestruct>
         <log>            .Set => _            </log>
         <activeAccounts> SetItem ( %ACCT_ID ) </activeAccounts>
         <messages>       .Bag                 </messages>
```

These parts of the proof change, but we would like to avoid specifying exactly how (abstract over their state change).

```{.k .transferFrom-then .transferFrom-else}
         <localMem>    .Map => _ </localMem>
         <previousGas> _    => _ </previousGas>
         <refund>      0    => _ </refund>
```

### Then Branch

```{.k .transferFrom-then}
         <gas>  G => G -Int 18221 </gas>

         <accounts>
           <account>
             <acctID>   %ACCT_ID     </acctID>
             <balance>  BAL          </balance>
             <code>     %HKG_Program </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> ...
                       (%ACCT_1_BALANCE |-> (B1 => B1 -Int TRANSFER))
                       (%ACCT_1_ALLOWED |-> (A1 => A1 -Int TRANSFER))
                       (%ACCT_2_BALANCE |-> (B2 => B2 +Int TRANSFER))
                       (%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool B2 +Int TRANSFER <Int pow256
       andBool B1 -Int TRANSFER >=Int 0
       andBool A1 >=Int TRANSFER andBool A1 <Int pow256
       andBool G >=Int 18221
endmodule
```

### Else Branch

```{.k .transferFrom-else}
         <gas> G => G1   </gas>

         <accounts>
           <account>
             <acctID>   %ACCT_ID     </acctID>
             <balance>  BAL          </balance>
             <code>     %HKG_Program </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> ...
                       (%ACCT_1_BALANCE |-> B1:Int)
                       (%ACCT_1_ALLOWED |-> A1:Int)
                       (%ACCT_2_BALANCE |-> B2:Int)
                       (%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >=Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool (B1 <Int TRANSFER orBool TRANSFER ==Int 0
                 orBool TRANSFER >Int A1)
       andBool G >=Int 785
      ensures (G1 ==Int G -Int 531)
         orBool (G1 ==Int G -Int 774)
         orBool (G1 ==Int G -Int 785)
endmodule
```

Allowance Function
------------------

Here we provide a specification file containing a reachability rule for the verifying the correctness of the HKG Token's Allowance Function.

```{.k .allowance}
module TOKEN-SPEC
imports ETHEREUM-SIMULATION

    rule <k>         #execute => (RETURN _ _  ~> _) </k>
         <exit-code> 1                              </exit-code>
         <mode>      NORMAL                         </mode>
         <schedule>  DEFAULT                        </schedule>

         <output>        .WordStack => _    </output>
         <memoryUsed>    0          => _    </memoryUsed>
         <callDepth>     0                  </callDepth>
         <callStack>     .List      => _    </callStack>
         <interimStates> .List              </interimStates>
         <callLog>       .Set               </callLog>

         <program>     %HKG_Program          </program>
         <id>          %ACCT_ID              </id>
         <caller>      %CALLER_ID            </caller>
         <callData>    #abiCallData("allowance", #address(%ORIGIN_ID), #address(%CALLER_ID))
         </callData>
         <callValue>   0                     </callValue>
         <wordStack>   .WordStack   => _     </wordStack>
         <localMem>    .Map  => ?B:Map        </localMem>
         <pc>          0     => _             </pc>
         <gas>         G     => G -Int 569    </gas>
         <previousGas> _     => _             </previousGas>

         <selfDestruct> .Set   </selfDestruct>
         <log>          .Set   </log>
         <refund>       0 => _ </refund>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <activeAccounts> SetItem ( %ACCT_ID ) </activeAccounts>
         <accounts>
           <account>
             <acctID>  %ACCT_ID      </acctID>
             <balance> BAL           </balance>
             <code>    %HKG_Program  </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> %ACCT_1_BALANCE |-> B1:Int
                       %ACCT_1_ALLOWED |-> A1:Int
                       %ACCT_2_BALANCE |-> B2:Int
                       %ACCT_2_ALLOWED |-> A2:Int
                       3 |-> %ORIGIN_ID
                       4 |-> %CALLER_ID
             </storage>
           </account>
         </accounts>
         requires G >Int 569

endmodule
```

Approve Function
----------------

Here we provide a specification file containing a reachability rule for the verifying the correctness of the HKG Token's APPROVE Function.

```{.k .approve}
module APPROVE-SPEC
    imports ETHEREUM-SIMULATION

    rule <k> #execute => (RETURN _ _  ~> _) </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack     </output>
         <memoryUsed>    0 => _         </memoryUsed>
         <callDepth>     0              </callDepth>
         <callStack>     .List  => _    </callStack>
         <interimStates> .List          </interimStates>
         <callLog>       .Set           </callLog>

         <program>   %HKG_Program </program>
         <id>        %ACCT_ID     </id>
         <caller>    %CALLER_ID   </caller>
         <callData>
                     #abiCallData("approve", #address(%ORIGIN_ID), #uint256(A2))
         </callData>
         <callValue> 0            </callValue>


         <wordStack>   .WordStack           => _            </wordStack>
         <localMem>    .Map                 => _            </localMem>
         <pc>          0                    => _            </pc>
         <gas>         G => G -Int 7278           </gas>
         <previousGas> _                    => _            </previousGas>

         <selfDestruct> .Set      </selfDestruct>
         <log>          .Set => _ </log>
         <refund>       0    => _ </refund>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <activeAccounts>   SetItem ( %ACCT_ID )   </activeAccounts>
         <accounts>
           <account>
           <acctID>   %ACCT_ID     </acctID>
           <balance>  BAL          </balance>
           <code>     %HKG_Program </code>
           <acctMap> "nonce" |-> 0 </acctMap>
           <storage> ...
                     3 |-> %ORIGIN_ID
                     4 |-> %CALLER_ID
                     %ACCT_1_BALANCE |-> B1:Int
                     %ACCT_1_ALLOWED |-> A1:Int
                     %ACCT_2_BALANCE |-> B2:Int
                     %ACCT_2_ALLOWED |-> (_ => A2)
                     ...
           </storage>
           </account>
         </accounts>
         requires (A2 <Int pow256) andBool (A2 >=Int 0)
                  andBool G >=Int 7278

endmodule
```

BalanceOf Function
------------------

Here we provide a specification file containing a reachability rule for the verifying the correctness of the HKG Token's BalanceOf Function.

```{.k .balanceOf}
module BALANCE-OF-SPEC
    imports ETHEREUM-SIMULATION
    rule <k> #execute => (RETURN _ _  ~> _) </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack     </output>
         <memoryUsed>    0    => 4      </memoryUsed>
         <callDepth>     0              </callDepth>
         <callStack>     .List => _     </callStack>
         <interimStates> .List          </interimStates>
         <callLog>       .Set           </callLog>

         <program>      %HKG_Program </program>
         <id>           %ACCT_ID     </id>
         <caller>       %CALLER_ID   </caller>
         <callData>     #abiCallData("balanceOf", #address(%CALLER_ID))
         </callData>

         <callValue>    0                     </callValue>
         <wordStack>    .WordStack    => _    </wordStack>
         <localMem>     .Map    => _            </localMem>
         <pc>           0       => _            </pc>
         <gas>          G       => G -Int 403   </gas>
         <previousGas>  _       => _            </previousGas>

         <selfDestruct> .Set </selfDestruct>
         <log>          .Set </log>
         <refund>       0    </refund>

         <gasPrice>     _               </gasPrice>
         <origin>       %ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <activeAccounts> SetItem ( %ACCT_ID ) </activeAccounts>
         <accounts>
           <account>
             <acctID>  %ACCT_ID      </acctID>
             <balance> BAL           </balance>
             <code>    %HKG_Program  </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage>
                       ...
                       %ACCT_2_BALANCE |-> B2:Int
                      ...
             </storage>
           </account>
         </accounts>

        requires G >Int 403

endmodule
```
