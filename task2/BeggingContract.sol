// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


contract BeggingContract{


    // 存储捐赠信息的结构体
    struct DonationInfo {
        uint256 totalAmount; // 总捐赠金额
        uint256 donationCount; // 捐赠次数
    }
    
// 合约所有者   
    address public owner;
    mapping ( address => DonationInfo ) public donateMap;
        // 捐赠事件
    event Donated(address indexed donor, uint256 amount, uint256 timestamp);
       // 提取事件
    event Withdrawn(address indexed owner, uint256 amount, uint256 timestamp);


 // 构造函数，设置合约部署者为所有者
    constructor() {
        owner = msg.sender;
    }

    function donate() public payable{
        require(msg.value > 0, "Donation amount must be greater than 0");

        // 更新捐赠者的信息
        donateMap[msg.sender].totalAmount += msg.value;
        donateMap[msg.sender].donationCount += 1;

        emit Donated(msg.sender, msg.value, block.timestamp);

    }

    // 提取函数，仅限所有者调用
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw");
        uint256 amount = address(this).balance;
        require(amount > 0, "No funds to withdraw");
        
        // 转移资金到所有者
        (bool success, ) = payable(owner).call{value: amount}("");
        require(success, "Withdrawal failed");
        
        // 触发提取事件
        emit Withdrawn(msg.sender, amount, block.timestamp);
    }

       // 获取指定地址的捐赠信息
    function getDonationInfo(address donor) public view returns (uint256, uint256) {
        return (donateMap[donor].totalAmount, donateMap[donor].donationCount);
    }
}