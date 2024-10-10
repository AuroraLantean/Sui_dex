module packagename::usdc {
	use sui::coin; 
	use sui::url;
	
	public struct USDC has drop {}

  fun init(witness: USDC, ctx: &mut TxContext) {
		let (treasury_cap, metadata) = coin::create_currency<USDC>(
			witness,
			6,
			b"USDC",
			b"USDC Coin",
			b"Ethereum Native Coin",
			option::some(url::new_unsafe_from_bytes(b"https://s2.coinmarketcap.com/static/img/coins/64x64/1027.png")),
			ctx
		);

		transfer::public_transfer(treasury_cap, tx_context::sender(ctx));

		//Turn the given object into a mutable shared object that everyone can access and mutate. This is irreversible
		transfer::public_share_object(metadata);
		//transfer::public_freeze_object(metadata);
	}

	#[test_only]
	public fun usdc(ctx: &mut TxContext) {
		init(USDC {}, ctx);
	}
}