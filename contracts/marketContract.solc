/*
This file is part of the DTX(Digital Token Exchange).

DTX is free software: you can redistribute it and/or modify
it under the terms of the GNU lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

DTX is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU lesser General Public License for more details.

You should have received a copy of the GNU lesser General Public License
along with the DTX.  If not, see <http://www.gnu.org/licenses/>.
*/

contract Market {

    // Only for testing 
    address public owner;
    
    struct Order {
        address owner;
        uint32 id;
        uint price;
        uint amount;
        uint32 nextOrder;
    }

    mapping(uint32 => Order) public bids; 
    mapping(uint32 => Order) public asks; 

    uint32 public highestBidId;
    uint32 public lowestAskId; 

    uint32 public numberOfTrades;
    uint32 public asksCounter;
    uint32 public bidsCounter;

    function Market() {
        owner = msg.sender;
        numberOfTrades = 0;
        highestBidId = 0;
        lowestAskId = 0;
    }

    // main function 
    function trade(bool ask, uint amount, uint price) {

        if (amount < 1) throw;
        
        var amountLeft = amount; 

        uint amountToExchange = 0;
        uint etherToExchange = 0;
        
        if (ask == false) {
            // bid, fill matching asks and place order
            while (lowestAskId != 0 && amountLeft > 0 && asks[lowestAskId].price <= price) { 
                if (asks[lowestAskId].amount <= amountLeft) {
                    amountToExchange = asks[lowestAskId].amount;
                    amountLeft -= amountToExchange;
                    etherToExchange = amountToExchange * asks[lowestAskId].price;
                    uint32 newLowestAskId = asks[lowestAskId].nextOrder; 
                    delete asks[lowestAskId];
                    lowestAskId = newLowestAskId;
                } else { 
                    asks[lowestAskId].amount -= amountLeft;
                    amountToExchange = amountLeft;
                    etherToExchange = amountToExchange * asks[lowestAskId].price;
                    amountLeft = 0;
                }
                // TODO: send some ether to owner
                // TODO: send amountToExchange tokens to msg.sender
                // TODO: send event to light clients
            }
            if (amountLeft > 0) placeOrder(ask, amountLeft, price, msg.sender);
        } else {  // ask
            while (highestBidId != 0 && amountLeft > 0 && bids[highestBidId].price >= price) { 
                if (bids[highestBidId].amount <= amountLeft) {
                    amountLeft -= bids[highestBidId].amount;
                    amountToExchange = bids[highestBidId].amount;
                    etherToExchange = amountToExchange * bids[highestBidId].price;
                    uint32 newHighestBidId = bids[highestBidId].nextOrder; 
                    delete bids[highestBidId];
                    highestBidId = newHighestBidId;
                } else { 
                    bids[highestBidId].amount -= amountLeft;
                    amountToExchange = amountLeft;
                    etherToExchange = amountToExchange * asks[highestBidId].price;
                    amountLeft = 0;
                }
                // TODO: send some ether to owner
                // TODO: send amountToExchange tokens to msg.sender
                // TODO: send event to light clients
            }
            if (amountLeft > 0) placeOrder(ask, amountLeft, price, msg.sender);
        }
    }

    // needs to be superoptimised 
    function placeOrder(bool ask, uint amount, uint price, address owner) internal {
        if (ask == false) {
            // place bid order
            uint32 previousBidId = 0;
            uint32 bidId = highestBidId;
            while (bidId != 0 && bids[bidId].price >= price) {
                previousBidId = bidId;
                bidId = bids[bidId].nextOrder;
            }
            bidsCounter += 1;
            bids[bidsCounter] = Order({
                owner: owner,
                id: bidsCounter,
                price: price,
                amount: amount,
                nextOrder: bidId
            });
            if (previousBidId != 0) {
                bids[previousBidId].nextOrder = bidsCounter;
            }
            if (highestBidId == 0 || bids[highestBidId].price < price) {
                highestBidId = bidsCounter;
            }
        } else {
            uint32 previousAskId = 0;
            uint32 askId = lowestAskId;
            while (askId != 0 && asks[askId].price <= price) {
                previousAskId = askId;
                askId = asks[askId].nextOrder;
            }
            asksCounter += 1;
            asks[asksCounter] = Order({
                owner: owner,
                id: asksCounter,
                price: price,
                amount: amount,
                nextOrder: askId
            });
            if (previousAskId != 0) {
                asks[previousAskId].nextOrder = asksCounter;
            }
            if (lowestAskId == 0 || asks[lowestAskId].price > price) {
                lowestAskId = asksCounter;
            }
        }
    }

    function kill() {
        // For testing purposes only
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }


    function () {
        // This function gets executed if a
        // transaction with invalid data is sent to
        // the contract or just ether without data.
        // We revert the send so that no-one
        // accidentally loses money when using the
        // contract.
        throw;
    }

}