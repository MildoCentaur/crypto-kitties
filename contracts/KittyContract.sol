// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract KittyContract is IERC721, Ownable {
    
    using Counters for Counters.Counter;
    uint256 public constant CREATION_LIMIT_GEN0 = 10; 
    string private _name = "";
    string private _symbol = "";

    struct Kitty {
        uint256 genes;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    event Birth (
        address owner, 
        uint256 kittenId,
        uint32 mumId,
        uint32 dadId,
        uint256 genes
    );

    Kitty[] public kitties;
    mapping(address => uint256) public owners_amount;
    mapping(uint256 => address) public kitties_to_owners;
    uint256 public gen0Counter;

    Counters.Counter public _nextTokenId; 
    
    constructor(){
        _nextTokenId.reset();
        _name = "MildoKitties";
        _symbol = "MKT";
    }
    
    function createKittyGen0(uint256 _genes) public returns (uint256){
        emit Birth(address(0),0,0,0,0);
        require(gen0Counter < CREATION_LIMIT_GEN0, "Gen 0 limit reached");
        emit Birth(address(0),0,0,1,1);
        gen0Counter ++;
        return _createKitty(0, 0, 0, _genes, msg.sender);
    }

    function getKitty(uint256 index) external view returns (Kitty memory kitty){
        require(index < _nextTokenId.current(), "index doesn't exist");
        return kitties[index];
    }
    
    function getKitty2(uint256 index) external view returns (uint256 genes,
                                                            uint256 birthTime,
                                                            uint256 mumId,
                                                            uint256 dadId,
                                                            uint256 generation){
        require(index < _nextTokenId.current());
        Kitty storage k = kitties[index];
        genes = k.genes;
        birthTime = uint256(k.birthTime);
        mumId = uint256(k.mumId);
        dadId = uint256(k.dadId);
        generation = uint256(k.generation);
    }

    function _createKitty( uint32 _mumId, uint32 _dadId,uint16 _generation, uint256 _genes, address _owner ) internal returns (uint256){
        Kitty memory _kitty = Kitty({genes: _genes,
                                     birthTime:uint64(block.timestamp),
                                     mumId: _mumId,
                                     dadId: _dadId,
                                     generation: uint16(_generation)});

        kitties.push(_kitty);
        
        _transfer(address(0), _owner, _nextTokenId.current()); 
        emit Birth(_owner, _nextTokenId.current(), _mumId, _dadId, _genes);
        _nextTokenId.increment();
        return _nextTokenId.current() -1;
    }

    function balanceOf(address owner) external override view returns (uint256 balance){
        return owners_amount[owner];
    }

    /*
     * @dev Returns the total number of tokens in circulation.
     */
    function totalSupply() public override view returns (uint256 total){
        return _nextTokenId.current();
    }

    /*
     * @dev Returns the name of the token.
     */
    function name() public override view returns (string memory tokenName){
        return _name;
    }

    /*
     * @dev Returns the symbol of the token.
     */
    function symbol() public override view returns (string memory tokenSymbol){
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
    function transfer(address _to, uint256 _tokenId) external override{
        require(_owns(_tokenId) == msg.sender, "ERC721: transfer from incorrect owner");
        require(_to != address(0), "ERC721: transfer to the zero address");
        require(_to != address(this), "This contract should not receive the token" );

        _transfer(msg.sender, _to, _tokenId);
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