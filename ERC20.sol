/*
file:   ERC20.sol
ver:    0.4.0
updated:6-April-2017
author: Darryl Morris
email:  o0ragman0o AT gmail.com

An ERC20 compliant token with reentry protection and safe math.

This software is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
See MIT Licence for further details.
<https://opensource.org/licenses/MIT>.
*/

pragma solidity ^0.4.10;

import "https://github.com/o0ragman0o/ReentryProtected/ReentryProtected.sol";

// ERC20 Standard Token Interface with safe maths and reentry protection
contract ERC20Interface
{
/* Structs */

/* State Valiables */

    /// @return Total amount of tokens
    uint public totalSupply;
    
    /// @return Token symbol
    string public symbol;
    
    // Token ownership mapping
    mapping (address => uint) balance;
    
    /// Allowances mapping
    mapping (address => mapping (address => uint)) allowed;

/* Events */
    // Triggered when tokens are transferred.
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value);

    // Triggered whenever approve(address _spender, uint256 _value) is called.
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value);

/* Modifiers */

/* Function Abstracts */

    /// @notice Send `_amount` of tokens from `msg.sender` to `_to`
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to transfer
    function transfer(address _to, uint256 _amount) external returns (bool);

    /// @notice Send `_amount` of tokens from `_from` to `_to` on the condition
    /// it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _amount The amount of tokens to transfer
    function transferFrom(address _from, address _to, uint256 _amount)
        external returns (bool);

    /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
    /// its behalf
    /// @param _spender The address of the approved spender
    /// @param _amount The amount of tokens to transfer
    function approve(address _spender, uint256 _amount) external returns (bool);
}

contract ERC20Token is ReentryProtected, ERC20Interface
{

/* Constants */
    bytes32 constant public VERSION = "ERC20 0.4.0-o0ragman0o";

/* Funtions Public */

    function ERC20Token(
        uint _supply,
        string _symbol)
    {
        totalSupply = _supply;
        symbol = _symbol;
        balance[msg.sender] = totalSupply;
    }
        
    function balanceOf(address _addr)
        public
        constant
        returns (uint)
    {
        return balance[_addr];
    }
    
    function allowance(address _owner, address _spender)
        public
        constant
        returns (uint remaining_)
    {
        return allowed[_owner][_spender];
    }
        

    // Send _value amount of tokens to address _to
    function transfer(address _to, uint256 _value)
        external
        noReentry
        returns (bool)
    {
        return xfer(msg.sender, _to, _value);
    }

    // Send _value amount of tokens from address _from to address _to
    function transferFrom(address _from, address _to, uint256 _value)
        external
        noReentry
        returns (bool)
    {
        require(_value <= allowed[_from][msg.sender]);
        uint __check;        
        __check = allowed[_from][msg.sender];
            allowed[_from][msg.sender] -= _value;
        assert(allowed[_from][msg.sender] < __check);
        
        return xfer(_from, _to, _value);
    }

    // Process a transfer internally.
    function xfer(address _from, address _to, uint _value)
        internal
        returns (bool)
    {
        uint __check;
        require(_value <= balance[_from]);

        __check = balance[_from];
            balance[_from] -= _value;
        assert(balance[_from] < __check);
        
        __check = balance[_to];
            balance[_to] += _value;
        assert(balance[_to] > __check);
        
        Transfer(_from, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value)
        external
        noReentry
        returns (bool)
    {
        require(balance[msg.sender] != 0);
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }
}