const factoryABI = [{
        "inputs": [],
        "stateMutability": "nonpayable",
        "type": "constructor"
    },
    {
        "inputs": [{
            "internalType": "address",
            "name": "owner",
            "type": "address"
        }],
        "name": "OwnableInvalidOwner",
        "type": "error"
    },
    {
        "inputs": [{
            "internalType": "address",
            "name": "account",
            "type": "address"
        }],
        "name": "OwnableUnauthorizedAccount",
        "type": "error"
    },
    {
        "anonymous": false,
        "inputs": [{
                "indexed": false,
                "internalType": "address",
                "name": "collectionAddress",
                "type": "address"
            },
            {
                "indexed": false,
                "internalType": "address",
                "name": "owner",
                "type": "address"
            }
        ],
        "name": "CollectionCreated",
        "type": "event"
    },
    {
        "anonymous": false,
        "inputs": [{
                "indexed": true,
                "internalType": "address",
                "name": "previousOwner",
                "type": "address"
            },
            {
                "indexed": true,
                "internalType": "address",
                "name": "newOwner",
                "type": "address"
            }
        ],
        "name": "OwnershipTransferred",
        "type": "event"
    },
    {
        "inputs": [{
                "internalType": "string",
                "name": "name",
                "type": "string"
            },
            {
                "internalType": "string",
                "name": "symbol",
                "type": "string"
            },
            {
                "internalType": "uint256",
                "name": "maxSupply",
                "type": "uint256"
            }
        ],
        "name": "createCollection",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "owner",
        "outputs": [{
            "internalType": "address",
            "name": "",
            "type": "address"
        }],
        "stateMutability": "view",
        "type": "function"
    },
    {
        "inputs": [],
        "name": "renounceOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    },
    {
        "inputs": [{
            "internalType": "address",
            "name": "newOwner",
            "type": "address"
        }],
        "name": "transferOwnership",
        "outputs": [],
        "stateMutability": "nonpayable",
        "type": "function"
    }
]

module.exports = factoryABI;