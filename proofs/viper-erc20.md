Viper ERC20 Token Smart Contract
================================

The source code can be found:
https://github.com/ethereum/viper/blob/master/examples/tokens/ERC20_solidity_compatible/ERC20.v.py

BalanceOf Function
------------------

```{.k .balanceOf}
module BALANCE-OF-SPEC
    imports ETHEREUM-SIMULATION

    rule <k> #execute => (RETURN _ _  ~> _) </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack     </output>
         <memoryUsed>    0    => _      </memoryUsed>
         <callDepth>     0              </callDepth>
         <callStack>     .List => _     </callStack>
         <interimStates> .List          </interimStates>
         <callLog>       .Set           </callLog>

         <program>      %ERC20_Program </program>
         <id>           %%ACCT_ID     </id>
         <caller>       %%CALLER_ID   </caller>
         <callData>     #abiCallData("balanceOf", #address(%%CALLER_ID))
         </callData>

         <callValue>    0                     </callValue>
         <wordStack>    .WordStack    => _    </wordStack>
         <localMem>     .Map    => _            </localMem>
         <pc>           0       => _            </pc>
         <gas>          1000    => _            </gas>
         <previousGas>  _       => _            </previousGas>

         <selfDestruct> .Set </selfDestruct>
         <log>          .Set </log>
         <refund>       0    </refund>

         <gasPrice>     _               </gasPrice>
         <origin>       %%ORIGIN_ID      </origin>
         <gasLimit>     _               </gasLimit>
         <coinbase>     %%COINBASE_VALUE </coinbase>
         <timestamp>    1               </timestamp>
         <number>       0               </number>
         <previousHash> 0               </previousHash>
         <difficulty>   256             </difficulty>

         <activeAccounts> SetItem ( %%ACCT_ID ) </activeAccounts>
         <accounts>
           <account>
             <acctID>  %%ACCT_ID      </acctID>
             <balance> BAL           </balance>
             <code>    %ERC20_Program  </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage>
                       ...
                       %%ACCT_2_BALANCE |-> B2:Int
                      ...
             </storage>
           </account>
         </accounts>
```

Allowance Function
------------------

```{.k .allowance}
module TOKEN-SPEC
imports ETHEREUM-SIMULATION

    rule <k> #execute => (RETURN _ _ ~> _) ... </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    0 => 3     </memoryUsed>
         <callDepth>     _          </callDepth>
         <callStack>     .List      </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>

         <program>     %ERC20_Program        </program>
         <id>          %%ACCT_ID             </id>
         <caller>      %%CALLER_ID           </caller>
         <callData>    .WordStack            </callData>
         <callValue>   0                     </callValue>
         <wordStack>   .WordStack => _ </wordStack>
         <localMem>    .Map => _        </localMem>
         <pc>          0  => _           </pc>
         <gas>         100000 => _    </gas>
         <previousGas> _    => _             </previousGas>

         <selfDestruct> .Set   </selfDestruct>
         <log>          .Set   </log>
         <refund>       0 => _ </refund>

         <gasPrice>     _                </gasPrice>
         <origin>       %%ORIGIN_ID      </origin>
         <gasLimit>     _                </gasLimit>
         <coinbase>     %%COINBASE_VALUE </coinbase>
         <timestamp>    1                </timestamp>
         <number>       0                </number>
         <previousHash> 0                </previousHash>
         <difficulty>   256              </difficulty>

         <activeAccounts> SetItem ( %ACCT_ID ) </activeAccounts>
         <accounts>
           <account>
             <acctID>  %%ACCT_ID       </acctID>
             <balance> BAL             </balance>
             <code>    %ERC20_Program  </code>
             <acctMap> "nonce" |-> 0   </acctMap>
             <storage> %%ACCT_1_BALANCE |-> B1:Int
                       %%ACCT_1_ALLOWED |-> A1:Int
                       %%ACCT_2_BALANCE |-> B2:Int
                       %%ACCT_2_ALLOWED |-> A2:Int
             </storage>
           </account>
         </accounts>
```

Approve Function
----------------

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

         <program>   %ERC20_Program </program>
         <id>        %%ACCT_ID      </id>
         <caller>    %%CALLER_ID    </caller>
         <callData>
                     #abiCallData("approve", #address(%ORIGIN_ID), #uint256(A2))
         </callData>
         <callValue> 0            </callValue>


         <wordStack>   .WordStack           => _            </wordStack>
         <localMem>    .Map                 => _            </localMem>
         <pc>          0                    => _            </pc>
         <gas>         100000               => _            </gas>
         <previousGas> _                    => _            </previousGas>

         <selfDestruct> .Set      </selfDestruct>
         <log>          .Set => _ </log>
         <refund>       0    => _ </refund>

         <gasPrice>     _                </gasPrice>
         <origin>       %%ORIGIN_ID      </origin>
         <gasLimit>     _                </gasLimit>
         <coinbase>     %%COINBASE_VALUE </coinbase>
         <timestamp>    1                </timestamp>
         <number>       0                </number>
         <previousHash> 0                </previousHash>
         <difficulty>   256              </difficulty>

         <activeAccounts>   SetItem ( %%ACCT_ID )   </activeAccounts>
         <accounts>
           <account>
           <acctID>   %%ACCT_ID       </acctID>
           <balance>  BAL             </balance>
           <code>     %ERC20_Program  </code>
           <acctMap> "nonce" |-> 0    </acctMap>
           <storage> ...
                     %%ACCT_1_BALANCE |-> B1:Int
                     %%ACCT_1_ALLOWED |-> A1:Int
                     %%ACCT_2_BALANCE |-> B2:Int
                     %%ACCT_2_ALLOWED |-> (_ => A2)
                     ...
           </storage>
           </account>
         </accounts>
         requires (A2 <Int pow256) andBool (A2 >=Int 0)
```

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

         <output>        .WordStack  </output>
         <memoryUsed>    0 => _      </memoryUsed>
         <callDepth>     0           </callDepth>
         <callStack>     .List => _  </callStack>
         <interimStates> .List       </interimStates>
         <callLog>       .Set        </callLog>
         <wordStack> .WordStack => _ </wordStack>

         <program>   %ERC20_Program </program>
         <id>        %%ACCT_ID      </id>
         <caller>    %%ORIGIN_ID    </caller>
         <callData>  #abiCallData("transfer",#address(%%CALLER_ID),#uint256(TRANSFER)) </callData>
         <callValue> 0              </callValue>

         <gasPrice>     _                </gasPrice>
         <origin>       %%ORIGIN_ID      </origin>
         <gasLimit>     _                </gasLimit>
         <coinbase>     %%COINBASE_VALUE </coinbase>
         <timestamp>    1                </timestamp>
         <number>       0                </number>
         <previousHash> 0                </previousHash>
         <difficulty>   256              </difficulty>

         <selfDestruct>   .Set                  </selfDestruct>
         <log>            .Set => _             </log>
         <activeAccounts> SetItem ( %%ACCT_ID ) </activeAccounts>
         <messages>       .Bag                  </messages>
```

These parts of the proof change, but we would like to avoid specifying exactly how (abstract over their state change).

```{.k .transfer-then .transfer-else}
         <localMem>    .Map => _ </localMem>
         <previousGas> _    => _ </previousGas>
         <refund>      0    => _ </refund>
```

### Then Branch

```{.k .transfer-then}
         <gas>  100000 => _ </gas>

         <accounts>
           <account>
             <acctID>   %%ACCT_ID      </acctID>
             <balance>  BAL            </balance>
             <code>     %ERC20_Program </code>
             <acctMap> "nonce" |-> 0   </acctMap>
             <storage> ...
                       (%%ACCT_1_BALANCE |-> (B1 => B1 -Int TRANSFER))
                       (%%ACCT_1_ALLOWED |-> A1)
                       (%%ACCT_2_BALANCE |-> (B2 => B2 +Int TRANSFER))
                       (%%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool B2 +Int TRANSFER <Int pow256
       andBool B1 -Int TRANSFER >=Int 0
```

### Else Branch

```{.k .transfer-else}
         <gas> 100000   => _   </gas>

         <accounts>
           <account>
             <acctID>   %%ACCT_ID      </acctID>
             <balance>  BAL            </balance>
             <code>     %ERC20_Program </code>
             <acctMap> "nonce" |-> 0   </acctMap>
             <storage> ...
                       (%%ACCT_1_BALANCE |-> B1:Int)
                       (%%ACCT_1_ALLOWED |-> A1:Int)
                       (%%ACCT_2_BALANCE |-> B2:Int)
                       (%%ACCT_2_ALLOWED |-> _)
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >=Int 0 andBool TRANSFER <Int pow256
       andBool B1 >=Int 0      andBool B1 <Int pow256
       andBool B2 >=Int 0      andBool B2 <Int pow256
       andBool (B1 <Int TRANSFER orBool TRANSFER ==Int 0)
```

TransferFrom Function
---------------------

These parts of the state are constant throughout the proof.

```{.k .transferFrom-then .transferFrom-else}
module TRANSFER-FROM-SPEC
    imports ETHEREUM-SIMULATION

    rule <k> #execute ... </k>
         <exit-code> 1 </exit-code>
         <mode>     NORMAL  </mode>
         <schedule> DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    3          </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List      </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>

         <program>   %HKG_Program </program>
         <id>        %ACCT_ID     </id>
         <caller>    %CALLER_ID   </caller>
         <callData>  .WordStack   </callData>
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
         <log>            .Set                 </log>
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
         <pc>  818 => 1331         </pc>
         <gas> G   => G -Int 16071 </gas>

         <wordStack>                        TRANSFER : %CALLER_ID : %ORIGIN_ID : WS
                  => A1 -Int TRANSFER : 0 : TRANSFER : %CALLER_ID : %ORIGIN_ID : WS
         </wordStack>
         <accounts>
           <account>
             <acctID>   %ACCT_ID     </acctID>
             <balance>  BAL          </balance>
             <code>     %HKG_Program </code>
             <acctMap> "nonce" |-> 0 </acctMap>
             <storage> ...
                       %ACCT_1_BALANCE |-> (B1 => B1 -Int TRANSFER)
                       %ACCT_1_ALLOWED |-> (A1 => A1 -Int TRANSFER)
                       %ACCT_2_BALANCE |-> (B2 => B2 +Int TRANSFER)
                       %ACCT_2_ALLOWED |-> _
                       ...
             </storage>
           </account>
         </accounts>

      requires TRANSFER >Int 0
       andBool B1 >=Int TRANSFER andBool B1 <Int pow256
       andBool A1 >=Int TRANSFER andBool A1 <Int pow256
       andBool B2 >=Int 0        andBool B2 +Int TRANSFER <Int pow256
       andBool #sizeWordStack(WS) <Int 1016
       andBool G >=Int 16071
```

### Else Branch

```{.k .transferFrom-else}
         <pc>  818 => 1451 </pc>
         <gas> G   => G1   </gas>

         <wordStack>     TRANSFER : %CALLER_ID : %ORIGIN_ID : WS
                  => 0 : TRANSFER : %CALLER_ID : %ORIGIN_ID : WS
         </wordStack>
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

      requires (TRANSFER <=Int 0 orBool B1 <Int TRANSFER orBool A1 <Int TRANSFER)
       andBool #sizeWordStack(WS) <Int 1016
       andBool G >=Int 485
       ensures G -Int G1 <=Int 485
```

Lemmas
------

```{.k .balanceOf .allowance .approve .transfer-then .transfer-else .transferFrom-then .transferFrom-else}

    rule <k> MLOAD INDEX => X ~> #push ... </k>
         <localMem> INDEX |-> #argdata(X:Int, 32) LM:Map </localMem>
    [trusted]
endmodule
```
