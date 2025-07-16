//SPDX-License-Identifier: MIT

//1.Deply mocks of contract when are in a local anvil chain 
//2. Kepp track of contract across different chains
// Sepolia Eth/USD
// Mainnet Eth/USD

pragma solidity ^0.8.19;
import {Script} from "../lib/forge-std/src/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
//////////////////**/Contract/**///////////////////////////
contract HelperConfig is Script {
 // If we are on a local anvil chain, we will deploy mocks
 // Otherwise ,grab the address from the live chain
 // @title A title that should describe the contract/interface
 // @author The name of the author
 // @notice Explain to an end user what this does
 // @dev Explain to a developer any extra details

/////////////////**/Varibles/**//////////////////////
uint8 public constant DECIMAL = 8;
int256 public constant INITIAL_PRICE = 2000e8;
//---------------------------------------------
 NetworkConfig public activeNetworkConfig;
struct NetworkConfig {
 address priceFeed; // ETH/USD price feed address  
}
////////////////**/constructor/**////////////////////
constructor() {
    if (block.chainid == 11155111) { // Sepolia chain id
        activeNetworkConfig = getSepoliaEthConfig();
    } else if (block.chainid == 1) { // Anvil chain id
      activeNetworkConfig = getMainnetEthConfig();
    } else if (block.chainid == 31337 ) { // Mainnet chain id
     activeNetworkConfig = getOrCrearAnvilEthConfig();

    } else {
        revert("No active network config found");
    }
}
////////////////////**/functions/**/////////////////////

//---------------GetSepoliaEthConfig---------------------------------
function getSepoliaEthConfig() public pure returns(NetworkConfig memory) {
    // price feed address 
    NetworkConfig memory sepoliaConfig = NetworkConfig({
        priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306} );
        return sepoliaConfig;
}
//---------------GetMainnetEthConfig----------------------------------
function getMainnetEthConfig() public pure returns(NetworkConfig memory) {
    // price feed address 
    NetworkConfig memory ethConfig = NetworkConfig({
        priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419} );
        return ethConfig;
}
//----------------GetAnvilEthConfig------------------------------------
function getOrCrearAnvilEthConfig() public returns(NetworkConfig memory) {
    if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
    // price feed address 
    // 1. Deploy mocks
    // 2. Return the mock address
    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAL, INITIAL_PRICE); // 2000 USD with 8 decimals
    vm.stopBroadcast(); 
    NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed) } );
        return anvilConfig ;
}

}