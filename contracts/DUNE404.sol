//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";
import {ERC404} from "./ERC404.sol";
import {IBox} from "./interfaces/IBox.sol";
import {ERC404UniswapV3Exempt} from "./extensions/ERC404UniswapV3Exempt.sol";


contract DUNE404 is Ownable, ERC404, ERC404UniswapV3Exempt{
  
  string public baseTokenURI;

  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_,
    uint256 maxTotalSupplyERC721_,
    string memory baseTokenURI_,
    address initialOwner_,
    address initialMintRecipient_,
    address uniswapV3SwapRouter_,
    address uniswapV3NonfungiblePositionManager_
  ) ERC404(name_, symbol_, decimals_) 
    Ownable(initialOwner_)
    ERC404UniswapV3Exempt(uniswapV3SwapRouter_, uniswapV3NonfungiblePositionManager_)
  {
    baseTokenURI = baseTokenURI_;
    _setERC721TransferExempt(initialOwner_, true);
    _setERC721TransferExempt(initialMintRecipient_, true);
    _mintERC20(initialMintRecipient_, maxTotalSupplyERC721_ * units);
  }

  function airdrop(address[] memory receivers) external onlyOwner {
    require(receivers.length >= 1, "DUNE404: at least 1 receiver");
    for (uint256 i; i < receivers.length; i++) {
      address receiver = receivers[i];
      transfer(receiver, units);
    }
  }

  function airdropWithAmounts(
    address[] memory receivers,
    uint256[] memory amounts
  ) external onlyOwner {
    require(receivers.length >= 1, "DUNE404: at least 1 receiver");
    for (uint256 i; i < receivers.length; i++) {
      address receiver = receivers[i];
      transfer(receiver, amounts[i] * units);
    }
  }

  function reveal(address boxAddress, uint256 from, uint256 to) external onlyOwner{
    require(to > from, "DUNE404: invalid input");
    IBox box = IBox(boxAddress);
    for (uint256 i = from; i < to; i++) {
      address receiver = box.ownerOf(i);
      box.burn(i);
      transfer(receiver, units);
    }
  }

  function tokenURI(uint256 id_) public view override returns (string memory) {
    return string.concat(baseTokenURI, Strings.toString(id_));
  }

  function setERC721TransferExempt(
    address account_,
    bool value_
  ) external onlyOwner {
    _setERC721TransferExempt(account_, value_);
  }

  function setBaseURI(string calldata baseURI) external onlyOwner {
    baseTokenURI = baseURI;
  }
}
