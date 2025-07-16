# Foundry-Full-Testing
#hello 
iam learned foundry an Deploy & Test smart contract throuh many networks .
-  Learned By Bootcamps { Muhammed Essa , Bahaa Taha , PatrickAlphaC , blokkat(Kareem & Omar) , ChannelYoutube: Smart Contract Programmer  }  .

--------------------------------------

//Basic:
//Install..
-  curl -L https://foundry.paradigm.xyz | bash
-  foundryup

-------------------------------
 //Init
 - forge init

-------------------------------
 //Testing :  uint , integratation ,  mocks , staging
 
-  forge build
-  forge test
-  forge test --match-path test/HelloWorld -vvvv
-  forge test --match-test testFundUpdatesFundedDataStructure
-  forge test --fork-url $MAINNET_RPC_URL
--------------------------
//Deploy

-  forge script  script/Counter.s.sol
-  forge script  script/Counter.s.sol --rpc-url $SEPOLIA_RPC_URL   --private-key  $PRIVATE_KEY
-  forge test -vvvv
---------------

-  forge coverage
-  forge coverage --fork-url $SEPOLIA_RPC_URL
-  foge snapshot


------------

anvil 
chisel
cast


