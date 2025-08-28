#!/bin/bash

echo "🧪 比特币RPC API测试"
echo "=================="

# 测试基本连接
echo "1️⃣ 测试区块链信息..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockchaininfo", "params": []}' | jq '.'

echo ""
echo "2️⃣ 测试钱包余额..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getbalance", "params": []}' | jq '.'

echo ""
echo "3️⃣ 生成新地址..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getnewaddress", "params": []}' | jq '.'

echo ""
echo "4️⃣ 获取网络信息..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getnetworkinfo", "params": []}' | jq '.'

echo ""
echo "5️⃣ 获取内存池信息..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getmempoolinfo", "params": []}' | jq '.'

echo ""
echo "6️⃣ 获取挖矿信息..."
curl -s -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getmininginfo", "params": []}' | jq '.'

echo ""
echo "✅ API测试完成！"
