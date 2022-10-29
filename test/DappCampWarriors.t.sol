// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/DappCampWarriors.sol";

contract DappCampWarriorsTest is Test {
    DappCampWarriors public dappcampWarriors;
    address owner = address(this);
    address user = address(0xDEAD);

    function setUp() public {
        dappcampWarriors = new DappCampWarriors();
    }

    function testOwnerBalanceOnDeploy() public {
        assertEq(dappcampWarriors.balanceOf(owner), 10);
    }

    function testCannotSetBaseURIIfNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(user);
        dappcampWarriors.setBaseURI("test");
    }

    function testSetBaseURIIfOwner() public {
        dappcampWarriors.setBaseURI("test");
        assertEq(dappcampWarriors.baseURI(), "test");
    }

    function testCannotMintIfNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(user);
        dappcampWarriors.mint(address(user));
    }

    function testMintIfOwner() public {
        dappcampWarriors.mint(owner);
        assertEq(dappcampWarriors.balanceOf(owner), 11);
    }
}