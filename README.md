# DappCamp Warriors

## Create ERC20

We already scaffolded the project, created the contracts of our NFT collection, and imported third-party contracts.

Now, it's time to create our fungible token: **$CAMP**.

We will use an OpenZeppelin contract that implements the [ERC20](https://ethereum.org/es/developers/docs/standards/tokens/erc-20/) standard, which makes things pretty easy.

First, we need to install [OpenZeppelin's contracts](https://www.npmjs.com/package/@openzeppelin/contracts) using forge:

```bash
forge install openzeppelin/openzeppelin-contracts
```

The contract could be as simple as this:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "openzeppelin-contracts/token/ERC20/ERC20.sol";

contract Camp is ERC20 {
    constructor() ERC20("Camp", "CAMP") {}
}
```

But we will add some extra magic to have more control over the supply, determining who can mint it and who can burn it.

Go to [Camp.sol](src/Camp.sol) to see the explained implementation.

## Test

### Overview

Forge comes with an in-built testing framework and allows us to write tests in Solidity itself.

We added tests for ERC20 contract: [test/Camp.t.sol](test/Camp.t.sol).

To run all the tests you can run:
`forge test`

### TDD

I recommend you trying TDD (in a nutshell, writing the tests before the code). It will help you think about potential security issues and edge cases.

## Deploy

With Foundry we can write deployment scripts in solidity. These scripts are present in `script` directory. The entrypoint for these scripts is the `run` function.

You will observe that cheatcode `vm.startBroadcast()` is being used. This cheatcode helps in recording the transactions before `vm.stopBroadcast()` is called. You can view the recorded transactions in `broadcast` directory.

### Deploying locally to anvil

* Start the anvil local node

```bash
anvil
```

* Set environment variables

```bash
source .env 
```

* Run foundry script

```
forge script script/Camp.s.sol:DeployScript --fork-url http://localhost:8545 --broadcast --private-key $PRIVATE_KEY
```

On successful completion you must have contract addresses printed on the console. Also check the `run-latest.json` file in `broadcast` directory for details on transactions made during the running of script.

### Deploying to testnet/mainnet

Follow these steps to deploy to your desired testnet:

* Rename `.env.example` to `.env` file.

* Add values for `PRIVATE_KEY` and `ETHERSCAN_KEY` variables in `.env` file.

* Get an rpc url of your desired testnet, this can be obtained by creating an account on [Alchemy](https://www.alchemy.com/). Replace `eth_rpc_url` in `foundry.toml` with the rpc url from Alchemy.

* Run the following command to deploy

```bash
forge script script/Camp.s.sol:DeployScript --broadcast
```

* Alternatively, to also verify the contract on etherscan, you can run the following command

```
source .env && forge script script/Camp.s.sol:DeployScript --broadcast --etherscan-api-key $ETHERSCAN_KEY --verify
```

* You can also verify the contract after deployment using the following command (The parameter `--num-of-optimizations` should be set to 200 if nothing was specified during deployment)

```
source .env && forge verify-contract --watch --chain-id 5 --num-of-optimizations 200 --compiler-version 0.8.15+commit.e14f2714 CONTRACT_ADDRESS src/Camp.sol:Camp $ETHERSCAN_KEY
```