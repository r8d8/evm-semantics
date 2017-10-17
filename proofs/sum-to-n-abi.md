``` {.k .uiuck}
module SUM-TO-N-ABI
    imports ETHEREUM-SIMULATION
    imports VERIFICATION
    rule <k> start </k>
         <exit-code> 1       </exit-code>
         <mode>      NORMAL  </mode>
         <schedule>  DEFAULT </schedule>

         <output>        .WordStack </output>
         <memoryUsed>    3          </memoryUsed>
         <callDepth>     0          </callDepth>
         <callStack>     .List      </callStack>
         <interimStates> .List      </interimStates>
         <callLog>       .Set       </callLog>

         <program>   %SumToNABI         </program>
         <id>        %ACCT_ID           </id>
         <caller>    %CALLER_ID         </caller>
         <callData>  %CallData          </callData>
         <callValue> 0                  </callValue>

         <wordStack>.WordStack          </wordStack>
         <localMem>     .Map           </localMem>
         <pc>           0 => 1         </pc>
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
         
    syntax Map ::= "%SumToNABI"
    rule %SumToNABI => #asMapOpCodes(#dasmOpCodes(#parseByteStack(
       "60606040526000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806327cd9d9e14603c57600080fd5b3415604657600080fd5b605a60048080359060200190919050506070565b6040518082815260200191505060405180910390f35b60006002600183018302811515608257fe5b0490509190505600a165627a7a72305820f557ffa9526076033da17171cc3bc8ce8e3641f23ee55c35d98756e0da6099ad0029"
       ))) [macro]
    syntax WordStack ::= "%CallData"
    rule %CallData => #parseByteStack("27cd9d9e0000000000000000000000000000000000000000000000000000000000000064")
           [macro]
endmodule
```
