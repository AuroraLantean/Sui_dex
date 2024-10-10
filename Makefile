-include .env

.PHONY: all clean build remove prove test 
#all targets in your Makefile which do not produce an output file with the same name as the target name should be PHONY.

all: clean remove install update build

clean :; rm -r build
format :; movefmt
build :; sui move build
test :; sui move test
test1 :; sui move test eth
test2 :; sui move test usdc
test2 :; sui move test dex

new_addr :; sui client new-address ed25519
activate_addr :; sui client active-address
switch :; sui client switch --address YOUR_ADDRESS
balance :; sui client balance
faucet :; sui client faucet
activate_testnet :; sui client switch --env testnet
activate_devnet :; sui client switch --env devnet

publish :; sui client publish --gas-budget 500000000
suiscan :; echo "https://suivision.xyz/"

mint :; sui client call --package 0xa85c6cc78f5723759ecb5568f625a9cd2315fedec651017af1508496994e0f29 --module sui_nft --function mint --args "Gold Coin1" "My first NFT on SUI Blockchain" --gas-budget 500000000

Nft_object1 :; echo "https://testnet.suivision.xyz/object/0x6b30ea36c885f9ddbece6529dd5a953c6bc248729269b46f457709c6d11d775d"

transfer :; sui client call --package 0xa85c6cc78f5723759ecb5568f625a9cd2315fedec651017af1508496994e0f29 --module sui_nft --function transfer --args 0x6b30ea36c885f9ddbece6529dd5a953c6bc248729269b46f457709c6d11d775d 0x015251dbd9732e36fe47fb8e58b4ac1e2ba9c3cce2679d26f5573f334a410756 --gas-budget 500000000

env :; source .env