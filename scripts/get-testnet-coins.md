# 🪙 比特币测试网获取测试币指南

## 方法一：使用测试网水龙头

### 1. Blockstream 测试网水龙头
访问：https://blockstream.info/testnet/faucet/
- 输入你的测试地址：tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw
- 点击获取测试币
- 等待几分钟到账

### 2. Coinfaucet 测试网水龙头
访问：https://coinfaucet.eu/en/btc-testnet/
- 输入你的测试地址
- 验证码验证
- 获取测试币

### 3. 使用命令行获取（推荐）

#### 使用 curl 请求测试币：
```bash
# 方法1：使用 Blockstream API
curl -X POST https://blockstream.info/testnet/api/faucet \
  -H "Content-Type: application/json" \
  -d '{"address": "tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw"}'

# 方法2：使用 Coinfaucet API
curl -X POST https://coinfaucet.eu/api/btc-testnet \
  -H "Content-Type: application/json" \
  -d '{"address": "tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw"}'
```

## 方法二：使用测试网挖矿

### 1. 启动本地挖矿
```bash
# 生成新区块
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 1 tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw

# 生成多个区块
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw
```

### 2. 查看余额
```bash
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
```

## 方法三：从其他测试网地址转账

如果你有其他测试网地址有余额，可以直接转账：
```bash
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet sendtoaddress tb1qhxhy4g2ugar2gpl76d36s25qjsf25rjs65dhfw 0.1
```

## 验证测试币到账

```bash
# 查看钱包余额
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance

# 查看交易历史
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions

# 查看UTXO
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listunspent
```

## 注意事项

1. **测试网同步**：确保节点完全同步后再获取测试币
2. **地址格式**：测试网地址以 `tb1` 开头
3. **确认数**：测试网通常需要1-6个确认
4. **水龙头限制**：每个水龙头都有频率限制，不要频繁请求
5. **网络连接**：确保节点连接到测试网网络

## 常用命令

```bash
# 查看节点状态
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo

# 查看连接节点
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo

# 查看内存池
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getmempoolinfo
```
