# Foundry-Full-Testing
#hello 
iam learned foundry an deploy smart contract throuh many networks 

//Basic::

 //Install
curl -L https://foundry.paradigm.xyz | bash
foundryup

-------------------------------
 //Init :
forge init

-------------------------------
 //Basic commands : uint , integratation ,  mocks
forge build
forge test
forge test --match-path test/HelloWorld -vvvv
forge test --match-test testFundUpdatesFundedDataStructure
forge test --fork-url $MAINNET_RPC_URL
forge script  script/Counter.s.sol
forge script  script/Counter.s.sol --rpc-url $SEPOLIA_RPC_URL   --private-key  $PRIVATE_KEY
forge test -vvvv

---------------

forge coverage
forge coverage --fork-url $SEPOLIA_RPC_URL


------------

anvil 
chisel
cast


