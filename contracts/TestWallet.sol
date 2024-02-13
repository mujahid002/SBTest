// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721, IERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Enumerable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import {Pausable} from "@openzeppelin/contracts/utils/Pausable.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

// Custom error messages
error TestWallet__UserCannotBurnNotice();
error TestWallet__UserCannotTransferNotice();

// TestWallet Contract
contract TestWallet is
    ERC721Enumerable,
    ERC721URIStorage,
    AccessControl,
    Pausable
{
    // Bytes32 for Access Control Roles
    bytes32 public constant TESTWALLET_MINTER_ROLE =
        keccak256("TESTWALLET_MINTER_ROLE");
    bytes32 public constant TESTWALLET_BURNER_ROLE =
        keccak256("TESTWALLET_BURNER_ROLE");

    // Event for token transfers
    event transfer(
        address indexed from,
        address indexed to,
        uint256 tokenId,
        bytes data
    );

    // Constructor
    constructor() ERC721("TestWalletNotice", "TWN") {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _grantRole(TESTWALLET_MINTER_ROLE, _msgSender());
        _grantRole(TESTWALLET_BURNER_ROLE, _msgSender());
    }

    /**
     * @dev Send new notice to a user with the specified URI.
     * @param _to Address of the recipient.
     * @param _noticeURI URI of the notice.
     */
    function sendNotice(address _to, string memory _noticeURI)
        public
        whenNotPaused
        onlyRole(TESTWALLET_MINTER_ROLE)
    {
        uint256 _noticeId = totalSupply() + 1;
        _safeMint(_to, _noticeId);
        _setTokenURI(_noticeId, _noticeURI);
    }

    /**
     * @dev Burn a notice belonging to the specified tokenId.
     * @param _noticeId ID of the notice to burn.
     */
    function burnNotice(uint256 _noticeId)
        external
        whenNotPaused
        onlyRole(TESTWALLET_BURNER_ROLE)
    {
        if (ownerOf(_noticeId) == _msgSender())
            revert TestWallet__UserCannotBurnNotice();
        _burn(_noticeId);
    }

    /**
     * @dev Get an array of notice tokens owned by a user.
     * @param _userAddress Address of the user.
     * @return Array of notice tokens.
     */
    function _fetchUserNotices(address _userAddress)
        public
        view
        returns (uint256[] memory)
    {
        uint256 userNoticeCount = balanceOf(_userAddress);
        uint256[] memory _allUserNotices = new uint256[](userNoticeCount);
        for (uint256 i = 0; i < userNoticeCount; i++) {
            _allUserNotices[i] = tokenOfOwnerByIndex(_userAddress, i);
        }

        return _allUserNotices;
    }

    /**
     * @dev Check if a user owns any notices.
     * @param _userAddress Address of the user.
     * @return True if the user owns notices, false otherwise.
     */
    function _checkUserHaveNotice(address _userAddress) public view returns(bool){
        return balanceOf(_userAddress) > 0;
    }


    /**************************
    OVERRIDE TRANSFER FUNCTIONS
    ***************************/

    /**
     * @dev Helper Functions: _safeTransfer, safeTransferFrom, transferFrom are overridden functions from ERC721, IERC721 to block user transfer
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual override {
        emit transfer(from, to, tokenId, data);
        revert TestWallet__UserCannotTransferNotice();
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override(ERC721, IERC721) {
        emit transfer(from, to, tokenId, data);
        revert TestWallet__UserCannotTransferNotice();
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721, IERC721) {
        emit transfer(from, to, tokenId, "");
        revert TestWallet__UserCannotTransferNotice();
    }

    /**************************
    OVERRIDE DEFAULT FUNCTIONS
    ***************************/

    /**
     * @dev Default Override Functions to allow contract functionalities
     */
    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
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
        override(ERC721Enumerable, ERC721URIStorage, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
