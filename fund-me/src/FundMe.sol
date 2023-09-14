// I'm a comment!
// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConvertor.sol";

error NotOwner();

contract FundMe {
    uint256 public constant MIN_USD = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded)
        public addressToAmountFunded;

    address public immutable i_owner;

    constructor() {
        owner = msg.sender;
    }

    function fund() public {
        require(
            msg.value.getConversionRate() >= MIN_USD,
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
        // require(msg.sender == i_owner, "Must be the owner");
        if (msg.sender != i_owner) {
            revert NotOwner();
        }
        _;
    }

    // If someone sends money directly to contract
    receive() external payable {
        fund();
    }

    // if someone call function that doesnt exist
    fallback() external payable {
        fund();
    }
}
