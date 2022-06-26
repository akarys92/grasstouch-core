// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.1; 
import "hardhat/console.sol";

contract Game {
    struct Board {
        int[] state;  
        address owner; 
    }

    struct State  {
        uint8 firstBoxState; 
        uint8 secondBoxState;
        uint8 thirdBoxState;
        uint8 fourthBoxState;
        uint8 layoutState; 
    }

    State public currentState;
    Board[] public won_games; 
    uint32 public totalStored; 
    address public owner; 

    constructor() {
        // Generate a genesis state
        generateState(msg.sender);
        totalStored = 0; 
        owner = msg.sender; 
    }

    function generateState(address add) private {
         // generateInitialState(msg.sender); 
        bytes20 _addy = bytes20(uint160(add));

        currentState = State( uint8(_addy[0]) % 4
            , uint8(_addy[1]) % 4
            , uint8(_addy[2]) % 4
            , uint8(_addy[3]) % 4
            , uint8(_addy[4]) % 4); 
    }   
    
    function getState() public view returns ( State memory ) {
        return currentState; 
    }

    function verifySolution( int[] memory board ) public {
        // 1) Check that board is valid 
        bool validBoard = checkValidBoard(board);
        require(validBoard, 'Board not valid.');
        // 2) Check that the initial condition is met
        // bool initCondition = checkInitial(board); 
        // require(initCondition, 'Not initial condition');
        
        /* 
        3) Translate solution to user color scheme 
            -> Replace each number in solution with mapping
        
        */ 
        //4) Store solution
        Board memory won = Board( board, msg.sender ); 

        // TODO: This may overflow or do something crazy at some point...
        address n = address(uint160(bytes20(msg.sender)) / uint160(totalStored + 1 )); 
        generateState(n);
        totalStored++; 
        won_games.push(won);
        // console.log(n);
    } 
    function checkValidBoard(int[] memory board) internal pure returns ( bool ) {

        // First check rows
        for(uint8 i = 0; i < 4; i+=4) {
            if(board[i]+ board[i+1] + board[i+2] + board[i+3] != 16) { return false; }
        }
        // Check columns
        for(uint8 i = 0; i < 4; i++) {
            if(board[i]+ board[i+4] + board[i+8] + board[i+12] != 16) { return false; }
        }
        // Check boxes 
        if(board[0]+ board[1] + board[4] + board[5] != 16) { return false; }
        if(board[2]+ board[3] + board[6] + board[7] != 16) { return false; }
        if(board[8]+ board[9] + board[12] + board[13] != 16) { return false; }
        if(board[10]+ board[11] + board[14] + board[15] != 16) { return false; }
        return true; 
    }

    function checkInitial(int[] memory board) internal view returns ( bool ) {
        // Get the quadrant of the 1
        uint8 firstIndex = quadrantLookup(currentState.layoutState, currentState.firstBoxState); 
        // console.log("First index: "); 
        // console.log(firstIndex);
        int firstValue = board[firstIndex]; 
        if(firstValue == 1) { return true; }
        // TODO: Check the rest...
        return false; 
    }

    function quadrantLookup(uint8 quadrant, uint8 position) internal pure returns ( uint8 ) {
        if(quadrant == 0 && position == 0) { return 0; }
        if(quadrant == 0 && position == 1) { return 1; }
        if(quadrant == 0 && position == 2) { return 4; }
        if(quadrant == 0 && position == 3) { return 5; }

        if(quadrant == 1 && position == 0) { return 2; }
        if(quadrant == 1 && position == 1) { return 3; }
        if(quadrant == 1 && position == 2) { return 6; }
        if(quadrant == 1 && position == 3) { return 7; }

        if(quadrant == 2 && position == 0) { return 8; }
        if(quadrant == 2 && position == 1) { return 9; }
        if(quadrant == 2 && position == 2) { return 12; }
        if(quadrant == 2 && position == 3) { return 13; }
    
        if(quadrant == 3 && position == 0) { return 10; }
        if(quadrant == 3 && position == 1) { return 11; }
        if(quadrant == 3 && position == 2) { return 14; }
        if(quadrant == 3 && position == 3) { return 15; }
        require(false, "Invalid position provided to quadrant lookup"); 
    }

    function translateUserColor() private {
        // 1) Break public key into 4 10 character components
        // 2) Have a deterministic function that generates a color for each
    }

    function getGames() public view returns ( uint32 wins ) {
        return totalStored; 
    }

    function getFinishedGames( ) public view returns ( Board[] memory boards ) {

        return won_games;
    }

    function update(uint8 firstBoxState, uint8 secondBoxState , uint8 thirdBoxState , uint8 fourthBoxState , uint8 layoutState) public  {
        require(owner == msg.sender); 
        currentState.firstBoxState = firstBoxState;
        currentState.secondBoxState = secondBoxState;
        currentState.thirdBoxState = thirdBoxState;
        currentState.fourthBoxState = fourthBoxState; 
        currentState.layoutState = layoutState; 
    }
}

