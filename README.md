# DappCamp Warriors

In this last section we are adding the frontend for our Dapp. The frontend is at the [frontend](frontend) folder.

## Step 2: Add Connect Wallet button and Balance counter

- Setup react contexts to share the connected account and contracts across pages in our app
  - [Passing Data Deeply with Context](https://beta.reactjs.org/learn/passing-data-deeply-with-context)
- Add Connect Wallet and Balance counter to the header
  - Clicking on the connect wallet will prompt the user to connect metamask to our app
  - Balance is fetched by reading the ERC20 balance from the Camp contract. It is refreshed every 1 second.
