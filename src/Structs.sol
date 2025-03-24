// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


library Structs {

    enum LoteryStatus {
        OPEN,
        CLOSED
    }

    struct User {
        address userAddress;
        uint256 value;
        string name;
    }

    struct Lotery {
        uint256 id;
        address creator;
        uint256 price;
        address[] players_id;
       // User[] players_info;
        uint256 startTime;
        uint256 reward;
        LoteryStatus status;
    }
}
