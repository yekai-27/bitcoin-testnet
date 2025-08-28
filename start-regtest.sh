#!/bin/bash

echo "🚀 启动比特币 Regtest 本地网络"
echo "=============================="

# 启动regtest节点
echo "📦 启动regtest节点..."
docker-compose -f docker-compose-regtest.yml up -d

# 等待节点启动
echo "⏳ 等待节点启动..."
sleep 10

# 创建钱包
echo "💰 创建钱包..."
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 createwallet "testwallet" 2>/dev/null || echo "钱包已存在"

# 生成初始区块
echo "⛏️  生成初始区块..."
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 $(docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress 2>/dev/null)

echo ""
echo "✅ Regtest 节点启动完成！"
echo ""
echo "📊 连接信息:"
echo "   RPC URL: http://localhost:18443"
echo "   RPC User: testuser"
echo "   RPC Password: testpass123"
echo "   Network: regtest"
echo ""
echo "🔧 可用命令:"
echo "   ./scripts/manage-nodes.sh status regtest  - 查看状态"
echo "   ./scripts/manage-nodes.sh test regtest    - 运行测试"
echo "   ./scripts/manage-nodes.sh mine regtest    - 挖矿"
echo "   ./scripts/manage-nodes.sh wallet regtest  - 钱包操作"
