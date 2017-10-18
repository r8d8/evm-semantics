``` {.k .uiuck}
module SUM-TO-N-ABI
```

Verify that `#abiCall` correctly desugars:

```{.k .uiuck}
    imports ETHEREUM-SIMULATION
    imports VERIFICATION
    rule <k> #execute     ...</k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    0          </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List      </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>

         <program>   %SumToNABI         </program>
         <id>        %ACCT_ID           </id>
         <caller>    %CALLER_ID         </caller>
         <callData>  %SumToNABICallData </callData>
         <callValue> 0                  </callValue>

         <wordStack>.WordStack          </wordStack>
         <localMem>     .Map           </localMem>
         <pc>           0 => 0         </pc>
         <gas>          100000         </gas>
         <previousGas>  _              </previousGas>

         <selfDestruct> .Set    </selfDestruct>
         <log>          .Set    </log>
         <refund>       0       </refund>

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
             <acctID>   %ACCT_ID           </acctID>
             <balance>  9999999            </balance>
             <code>     %SumToNABI         </code>
             <storage>  .Map
             </storage>
             <acctMap> "nonce" |-> 0 </acctMap>
           </account>
         </accounts>
```

```{.k .uiuck}
    rule <k> #execute     ...</k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack     </output>
         <memoryUsed>    0      => _    </memoryUsed>
         <callDepth>     0              </callDepth>
         <callStack>     .List          </callStack>
         <interimStates> .List          </interimStates>
         <callLog>       .Set           </callLog>

         <program>   %SumToNABI         </program>
         <id>        %ACCT_ID           </id>
         <caller>    %CALLER_ID         </caller>
         <callData>  %SumToNABICallData </callData>
         <callValue> 0                  </callValue>

         <wordStack>.WordStack  => _    </wordStack>
         <localMem>     .Map    => _    </localMem>
         <pc>           0       => 111  </pc>
         <gas>          100000  => _    </gas>
         <previousGas>  _       => _    </previousGas>
         <selfDestruct> .Set            </selfDestruct>
         <log>          .Set            </log>
         <refund>       0               </refund>

         <gasPrice>     0               </gasPrice>
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
             <acctID>   %ACCT_ID           </acctID>
             <balance>  9999999            </balance>
             <code>     %SumToNABI         </code>
             <storage>  .Map
             </storage>
             <acctMap> "nonce" |-> 0 </acctMap>
           </account>
         </accounts>
```

```{.k .uiuck}
endmodule
```
