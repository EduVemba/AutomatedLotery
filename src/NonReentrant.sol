// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error NonReentrant();

contract NoReentrant {
    bool internal lock = false;

    modifier NoReentrancy(){
        if (lock != false) {
            revert NonReentrant();
        }
        lock = true;
        _;
        lock = false;
    }
}