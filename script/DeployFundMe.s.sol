//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        //before startBroadcast -> Not a "real" tx
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed= helperConfig.activeNetworkConfig();
        //before startBroadcast -> Real tx
        vm.startBroadcast();
        //mock
        FundMe fundMe =new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
      
    } 
}
