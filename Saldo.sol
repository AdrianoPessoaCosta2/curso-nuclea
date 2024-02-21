// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.4;

import "./IRC20.sol";

contract Saldo {

    function getSaldo(address token_, address pessoa_) public view returns(uint256){
        IERC20 token = IERC20(token_);
        return token.balanceOf(pessoa_);
    }
}

