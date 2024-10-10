module packagename::dex {
    //use std::debug::print;
    //use std::string::{utf8, String};
    //use std::error;
    //use std::timestamp;
  use std::type_name::{get, TypeName};
  use sui::sui::SUI;
  use sui::clock::{Clock};
  use sui::balance::{Self, Supply};
  //use sui::object::{Self, UID};
  use sui::table::{Self, Table};
  use sui::dynamic_field as df;
  //use sui::tx_context::{Self, TxContext};
  use sui::coin::{Self, TreasuryCap, Coin};
  use deepbook::clob_v2::{Self as clob, Pool};
  use deepbook::custodian_v2::AccountCap;
  use packagename::eth::ETH;
  use packagename::usdc::USDC;
	
	 // Constants
  const CLIENT_ID: u64 = 122227;//the initial client ID used for placing orders in the DeepBook protocol. Each order placed by the contract will have a unique client ID. 
  const MAX_U64: u64 = 18446744073709551615;//the maximum value of an unsigned 64-bit integer. It is used as a placeholder for an "infinite" timestamp when placing limit orders with no expiration.
  const NO_RESTRICTION: u8 = 0;//represents no restrictions when placing limit orders. It is used as a placeholder for order parameters that don't have any specific restrictions.
  const FLOAT_SCALING: u64 = 1_000_000_000;//1e9 This constant represents the scaling factor for float operations. It is used to convert between decimal values and integer representations in the contract.
  const EAlreadyMintedThisEpoch: u64 = 0;//error code used in the mint_coin function. It is used to indicate that the user has already minted a coin in the current epoch.
	
	//One-time witness to create the DEX coin
  public struct DEX has drop {}

	//stores data related to a specific coin type... to store user addresses and their last epoch of minting.
	public struct Data<phantom CoinType> has store {
    cap: TreasuryCap<CoinType>,
    faucet_lock: Table<address, u64>,
	}

	public struct Storage has key {
    id: UID,
    dex_supply: Supply<DEX>,//the supply of the DEX token, and its type is Supply<DEX>.
    swaps: Table<address, u64>,//a table with address keys and u64 values. to keep track of the number of swaps performed by each address.
    account_cap: AccountCap,//related to the account capabilities within the context of the contract.
    client_id: u64,//used for tracking client IDs within the contract.
	}

  fun init(witness: DEX, ctx: &mut TxContext) {
    let (treasury_cap, metadata) = coin::create_currency<DEX>(
      witness,
      9,
      b"DEX",
      b"DEX Coin",
      b"Coin of SUI DEX",
      option::none(),
      ctx
    );//users will get this DEX token on every 2 successful swap

    transfer::public_freeze_object(metadata);

    transfer::share_object(Storage {
      id: object::new(ctx),
      dex_supply: coin::treasury_into_supply(treasury_cap),
      swaps: table::new(ctx),
      account_cap: clob::create_account(ctx),
      client_id: CLIENT_ID,
    });
  }



}
