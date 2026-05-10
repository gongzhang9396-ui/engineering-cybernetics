#!/bin/bash
# 系统辨识验证脚本 v2.0 — 基于关键词匹配
# 用法: source identify.sh && identify_task "用户请求"

# ========== 关键词库 ==========

# 意图标签关键词
QUERY_KEYWORDS="查看|查询|状态|日志|读取|获取|显示|列出|检查"
CONFIG_KEYWORDS="修改配置|改配置|配置|设置|调整|变更|编辑配置"
DEPLOY_KEYWORDS="部署|安装|搭建|启动服务|上线|发布"
DEBUG_KEYWORDS="排查|调试|修复|解决|错误|故障|异常"
BACKUP_KEYWORDS="备份|恢复|导出|导入|迁移|复制"
OPTIMIZE_KEYWORDS="优化|提速|压缩|清理|扩容|缩容"
SECURITY_KEYWORDS="防火墙|权限|密码|证书|加密|安全|漏洞"

# 危险操作关键词（强制触发 error-control）
DANGER_DELETE="删除|清空|rm |rm -rf|drop |truncate|格式化"
DANGER_REBOOT="重启|reboot|shutdown|poweroff|停止服务"
DANGER_PERMISSION="chmod 777|chown |passwd|修改密码|提权"
DANGER_NETWORK="关闭防火墙|iptables -F|开放端口|公网暴露"
DANGER_DATA="修改数据库|更新表|删除字段|数据迁移|主从切换"
DANGER_PROD="生产环境|线上|正式环境|影响业务"

# 复杂度关键词
SIMPLE_KEYWORDS="查看|查询|状态|日志|读取|获取|显示|列出|检查"
MEDIUM_KEYWORDS="修改配置|重启|更新|调整|设置|安装"
COMPLEX_KEYWORDS="部署|迁移|升级|架构|多服务|集成|搭建"
CRITICAL_KEYWORDS="删除|清空|格式化|rm -rf|drop |生产环境|数据变更|不可逆"

# 合并危险词
ALL_DANGER="${DANGER_DELETE}|${DANGER_REBOOT}|${DANGER_PERMISSION}|${DANGER_NETWORK}|${DANGER_DATA}|${DANGER_PROD}"

# ========== 核心函数 ==========

# 检查是否包含关键词
contains_keyword() {
    local input="$1"
    local keywords="$2"
    echo "$input" | grep -qiE "($keywords)"
    return $?
}

# 意图分类（关键词匹配）
classify_intent() {
    local input="$1"
    
    # 按优先级检查
    if contains_keyword "$input" "$DEPLOY_KEYWORDS"; then
        echo "deploy"
        return 0
    fi
    
    if contains_keyword "$input" "$SECURITY_KEYWORDS"; then
        echo "security"
        return 0
    fi
    
    if contains_keyword "$input" "$BACKUP_KEYWORDS"; then
        echo "backup"
        return 0
    fi
    
    if contains_keyword "$input" "$CONFIG_KEYWORDS"; then
        echo "config"
        return 0
    fi
    
    if contains_keyword "$input" "$DEBUG_KEYWORDS"; then
        echo "debug"
        return 0
    fi
    
    if contains_keyword "$input" "$OPTIMIZE_KEYWORDS"; then
        echo "optimize"
        return 0
    fi
    
    if contains_keyword "$input" "$QUERY_KEYWORDS"; then
        echo "query"
        return 0
    fi
    
    # 未匹配
    echo "unknown"
    return 1
}

# 检查危险操作
check_danger() {
    local input="$1"
    local matched=""
    
    # 检查各类危险词
    if contains_keyword "$input" "$DANGER_DELETE"; then
        matched="${matched}删除类 "
    fi
    
    if contains_keyword "$input" "$DANGER_REBOOT"; then
        matched="${matched}重启类 "
    fi
    
    if contains_keyword "$input" "$DANGER_PERMISSION"; then
        matched="${matched}权限类 "
    fi
    
    if contains_keyword "$input" "$DANGER_NETWORK"; then
        matched="${matched}网络类 "
    fi
    
    if contains_keyword "$input" "$DANGER_DATA"; then
        matched="${matched}数据类 "
    fi
    
    if contains_keyword "$input" "$DANGER_PROD"; then
        matched="${matched}生产环境 "
    fi
    
    if [ -n "$matched" ]; then
        echo "$matched"
        return 0  # 命中危险词
    fi
    
    return 1  # 未命中
}

# 复杂度评估（关键词匹配）
assess_complexity() {
    local input="$1"
    
    # 先检查 critical
    if contains_keyword "$input" "$CRITICAL_KEYWORDS"; then
        echo "critical"
        return 0
    fi
    
    # 检查 complex
    if contains_keyword "$input" "$COMPLEX_KEYWORDS"; then
        echo "complex"
        return 0
    fi
    
    # 检查 medium
    if contains_keyword "$input" "$MEDIUM_KEYWORDS"; then
        echo "medium"
        return 0
    fi
    
    # 默认 simple
    echo "simple"
    return 0
}

# 主函数：系统辨识
identify_task() {
    local input="$1"
    
    echo "=== 系统辨识 v2.0 ==="
    echo "用户输入: $input"
    echo ""
    
    # 步骤1：意图分类
    local tag=$(classify_intent "$input")
    echo "意图标签: $tag"
    
    # 步骤2：检查危险操作
    local danger=$(check_danger "$input")
    if [ $? -eq 0 ] && [ -n "$danger" ]; then
        echo "⚠️ 检测到危险操作: $danger"
        echo "⚠️ 必须输出【边界声明】"
        echo ""
        
        # 返回危险标记
        echo "DANGER:$danger"
        return 2  # 特殊返回值：危险操作
    fi
    
    # 步骤3：复杂度评估
    local complexity=$(assess_complexity "$input")
    echo "复杂度: $complexity"
    echo ""
    
    # 步骤4：根据复杂度处理
    case "$complexity" in
        simple)
            if [ "$tag" = "unknown" ]; then
                echo "⚠️ 意图不明确，需要澄清"
                echo ""
                echo "【澄清请求】"
                echo "您的指令不够明确，请补充以下信息："
                echo "1. 是查询信息？（查看状态、读取日志等）"
                echo "2. 是修改配置？（调整设置、变更参数等）"
                echo "3. 是部署服务？（安装、上线、发布等）"
                echo "4. 是排查问题？（修复错误、调试故障等）"
                echo "5. 其他：请具体说明"
                echo ""
                echo "CLARIFY:需要用户澄清意图"
                return 3  # 特殊返回值：需要澄清
            fi
            echo "处理: 直接执行"
            ;;
        medium)
            if [ "$tag" = "unknown" ]; then
                echo "⚠️ 意图不明确，需要澄清"
                echo ""
                echo "【澄清请求】"
                echo "您的指令涉及配置变更，但意图不够明确，请补充："
                echo "1. 是修改哪个服务的配置？"
                echo "2. 是新增、修改还是删除配置项？"
                echo "3. 预期达到什么效果？"
                echo ""
                echo "CLARIFY:需要用户澄清意图"
                return 3  # 特殊返回值：需要澄清
            fi
            echo "处理: 执行后验证"
            ;;
        complex)
            echo "处理: 任务分解 + 每步验证"
            ;;
        critical)
            echo "⚠️ 处理: 强制边界确认 + 双重验证"
            ;;
    esac
    
    return 0
}

# 快速辨识（仅返回标签和复杂度）
quick_identify() {
    local input="$1"
    local tag=$(classify_intent "$input")
    local complexity=$(assess_complexity "$input")
    
    echo "${tag}|${complexity}"
}

# 检查是否需要边界声明
need_boundary() {
    local input="$1"
    
    # 检查危险词
    if check_danger "$input" > /dev/null; then
        echo "true"
        return 0
    fi
    
    # 检查 critical 复杂度
    local complexity=$(assess_complexity "$input")
    if [ "$complexity" = "critical" ]; then
        echo "true"
        return 0
    fi
    
    echo "false"
    return 1
}
