contract Market {

    address public owner;
    
    struct Order
    {
        uint price;
        uint amount;
        uint timestamp;
        uint owner;
        uint nextOrder;
    }

    Order[] bids;
    Order[] asks; 

    uint highestBid;
    uint lowestAsk; 

    uint32 public numberOfTrades;


    function Market() {
        owner = msg.sender;
        numberOfTrades = 0;
        highestBid = -1;
        lowestAsk = -1;
    }

    // main function 
    // params: 
    // type 0 - bid, 1 - ask
    // 
    function trade(bool type, uint amount, uint price) {

        if (amount < 0.1) throw;

        if (type == 0) {
            // bid, fill matchin asks and place order

            amountLeft = amount; 

            while (lowestAsk != -1 && amountLeft > 0 && asks[lowestAsk].price < price) { 
                uint amountToExchange = 0;
                uint etherToExchange = 0;
                if (asks[lowestAsk].amount <= amountLeft) {
                    amountLeft -= asks[lowestAsk].amount;
                    amountToExchange = asks[lowestAsk].amount;
                    etherToExchange = amountToExchange * asks[lowestAsk].price;
                    lowestAsk = asks[lowestAsk].nextOrder; 
                } else { 
                    asks[lowestAsk].amount -= amountLeft;
                    amountToExchange = amountLeft;
                    amountLeft = 0;

                }
                etherToExchange = amountToExchange * price
                // TODO: send some ether to owner
                // TODO: send amountToExchange tokens to msg.sender
                // TODO: send event to light clients

                
                
            }
            if 
            
        } else {
            // ask, fill matching bids and place order 

        }
    }

    // needs to be superiptimised 
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
