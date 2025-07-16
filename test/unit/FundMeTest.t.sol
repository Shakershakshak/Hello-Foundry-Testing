//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;    

import {Test,console} from "lib/forge-std/src/Test.sol" ;
import {FundMe} from "src/FundMe.sol";
import {DeployFundMe} from "script/DeployFundMe.s.sol"; 

contract FundMeTest is Test {
     FundMe fundMe;
     address USER = makeAddr("user");
     uint256 constant SEND_VALUE = 0.1 ether; //1000000000000000000
     uint256 constant STARTING_BALANCE = 10 ether;
     uint256 constant GAS_PRICE = 1;
    function setUp() external {
       // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
     DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
     }

  function testMinimumDollarIsFive() public view {
       assertEq(fundMe.MINIMUM_USD( ) , 5e18);
   }
   

   function testOnwerIsMsgSender() public view{
       assertEq(fundMe.i_owner(), msg.sender);
   }


      function testPriceFeedVersion() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert() ; 
        fundMe.fund();
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // The Next TX will be sent by USER
        fundMe.fund{value:SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
 
    }
       function testAddsFunderToArrayOfFunder() public {
        vm.prank(USER); // The Next TX will be sent by USER
        fundMe.fund{value:SEND_VALUE}();
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER);
    }

       modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

      function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER); // The Next TX will be sent by USER
        vm.expectRevert() ; 
        fundMe.withdraw();
    }

        function testWithdrawWithasSingleFunder() public funded {
            // Arrange   // Act   //Assert
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // address:TesterOnwer , balance :0
        uint256 startingFundMeBalance = address(fundMe).balance; //address: contractFundMe, balance:0
        
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());  //address: TesterOnwer = 0
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsd = (gasStart) - (gasEnd) * tx.gasprice ; 
        console.log(gasUsd);

        uint256 endingOwnerBalance = fundMe.getOwner().balance; // address: Tester , balance :0
        uint256 endingFundMeBalance = address(fundMe).balance;  //address: contractFundMe, balance:0

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

        function testWithdrawForMultipleFunders() public {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance; // 0
        uint256 startingFundMeBalance = address(fundMe).balance; // 10

        vm.startPrank(fundMe.getOwner()); //testContract
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;//10
        uint256 endingFundMeBalance = address(fundMe).balance;//0

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance /*10*/ + startingOwnerBalance /*0*/, endingOwnerBalance);
    }
    
    function testCheaperWithdrawForMultipleFunders() public {
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

        
} 