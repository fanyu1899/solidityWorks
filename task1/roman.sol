// SPDX-License-Identifier: MIT
pragma solidity ^0.8;


contract roman{
    mapping (string => uint) public  romanMap;

    constructor(){
        romanMap["I"] = 1;
        romanMap["V"] = 5;
        romanMap["X"] = 10;
        romanMap["L"] = 50;
        romanMap["C"] = 100;
        romanMap["D"] = 500;
        romanMap["M"] = 1000;

        romanMap["IV"] = 4;
        romanMap["IX"] = 9;
        romanMap["XL"] = 40;
        romanMap["XC"] = 90;
        romanMap["CD"] = 400;
        romanMap["CM"] = 900;
    }

    function romanToNum(string calldata roman) public view returns (uint){
        bytes calldata by = bytes(roman);
        uint len = by.length;
        uint res =0;
        for(uint i = 0; i < len; i++){
            if(i<len-1 && romanMap[bytes2string(by[i:i+2])] != 0){
                res += romanMap[bytes2string(by[i:i+2])];
                i+=1;
            }
            else{
                res += romanMap[bytes2string(by[i:i+1])];
            }
        }

        return res;
    }

    function numToRoman(uint num) public pure returns (string memory) {
        bytes memory result;

        string[13] memory strArray = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"];
        uint16[13] memory numArray = [1000,900,500,400,100,90,50,40,10,9,5,4,1];

        for (uint i = 0; i < 13; i++) {
            while (num >= numArray[i]) {
                num -= numArray[i];
                result = abi.encodePacked(result, bytes(strArray[i]));
            }
        }

        return string(result);
    }


    function bytes2string(bytes memory by) private pure returns (string memory){
        return string(by);
    }
}