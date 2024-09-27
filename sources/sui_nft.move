module sui_nft::sui_nft {
    use std::debug::print;
    use std::string::{utf8, String};
    //use std::error;
    //use std::timestamp;

    public struct NFT has key, store{
        id: UID,
        name: String,
        description: String,
    }

    //fun init(ctx: &mut TxContext) {    }
		
    public entry fun mint (name: String, description: String, ctx: &mut TxContext) {

        let nft = NFT {
            id: object::new(ctx),
            name: name,
            description: description,
        };
        let sender: address = tx_context::sender(ctx);
        transfer::public_transfer(nft, sender);
    }

    public entry fun transfer_nft(nft: NFT, recipient: address) {
        transfer::public_transfer(nft, recipient);
    }
}
