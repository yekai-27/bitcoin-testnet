#!/bin/bash
# 测试交易脚本

ADDRESS="tb1qd4tr0y0kx4v3vt4evwdljv5wv5553p07564kf0"

echo "🧪 测试交易功能..."

# 检查余额
echo "💰 当前余额:"
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance

# 生成新地址
echo "📝 生成新地址:"
NEW_ADDRESS=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress)
echo "新地址: $NEW_ADDRESS"

# 查看UTXO
echo "🔍 查看UTXO:"
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listunspent | jq '.'

echo "✅ 测试完成！"
