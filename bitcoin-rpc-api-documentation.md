# 🪙 比特币RPC API接口文档

## 📋 概述

本文档列出了通过Docker搭建的本地比特币节点提供的所有RPC接口，包括请求格式、参数说明和响应示例。

## 🔗 连接信息

### **Regtest 网络**
- **RPC URL**: `http://localhost:18443`
- **RPC用户**: `testuser`
- **RPC密码**: `testpass123`
- **网络**: regtest

### **Testnet 网络**
- **RPC URL**: `http://localhost:18332`
- **RPC用户**: `testuser`
- **RPC密码**: `testpass123`
- **网络**: testnet

## 📡 请求格式

### **HTTP POST 请求**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "方法名",
    "params": [参数1, 参数2, ...]
  }'
```

### **命令行调用**
```bash
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 方法名 参数1 参数2
```

## 🔧 核心接口分类

## 1️⃣ 区块链接口 (Blockchain)

### **getblockchaininfo**
获取区块链信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getblockchaininfo",
    "params": []
  }'
```

**响应:**
```json
{
  "result": {
    "chain": "regtest",
    "blocks": 101,
    "headers": 101,
    "bestblockhash": "0000000000000000000000000000000000000000000000000000000000000000",
    "difficulty": 4.656542373906925e-10,
    "verificationprogress": 1,
    "initialblockdownload": false,
    "size_on_disk": 123456,
    "pruned": false,
    "warnings": ""
  }
}
```

### **getblockcount**
获取当前区块数量

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getblockcount",
    "params": []
  }'
```

**响应:**
```json
{
  "result": 101
}
```

### **getblockhash**
根据区块高度获取区块哈希

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getblockhash",
    "params": [100]
  }'
```

### **getblock**
获取区块信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getblock",
    "params": ["blockhash", 2]
  }'
```

## 2️⃣ 钱包接口 (Wallet)

### **getbalance**
获取钱包余额

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getbalance",
    "params": ["*", 0]
  }'
```

**响应:**
```json
{
  "result": 50.00000000
}
```

### **getnewaddress**
生成新地址

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getnewaddress",
    "params": ["", "bech32m"]
  }'
```

**响应:**
```json
{
  "result": "bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc"
}
```

### **sendtoaddress**
发送比特币到指定地址

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "sendtoaddress",
    "params": ["bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc", 0.1]
  }'
```

**响应:**
```json
{
  "result": "txid_hash_here"
}
```

### **listtransactions**
列出交易历史

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "listtransactions",
    "params": ["*", 10, 0, true]
  }'
```

### **listunspent**
列出未花费的交易输出(UTXO)

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "listunspent",
    "params": [0, 9999999, []]
  }'
```

## 3️⃣ 网络接口 (Network)

### **getnetworkinfo**
获取网络信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getnetworkinfo",
    "params": []
  }'
```

### **getpeerinfo**
获取连接节点信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getpeerinfo",
    "params": []
  }'
```

### **getconnectioncount**
获取连接数量

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getconnectioncount",
    "params": []
  }'
```

## 4️⃣ 内存池接口 (Mempool)

### **getmempoolinfo**
获取内存池信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getmempoolinfo",
    "params": []
  }'
```

**响应:**
```json
{
  "result": {
    "loaded": true,
    "size": 0,
    "bytes": 0,
    "usage": 0,
    "maxmempool": 300000000,
    "mempoolminfee": 0.00001000,
    "minrelaytxfee": 0.00001000,
    "unbroadcastcount": 0
  }
}
```

### **getrawmempool**
获取内存池中的原始交易

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getrawmempool",
    "params": [false]
  }'
```

## 5️⃣ 挖矿接口 (Mining)

### **getmininginfo**
获取挖矿信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getmininginfo",
    "params": []
  }'
```

### **generatetoaddress**
生成区块到指定地址

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "generatetoaddress",
    "params": [1, "bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc"]
  }'
```

## 6️⃣ 原始交易接口 (Raw Transactions)

### **createrawtransaction**
创建原始交易

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "createrawtransaction",
    "params": [
      [{"txid": "previous_txid", "vout": 0}],
      {"bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc": 0.1}
    ]
  }'
```

### **signrawtransactionwithwallet**
使用钱包签名原始交易

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "signrawtransactionwithwallet",
    "params": ["hex_string"]
  }'
```

### **sendrawtransaction**
发送原始交易

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "sendrawtransaction",
    "params": ["signed_hex_string"]
  }'
```

### **decoderawtransaction**
解码原始交易

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "decoderawtransaction",
    "params": ["hex_string"]
  }'
```

## 7️⃣ 地址接口 (Address)

### **validateaddress**
验证地址

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "validateaddress",
    "params": ["bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc"]
  }'
```

**响应:**
```json
{
  "result": {
    "isvalid": true,
    "address": "bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc",
    "scriptPubKey": "0014...",
    "isscript": false,
    "iswitness": true,
    "witness_version": 0,
    "witness_program": "..."
  }
}
```

### **getaddressinfo**
获取地址详细信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getaddressinfo",
    "params": ["bcrt1qa370sv084nj3rssk0y9e0zawqx87nurwlsxmtc"]
  }'
```

## 8️⃣ 工具接口 (Util)

### **estimatesmartfee**
估算智能手续费

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "estimatesmartfee",
    "params": [6, "CONSERVATIVE"]
  }'
```

### **createmultisig**
创建多重签名地址

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "createmultisig",
    "params": [2, ["pubkey1", "pubkey2"], "bech32"]
  }'
```

## 9️⃣ 控制接口 (Control)

### **getrpcinfo**
获取RPC信息

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "getrpcinfo",
    "params": []
  }'
```

### **stop**
停止节点

**请求:**
```bash
curl -X POST http://localhost:18443/ \
  -H "Content-Type: application/json" \
  -u "testuser:testpass123" \
  -d '{
    "jsonrpc": "1.0",
    "id": "curltest",
    "method": "stop",
    "params": []
  }'
```

## 🔧 测试脚本

### **创建测试脚本**
```bash
cat > test-api.sh << 'EOF'
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
echo "✅ API测试完成！"
