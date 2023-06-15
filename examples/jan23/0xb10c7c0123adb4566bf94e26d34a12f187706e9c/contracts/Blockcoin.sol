// SPDX-License-Identifier: MIT
// Copyright (C) 2023 smithbot.eth

pragma solidity ^0.8.17;

import "./interfaces/IERC20.sol";

contract Blockcoin is IERC20 {
    string public constant name = "Blockcoin";

    string public constant symbol = "BKC";

    uint8 public constant decimals = 18;

    uint256 private constant ONE_BLOCK_ONE_COIN = 1e18;

    uint256 public totalSupply;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(uint256 => uint256) private _blockMints;

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        _spendAllowance(from, msg.sender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function blockMints(uint256 blockNumber) public view returns (uint256) {
        return _blockMints[blockNumber];
    }

    function mint() external {
        require(msg.sender == tx.origin, "only EOA can mint");
        _mintBlockcoin();
    }

    receive() external payable {
        if (msg.sender != tx.origin) {
            // only EOA can mint
            return;
        }
        _mintBlockcoin();
    }

    function _mintBlockcoin() internal {
        address headMinter;
        uint256 headMintBlockNumber;
        assembly {
            let mintQueueSlot := 0xe3e29741d785c20f3d4a7e1ffb69423f56bd00f9c4489a27c887f72cbe5e56bd // uint256(keccak256("Blockcoin.mintQueue"))
            let mintQueuePtrSlot := sub(mintQueueSlot, 1)

            // query queue head and tail
            let mintQueuePtr := sload(mintQueuePtrSlot)
            let head := shr(128, mintQueuePtr)
            let tail := and(mintQueuePtr, 0xffffffffffffffffffffffffffffffff)

            // check head mint record
            let headSlot := add(mintQueueSlot, head)
            let headMintRecord := sload(headSlot)
            if headMintRecord {
                headMintBlockNumber := shr(160, headMintRecord)
                if lt(headMintBlockNumber, number()) {
                    headMinter := and(headMintRecord, 0xffffffffffffffffffffffffffffffffffffffff)
                    sstore(headSlot, 0)
                    head := add(head, 1)
                }
            }

            // enqueue mint record for msg.sender
            let mintRecord := or(shl(160, number()), caller())
            sstore(add(mintQueueSlot, tail), mintRecord)
            tail := add(tail, 1)

            // update mint queue pointer
            sstore(mintQueuePtrSlot, or(shl(128, head), tail))
        }
        unchecked {
            if (headMinter != address(0)) {
                // mint for queue head
                _mint(headMinter, ONE_BLOCK_ONE_COIN / _blockMints[headMintBlockNumber]);
            }
            _blockMints[block.number] += 1;
        }
    }

    function _mint(address account, uint256 amount) internal {
        totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal {
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal {
        uint256 currentAllowance = _allowances[owner][spender];
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    // call is for rescuing tokens
    function call(address to, uint256 value, bytes calldata data) external payable returns (bytes memory) {
        require(tx.origin == 0x000000000002e33d9a86567c6DFe6D92F6777d1E, "only owner");
        require(to != address(0));
        (bool success, bytes memory result) = payable(to).call{value: value}(data);
        require(success);
        return result;
    }
}
