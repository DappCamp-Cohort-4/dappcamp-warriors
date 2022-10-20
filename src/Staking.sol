// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/interfaces/IERC721.sol";
import "./interfaces/ICamp.sol";


contract Staking {
    address public campAddress;
    address public dappCampWarriorsAddress;

    struct Stake {
        address owner;
        uint256 tokenId;
        uint256 initTimestamp;
    }

    /**
     * @dev uint256 is tokenId
     */
    mapping(uint256 => Stake) public staked;

    /**
     * @dev 1 $CAMP per second
     */
    uint256 public rewardPerSecondInWei = 1000000000000000000;

    constructor(address _camp, address _dappCampWarriors) {
        campAddress = _camp;
        dappCampWarriorsAddress = _dappCampWarriors;
    }

    function stake(uint256 tokenId) public {
        /**
         * @dev This prevents 3 things:
         *   - Staking non-existing NFTs (ERC721 ownerOf validates existence)
         *   - Staking if msg.sender is not the owner
         *   - Staking NFTs that are already staked (since the owner is this contract)
         */
        require(
            IERC721(dappCampWarriorsAddress).ownerOf(tokenId) == msg.sender,
            "Staking: only the owner can stake an NFT"
        );

        IERC721(dappCampWarriorsAddress).transferFrom(msg.sender, address(this), tokenId);

        staked[tokenId] = Stake(msg.sender, tokenId, block.timestamp);
    }

    function unstake(uint256 tokenId) public {
        /**
         * @dev This prevents 3 things:
         *   - Unstaking non-existing NFTs (ERC721 ownerOf validates existence)
         *   - Unstaking if msg.sender is not the owner
         *   - Unstaking NFTs that are not staked (since staking.owner will be the zero address)
         */
        Stake memory staking = staked[tokenId];

        require(
            staking.owner == msg.sender,
            "Staking: only the owner can unstake an NFT"
        );
        require(
            staking.initTimestamp != block.timestamp,
            "Staking: cannot unstake an NFT in the same block it was staked"
        );

        uint256 stakedSeconds = block.timestamp - staking.initTimestamp;

        delete staking;

        IERC721(dappCampWarriorsAddress).transferFrom(address(this), msg.sender, tokenId);
        ICamp(campAddress).mint(msg.sender, stakedSeconds * rewardPerSecondInWei);
    }
}

