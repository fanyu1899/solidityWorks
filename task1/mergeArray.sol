// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract mergeArray{

    function merge(int[] memory arr1,int[] memory arr2) public pure returns (int[] memory){
        uint i =0;
        uint j =0;
        int[] memory res = new int[](arr1.length+arr2.length);

        uint k = 0;

        while(k< res.length){
            if(i<arr1.length && j<=arr2.length){
                if(arr1[i]<arr2[j]){
                    res[k] = arr1[i];
                    i++;
                }else{
                    res[k] = arr2[j];
                    j++;
                }   
            }else{
                if(i<arr1.length){
                    res[k] = arr1[i];
                    i++;
                }else{
                    res[k] = arr2[j];
                    j++;
                }
            }
            k++;
        }
        
        return  res;

    }
}