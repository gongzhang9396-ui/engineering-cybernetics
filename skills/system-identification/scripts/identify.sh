#!/bin/bash
# 系统辨识验证脚本 — 意图分类、复杂度评估、任务分解
# 用法: source identify.sh && identify_task "用户请求"

# 标签存储路径
TAGS_FILE="${HOME}/.hermes/skills/system-identification/intent-tags/tags.conf"

# 初始化标签文件
init_tags() {
    mkdir -p "$(dirname $TAGS_FILE)"
    if [ ! -f "$TAGS_FILE" ]; then
        cat > "$TAGS_FILE" << 'EOF'
deploy|部署服务到服务器|0
query|查询信息或状态|0
debug|排查问题或错误|0
config|修改配置或设置|0
develop|开发或编写代码|0
optimize|优化性能或资源|0
backup|备份或恢复数据|0
security|安全相关操作|0
EOF
    fi
}

# 快速扫描：判断简单/复杂
quick_scan() {
    local input="$1"
    local complex_score=0
    
    # 复杂特征检查
    local complex_patterns=(
        "部署|安装|搭建|配置.*服务"
        "多个|多系统|协调|集成"
        "设计|架构|方案"
        "生产环境|线上|正式"
        "数据库|缓存|消息队列"
        "nginx|docker|k8s|kubernetes"
    )
    
    for pattern in "${complex_patterns[@]}"; do
        if echo "$input" | grep -qiE "$pattern"; then
            ((complex_score++))
        fi
    done
    
    # 简单特征检查
    local simple_patterns=(
        "查看|查询|状态|日志"
        "简单|一下|快速"
    )
    
    for pattern in "${simple_patterns[@]}"; do
        if echo "$input" | grep -qiE "$pattern"; then
            ((complex_score--))
        fi
    done
    
    # 判定
    if [ $complex_score -ge 2 ]; then
        echo "complex"
        return 1  # 复杂，需要完整分析
    else
        echo "simple"
        return 0  # 简单，快速路径
    fi
}

# 意图分类：匹配现有标签
classify_intent() {
    local input="$1"
    local best_tag=""
    local best_score=0
    
    init_tags
    
    # 读取标签并匹配
    while IFS='|' read -r tag desc count; do
        # 简单关键词匹配（实际可用更复杂的算法）
        local score=0
        
        # 标签名匹配
        if echo "$input" | grep -qi "$tag"; then
            ((score+=3))
        fi
        
        # 描述关键词匹配
        local desc_words=$(echo "$desc" | tr '|' ' ')
        for word in $desc_words; do
            if echo "$input" | grep -qi "$word"; then
                ((score+=1))
            fi
        done
        
        if [ $score -gt $best_score ]; then
            best_score=$score
            best_tag="$tag"
        fi
    done < "$TAGS_FILE"
    
    # 归一化匹配度（0-1）
    local max_score=5  # 假设最大匹配分
    local confidence=$(echo "scale=2; $best_score / $max_score" | bc 2>/dev/null || echo "0")
    
    # 如果 bc 不可用，用整数比较
    if ! command -v bc &> /dev/null; then
        if [ $best_score -ge 4 ]; then
            confidence="0.8"
        elif [ $best_score -ge 3 ]; then
            confidence="0.6"
        elif [ $best_score -ge 2 ]; then
            confidence="0.4"
        else
            confidence="0.2"
        fi
    fi
    
    echo "${best_tag}|${confidence}"
}

# 动态生成新标签
generate_new_tag() {
    local input="$1"
    local suggested_tag="$2"
    
    echo "=== 动态生成新标签 ==="
    echo "用户输入: $input"
    echo "建议标签: $suggested_tag"
    echo "描述: 待补充"
    echo "0"
    
    # 存储新标签
    echo "$suggested_tag|待补充|0" >> "$TAGS_FILE"
    echo "✓ 已存储新标签: $suggested_tag"
}

# 复杂度评估
assess_complexity() {
    local input="$1"
    local score=0
    
    # 检查清单
    [ $(echo "$input" | grep -ciE "多个|多系统|协调|集成|docker|nginx|数据库") -gt 0 ] && ((score++))
    [ $(echo "$input" | grep -ciE "设计|架构|方案|规划") -gt 0 ] && ((score++))
    [ $(echo "$input" | grep -ciE "生产|线上|正式|环境") -gt 0 ] && ((score++))
    [ $(echo "$input" | grep -ciE "数据|备份|恢复|迁移") -gt 0 ] && ((score++))
    [ $(echo "$input" | grep -ciE "重启|停止|删除|清理") -gt 0 ] && ((score++))
    [ $(echo "$input" | grep -ciE "审批|确认|授权|权限") -gt 0 ] && ((score++))
    
    # 判定
    case $score in
        0|1)
            echo "simple"
            ;;
        2|3)
            echo "medium"
            ;;
        4|5)
            echo "complex"
            ;;
        *)
            echo "critical"
            ;;
    esac
}

# 任务分解
decompose_task() {
    local input="$1"
    local complexity="$2"
    local tag="$3"
    
    echo "=== 任务分解 ==="
    echo "主任务: $input"
    echo "意图标签: $tag"
    echo "复杂度: $complexity"
    echo ""
    
    case "$complexity" in
        simple)
            echo "不分解，直接执行"
            ;;
        medium)
            echo "子任务列表："
            echo "1. [ ] 准备环境 → 验证: 环境就绪"
            echo "2. [ ] 执行主操作 → 验证: 操作成功"
            echo "3. [ ] 验证结果 → 验证: 符合预期"
            echo ""
            echo "依赖关系: 线性"
            ;;
        complex)
            echo "子任务列表："
            echo "1. [ ] 确认边界（error-control） → 验证: 边界确认完成"
            echo "2. [ ] 准备环境/资源 → 验证: 资源就绪"
            echo "3. [ ] 执行核心操作 → 验证: 操作成功"
            echo "4. [ ] 配置关联系统 → 验证: 配置生效"
            echo "5. [ ] 集成测试 → 验证: 端到端通过"
            echo ""
            echo "依赖关系: 线性（1前置，2→3→4→5）"
            echo "回滚点: 步骤2、3、4可独立回滚"
            ;;
        critical)
            echo "子任务列表："
            echo "1. [ ] 强制边界确认（error-control） → 验证: 用户审批"
            echo "2. [ ] 备份现有状态 → 验证: 备份可恢复"
            echo "3. [ ] 执行变更（需审批） → 验证: 每步审批"
            echo "4. [ ] 验证变更（双重验证） → 验证: 测试通过"
            echo "5. [ ] 监控运行状态 → 验证: 无异常"
            echo ""
            echo "依赖关系: 严格线性，每步需审批"
            echo "回滚点: 任何步骤可立即回滚"
            ;;
    esac
}

# 主函数：完整分析
identify_task() {
    local input="$1"
    
    echo "=== 系统辨识 ==="
    echo "用户输入: $input"
    echo ""
    
    # 步骤1：快速扫描
    local scan_result=$(quick_scan "$input")
    local scan_exit=$?
    
    if [ $scan_exit -eq 0 ]; then
        echo "快速扫描: 简单请求，走快速路径"
        echo ""
        
        # 快速路径：意图分类后直接返回
        local intent_result=$(classify_intent "$input")
        local tag=$(echo "$intent_result" | cut -d'|' -f1)
        local confidence=$(echo "$intent_result" | cut -d'|' -f2)
        
        echo "意图标签: $tag"
        echo "置信度: $confidence"
        echo "复杂度: simple"
        echo "处理: 直接执行"
        
        return 0
    else
        echo "快速扫描: 复杂请求，走完整分析"
        echo ""
    fi
    
    # 步骤2：意图分类
    local intent_result=$(classify_intent "$input")
    local tag=$(echo "$intent_result" | cut -d'|' -f1)
    local confidence=$(echo "$intent_result" | cut -d'|' -f2)
    
    echo "意图分类:"
    echo "  匹配标签: $tag"
    echo "  置信度: $confidence"
    echo ""
    
    # 步骤3：置信度检查
    local confidence_threshold="0.8"
    if [ $(echo "$confidence < $confidence_threshold" | bc 2>/dev/null || echo "0") -eq 1 ] 2>/dev/null; then
        # 整数比较备用
        if [ "${confidence%.*}" -lt 1 ] 2>/dev/null; then
            echo "⚠ 置信度 < 0.8，建议调用 error-control 澄清机制"
            echo ""
        fi
    fi
    
    # 步骤4：复杂度评估
    local complexity=$(assess_complexity "$input")
    echo "复杂度评估: $complexity"
    echo ""
    
    # 步骤5：任务分解
    decompose_task "$input" "$complexity" "$tag"
    
    return 0
}

# 快速路径函数（仅返回标签和复杂度）
quick_identify() {
    local input="$1"
    local intent_result=$(classify_intent "$input")
    local tag=$(echo "$intent_result" | cut -d'|' -f1)
    local complexity=$(assess_complexity "$input")
    
    echo "${tag}|${complexity}"
}
