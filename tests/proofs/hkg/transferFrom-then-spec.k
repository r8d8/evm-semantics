// The Hacker Gold (HKG) Token Smart Contract
// ==========================================

// TransferFrom Function
// ---------------------

// These parts of the state are constant throughout the proof.


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


// These parts of the proof change, but we would like to avoid specifying exactly
// how (abstract over their state change).


         <localMem>    .Map => _ </localMem>
         <previousGas> _    => _ </previousGas>
         <refund>      0    => _ </refund>


// ### Then Branch {#then-branch-1}


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


// ### Else Branch {#else-branch-1}
