# DappCamp Warriors

## Scaffolding

### Pre-requisites

* [Install foundry](https://book.getfoundry.sh/getting-started/installation)

### Overview

This branch shows the scaffolding of a [Foundry](https://getfoundry.sh/) project.

To get a similar result, you can do the following:

1) Install foundry by following the instructions from here: [Getting Started](https://book.getfoundry.sh/getting-started/installation)

        cd .. && mkdir my-project && cd my-project

2) To start a new project with Foundry, use the `forge init` command. Forge is a command-line tool that ships with Foundry. Forge tests, builds, and deploys your smart contracts.:

        forge init

### Why Foundry

Foundry is a relatively new, open-source smart contract development framework built by [Paradigm](https://paradigm.xyz/).
Some of its benefits are:

* Fast & flexible compilation pipeline
* Tests are written in Solidity
* Fast fuzz testing
* Many more, listed on [its GitHub repo](https://github.com/foundry-rs/foundry)

### Files and folders

* `src` all your Solidity files will go here.
* `lib` contains dependencies stored as submodules.
* `out` compiled contract and abis
* `script` Foundry scripts, e.g.: deploy scripts.
* `test` this one's pretty self-explanatory.
* `foundry.toml` configure foundry's behaviour

### Recommended tooling

#### VS Code Solidity extension

Another useful extension is [Nomic Foundation's](https://marketplace.visualstudio.com/items?itemName=NomicFoundation.hardhat-solidity), also listed on the recommended extensions.
