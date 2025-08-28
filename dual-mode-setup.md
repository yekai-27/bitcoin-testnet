# 🪙 比特币双模式节点搭建指南

## 📋 概述

本指南提供了同时支持 **testnet**（测试网）和 **regtest**（本地网络）的比特币节点配置，满足不同的开发和测试需求。

## 🚀 快速开始

### **启动 Regtest 节点（推荐用于开发）**
```bash
./start-regtest.sh
```

### **启动 Testnet 节点**
```bash
./scripts/manage-nodes.sh start testnet
```

## 📊 网络模式对比

| 特性 | Testnet | Regtest |
|------|---------|---------|
| **网络类型** | 公共测试网 | 本地独立网络 |
| **同步需求** | ✅ 需要同步 | ❌ 无需同步 |
| **启动时间** | 慢（几小时） | 快（几秒） |
| **挖矿功能** | ❌ 不可用 | ✅ 可用 |
| **测试币获取** | 水龙头/转账 | 挖矿生成 |
| **网络连接** | 需要互联网 | 完全本地 |
| **适用场景** | 集成测试 | 单元测试 |

## 🔧 配置信息

### **Regtest 模式**
- **RPC URL**: `http://localhost:18443`
- **RPC用户**: `testuser`
- **RPC密码**: `testpass123`
- **网络**: regtest
- **钱包**: `testwallet`
- **初始余额**: 50 BTC（通过挖矿获得）

### **Testnet 模式**
- **RPC URL**: `http://localhost:18332`
- **RPC用户**: `testuser`
- **RPC密码**: `testpass123`
- **网络**: testnet
- **钱包**: `testwallet`
- **初始余额**: 0 BTC（需要从水龙头获取）

## 🛠️ 管理命令

### **统一管理脚本**
```bash
# 查看帮助
./scripts/manage-nodes.sh

# 启动节点
./scripts/manage-nodes.sh start testnet
./scripts/manage-nodes.sh start regtest

# 停止节点
./scripts/manage-nodes.sh stop testnet
./scripts/manage-nodes.sh stop regtest

# 查看状态
./scripts/manage-nodes.sh status testnet
./scripts/manage-nodes.sh status regtest

# 运行测试
./scripts/manage-nodes.sh test testnet
./scripts/manage-nodes.sh test regtest

# 钱包操作
./scripts/manage-nodes.sh wallet testnet
./scripts/manage-nodes.sh wallet regtest

# 挖矿（仅regtest）
./scripts/manage-nodes.sh mine regtest
```

### **快速启动脚本**
```bash
# 启动regtest节点（推荐）
./start-regtest.sh
```

## 💰 获取测试币

### **Regtest 模式**
```bash
# 自动挖矿生成测试币
./scripts/manage-nodes.sh mine regtest

# 手动挖矿到指定地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 <地址>
```

### **Testnet 模式**
1. 访问 https://coinfaucet.eu/en/btc-testnet/
2. 输入你的测试地址
3. 完成验证码验证
4. 等待几分钟到账

## 🧪 测试功能

### **Regtest 测试**
```bash
# 运行完整测试
./scripts/manage-nodes.sh test regtest

# 查看钱包信息
./scripts/manage-nodes.sh wallet regtest

# 生成新地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress
```

### **Testnet 测试**
```bash
# 运行完整测试
./scripts/manage-nodes.sh test testnet

# 查看钱包信息
./scripts/manage-nodes.sh wallet testnet

# 生成新地址
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress
```

## 📁 目录结构

```
bitcoin-testnet/
├── docker-compose.yml              # Testnet配置
├── docker-compose-regtest.yml      # Regtest配置
├── start-regtest.sh               # Regtest快速启动
├── data/                          # Testnet数据
├── data-regtest/                  # Regtest数据
├── scripts/
│   ├── manage-nodes.sh            # 统一管理脚本
│   ├── quick-test.sh              # 快速测试
│   ├── debug.sh                   # 调试脚本
│   └── dev-environment.sh         # 开发环境配置
├── test-api.sh                    # API测试
├── test-transaction.sh            # 交易测试
└── README.md                      # 详细文档
```

## 🎯 使用建议

### **开发阶段（推荐使用 Regtest）**
- ✅ 快速启动，无需等待同步
- ✅ 可以随时挖矿生成测试币
- ✅ 完全本地化，不依赖网络
- ✅ 适合单元测试和功能测试

### **集成测试（推荐使用 Testnet）**
- ✅ 真实的网络环境
- ✅ 与其他测试网节点交互
- ✅ 模拟真实的使用场景
- ✅ 适合集成测试和端到端测试

## 🔗 有用的链接

- **Testnet浏览器**: https://blockstream.info/testnet/
- **Testnet水龙头**: https://coinfaucet.eu/en/btc-testnet/
- **Bitcoin Core文档**: https://bitcoin.org/en/developer-reference
- **RPC API文档**: https://developer.bitcoin.org/reference/rpc/

## ⚠️ 注意事项

1. **端口冲突**: Regtest和Testnet使用不同的端口，可以同时运行
2. **数据隔离**: 两个网络的数据完全独立存储
3. **网络选择**: 根据测试需求选择合适的网络模式
4. **资源使用**: 同时运行两个节点会消耗更多系统资源

## 🎉 成功验证

搭建完成后，你应该能够：

1. ✅ 成功启动Regtest节点（无需同步）
2. ✅ 成功启动Testnet节点（需要同步）
3. ✅ 在Regtest中挖矿生成测试币
4. ✅ 在Testnet中从水龙头获取测试币
5. ✅ 使用统一脚本管理两个节点
6. ✅ 进行完整的开发和测试工作

这个双模式配置为你提供了完整的比特币开发和测试环境！
