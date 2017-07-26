# ERC20
### A Re-entry protected and overloadedable implimentation of the ERC20 token standard.

0.4.4-o0ragman0o

updated:26-July-2017

author: Darryl Morris

license: MIT

### ABI
```
[{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"remaining_","type":"uint256"}],"payable":false,"type":"function"},{"constant":true,"inputs":[],"name":"VERSION","outputs":[{"name":"","type":"bytes32"}],"payable":false,"type":"function"},{"inputs":[{"name":"_supply","type":"uint256"},{"name":"_symbol","type":"string"}],"payable":false,"type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_from","type":"address"},{"indexed":true,"name":"_to","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Transfer","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"_owner","type":"address"},{"indexed":true,"name":"_spender","type":"address"},{"indexed":false,"name":"_value","type":"uint256"}],"name":"Approval","type":"event"}]
```

## Overview
This contract impliments the ERC20 API functions of `totalSupply()` `balanceOf()`
`allowed()` `transfer()` `transferFrom()` and `allowance()`.

[Re-entry protection](https://github.com/o0ragman0o/ReentryProtected)
on the state mutating functions prevents a malicious 
contract from reentering the contract in an attempt to change state while in a
different memory context.

The `totalSupply()` `balanceOf()` and `allowance()` getters are explicitly defined to allow for
function overloading in deriving contracts where such contracts may return calculated values.
The respective internal state variables are `totSupply` `balance` and `allowed`

This implimentation uses a single internal transfer function `xfer(from, to, amount)` called
by the overloadable public functions `transfer()` and `transferFrom`.  This allows deriving
contracts to overload the public functions with additional parameter validation and dynamic
behaviour without having to rewrite the core transfer logic.

## Functions

### totalSupply
```
function totalSupply() public constant returns (uint);
```
Returns the total supply of tokens

### symbol
```
function symbol() public constant returns (string);
```
Returns the trading symbol of the token

### balanceOf
```
function balanceOf(address _addr) public constant returns (uint);
```
Returns the balance of tokens of a holder
`_addr` The address of a token holder

### allowance
```
function allowance(address _owner, address _spender) public constant returns (uint);
```
Returns the amount of tokens the `_spender` is allowed to transfer
`_owner` The address of a token holder
`_spender` the address of a third-party

### transfer
```
function transfer(address _to, uint256 _amount) public returns (bool);
```
Sends the `_amount` of tokens from `msg.sender` to `_to`. Returns success.
`_to` The address of the recipient
`_amount` The amount of tokens to transfer

### transferFrom
```
function transferFrom(address _from, address _to, uint256 _amount)
        public returns (bool);
```
Sends the `_amount` of tokens from `_from` to `_to` on the condition the amount
has been approved by `_from`.
`_from` The address of the sender.
`_to` The address of the recipient.
`_amount` The amount of tokens to transfer.

### approve
```
function approve(address _spender, uint256 _amount) public returns (bool);
```
Approves and amount of tokens that can be sent by a thrid-party
`_spender` The address of the approved spender
`_amount` The amount of tokens to transfer

## Events

### Transfer
```
event Transfer(address indexed _from, address indexed _to, uint256 _value);`
```
Triggered when tokens are transferred.

### Approval
```
event Approval(address indexed _owner, address indexed _spender, uint256 _value);
```
Triggered whenever approve(address _spender, uint256 _value) is called.
