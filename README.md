# InAppPurchaseService

An abstraction of a service for handling in-app purchases.

## Features

- Fetch all available purchases, or their IDs.
- Fetch purchase information for a certain ID.
- Check whether a purchase was already purchased.
- Purchase a purchase.

## How to use

- Define a type (preferrably an enum), with your purchase IDs.
- Add their identifier as a raw String value.
- Conform to CaseIterable.
- Pass this ID type as a generic argument to your InAppPurchaseService.

## StoreKitService

With the ID type all products will be automatically fetched during asynchronous initialization and updated later, as needed.
