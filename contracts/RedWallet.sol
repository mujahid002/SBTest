// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC721Enumerable, ERC721} from "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {ERC721URIStorage} from "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "../node_modules/@openzeppelin/contracts/access/AccessControl.sol";

contract SoulboundToken is ERC721, ERC721URIStorage, AccessControl {
    bytes32 public constant REDWALLET_MINTER_ROLE =
        keccak256("REDWALLET_MINTER_ROLE");
    bytes32 public constant REDWALLET_BURNER_ROLE =
        keccak256("REDWALLET_BURNER_ROLE");

    uint256 private _tokenIdCounter;
    mapping(uint256 => bool) private s_soulBoundTokens;

    event Attest(address indexed to, uint256 indexed tokenId);
    event Revoke(address indexed to, uint256 indexed tokenId);

    constructor() ERC721("RedWalletSBT", "RSBT") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(REDWALLET_MINTER_ROLE, _msgSender());
        _grantRole(REDWALLET_BURNER_ROLE, _msgSender());
    }

    function safeMint(address to, string memory uri)
        public
        onlyRole(REDWALLET_MINTER_ROLE)
    {
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, uri);
        _tokenIdCounter += 1;
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "Only owner of the token can burn it");
        _burn(tokenId);
    }


    function _beforeTokenTransfer(address from, address to, uint256) pure override internal {
        require(from == address(0) || to == address(0), "Not allowed to transfer token");
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId) override internal {

        if (from == address(0)) {
            emit Attest(to, tokenId);
        } else if (to == address(0)) {
            emit Revoke(to, tokenId);
        }
    }

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getTokenCount() public view returns(uint256){
        return _tokenIdCounter;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(ERC721, ERC721URIStorage, AccessControl)
        onlyRole(DEFAULT_ADMIN_ROLE)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
