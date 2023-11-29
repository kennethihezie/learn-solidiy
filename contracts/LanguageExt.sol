//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

// public - all can access

// external - Cannot be accessed internally, only externally

// internal - only this contract and contracts deriving from it can access

// private - can be accessed only from this contract

// As for best practices, you should use external if you expect
// that the function will only ever be called externally, and use
// public if you need to call the function internally. Reason because
// public function consume more gas than external functions

contract LanguageExt{
    //dynamic array
    uint[] public myArray;
    //fixed array
    uint[2] public fixedArr = [1, 2];

    constructor(){
        myArray.push(1);
        myArray.push(2);
        myArray.push(3);
        myArray.push(4);
    }

    function getAllElement() public view returns(uint[] memory, uint[2] memory) {
        return (myArray, fixedArr);
    }

    function getArrayLength() public view returns(uint, uint) {
        return (myArray.length, fixedArr.length);
    }

    function getFirstElement() public view returns(uint) {
        return myArray[0];
    }
}

//Solidity data types

//string
//bool
//int alias for init256 holds value from really negative to really big
//int8 holds value from -128 to 127
//int16 holds value from -32,768 to 32,767
//int32 holds value from -2,147,483,648 to 2,147,483,647
//uint alias for uinit256 holds value from 0 to really big
//uint8 holds value from 0 to 255
//uint16 holds value from 0 to 65,535
//uint32 holds value from 0 to 4,296,967,295
//fixed holds decimal holds both negative or positive decimal numbers
//ufixed holds decimal only positive decimal numbers.
//address for storing address and has method tied to it for sending money
//fixed array = array that contains a single type of element. Has an unchanging length eg int[3] -> [1, 2, 3]
//dynamic array = array that contains a single type of element. Can change in size over time eg int[] -> [1,2,3,4,5]
//mapping = Collection of key value pairs. All keys must be of the same type and so with values. eg mapping(string => string) or mapping(int => bool)
//struct = collection of key value pairs that can have different types
// struct Car{
//     string make;
//     string model;
//     uint value;
// }
// Car car = Car({make: "Make", model: "Model", value: 25});
//Enums
// enum States {
//     PENDING,
//     LOADING,
//     SUCCESS,
//     FAILURE
// }
// States state = States.LOADING;

//Understanding Memory and storage
contract Numbers{
    //all top levels variables are storage variables
    int[] public numbers;

    constructor(){
        numbers.push(20);
        numbers.push(32);

        changeArray(numbers);
    }

    //this method is not view cus we are  modifying myArray in the contract...we are using storage keyword
    function storageFunc() public {
        //when using the storage keyword here it makes the myArray variable
        //point directly to storage location the numbers variables is pointing at
        int[] storage myArray = numbers;
        //the below line will change the value of numbers[0] which is 20 to 1 cause myArray
        //is pointing to the same location.
        myArray[0] = 1;
    }

    //this method is view cus we are not modifying anything in the contract...we are using memory keyword
    function memoryFunc() public view {
        //when using memory keyword solidity create a seprate location
        //and copy the data to it. myArray now points to seprate location created by solidity
        int[] memory myArray = numbers;
        //the below line won't change the value of numbers[0] which is 20 to 1 cause myArray
        //is pointing to a different location.
        myArray[0] = 1;
        //remeber memory gets dumps once the function exits
    }

    //this method is view cus we are not modifying anything in the contract...we are using memory keyword
    //why we care about storage and memory
    function changeArray(int[] memory array) private pure {
       array[0] = 1;
    }
}

contract LearnEvents {
    /*
    Events allow contracts to perform logging on the Ethereum blockchain. 
    Logs for a given contract can be parsed later to perform updates on the 
    frontend interface, for example. They are commonly used to allow frontend 
    interfaces to listen for specific events and update the user interface, 
    or used as a cheap form of storage.
    */

    event TestCalled(address sender, string message);

    function test() public {
        emit TestCalled(msg.sender, "Someone called test()");
    }
}

/*
Inheritance
Inheritance is the procedure by which one contract can inherit the attributes and methods of another contract. Solidity supports multiple inheritance. Contracts can inherit other contract by using the is keyword.

Note: We actually also did Inheritance in the Freshman Track Cryptocurrency and NFT tutorials - where we inherited from the ERC20 and ERC721 contracts respectively.

A parent contract which has a function that can be overridden by a child contract must be declared as a virtual function.

A child contract that is going to override a parent function must use the override keyword.

The order of inheritance matters if parent contracts share methods or attributes by the same name.
*/

contract A {
    function foo() public pure virtual returns (string memory) {
        return "A";
    }
}

contract B is A {
    // Override A.foo();
    // But also allow this function to be overridden by further children
    // So we specify both keywords - virtual and override
    function foo() public pure virtual override returns (string memory) {
        return "B";
    }
}

contract C is A {
    // Similar to contract B above
    function foo() public pure virtual override returns (string memory) {
        return "C";
    }
}

// When inheriting from multiple contracts,
// if a function is defined multiple times, the right-most 
// parent contract's function is used.
contract D is B, C {
    // D.foo() returns "C"
    // since C is the right-most parent with function foo();
    // override (B,C) means we want to override a method that exists in two parents
    function foo() public pure override (B, C) returns (string memory) {
        // super is a special keyword that is used to call functions
        // in the parent contract
        return super.foo();
    }
}

contract E is C, B {
    // E.foo() returns "B"
    // since B is the right-most parent with function foo();
    function foo() public pure override (C, B) returns (string memory) {
        return super.foo();
    }
}

/*
Currently, the recommended way to transfer ETH from a 
contract is to use the call function. The call function 
returns a bool indicating success or failure of the transfer.
 */

contract SendEther {
    function sendEth(address payable _to) public payable {
        // Just forward the ETH received in this payable function
        // to the given address
        uint amountToSend = msg.value;
        // call returns a bool value specifying success or failure
        (bool success, bytes memory data) = _to.call{value: msg.value}("");
        require(success == true, "Failed to send ETH");
    }
}

/*
However, if you are writing a contract that you want to be able 
to receive ETH transfers directly, you must have at least one 
of the functions below

receive() external payable
fallback() external payable
receive() is called if msg.data is an empty value, and fallback() is used otherwise.
*/

contract ReceiveEther {
     /*
    Which function is called, fallback() or receive()?

           send Ether
               |
         msg.data is empty?
              / \
            yes  no
            /     \
receive() exists?  fallback()
         /   \
        yes   no
        /      \
    receive()   fallback()
    */

    // Function to receive Ether. msg.data must be empty
    receive() external payable {}

    // Fallback function is called when msg.data is not empty
    fallback() external payable {}

    // get contract balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}


//Interfaces
//  Interfaces in Solidity behave like header files, 
// and serve similar purposes to the ABI we have been
// using when calling contracts from the frontend.

interface MinimalERC20 {
    // Just include the functions we are interested in
    // in the interface
    function balanceOf(address account) external view returns (uint256);
}

contract MyInterfaceContract {
    MinimalERC20 _minimalErc20;

    constructor() {
      // Initialize a MinimalERC20 contract instance
      _minimalErc20 = MinimalERC20(msg.sender);
    }

    function mustHaveSomeBalance() public view {
        // Require that the caller of this transaction has a non-zero
        // balance of tokens in the external ERC20 contract
        uint balance = _minimalErc20.balanceOf(msg.sender);
        require(balance > 0, "You don't own any tokens of external contract");
    }
}

// Solidity Libraries
/*
Libraries are similar to contracts in Solidity, 
with a few limitations. Libraries cannot contain 
any state variables, and cannot transfer ETH.

Typically, libraries are used to add helper functions 
to your contracts. An extremely commonly used library 
in Solidity world is SafeMath - which ensures that 
mathematical operations do not cause an integer underflow or overflow.
*/

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z = x + y;
        // If z overflowed, throw an error
        require(z >= x, "uint overflow");
        return z;
    }
}

contract TestSafeMath {
    function testAdd(uint x, uint y) public pure returns(uint) {
        return SafeMath.add(x, y);
    }
}

// Provider
/*
A Provider is an Ethereum node connection that allows you 
to read data from its state. You will use a Provider to 
do things like calling read-only functions in smart contracts, 
fetching balances of accounts, fetching transaction details, etc.
*/

// Signer
/*
A Signer is an Ethereum node connection that allows you 
to write data to the blockchain. You will use a Signer 
to do things like calling write functions in smart contracts,
transferring ETH between accounts, etc. To do so, 
the Signer needs access to a Private Key it can use 
for making transactions on behalf of an account.
*/
// Additionally, a Signer can do everything a Provider can.
// You can do both, reading and writing, using a Signer,
// but a Provider is only good for reading data.