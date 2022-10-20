// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Camp.sol";

contract CampTest is Test {
    Camp public camp;
    address owner = address(this);
    address user = address(0xBEEF);

    function setUp() public {
        camp = new Camp();
    }

    function testCannotMintIfNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(user);
        camp.mint(user, 1 ether);
    }

    function testMintIfOwner() public {
        camp.mint(user, 1 ether);
        assertEq(camp.balanceOf(user), 1 ether);
    }

    function testCannotBurnIfNotOwner() public {
        vm.expectRevert("Ownable: caller is not the owner");

        vm.prank(user);
        camp.burn(user, 1 ether);
    }

    function testBurnIfOwner() public {
        camp.mint(user, 1 ether);

        camp.burn(user, 1 ether);
        assertEq(camp.balanceOf(user), 0);
    }

}
