// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConvertor.sol";

contract FundMe {
    uint256 public minUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public {
        require(
            msg.value.getConversionRate() >= minUsd,
            "Didn't Send enough ETH."
        );
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint i = 0; i < funders.length; i++) {
            addressToAmountFunded[funders[i]];
        }

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call Failed!");
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Must be the owner");
        _;
    }
}
