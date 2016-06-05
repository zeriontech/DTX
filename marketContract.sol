contract Market {

    address public owner;
    
    struct Order {
        address owner;
        uint32 id;
        uint price;
        uint amount;
        uint32 timestamp;
        uint32 nextOrder;
    }

    mapping(uint32 => Order) bids; 
    mapping(uint32 => Order) asks; 

    uint32 highestBidId;
    uint32 lowestAskId; 

    uint32 public numberOfTrades;


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
            // bid, fill matchin asks and place order
            while (lowestAskId != 0 && amountLeft > 0 && asks[lowestAskId].price <= price) { 
                if (asks[lowestAskId].amount <= amountLeft) {
                    amountToExchange = asks[lowestAskId].amount;
                    amountLeft -= amountToExchange;
                    etherToExchange = amountToExchange * asks[lowestAskId].price;
                    lowestAskId = asks[lowestAskId].nextOrder; 
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
            
        } else {  // ask
            while (highestBidId != 0 && amountLeft > 0 && bids[highestBidId].price >= price) { 
                if (bids[highestBidId].amount <= amountLeft) {
                    amountLeft -= bids[highestBidId].amount;
                    amountToExchange = bids[highestBidId].amount;
                    etherToExchange = amountToExchange * bids[highestBidId].price;
                    highestBidId = bids[highestBidId].nextOrder; 
                } else { 
                    bids[highestBidId].amount -= amountLeft;
                    amountToExchange = amountLeft;
                    etherToExchange = amountToExchange * asks[highestBidId].price;
                    amountLeft = 0;

                }
                // TODO: 
            }

        }
    }

    // needs to be superoptimised 
    function placeOrder() internal {

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