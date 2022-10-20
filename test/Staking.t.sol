// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Camp.sol";
import "../src/Staking.sol";
import "../src/DappCampWarriors.sol";


contract StakingTest is Test {
    Staking public staking;
    Camp camp;
    DappCampWarriors dappCampWarriors;

    address owner = address(this);
    address user = address(0xBEEF);

    function createStake(address staker) public returns (uint256) {
        uint256 newTokenId = dappCampWarriors.mint(staker);

        vm.prank(staker);
        dappCampWarriors.approve(address(staking), newTokenId);
        
        vm.prank(staker);
        staking.stake(newTokenId);
        
        return newTokenId;
    }

    function setUp() public {
        camp = new Camp();
        dappCampWarriors = new DappCampWarriors();

        staking = new Staking(address(camp), address(dappCampWarriors));

        camp.transferOwnership(address(staking));
    }

    function testNonExistentNFTStake() public {
        vm.expectRevert("ERC721: invalid token ID");
        staking.stake(536);
    }


    function testCannotStakeIfNotOwner() public {
        vm.expectRevert("Staking: only the owner can stake an NFT");
        
        vm.prank(user);
        staking.stake(1);
    }

    function testCannotStakeIfNotApproved() public {
        vm.expectRevert("ERC721: caller is not token owner or approved");
        staking.stake(1);
    }

    function testCannotStakeStakedNFT() public {
        uint256 tokenId = createStake(user);
        vm.expectRevert("Staking: only the owner can stake an NFT");

        vm.prank(user);
        staking.stake(tokenId);
    }

    function testOwnerOfStakedNFT() public {
        uint stakedTokenId = createStake(owner);
        assertEq(dappCampWarriors.ownerOf(stakedTokenId), address(staking));
    }
    
    function testStakedEntryAddition() public {
        uint stakedTokenId = createStake(user);
        (, uint256 _tokenId, ) = staking.staked(stakedTokenId);

        assertEq(_tokenId, stakedTokenId);
    }

    function testEmptyMetadataForNonStakedNFT() public {
        (, uint256 _tokenId, ) = staking.staked(1);

        assertEq(_tokenId, 0);
    }

    function testFilledMetadataForStakedNFT() public {
        uint256 stakingTokenId = createStake(user);
        (, uint256 _tokenId, ) = staking.staked(stakingTokenId);

        assertEq(_tokenId, stakingTokenId);
    }

    function testCannotUnstakeIfNotStaked() public {
        vm.expectRevert("Staking: only the owner can unstake an NFT");
        
        vm.prank(user);
        staking.unstake(1);
    }

    function testCannotUnstakeIfNotOwner() public {
        createStake(user);

        vm.prank(user);
        vm.expectRevert("Staking: only the owner can unstake an NFT");
        staking.unstake(1);
    }
    
    function testTokenSentBackOnUnstake() public {
        uint256 tokenId = createStake(user);
        assertEq(dappCampWarriors.ownerOf(tokenId), address(staking));
        
        vm.prank(user);
        vm.warp(block.timestamp + 10);
        
        staking.unstake(tokenId);

        assertEq(dappCampWarriors.ownerOf(tokenId), user);
    }

    function testCampTokenGivenToStaker() public {
        uint256 tokenId = createStake(user);
        uint initialBalance = camp.balanceOf(user);

        vm.prank(user);
        vm.warp(block.timestamp + 10);

        staking.unstake(tokenId);
        assert(camp.balanceOf(address(user)) > initialBalance);
    }

}