# Bitcoin Docker API 命令参考

## 📋 目录
- [基础连接](#基础连接)
- [钱包操作](#钱包操作)
- [地址管理](#地址管理)
- [交易操作](#交易操作)
- [区块操作](#区块操作)
- [网络信息](#网络信息)
- [挖矿操作](#挖矿操作)
- [节点管理](#节点管理)

---

## 🔗 基础连接

### 容器名称和网络参数
```bash
# Regtest 网络
CONTAINER="bitcoin-regtest"
NETWORK_FLAG="-regtest"
RPC_PORT="18443"

# Testnet 网络
CONTAINER="bitcoin-testnet"
NETWORK_FLAG="-testnet"
RPC_PORT="18332"
```

### 基础RPC调用格式
```bash
# 通用格式
docker exec $CONTAINER bitcoin-cli $NETWORK_FLAG -rpcuser=testuser -rpcpassword=testpass123 [命令]

# 带钱包的格式
docker exec $CONTAINER bitcoin-cli $NETWORK_FLAG -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet [命令]
```

---

## 💰 钱包操作

### 钱包管理
```bash
# 创建钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 createwallet "testwallet"

# 加载钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 loadwallet "testwallet"

# 卸载钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 unloadwallet "testwallet"

# 列出所有钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 listwallets

# 获取钱包信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getwalletinfo
```

### 余额查询
```bash
# 获取总余额
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance

# 获取确认余额
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance "*" 1

# 获取未确认余额
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getunconfirmedbalance
```

---

## 📍 地址管理

### 地址生成
```bash
# 生成新地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress

# 生成带标签的地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress "收款地址"

# 生成P2SH地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress "" "p2sh-segwit"

# 生成Bech32地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress "" "bech32"
```

### 地址管理
```bash
# 列出所有地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listreceivedbyaddress

# 获取地址信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getaddressinfo [地址]

# 验证地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 validateaddress [地址]

# 获取地址余额
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getreceivedbyaddress [地址]
```

---

## 💸 交易操作

### 发送交易
```bash
# 发送到地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet sendtoaddress [地址] [金额]

# 发送到地址（指定手续费）
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet sendtoaddress [地址] [金额] "备注" "备注到" false 0.0001

# 发送到多个地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet sendmany "" '{"[地址1]": [金额1], "[地址2]": [金额2]}'

# 发送原始交易
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet sendrawtransaction [十六进制交易]
```

### 交易查询
```bash
# 列出交易
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions

# 列出交易（带参数）
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions "*" 10 0 true

# 获取交易详情
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet gettransaction [交易ID]

# 获取原始交易
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getrawtransaction [交易ID]

# 解码原始交易
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 decoderawtransaction [十六进制交易]
```

### 交易池操作
```bash
# 获取内存池信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getmempoolinfo

# 列出内存池交易
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getrawmempool

# 获取内存池交易详情
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getmempoolentry [交易ID]
```

---

## 🧱 区块操作

### 区块信息
```bash
# 获取区块链信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo

# 获取区块头信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockheader [区块哈希]

# 获取区块信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblock [区块哈希]

# 获取区块统计
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockstats [区块哈希]

# 获取最佳区块哈希
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getbestblockhash
```

### 区块高度
```bash
# 获取当前区块高度
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockcount

# 根据高度获取区块哈希
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockhash [高度]

# 获取区块头数量
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockheader [区块哈希] | jq '.height'
```

---

## 🌐 网络信息

### 节点信息
```bash
# 获取网络信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getnetworkinfo

# 获取连接信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getconnectioncount

# 获取对等节点信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo

# 添加节点
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 addnode [IP:端口] "add"

# 断开节点
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 disconnectnode [IP:端口]
```

### 网络统计
```bash
# 获取网络统计
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getnettotals

# 获取网络流量
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getnetworkinfo | jq '.bytesrecv, .bytesrecv'
```

---

## ⛏️ 挖矿操作

### 挖矿命令（仅限Regtest）
```bash
# 生成区块到地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress [区块数] [地址]

# 生成区块（示例：生成101个区块）
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 $(docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress)

# 生成区块到钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generate [区块数]

# 设置挖矿难度
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 setgenerate true 1
```

### 挖矿状态
```bash
# 获取挖矿信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getmininginfo

# 获取区块模板
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblocktemplate

# 获取难度
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getdifficulty
```

---

## 🔧 节点管理

### 节点状态
```bash
# 获取节点信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getinfo

# 获取内存使用
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getmemoryinfo

# 获取运行时信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getruntimeinfo

# 获取日志信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 logging
```

### 节点控制
```bash
# 停止节点
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 stop

# 重新扫描钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet rescanblockchain

# 备份钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet backupwallet "/bitcoin/backup.dat"

# 导入钱包
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet importwallet "/bitcoin/backup.dat"
```

---

## 📊 实用脚本示例

### 快速检查脚本
```bash
#!/bin/bash
# 快速检查节点状态
echo "=== 节点状态检查 ==="
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo | jq '.blocks, .headers, .verificationprogress'
echo "=== 钱包余额 ==="
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
echo "=== 连接数 ==="
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getconnectioncount
```

### 批量操作脚本
```bash
#!/bin/bash
# 批量生成地址
for i in {1..5}; do
    ADDRESS=$(docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress "地址$i")
    echo "地址$i: $ADDRESS"
done
```

### 监控脚本
```bash
#!/bin/bash
# 监控新交易
while true; do
    NEW_TXS=$(docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getrawmempool | jq length)
    echo "$(date): 内存池中有 $NEW_TXS 个交易"
    sleep 10
done
```

---

## ⚠️ 注意事项

1. **网络参数**: 确保使用正确的网络参数（`-regtest` 或 `-testnet`）
2. **钱包加载**: 使用钱包相关命令前确保钱包已加载
3. **权限**: 确保RPC用户和密码正确
4. **容器状态**: 确保Bitcoin容器正在运行
5. **数据持久化**: 重要数据请及时备份

---

## 🔗 相关链接

- [Bitcoin Core RPC API 文档](https://developer.bitcoin.org/reference/rpc/)
- [Docker 命令参考](https://docs.docker.com/engine/reference/commandline/)
- [JSON-RPC 规范](https://www.jsonrpc.org/specification)
