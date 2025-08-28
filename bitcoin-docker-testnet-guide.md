# 🪙 比特币Docker双模式节点搭建指南

## 📋 环境要求

- **操作系统**: Linux (Ubuntu 20.04+)
- **Docker**: 已安装并运行
- **Docker Compose**: 已安装
- **磁盘空间**: 至少10GB可用空间
- **网络**: 稳定的互联网连接（仅testnet需要）

## 🚀 搭建步骤

### **1️⃣ 创建项目目录**

```bash
# 创建项目目录
mkdir -p ~/bitcoin-testnet/{data,data-regtest,config,logs,scripts}
cd ~/bitcoin-testnet
```

### **2️⃣ 创建Testnet Docker Compose配置**

```bash
cat > docker-compose.yml << 'EOF'
services:
  bitcoin-testnet:
    image: kylemanna/bitcoind:latest
    container_name: bitcoin-testnet
    restart: unless-stopped
    ports:
      - "18332:18332"  # RPC端口
      - "18333:18333"  # P2P端口
      - "28332:28332"  # ZMQ rawblock
      - "28333:28333"  # ZMQ rawtx
      - "28334:28334"  # ZMQ hashblock
    volumes:
      - ./data:/bitcoin/.bitcoin
      - ./logs:/bitcoin/logs
    environment:
      - BITCOIN_NETWORK=testnet
      - BITCOIN_RPC_USER=testuser
      - BITCOIN_RPC_PASSWORD=testpass123
      - BITCOIN_RPC_ALLOW_IP=0.0.0.0/0
    command: >
      bitcoind
      -testnet
      -printtoconsole
      -logtimestamps
      -txindex=1
      -server=1
      -rpcuser=testuser
      -rpcpassword=testpass123
      -rpcallowip=0.0.0.0/0
      -rpcbind=0.0.0.0
      -zmqpubrawblock=tcp://0.0.0.0:28332
      -zmqpubrawtx=tcp://0.0.0.0:28333
      -zmqpubhashblock=tcp://0.0.0.0:28334
    networks:
      - bitcoin-net

  bitcoin-cli:
    image: kylemanna/bitcoind:latest
    container_name: bitcoin-cli
    depends_on:
      - bitcoin-testnet
    volumes:
      - ./data:/bitcoin/.bitcoin
    environment:
      - BITCOIN_NETWORK=testnet
    command: >
      bitcoin-cli
      -testnet
      -rpcuser=testuser
      -rpcpassword=testpass123
      -rpcconnect=bitcoin-testnet
    networks:
      - bitcoin-net

networks:
  bitcoin-net:
    driver: bridge
EOF
```

### **3️⃣ 创建Regtest Docker Compose配置**

```bash
cat > docker-compose-regtest.yml << 'EOF'
services:
  bitcoin-regtest:
    image: kylemanna/bitcoind:latest
    container_name: bitcoin-regtest
    restart: unless-stopped
    ports:
      - "18443:18443"  # RPC端口
      - "18444:18444"  # P2P端口
      - "28432:28432"  # ZMQ rawblock (避免与testnet冲突)
      - "28433:28433"  # ZMQ rawtx
      - "28434:28434"  # ZMQ hashblock
    volumes:
      - ./data-regtest:/bitcoin/.bitcoin
      - ./logs:/bitcoin/logs
    environment:
      - BITCOIN_NETWORK=regtest
      - BITCOIN_RPC_USER=testuser
      - BITCOIN_RPC_PASSWORD=testpass123
      - BITCOIN_RPC_ALLOW_IP=0.0.0.0/0
    command: >
      bitcoind
      -regtest
      -printtoconsole
      -logtimestamps
      -txindex=1
      -server=1
      -rpcuser=testuser
      -rpcpassword=testpass123
      -rpcallowip=0.0.0.0/0
      -rpcbind=0.0.0.0
      -rpcport=18443
      -port=18444
      -zmqpubrawblock=tcp://0.0.0.0:28432
      -zmqpubrawtx=tcp://0.0.0.0:28433
      -zmqpubhashblock=tcp://0.0.0.0:28434
    networks:
      - bitcoin-net

  bitcoin-cli-regtest:
    image: kylemanna/bitcoind:latest
    container_name: bitcoin-cli-regtest
    depends_on:
      - bitcoin-regtest
    volumes:
      - ./data-regtest:/bitcoin/.bitcoin
    environment:
      - BITCOIN_NETWORK=regtest
    command: >
      bitcoin-cli
      -regtest
      -rpcuser=testuser
      -rpcpassword=testpass123
      -rpcconnect=bitcoin-regtest
      -rpcport=18443
    networks:
      - bitcoin-net

networks:
  bitcoin-net:
    driver: bridge
EOF
```

### **4️⃣ 创建统一管理脚本**

```bash
cat > scripts/manage-nodes.sh << 'EOF'
#!/bin/bash

# 比特币节点管理脚本 - 支持testnet和regtest

show_help() {
    echo "🚀 比特币节点管理脚本"
    echo "======================"
    echo ""
    echo "用法: $0 [命令] [网络]"
    echo ""
    echo "命令:"
    echo "  start     - 启动节点"
    echo "  stop      - 停止节点"
    echo "  restart   - 重启节点"
    echo "  status    - 查看状态"
    echo "  logs      - 查看日志"
    echo "  test      - 运行测试"
    echo "  mine      - 挖矿生成区块"
    echo "  wallet    - 钱包操作"
    echo ""
    echo "网络:"
    echo "  testnet   - 测试网 (需要同步)"
    echo "  regtest   - 本地网络 (无需同步)"
    echo ""
    echo "示例:"
    echo "  $0 start testnet    - 启动测试网节点"
    echo "  $0 start regtest    - 启动本地网络节点"
    echo "  $0 test regtest     - 测试本地网络"
    echo "  $0 mine regtest     - 在本地网络挖矿"
}

get_compose_file() {
    local network=$1
    if [[ $network == "regtest" ]]; then
        echo "docker-compose-regtest.yml"
    else
        echo "docker-compose.yml"
    fi
}

get_container_name() {
    local network=$1
    if [[ $network == "regtest" ]]; then
        echo "bitcoin-regtest"
    else
        echo "bitcoin-testnet"
    fi
}

get_rpc_port() {
    local network=$1
    if [[ $network == "regtest" ]]; then
        echo "18443"
    else
        echo "18332"
    fi
}

get_network_flag() {
    local network=$1
    if [[ $network == "regtest" ]]; then
        echo "-regtest"
    else
        echo "-testnet"
    fi
}

start_node() {
    local network=$1
    local compose_file=$(get_compose_file $network)
    
    echo "🚀 启动 $network 节点..."
    docker-compose -f $compose_file up -d
    
    # 等待节点启动
    sleep 5
    
    # 创建钱包
    local container_name=$(get_container_name $network)
    local network_flag=$(get_network_flag $network)
    
    echo "💰 创建钱包..."
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 createwallet "testwallet" 2>/dev/null || echo "钱包已存在"
    
    echo "✅ $network 节点启动完成！"
}

stop_node() {
    local network=$1
    local compose_file=$(get_compose_file $network)
    
    echo "🛑 停止 $network 节点..."
    docker-compose -f $compose_file down
    echo "✅ $network 节点已停止！"
}

restart_node() {
    local network=$1
    stop_node $network
    start_node $network
}

show_status() {
    local network=$1
    local compose_file=$(get_compose_file $network)
    local container_name=$(get_container_name $network)
    local network_flag=$(get_network_flag $network)
    
    echo "📊 $network 节点状态:"
    echo "=================="
    
    # 容器状态
    echo "📦 容器状态:"
    docker-compose -f $compose_file ps
    
    echo ""
    echo "🔗 网络信息:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo 2>/dev/null | jq '.' || echo "无法获取网络信息"
    
    echo ""
    echo "💰 钱包余额:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance 2>/dev/null || echo "无法获取余额"
}

show_logs() {
    local network=$1
    local compose_file=$(get_compose_file $network)
    
    echo "📝 显示 $network 节点日志:"
    docker-compose -f $compose_file logs -f
}

run_test() {
    local network=$1
    local container_name=$(get_container_name $network)
    local network_flag=$(get_network_flag $network)
    
    echo "🧪 测试 $network 节点..."
    echo "=================="
    
    # 测试1：节点连接
    echo "1️⃣ 测试节点连接..."
    if docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 getblockchaininfo > /dev/null 2>&1; then
        echo "✅ 节点连接正常"
    else
        echo "❌ 节点连接失败"
        return 1
    fi
    
    # 测试2：钱包功能
    echo "2️⃣ 测试钱包功能..."
    if docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance > /dev/null 2>&1; then
        echo "✅ 钱包功能正常"
    else
        echo "❌ 钱包功能异常"
    fi
    
    # 测试3：生成新地址
    echo "3️⃣ 测试地址生成..."
    NEW_ADDRESS=$(docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress 2>/dev/null)
    if [[ $NEW_ADDRESS == *1* ]] || [[ $NEW_ADDRESS == tb1* ]]; then
        echo "✅ 地址生成正常: $NEW_ADDRESS"
    else
        echo "❌ 地址生成失败"
    fi
    
    # 测试4：网络连接（regtest不需要外部连接）
    if [[ $network == "testnet" ]]; then
        echo "4️⃣ 测试网络连接..."
        PEER_COUNT=$(docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 getpeerinfo 2>/dev/null | jq length 2>/dev/null || echo "0")
        if [[ $PEER_COUNT -gt 0 ]]; then
            echo "✅ 网络连接正常，连接节点数: $PEER_COUNT"
        else
            echo "⚠️  网络连接异常，节点数: $PEER_COUNT"
        fi
    else
        echo "4️⃣ 本地网络模式，无需外部连接"
    fi
    
    echo ""
    echo "🎉 $network 节点测试完成！"
}

mine_blocks() {
    local network=$1
    local container_name=$(get_container_name $network)
    local network_flag=$(get_network_flag $network)
    
    if [[ $network != "regtest" ]]; then
        echo "❌ 挖矿功能仅在 regtest 模式下可用"
        return 1
    fi
    
    echo "⛏️  在 $network 网络挖矿..."
    
    # 生成新地址用于接收挖矿奖励
    local address=$(docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress 2>/dev/null)
    echo "📝 挖矿地址: $address"
    
    # 挖矿
    echo "⛏️  开始挖矿..."
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 $address
    
    echo "✅ 挖矿完成！"
    echo "💰 当前余额:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
}

wallet_operations() {
    local network=$1
    local container_name=$(get_container_name $network)
    local network_flag=$(get_network_flag $network)
    
    echo "💰 $network 钱包操作"
    echo "=================="
    
    echo "📝 生成新地址:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getnewaddress
    
    echo ""
    echo "💰 当前余额:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet getbalance
    
    echo ""
    echo "📋 交易历史:"
    docker exec $container_name bitcoin-cli $network_flag -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet listtransactions | jq '.' 2>/dev/null || echo "无交易历史"
}

# 主逻辑
if [[ $# -lt 2 ]]; then
    show_help
    exit 1
fi

command=$1
network=$2

case $command in
    "start")
        start_node $network
        ;;
    "stop")
        stop_node $network
        ;;
    "restart")
        restart_node $network
        ;;
    "status")
        show_status $network
        ;;
    "logs")
        show_logs $network
        ;;
    "test")
        run_test $network
        ;;
    "mine")
        mine_blocks $network
        ;;
    "wallet")
        wallet_operations $network
        ;;
    *)
        echo "❌ 未知命令: $command"
        show_help
        exit 1
        ;;
esac
EOF

chmod +x scripts/manage-nodes.sh
```

### **5️⃣ 创建快速启动脚本**

```bash
cat > start-regtest.sh << 'EOF'
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
EOF

chmod +x start-regtest.sh
```

### **6️⃣ 安装jq工具**

```bash
# 安装JSON处理工具
sudo apt install -y jq
```

### **7️⃣ 启动节点**

#### **启动Regtest节点（推荐）**
```bash
./start-regtest.sh
```

#### **启动Testnet节点**
```bash
./scripts/manage-nodes.sh start testnet
```

### **8️⃣ 运行测试**

```bash
# 测试Regtest节点
./scripts/manage-nodes.sh test regtest

# 测试Testnet节点
./scripts/manage-nodes.sh test testnet
```

## 📊 配置信息

### **连接参数**

| 网络        | RPC URL                  | RPC用户    | RPC密码       | 网络类型 | 钱包         |
| ----------- | ------------------------ | ---------- | ------------- | -------- | ------------ |
| **Regtest** | `http://localhost:18443` | `testuser` | `testpass123` | regtest  | `testwallet` |
| **Testnet** | `http://localhost:18332` | `testuser` | `testpass123` | testnet  | `testwallet` |

### **端口映射**

| 网络        | RPC端口 | P2P端口 | ZMQ端口     |
| ----------- | ------- | ------- | ----------- |
| **Regtest** | 18443   | 18444   | 28432-28434 |
| **Testnet** | 18332   | 18333   | 28332-28334 |

## 💰 获取测试币

### **Regtest 模式**
```bash
# 自动挖矿生成测试币
./scripts/manage-nodes.sh mine regtest

# 手动挖矿到指定地址
docker exec bitcoin-regtest bitcoin-cli -regtest -rpcuser=testuser -rpcpassword=testpass123 -rpcwallet=testwallet generatetoaddress 101 <你的地址>
```

### **Testnet 模式**
1. 访问 https://coinfaucet.eu/en/btc-testnet/
2. 输入你的测试地址
3. 完成验证码验证
4. 等待几分钟到账

## 🔧 常用命令

### **节点管理**
```bash
# 启动节点
./scripts/manage-nodes.sh start testnet
./scripts/manage-nodes.sh start regtest

# 停止节点
./scripts/manage-nodes.sh stop testnet
./scripts/manage-nodes.sh stop regtest

# 查看状态
./scripts/manage-nodes.sh status testnet
./scripts/manage-nodes.sh status regtest

# 查看日志
./scripts/manage-nodes.sh logs testnet
./scripts/manage-nodes.sh logs regtest
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

## ⚠️ 注意事项

1. **端口冲突**: Regtest和Testnet使用不同的端口，可以同时运行
2. **数据隔离**: 两个网络的数据完全独立存储
3. **网络选择**: 根据测试需求选择合适的网络模式
4. **资源使用**: 同时运行两个节点会消耗更多系统资源

## 🔗 有用的链接

- **Testnet浏览器**: https://blockstream.info/testnet/
- **Testnet水龙头**: https://coinfaucet.eu/en/btc-testnet/
- **Bitcoin Core文档**: https://bitcoin.org/en/developer-reference
- **RPC API文档**: https://developer.bitcoin.org/reference/rpc/

## 🎯 成功验证

搭建完成后，你应该能够：

1. ✅ 成功启动Regtest节点（无需同步）
2. ✅ 成功启动Testnet节点（需要同步）
3. ✅ 在Regtest中挖矿生成测试币
4. ✅ 在Testnet中从水龙头获取测试币
5. ✅ 使用统一脚本管理两个节点
6. ✅ 进行完整的开发和测试工作

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

这个双模式配置已经过实际验证，可以稳定运行比特币节点，为你的开发工作提供完整的测试环境。
