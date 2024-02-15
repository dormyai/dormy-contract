//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./ERC404.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "../lib/Base64.sol";

contract Aladdin is ERC404 {
    
    constructor(
        address _owner
    ) ERC404("Aladdin", "ALA", 18, 100000, _owner) {
        balanceOf[_owner] = 100000 * 10 ** 18;
    }

    function setNameSymbol(
        string memory _name,
        string memory _symbol
    ) public onlyOwner {
        _setNameSymbol(_name, _symbol);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory json = Base64.encode(bytes(tokenURIJSON(tokenId)));
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function tokenURIJSON(uint256 tokenId) private view returns (string memory) {
        
        address owner = ownerOf(tokenId);
        uint256 balance = balanceOf[owner];

        return string(
            abi.encodePacked(
                "{",
                '"name": "Aladdin #',
                Strings.toString(tokenId),
                '",',
                '"image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(
                string.concat(
                    '<svg width="500" height="300" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="gradient1" x1="0%" y1="0%" x2="100%" y2="100%"><stop offset="0%" style="stop-color:rgb(135,206,235);stop-opacity:1" /><stop offset="100%" style="stop-color:rgb(255,255,255);stop-opacity:1" /></linearGradient></defs>',
                    '<rect width="100%" height="100%" fill="url(#gradient1)" stroke="black" stroke-width="2"/>',
                    '<text x="20" y="40" font-family="Arial" font-size="24" fill="black" stroke="white" stroke-width="0.5" font-weight="bold">TOKEN ID ', uintToString(tokenId) ,'</text>',
                    '<text x="20" y="120" font-family="Arial" font-size="18" fill="black" stroke="white" stroke-width="0.3">Owner: ', Strings.toHexString(uint256(uint160(owner)), 20) ,'</text>',
                    '<text x="20" y="160" font-family="Arial" font-size="18" fill="black" stroke="white" stroke-width="0.3">Balance: ',uintToString(balance), ' WEI </text>',
                    '<circle cx="380" cy="30" r="25" fill="gold" stroke="black" stroke-width="1"/>',
                    '<text x="360" y="35" font-family="Arial" font-size="12" fill="black">Aladdin</text></svg>'
                ))),
                '"}'
            )
        );
    }

    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + value % 10));
            value /= 10;
        }
        return string(buffer);
    }
}