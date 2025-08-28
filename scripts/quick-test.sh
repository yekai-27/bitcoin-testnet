#!/bin/bash

# 快速测试脚本 - 验证节点功能

echo "🚀 比特币测试节点快速测试"
echo "=========================="

# 测试1：节点连接
echo "1️⃣ 测试节点连接..."
if docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo > /dev/null 2>&1; then
    echo "✅ 节点连接正常"
else
    echo "❌ 节点连接失败"
    exit 1
fi

# 测试2：钱包功能
echo "2️⃣ 测试钱包功能..."
if docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance > /dev/null 2>&1; then
    echo "✅ 钱包功能正常"
else
    echo "❌ 钱包功能异常"
fi

# 测试3：生成新地址
echo "3️⃣ 测试地址生成..."
NEW_ADDRESS=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress 2>/dev/null)
if [[ $NEW_ADDRESS == tb1* ]]; then
    echo "✅ 地址生成正常: $NEW_ADDRESS"
else
    echo "❌ 地址生成失败"
fi

# 测试4：网络连接
echo "4️⃣ 测试网络连接..."
PEER_COUNT=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo 2>/dev/null | jq length)
if [[ $PEER_COUNT -gt 0 ]]; then
    echo "✅ 网络连接正常，连接节点数: $PEER_COUNT"
else
    echo "⚠️  网络连接异常，节点数: $PEER_COUNT"
fi

# 测试5：同步状态
echo "5️⃣ 测试同步状态..."
SYNC_INFO=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo 2>/dev/null | jq -r '.initialblockdownload')
if [[ $SYNC_INFO == "true" ]]; then
    echo "⏳ 节点正在同步中..."
else
    echo "✅ 节点同步完成"
fi

echo ""
echo "🎉 快速测试完成！"
echo "📝 测试地址: $NEW_ADDRESS"
echo "💡 使用 './scripts/get-testnet-coins.md' 获取测试币"
