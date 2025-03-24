include .env

.PHONY: test-sepolia deploy-sepolia deploy-mainnet

test-sepolia:
	forge test --rpc-url $(SEPOLIA_RPC_URL) --via-ir

deploy-sepolia:
	forge script script/LoteryDeploy.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --via-ir --broadcast

deploy-mainnet:
	forge script script/LoteryDeploy.s.sol --rpc-url $(MAINNET_RPC_URL) --private-key $(PRIVATE_KEY) --via-ir --broadcast