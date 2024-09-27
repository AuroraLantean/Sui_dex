-include .env

.PHONY: all clean build remove prove test 
#all targets in your Makefile which do not produce an output file with the same name as the target name should be PHONY.

all: clean remove install update build

clean :; rm -r build
format :; movefmt
build :; sui move build
build2 :; sui move build --named-addresses publisher=default
test :; sui move test
test2 :; sui move test --named-addresses publisher=default

publish :; sui move publish --named-addresses publisher=default

addItem :; sui move run --function-id "0x_publisher_address::advanced_list::add_item"

getListCounter :; sui move view --function-id "0x_publisher_address::advanced_list::get_list_counter" --args address:0x_publisher_address


prove :; sui move prove --named-addresses publisher=default

#remove :; rm -rf .gitmodules

#ethereum_sepolia :; ${ETHEREUM_SEPOLIA_RPC}

env :; source .env