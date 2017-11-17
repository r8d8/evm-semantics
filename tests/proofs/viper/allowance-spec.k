// Viper ERC20 Token Smart Contract
// ================================

// The source code can be found:
// https://github.com/ethereum/viper/blob/master/examples/tokens/ERC20\_solidity\_compatible/ERC20.v.py

// Allowance Function
// ------------------


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


// Lemmas
// ------



    rule <k> MLOAD INDEX => X ~> #push ... </k>
         <localMem> INDEX |-> #argdata(X:Int, 32) LM:Map </localMem>
    [trusted]
endmodule

