//SPDX-License-Identifier: UNLICENSED

pragma solidity >=0.5.0 < 0.9.0;
 contract EventOrganizer
 {
      struct Event{
          address organizer;
          string name;
          uint date;
          uint price;
          uint ticketCount;
          uint ticketRemaining;
      }
      mapping(uint=>Event) public events;
      mapping(address=>mapping(uint=>uint))public tickets;
      uint public nextId;

      function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
          require(date>block.timestamp,"You can organize event for future date");
          require(ticketCount>0,"You can organize events only if you sell more than 0 tickets");
          
          events[nextId]=Event(msg.sender,name,date,price,ticketCount,ticketCount);
          nextId++;
      }
    function buyTicket(uint id,uint quantity)external payable{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has alreaddy occured");
        Event storage _event=events[id];
        require(msg.value==(_event.price*quantity),"Not enough Ether");
        require(_event.ticketRemaining>=quantity,"NOt wnought tickets");
        _event.ticketRemaining-=quantity;
        tickets[msg.sender][id]+=quantity;
    }
    function transferTicket(uint id,uint quantity,address to)external{
        require(events[id].date!=0,"Event does not exist");
        require(events[id].date>block.timestamp,"Event has already occured");
        require(tickets[msg.sender][id]>=quantity,"You fucking don't have enough tickets to transfer brother");
        tickets[msg.sender][id]-=quantity;
        tickets[to][id]+=quantity;
    }
 }
 
