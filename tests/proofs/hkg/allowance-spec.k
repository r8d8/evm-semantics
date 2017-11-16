// The Hacker Gold (HKG) Token Smart Contract
// ==========================================

// Allowance Function
// ------------------

// Here we provide a specification file containing a reachability rule for the
// verifying the correctness of the HKG Token's Allowance Function.


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

