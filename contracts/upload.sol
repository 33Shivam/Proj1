// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Upload {
  
  struct Access{   //structure starts
     address user;  //address of user
     bool access; //true or false
  }
  mapping(address=>string[]) value; //single mapping storing adresses to strings array
  mapping(address=>mapping(address=>bool)) ownership; //nested mapping storing boolean value for ownership
  mapping(address=>Access[]) accessList; //accesslist stores all address that are eleigible to file just like a current entry book
  mapping(address=>mapping(address=>bool)) previousData; //just like a register it stores all the previous data

  function add(address _user,string memory url) external {
      value[_user].push(url);  //this function takes in IPFS URL and address of image 
  }
  function allow(address user) external {//this function allows other user to access the file  
      ownership[msg.sender][user]=true; //changes the state of other user which has selected to allowed
      if(previousData[msg.sender][user]){ //this loop iterates and finds if user exists in prevData has true value
         for(uint i=0;i<accessList[msg.sender].length;i++){ //iteration for loop
             if(accessList[msg.sender][i].user==user){  //checks if user in slot one of array is equal to current user address
                  accessList[msg.sender][i].access=true;  //updates access to true
             }
         }
      }else{
          accessList[msg.sender].push(Access(user,true));  
          previousData[msg.sender][user]=true;  
      }
    
  }
  function disallow(address user) public{
      ownership[msg.sender][user]=false;
      for(uint i=0;i<accessList[msg.sender].length;i++){ //this loop iterates over the access list and changes the access to false
          if(accessList[msg.sender][i].user==user){ //checks
              accessList[msg.sender][i].access=false;  
          }
      }
  }

  function display(address _user) external view returns(string[] memory){ //this function takes in user value and shows all the images
      require(_user==msg.sender || ownership[_user][msg.sender],"You don't have access"); 
      return value[_user];
  }

  function shareAccess() public view returns(Access[] memory){ //this function returns list of all people with the access
      return accessList[msg.sender];
  }
}