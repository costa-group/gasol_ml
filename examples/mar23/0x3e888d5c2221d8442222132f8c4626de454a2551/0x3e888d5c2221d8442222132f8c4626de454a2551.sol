// SPDX-License-Identifier: MIT

pragma solidity ^0.5.0;

contract Story {
  string[] public chapters;

  function writeChapter(string memory newChapter) public {
    chapters.push(newChapter);
  }
}