// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract EventOrganization {
    struct Event {
        address organizer;
        string name;
        uint256 date;
        uint256 price;
        uint256 ticketCount;
        uint256 ticketRemain;
    }

    mapping(uint256 => Event) public events;
    mapping(address => mapping(uint256 => uint256)) public tickets;
    uint256 public nextId;

    function createEvent(
        string memory name,
        uint256 date,
        uint256 price,
        uint256 ticketCount
    ) external {
        require(
            date > block.timestamp,
            "You can organize event for future date only"
        );
        require(
            ticketCount > 0,
            "You can organize event only if you create ticket more thane 0"
        );
        events[nextId] = Event(
            msg.sender,
            name,
            date,
            price,
            ticketCount,
            ticketCount
        );
        nextId++;
    }

    function buyTicket(uint256 id, uint256 quantity) external payable {
        require(events[id].date > 0, "Invalid event");
        require(block.timestamp < events[id].date, "Event has already occured");
        require(quantity > 0, "Buy atleast 1 ticket");
        Event storage _event = events[id];
        require(msg.value >= (_event.price * quantity), "price too low");
        require(_event.ticketRemain >= quantity, "Not enough tickets");
        _event.ticketRemain -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(uint id, uint quantity, address transferAddress) external {
        require(events[id].date > 0, "Invalid event");
        require(block.timestamp < events[id].date, "Event has already occured");
        require(quantity > 0, "Atleast 1 ticket should be transferred");
        require(tickets[msg.sender][id] >= quantity, "You do not have enough tickets");
        tickets[msg.sender][id] -=quantity;
        tickets[transferAddress][id] +=quantity;

    }
}
