#!/bin/bash
# 误差控制验证脚本 — 快速检查命令执行结果
# 用法: source verify.sh && verify_command "your command here"

verify_command() {
    local cmd="$1"
    local expected_pattern="$2"
    
    echo "▶ 执行: $cmd"
    
    # 执行并捕获输出
    output=$(eval "$cmd" 2>&1)
    exit_code=$?
    
    # 检查 exit code
    if [ $exit_code -ne 0 ]; then
        echo "✗ 失败 (exit_code=$exit_code)"
        echo "stderr: $output"
        return 1
    fi
    
    # 检查预期内容
    if [ -n "$expected_pattern" ] && ! echo "$output" | grep -q "$expected_pattern"; then
        echo "⚠ 成功执行但输出不包含预期模式 '$expected_pattern'"
        echo "输出: $output"
        return 2
    fi
    
    echo "✓ 通过"
    echo "输出: $(echo "$output" | head -3)"
    return 0
}

verify_port() {
    local port="$1"
    local service_name="$2"
    
    if ss -tlnp | grep -q ":$port "; then
        echo "✓ $service_name (端口 $port) 监听正常"
        return 0
    else
        echo "✗ $service_name (端口 $port) 未监听"
        return 1
    fi
}

verify_file() {
    local path="$1"
    
    if [ -f "$path" ]; then
        echo "✓ 文件存在: $path"
        return 0
    else
        echo "✗ 文件不存在: $path"
        return 1
    fi
}
