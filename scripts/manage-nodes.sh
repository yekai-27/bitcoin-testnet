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
    echo "�� 交易历史:"
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
