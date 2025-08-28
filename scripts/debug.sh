#!/bin/bash

# 比特币测试节点调试脚本

echo "🔍 比特币测试节点调试工具"
echo "=========================="

# 检查容器状态
echo "📦 检查容器状态..."
docker-compose ps

echo ""
echo "📊 节点信息..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo | jq '.'

echo ""
echo "🌐 网络连接..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo | jq '.[0:3]'

echo ""
echo "💰 钱包余额..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance

echo ""
echo "📝 最近交易..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions | jq '.[0:5]'

echo ""
echo "🔧 内存池状态..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getmempoolinfo | jq '.'

echo ""
echo "📈 网络信息..."
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getnetworkinfo | jq '.'

echo ""
echo "✅ 调试完成！"
