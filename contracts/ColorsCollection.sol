// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

// We first import some OpenZeppelin Contracts.
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// We inherit the contract we imported. This means we'll have access
// to the inherited contract's methods.
contract ColorsCollection is ERC721URIStorage {
  // By OpenZeppelin to help us keep track of tokenIds.
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  // This is our SVG code. All we need to change is the word that's displayed. Everything else stays the same.
  // So, we make a baseSvg variable here that all our NFTs can use.
  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: monospace; font-size: 9px; }</style><rect width='100%' height='100%' fill='";

  // I create three arrays, each with their own theme of random words.
  // Pick some random funny words, names of anime characters, foods you like, whatever! 
  string[] hexCode = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"];
  event NewColorMinted(address sender, uint256 tokenId);


  // We need to pass the name of our NFTs token and its symbol.
  constructor() ERC721 ("colors.", "CLRS") {
    console.log("This is my Test-NFT contract. Woah!");
  }

  // I create a function to randomly pick a word from each array.
  
  function pickRandomHexadecimalOne(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERONE", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }
  function pickRandomHexadecimalTwo(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERTWO", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }
  function pickRandomHexadecimalThree(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERTHREE", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }
  function pickRandomHexadecimalFour(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERFOUR", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }
  function pickRandomHexadecimalFive(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERFIVE", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }
  function pickRandomHexadecimalSix(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("HEX_CHARACTERSIX", Strings.toString(tokenId))));
    rand = rand % hexCode.length;
    return hexCode[rand];
  }

 function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  // A function our user will hit to get their NFT.
  function makeColor() public {
     // Get the current tokenId, this starts at 0.
    uint256 newItemId = _tokenIds.current();

     // We go and randomly grab one word from each of the three arrays.
    string memory first = pickRandomHexadecimalOne(newItemId);
    string memory second = pickRandomHexadecimalTwo(newItemId);
    string memory third = pickRandomHexadecimalThree(newItemId);
    string memory fourth = pickRandomHexadecimalFour(newItemId);
    string memory fifth = pickRandomHexadecimalFive(newItemId);
    string memory sixth = pickRandomHexadecimalSix(newItemId);
    string memory colorCode = string(abi.encodePacked("#", first, second, third, fourth, fifth, sixth));

    // I concatenate it all together, and then close the <text> and <svg> tags.
    string memory rectSvg = string(abi.encodePacked(baseSvg, colorCode, "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>"));
    string memory finalSvg = string(abi.encodePacked(rectSvg, colorCode, "</text></svg>"));

    // Get all the JSON metadata in place and base64 encode it.
    string memory json = Base64.encode(
        bytes(
            string(
                abi.encodePacked(
                    '{"name": "',
                    // We set the title of our NFT as the generated word.
                    colorCode,
                    '", "description": "A highly acclaimed collection of colors.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
        )
    );

    
      function getTotalNFTsMintedSoFar() public view returns(uint256) {
    return _tokenIds.current();
 }

 // Just like before, we prepend data:application/json;base64, to our data.
    string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
    );

    console.log("\n--------------------");
console.log(
    string(
        abi.encodePacked(
            "https://nftpreview.0xdev.codes/?code=",
            finalTokenUri
        )
    )
);
console.log("--------------------\n");
    _safeMint(msg.sender, newItemId);
    
    // Update your URI!!!
    _setTokenURI(newItemId, finalTokenUri);
  
    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewColorMinted(msg.sender, newItemId);
  }
}