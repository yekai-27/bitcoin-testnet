#!/bin/bash

# 比特币开发环境配置脚本

echo "🔧 配置比特币开发环境..."
echo "=========================="

# 1. 检查节点状态
echo "📊 检查节点状态..."
SYNC_INFO=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo 2>/dev/null | jq -r '.initialblockdownload // "unknown"')

if [[ $SYNC_INFO == "true" ]]; then
    echo "⏳ 节点正在同步中，请等待同步完成..."
    echo "💡 同步可能需要几个小时，建议在后台运行"
    echo "📝 使用 'docker-compose logs -f bitcoin-testnet' 查看同步进度"
else
    echo "✅ 节点同步完成，可以开始开发测试"
fi

# 2. 生成测试地址
echo ""
echo "💰 生成测试地址..."
TEST_ADDRESS=$(docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress 2>/dev/null)
echo "📝 测试地址: $TEST_ADDRESS"

# 3. 显示RPC配置
echo ""
echo "🔌 RPC配置信息:"
echo "   RPC URL: http://localhost:18332"
echo "   RPC User: testuser"
echo "   RPC Password: testpass123"
echo "   Network: testnet"

# 4. 显示ZMQ配置
echo ""
echo "📡 ZMQ配置信息:"
echo "   Raw Block: tcp://localhost:28332"
echo "   Raw Transaction: tcp://localhost:28333"
echo "   Hash Block: tcp://localhost:28334"

# 5. 创建测试脚本
echo ""
echo "📝 创建测试脚本..."

cat > test-transaction.sh << 'TEST_EOF'
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
TEST_EOF

chmod +x test-transaction.sh

# 6. 创建API测试脚本
cat > test-api.sh << 'API_EOF'
#!/bin/bash
# API测试脚本

echo "🌐 测试RPC API..."

# 测试基本RPC调用
echo "📊 区块链信息:"
curl -s --user testuser:testpass123 --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq '.'

echo ""
echo "💰 钱包余额:"
curl -s --user testuser:testpass123 --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getbalance", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq '.'

echo ""
echo "📝 生成新地址:"
curl -s --user testuser:testpass123 --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getnewaddress", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq '.'

echo "✅ API测试完成！"
API_EOF

chmod +x test-api.sh

echo ""
echo "🎉 开发环境配置完成！"
echo ""
echo "📋 可用命令:"
echo "  ./test-transaction.sh  - 测试交易功能"
echo "  ./test-api.sh         - 测试RPC API"
echo "  ./scripts/debug.sh    - 调试节点状态"
echo "  ./scripts/quick-test.sh - 快速测试"
echo ""
echo "💡 获取测试币的方法:"
echo "  1. 等待节点同步完成后使用挖矿: generatetoaddress"
echo "  2. 使用在线水龙头: https://coinfaucet.eu/en/btc-testnet/"
echo "  3. 从其他测试网地址转账"
echo ""
echo "🔗 有用的链接:"
echo "  - 测试网浏览器: https://blockstream.info/testnet/"
echo "  - 测试网水龙头: https://coinfaucet.eu/en/btc-testnet/"
echo "  - Bitcoin Core文档: https://bitcoin.org/en/developer-reference"
