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

# 边界确认函数
verify_scope() {
    local task="$1"
    local scope="$2"  # single|multiple|all
    
    echo "=== 边界确认 ==="
    echo "任务: $task"
    
    case "$scope" in
        single)
            echo "✓ 声明：仅影响单个资源"
            ;;
        multiple)
            echo "⚠ 声明：影响多个资源，需逐项验证"
            ;;
        all)
            echo "⚠ 声明：影响全部资源，需额外谨慎"
            ;;
        *)
            echo "✗ 错误：未声明影响范围 (scope=$scope)"
            return 1
            ;;
    esac
    return 0
}

# 备份验证函数
verify_backup() {
    local original="$1"
    local backup_dir="${2:-/tmp/error-control-backups}"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$backup_dir/$(basename $original).$timestamp.bak"
    
    mkdir -p "$backup_dir"
    
    if [ -f "$original" ] || [ -d "$original" ]; then
        cp -r "$original" "$backup_path"
        echo "✓ 已备份: $original → $backup_path"
        echo "$backup_path"  # 输出备份路径供后续使用
        return 0
    else
        echo "⚠ 原文件不存在，无需备份: $original"
        return 2
    fi
}

# 协议确认函数
verify_protocol() {
    local current="$1"
    local target="$2"
    
    if [ "$current" != "$target" ]; then
        echo "⚠ 协议变更: $current → $target"
        echo "  影响：客户端可能需要调整"
        return 2  # 返回 2 表示警告
    else
        echo "✓ 协议保持不变: $current"
        return 0
    fi
}
