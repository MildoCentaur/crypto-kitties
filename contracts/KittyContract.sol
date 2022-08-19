// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract KittyContract is IERC721{
    
    using Counters for Counters.Counter;
    
    string private _name = "";
    string private _symbol = "";

    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    Kitty[] private kitties;
    mapping(address => uint256) private owners_amount;
    mapping(uint256 => address) private kitties_to_owners;

    Counters.Counter private _nextTokenId; 
    
    constructor(){
        _nextTokenId.reset();
        _name = "MildoKitties";
        _symbol = "MKT";
    }

    function balanceOf(address owner) external override view returns (uint256 balance){
        return owners_amount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() external override view returns (uint256 total){
        return _nextTokenId.current();
    }

    /*
     * @dev Returns the name of the token.
     */
    function name() external override view returns (string memory tokenName){
        return _name;
    }

    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() external override view returns (string memory tokenSymbol){
        return _symbol;
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external override view returns (address owner){
        return _owns(tokenId);
    }


     /* @dev Transfers `tokenId` token from `msg.sender` to `to`.
     *
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `to` can not be the contract address.
     * - `tokenId` token must be owned by `msg.sender`.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 tokenId) external override{
        require(_owns(tokenId) == msg.sender, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        require(to != address(this), "This contract should not receive the token" );

        _transfer(msg.sender, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        
        if (from != address(0)){
            owners_amount[from]--;
        }
        owners_amount[to]++;
        kitties_to_owners[tokenId] = to;

        emit Transfer(msg.sender, to, tokenId);
    }

    function _owns(uint256 tokenId) internal view returns( address owner){
        require(tokenId <= _nextTokenId.current(), "Token doesn't exist");
        
        return kitties_to_owners[tokenId];
    }

}