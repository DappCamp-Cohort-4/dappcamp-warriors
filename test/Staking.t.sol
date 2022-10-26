// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Camp.sol";
import "../src/Staking.sol";
import "../src/DappCampWarriors.sol";

import "openzeppelin-contracts/token/ERC721/utils/ERC721Holder.sol";


contract StakingTest is Test, ERC721Holder {
    Staking public staking;
    Camp camp;
    DappCampWarriors dappCampWarriors;

    address public owner = address(this);
    address public nftOwner = address(new ERC721Holder());
    address public randomUser = address(0xBEEF);

    function createStake(address staker) private returns (uint256) {
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
        vm.prank(randomUser);
        staking.stake(1);
    }

    function testCannotStakeIfNotApproved() public {
        vm.expectRevert("ERC721: caller is not token owner or approved");
        uint256 newTokenId = dappCampWarriors.mint(randomUser);

        vm.prank(randomUser);
        staking.stake(1);
    }

    function testCannotStakeStakedNFT() public {
        uint256 tokenId = createStake(nftOwner);
        vm.expectRevert("Staking: only the owner can stake an NFT");

        vm.prank(nftOwner);
        staking.stake(tokenId);
    }

    function testOwnerOfStakedNFT() public {
        uint stakedTokenId = createStake(owner);
        assertEq(dappCampWarriors.ownerOf(stakedTokenId), address(staking));
    }
    
    function testStakedEntryAddition() public {
        uint stakedTokenId = createStake(nftOwner);
        (, uint256 _tokenId, ) = staking.staked(stakedTokenId);

        assertEq(_tokenId, stakedTokenId);
    }

    function testEmptyMetadataForNonStakedNFT() public {
        (, uint256 _tokenId, ) = staking.staked(1);

        assertEq(_tokenId, 0);
    }

    function testFilledMetadataForStakedNFT() public {
        uint256 stakingTokenId = createStake(nftOwner);
        (, uint256 _tokenId, ) = staking.staked(stakingTokenId);

        assertEq(_tokenId, stakingTokenId);
    }

    function testCannotUnstakeIfNotStaked() public {
        vm.expectRevert("Staking: only the owner can unstake an NFT");
        
        vm.prank(nftOwner);
        staking.unstake(1);
    }

    function testCannotUnstakeIfNotOwner() public {
        createStake(nftOwner);

        vm.prank(nftOwner);
        vm.expectRevert("Staking: only the owner can unstake an NFT");
        staking.unstake(1);
    }
    
    function testTokenSentBackOnUnstake() public {
        uint256 tokenId = createStake(nftOwner);
        assertEq(dappCampWarriors.ownerOf(tokenId), address(staking));
        
        vm.prank(nftOwner);
        vm.warp(block.timestamp + 10);
        
        staking.unstake(tokenId);

        assertEq(dappCampWarriors.ownerOf(tokenId), nftOwner);
    }

    function testCampTokenGivenToStaker() public {
        uint256 tokenId = createStake(nftOwner);
        uint initialBalance = camp.balanceOf(nftOwner);

        vm.prank(nftOwner);
        vm.warp(block.timestamp + 10);

        staking.unstake(tokenId);
        assert(camp.balanceOf(address(nftOwner)) > initialBalance);
    }

}