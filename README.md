# DappCamp Warriors

In this last section we are adding the frontend for our Dapp. The frontend is at the [frontend](frontend) folder.

## Step 1: Add frontend boilerplate

- Initialize project with [Next.js + Tailwind CSS Template](https://github.com/vercel/next.js/tree/c3e5caf1109a2eb42801de23fc78e42a08e5da6e/examples/with-tailwindcss)
- Install [prettier-plugin-tailwindcss plugin](https://github.com/tailwindlabs/prettier-plugin-tailwindcss) for automatic class sorting
- Install ethers.js
- Overview of the components:
  - Next.js is a Node.js based framework for building server-side rendered React applications
  - Tailwind is a library that provides utility css classes to style elements
  - Ethers.js is a library for interacting with the Ethereum Blockchain
- Setup meta tags by adding a [\_document.jsx file](https://nextjs.org/docs/advanced-features/custom-document)
- Add utility methods for common operations like fetching connected accounts and signing a contract
- Add abis of the smart contracts ([frontend/src/data/abis](frontend/src/data/abis))
