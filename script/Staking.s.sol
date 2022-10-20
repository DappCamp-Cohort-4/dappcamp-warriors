// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Camp.sol";
import "../src/DappCampWarriors.sol";
import "../src/Staking.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        Camp camp = new Camp();
        DappCampWarriors dappCampWarriors = new DappCampWarriors();
        Staking staking = new Staking(address(camp), address(dappCampWarriors));

        camp.transferOwnership(address(staking));

        vm.stopBroadcast();
    }
}