//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

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
//Enums


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
