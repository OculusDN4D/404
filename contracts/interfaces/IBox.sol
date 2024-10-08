//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IBox{
    function burn(uint256) external;
    function ownerOf(uint256) external view returns (address);
}
