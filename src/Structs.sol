// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library Structs {

    enum LoteryStatus {
        OPEN,
        CLOSED,
        CANCELLED
    }

    struct User {
        address userAddress;
        uint256 balance;
        string name;
    }

    struct Lotery {
        uint256 id;
        address creator;
        uint256 price;
        User[] players;
        uint256 startTime;
        uint256 reward;
        LoteryStatus status;
    }
}
