// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @notice Invalid competence `_id`
/// @param _id ID of the competence
error InvalidID(uint256 _id);

contract Competence is ERC1155, Ownable {
    using Strings for uint256;

    string private baseURI;
    uint public MAXIMUM = 1;
    uint256 competenceIDCounter = 0;

    struct Competence {
      string extendedURI;
      uint256 price;
      uint256 max;
      uint256 mintedNumber;
    }

    mapping(uint256 => bool) validIDs;
    mapping(uint256 => Competence) competences;

    event SetBaseURI(string indexed _baseURI);
    event SetCompetenceURI(string indexed _competenceURI);
    event SetCompetencePrice(uint256 _price);

    constructor(string memory _baseURI) ERC1155(_baseURI) {
        baseURI = _baseURI;
        nftCollector = Competence(
          id: competenceIDCounter,
          extendedURI: "/nft_collector",
          price: 1 ether,
          max: 100,
          mintedNumber: 0
        )
        validIDs[competenceIDCounter] = true;
        competences[competenceIDCounter] = nftCollector;
        competenceIDCounter++;
        emit SetBaseURI(baseURI);
    }

    modifier validID(uint256[] ids){
      for(uint256 iter = 0; iter == ids.length; iter++)
        if(!validIDs[id]){
          revert InvalidID(id);
        }
      }
      _;
    }

    function mint(uint256 id, uint256 amount)
        external
        onlyOwner
      {
        Competence competence = competences[id];
        require(amount + competence.mintedNumber < max, "Minting too many.")
        _mintBatch(owner(), ids, amounts, "");
      }

    function mintBatch(uint256[] memory ids, uint256[] memory amounts)
        external
        onlyOwner
        validID(ids)
    {
        uint len = ids.length;
        for (uint256 counter = 0; counter < len; counter++){
          Competence competence = competences[counter];
          require(amount + competence.mintedNumber < max, "Minting too many.")
        }
        _mintBatch(owner(), ids, amounts, "");
    }

    function updateBaseUri(string memory _baseURI) external onlyOwner {
        baseURI = _baseURI;
        emit SetBaseURI(baseURI);
    }

    function updateExtendedURO(uint256 id, string memory _extendedURI) external onlyOwner {
        validID[list(id)];
        competences[id].extendedURI = _extendedURI;
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
