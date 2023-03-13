# G-Naira
G-Naira currency

 *  How to use the multi-signature feature
------------------------------------------------------------------------------------------------
 *  First deploy contract with your address, this address is now the owner and the GOVERNOR
 *  Now GOVERNOR can add DELEGATES addresses using the "setDelegates" function 
-------------------------------------------------------------------------------------------
 *  (Hardcoded at line 33: only 2 approvals are needed before GOVERNOR can mint/ burn, 
 *   you can change the number of DELEGATES needed using "setRequiredApproval") 
-----------------------------------------------------------------------------------------
 *  Connect wallet as DELEGATE addresses to interact with the contract,
 *  one by one your DELEGATES should click on "incrementApproval" function,
 *  when a DELEGATE does this, 1 approval will be added, other DELEGATES need to do this to increase approval for GOVERNOR
 *  Only when atleast 2 delegates approve, can the governor burn or mint
 
 
