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
