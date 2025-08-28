#!/bin/bash

# 比特币CLI工具脚本
CONTAINER_NAME="bitcoin-cli"

case "$1" in
    "info")
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet getblockchaininfo
        ;;
    "balance")
        if [ -z "$2" ]; then
            echo "Usage: $0 balance <address>"
            exit 1
        fi
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet getreceivedbyaddress "$2"
        ;;
    "newaddress")
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet getnewaddress
        ;;
    "send")
        if [ -z "$2" ] || [ -z "$3" ]; then
            echo "Usage: $0 send <address> <amount>"
            exit 1
        fi
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet sendtoaddress "$2" "$3"
        ;;
    "utxo")
        if [ -z "$2" ]; then
            echo "Usage: $0 utxo <address>"
            exit 1
        fi
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet listunspent 0 999999 "[\"$2\"]"
        ;;
    "peers")
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet getpeerinfo
        ;;
    "mempool")
        docker exec $CONTAINER_NAME bitcoin-cli -testnet -rpcuser=testuser -rpcpassword=testpass123 -rpcconnect=bitcoin-testnet getmempoolinfo
        ;;
    "help")
        echo "可用命令:"
        echo "  info      - 获取区块链信息"
        echo "  balance   - 查询地址余额"
        echo "  newaddress- 生成新地址"
        echo "  send      - 发送比特币"
        echo "  utxo      - 查询UTXO"
        echo "  peers     - 查看连接节点"
        echo "  mempool   - 查看内存池"
        ;;
    *)
        echo "未知命令: $1"
        echo "使用 '$0 help' 查看可用命令"
        exit 1
        ;;
esac
