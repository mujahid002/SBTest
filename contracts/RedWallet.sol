// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

error RedWallet__CannotBurnSoulBoundToken();
error RedWallet__CannotTransferSoulBoundToken();

contract RedWallet is ERC721Enumerable, ERC721URIStorage, AccessControl, Pausable {
    bytes32 public constant REDWALLET_MINTER_ROLE =
        keccak256("REDWALLET_MINTER_ROLE");
    bytes32 public constant REDWALLET_BURNER_ROLE =
        keccak256("REDWALLET_BURNER_ROLE");

    uint256 public _tokenIdCounter;

    event transfer(address indexed from, address indexed to, uint256 tokenId, bytes data);


    constructor() ERC721("RedWalletSBT", "RSBT") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(REDWALLET_MINTER_ROLE, _msgSender());
        _grantRole(REDWALLET_BURNER_ROLE, _msgSender());
    }

    function safeMint(address to, string memory uri) public onlyRole(REDWALLET_MINTER_ROLE) whenNotPaused{
        _safeMint(to, _tokenIdCounter);
        _setTokenURI(_tokenIdCounter, uri);
        _tokenIdCounter+=1;
    }

    function burn(uint256 tokenId) external onlyRole(REDWALLET_BURNER_ROLE) whenNotPaused{
        if(ownerOf(tokenId)==_msgSender()) revert RedWallet__CannotBurnSoulBoundToken();
        _burn(tokenId);
    }

    function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual override {
        emit transfer(from, to,tokenId,data);
        revert RedWallet__CannotTransferSoulBoundToken();
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override(ERC721, IERC721) {
        emit transfer(from, to,tokenId,data);
        revert RedWallet__CannotTransferSoulBoundToken();
    }

    function transferFrom(address from, address to, uint256 tokenId) public virtual override(ERC721, IERC721) {
        emit transfer(from, to,tokenId,"");
        revert RedWallet__CannotTransferSoulBoundToken();
    }

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override( ERC721Enumerable,ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

}
