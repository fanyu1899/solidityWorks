// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract BinarySearch{
    function search(int[] memory array,int num) public pure returns(uint index){
        uint l = 0;
        uint r = array.length;

        while(l<r){
            uint mid = (l+r)>>1;
            if (array[mid]<num)l=mid+1;
            else r=mid;
        }

        return l;
    }
}