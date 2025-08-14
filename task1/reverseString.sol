// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract ReverseString{

    function reverse(string memory s) public pure returns(string memory){
        bytes memory strBytes = bytes(s);
        uint len = strBytes.length;

        for (uint i=0;i<len/2;i++){
            bytes1 tmp =strBytes[i];
            strBytes[i] = strBytes[len-i-1];
            strBytes[len-i-1] = tmp;
        }

        return string(strBytes);
    }
    function reverseZh(string memory str) public pure returns (string memory) {
        bytes memory strBytes = bytes(str);
        bytes[] memory chars = new bytes[](strBytes.length); // 最多可能每个字节一个元素
        uint count = 0;
        uint i = 0;

        while (i < strBytes.length) {
            uint charLen = 1;
            uint8 b = uint8(strBytes[i]);

            if (b >= 0xF0) {
                charLen = 4; // 4 字节字符（emoji）
            } else if (b >= 0xE0) {
                charLen = 3; // 3 字节字符（常见中文）
            } else if (b >= 0xC0) {
                charLen = 2; // 2 字节字符
            } // else 1 字节 ASCII

            bytes memory charBytes = new bytes(charLen);
            for (uint j = 0; j < charLen; j++) {
                charBytes[j] = strBytes[i + j];
            }

            chars[count] = charBytes;
            count++;
            i += charLen;
        }

        // 拼接倒序字符
        bytes memory reversed = new bytes(strBytes.length);
        uint k = 0;
        for (int m = int(count) - 1; m >= 0; m--) {
            bytes memory charBytes = chars[uint(m)];
            for (uint n = 0; n < charBytes.length; n++) {
                reversed[k] = charBytes[n];
                k++;
            }
        }

        return string(reversed);
    }
}