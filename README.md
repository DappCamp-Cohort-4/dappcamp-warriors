# DappCamp Warriors

## Create ERC721

We'll give birth to the DappCamp warriors, an NFT collection using [ERC721](https://eips.ethereum.org/EIPS/eip-721).

Let's now go to [DappCampWarriors.sol](src/DappCampWarriors.sol), as you can see, the file is fully commented explaining what's going on.
The format of the comments follows [NatSpec](https://docs.soliditylang.org/en/v0.8.13/natspec-format.html), the standard comment format for Solidity code.

## Test

Forge comes with an in-built testing framework and allows us to write tests in Solidity itself.

We added tests for ERC721 contract: [test/DappCampWarriors.t.sol](test/DappCampWarriors.t.sol).

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
forge script script/DappCampWarriors.s.sol:DeployScript --fork-url http://localhost:8545 --broadcast --private-key $PRIVATE_KEY
```

On successful completion you must have contract addresses printed on the console. Also check the `run-latest.json` file in `broadcast` directory for details on transactions made during the running of script.

### Deploying to testnet/mainnet

Follow these steps to deploy to your desired testnet, you can skip the first 3 steps if you have already done this during ERC20 deployment:

* Rename `.env.example` to `.env` file.

* Add values for `PRIVATE_KEY` and `ETHERSCAN_KEY` variables in `.env` file.

* Get an rpc url of your desired testnet, this can be obtained by creating an account on [Alchemy](https://www.alchemy.com/). Replace `eth_rpc_url` in `foundry.toml` with the rpc url from Alchemy.

* Run the following command to deploy

```bash
forge script script/DappCampWarriors.s.sol:DeployScript --broadcast
```

* Alternatively, to also verify the contract on etherscan, you can run the following command

```
source .env && forge script script/DappCampWarriors.s.sol:DeployScript --broadcast --etherscan-api-key $ETHERSCAN_KEY --verify
```