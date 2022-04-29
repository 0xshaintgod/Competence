// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Competence is ERC1155, Ownable {
    using Strings for uint256;

    string private baseURI;
    uint public MAXIMUM = 1;

    mapping(uint256 => bool) validIDs;

    event SetBaseURI(string indexed _baseURI);

    constructor(string memory _baseURI, uint maximum) ERC1155(_baseURI) {
        MAXIMUM = maximum;
        baseURI = _baseURI;
        validIDs[0] = true;
        validIDs[1] = true;
        emit SetBaseURI(baseURI);
    }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        external
        onlyOwner
    {
        uint len = ids.length;
        for (uint256 counter = 0; counter < len; counter++){
          require(validIDs[ids[counter]], "ID not accepted.");
        }
        _mintBatch(owner(), ids, amounts, "");
    }

    function updateBaseUri(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
        emit SetBaseURI(baseURI);
    }

    function uri(uint256 typeId)
        public
        view
        override
        returns (string memory)
    {
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, typeId.toString()))
                : baseURI;
    }
}
