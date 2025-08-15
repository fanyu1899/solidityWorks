// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Voting{
    mapping (string name => uint voteNums)  public votemap;
    mapping(string => bool) private keyExists;

    string[] public keys;

    function vote(string calldata name) public{
        votemap[name] += 1;
        if(!keyExists[name]){
            keys.push(name);
            keyExists[name] = true;
        }
    }

    function getVote(string calldata name) public view returns(uint){
       return votemap[name];
    }

    function resetVotes() public {
        for (uint i = 0; i < keys.length; i++) {
            delete votemap[keys[i]];
        }
        
        delete keys;
    }

}