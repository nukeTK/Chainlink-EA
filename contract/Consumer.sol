// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

//This contract for single return value from the External adapter
contract Counsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    uint256 private constant ORACLE_PAYMENT = 1 * 10**18; //How much cost for per API call 
    string public lastRetrivedData;

    constructor() ConfirmedOwner(msg.sender) {
        setChainlinkToken(0x326C977E6efc84E512bB9C30f76E30c160eD06FB); //Link Token Address 
        setChainlinkOracle(0xCC79157eb46F5624204f47AB42b3906cAA40eaB7); //Deployed Oracle or Operator contract address
    }


    function requestInfo(
        string memory jobId, //Id of job that created on chainlink node
        string memory name  //argument need to pass into external to fetch particular data
    ) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            stringToBytes32(jobId),
            address(this),
            this.fulfill.selector //Callback function
        );
        req.add("name", name);  
        return sendChainlinkRequest(req, ORACLE_PAYMENT);
    }

    //this function will store the value come back from the external adapter 
    function fulfill(bytes32 _requestId, string memory _info)
        public
        recordChainlinkFulfillment(_requestId)
    {
        lastRetrivedData = _info;
    }
    //utils functions
    function stringToBytes32(string memory source)
        internal
        pure
        returns (bytes32 result)
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }
        assembly {
            result := mload(add(source, 32))
        }
    }
 
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
