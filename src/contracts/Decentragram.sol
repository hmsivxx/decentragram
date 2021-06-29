pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create images

  function uploadImage(string memory _imgHash, string memory _description) public {
    require(bytes(_imgHash).length > 0, "Image hash shouldn't be blank");
    require(bytes(_description).length > 0, "Description shouldn't be empty");
    // require(msg.sender != address(0), "Invalid sender");

    // increment image id
    imageCount++;

    // Add image to contract
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
  }

  // Tip images
  function tipImageOwner(uint _id) public payable {
    require(_id > 0 && _id <= imageCount, "Invalid image id");
    
    // fetch image
    Image memory _image = images[_id];
    // fetch address
    address payable _author = _image.author;
    // pay the author
    address(_author).transfer(msg.value);
    // increment tipAmout
    _image.tipAmount = _image.tipAmount + msg.value;
    // update image
    images[_id] = _image;

    emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _image.author);
  }

}