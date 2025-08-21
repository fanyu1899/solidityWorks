// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MikuCoin{
    string public  name = "Miku Coin";
    string public  symbol = "MIKU";
    uint8 public decimals = 18;
    uint256 public totalSupply;


    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner,address indexed spender, uint256 value);

    address public owner;

    constructor(){
        owner = msg.sender;
    }

    // ========== erc20 基础功能 ============
    
    function balanceOf(address account) external view returns(uint256){
        return balances[account];
    }

    function transfer(address to, uint256 amount) external returns(bool){
        require(to != address(0),"ERC20: transfer to the zero address");
        require(balances[msg.sender]>=amount,"ERC20: transfer amount exceeds balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;
        
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender,uint256 amount) external returns (bool){
        require(spender != address(0),"ERC20: transfer to the zero address");
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address _owner,address spender) external view returns (uint256){
        return allowances[_owner][spender];
    }

    function transferFrom(address from ,address to,uint256 amount) external returns(bool){
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balances[from] >= amount,"ERC20: transfer amount exceeds balance");
        require(allowances[from][msg.sender] >= amount,"ERC20: insufficient allowance");

        balances[from] -= amount;
        balances[to] += amount;
        allowances[from][msg.sender] -= amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "only owner can mint");
        require(to!=address(0),"ERC20: mint to zero address");
        totalSupply += amount;
        balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }
    
}
