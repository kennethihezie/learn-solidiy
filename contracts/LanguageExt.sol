pragma solidity ^0.8.12;

contract LanguageExt{
    //dynamic array
    uint[] public myArray;
    //fixed array
    uint[2] public fixedArr = [1, 2];

    constructor () public {
        myArray.push(1);
        myArray.push(2);
        myArray.push(3);
        myArray.push(4);
    }

    function getAllElement() public view returns(uint[], uint[2]) {
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
