// Viper ERC20 Token Smart Contract
// ================================

// The source code can be found:
// https://github.com/ethereum/viper/blob/master/examples/tokens/ERC20\_solidity\_compatible/ERC20.v.py

// Transfer Function
// -----------------

// These parts of the state are constant throughout the proof.


module TRANSFER-SPEC
    imports ETHEREUM-SIMULATION

    rule
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


// These parts of the proof change, but we would like to avoid specifying exactly how (abstract over their state change).


         <localMem>    .Map => _ </localMem>
         <previousGas> _    => _ </previousGas>
         <refund>      0    => _ </refund>


// ### Then Branch

// ### Else Branch


         <k> #execute => (#exception ~> _) </k>

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
       andBool B1 <Int TRANSFER


// Lemmas
// ------



    rule <k> MLOAD INDEX => X ~> #push ... </k>
         <localMem> INDEX |-> #argdata(X:Int, 32) LM:Map </localMem>
    [trusted]
endmodule

