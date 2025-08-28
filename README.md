# 🪙 比特币双模式测试节点开发环境

这是一个完整的比特币节点环境，支持 **testnet**（测试网）和 **regtest**（本地网络）两种模式，用于开发和测试比特币相关应用。只要是linux环境，并且安装docker，能够联网，就可以一键运行比特币测试网络，方便开发测试。

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

## 🔧 环境信息

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

## 🔧 常用命令

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

### **节点管理**
```bash
# 启动节点
docker-compose up -d                    # testnet
docker-compose -f docker-compose-regtest.yml up -d  # regtest

# 停止节点
docker-compose down                     # testnet
docker-compose -f docker-compose-regtest.yml down   # regtest

# 查看日志
docker-compose logs -f bitcoin-testnet  # testnet
docker-compose -f docker-compose-regtest.yml logs -f bitcoin-regtest  # regtest

# 重启节点
docker-compose restart bitcoin-testnet  # testnet
docker-compose -f docker-compose-regtest.yml restart bitcoin-regtest  # regtest
```

### **钱包操作**
```bash
# Regtest 钱包操作
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listunspent

# Testnet 钱包操作
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listunspent
```

### **网络信息**
```bash
# Regtest 网络信息
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getmempoolinfo

# Testnet 网络信息
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getmempoolinfo
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

### **快速测试**
```bash
# Regtest 快速测试
./scripts/manage-nodes.sh test regtest

# Testnet 快速测试
./scripts/manage-nodes.sh test testnet
```

### **调试信息**
```bash
# Regtest 调试
./scripts/manage-nodes.sh status regtest

# Testnet 调试
./scripts/manage-nodes.sh status testnet
```

### **API测试**
```bash
# Regtest API测试
curl -s --user testuser:testpass123 --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18443/ | jq '.'

# Testnet API测试
curl -s --user testuser:testpass123 --data-binary '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockchaininfo", "params": []}' -H 'content-type: text/plain;' http://127.0.0.1:18332/ | jq '.'
```

## 📁 目录结构

```
bitcoin-testnet/
├── docker-compose.yml              # Testnet配置
├── docker-compose-regtest.yml      # Regtest配置
├── start-regtest.sh               # Regtest快速启动
├── data/                          # Testnet数据
├── data-regtest/                  # Regtest数据
├── config/                        # 配置文件目录
├── logs/                          # 日志目录
├── scripts/                       # 脚本目录
│   ├── manage-nodes.sh            # 统一管理脚本
│   ├── quick-test.sh              # 快速测试脚本
│   ├── debug.sh                   # 调试脚本
│   ├── dev-environment.sh         # 开发环境配置脚本
│   ├── bitcoin-cli.sh             # CLI工具脚本
│   └── get-testnet-coins.md       # 测试币获取指南
├── test-api.sh                    # API测试脚本
├── test-transaction.sh            # 交易测试脚本
├── dual-mode-setup.md             # 双模式设置指南
├── bitcoin-docker-testnet-guide.md # 详细搭建指南
└── README.md                      # 说明文档
```

## ⚠️ 注意事项

1. **端口配置**: Regtest和Testnet使用不同的端口，可以同时运行
   - Testnet: 18332 (RPC), 18333 (P2P)
   - Regtest: 18443 (RPC), 18444 (P2P)

2. **数据隔离**: 两个网络的数据完全独立存储
   - Testnet数据: `./data/`
   - Regtest数据: `./data-regtest/`

3. **网络选择**: 根据测试需求选择合适的网络模式
   - 开发阶段: 推荐使用Regtest（快速、无需同步）
   - 集成测试: 推荐使用Testnet（真实网络环境）

4. **资源使用**: 同时运行两个节点会消耗更多系统资源

## 🔗 有用的链接

- **Testnet浏览器**: https://blockstream.info/testnet/
- **Testnet水龙头**: https://coinfaucet.eu/en/btc-testnet/
- **Bitcoin Core文档**: https://bitcoin.org/en/developer-reference
- **RPC API文档**: https://developer.bitcoin.org/reference/rpc/

## 🐛 故障排除

### **节点无法启动**
```bash
# 检查容器状态
docker-compose ps
docker-compose -f docker-compose-regtest.yml ps

# 查看错误日志
docker-compose logs bitcoin-testnet
docker-compose -f docker-compose-regtest.yml logs bitcoin-regtest

# 重新创建容器
docker-compose down && docker-compose up -d
docker-compose -f docker-compose-regtest.yml down && docker-compose -f docker-compose-regtest.yml up -d
```

### **端口冲突**
```bash
# 检查端口占用
netstat -tlnp | grep 18332
netstat -tlnp | grep 18443

# 停止冲突的服务
sudo lsof -ti:18332 | xargs kill -9
sudo lsof -ti:18443 | xargs kill -9
```

### **RPC连接失败**
```bash
# 检查RPC配置
docker exec bitcoin-testnet bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo
```

## 📝 开发建议

1. **使用Regtest进行开发**: 快速启动，无需等待同步
2. **使用Testnet进行测试**: 真实的网络环境
3. **备份钱包**: 定期备份钱包文件
4. **监控日志**: 关注节点日志以发现潜在问题
5. **版本控制**: 使用版本控制管理配置和脚本
6. **文档记录**: 记录重要的配置和操作步骤

## 🎯 成功验证

搭建完成后，你应该能够：

1. ✅ 成功启动Regtest节点（无需同步）
2. ✅ 成功启动Testnet节点（需要同步）
3. ✅ 在Regtest中挖矿生成测试币
4. ✅ 在Testnet中从水龙头获取测试币
5. ✅ 使用统一脚本管理两个节点
6. ✅ 进行完整的开发和测试工作

## 🤝 贡献

欢迎提交Issue和Pull Request来改进这个开发环境！

## 📄 许可证

MIT License
