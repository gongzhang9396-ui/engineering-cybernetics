# 验证报告模板

## 任务信息
- **任务**: {task_description}
- **时间**: {timestamp}
- **执行者**: Hermes Agent

## 边界声明（第 0 阶段）

| 维度 | 声明内容 | 状态 |
|------|----------|------|
| 空间边界 | {scope_single_multiple_all} | {confirmed} |
| 时间边界 | {timing_immediate_scheduled} | {confirmed} |
| 协议边界 | {protocol_unchanged_changed} | {confirmed} |
| 环境边界 | {env_dev_test_prod} | {confirmed} |
| 回滚边界 | {backup_path_or_unbacked} | {confirmed} |

**偏差记录**：
- 声明影响：{declared_scope}
- 实际影响：{actual_scope}
- 偏差处理：{deviation_handling}

---

## 验证结果

### 1. 理解验证
- [ ] 用户意图置信度: {confidence}/1.0
- [ ] 关键参数确认: {parameters}
- [ ] 边界条件识别: {constraints}

### 2. 执行验证
| 步骤 | 命令 | 预期结果 | 实际结果 | 状态 |
|------|------|----------|----------|------|
| {step_1} | `{cmd_1}` | {expected_1} | {actual_1} | {status_1} |
| {step_2} | `{cmd_2}` | {expected_2} | {actual_2} | {status_2} |
| {step_3} | `{cmd_3}` | {expected_3} | {actual_3} | {status_3} |

### 3. 输出审计
- [ ] 事实准确性: {fact_check}
- [ ] 逻辑一致性: {logic_check}
- [ ] 信息溯源: {source_trace}
- [ ] 不确定性标记: {uncertainty_markers}

### 4. 误差分析
| 误差类型 | 严重程度 | 处理措施 | 当前状态 |
|----------|----------|----------|----------|
| {error_type} | {severity} | {action} | {status} |

### 5. 结论
**最终结论**: {conclusion}

**置信度**: {final_confidence}/1.0

**建议**: {recommendation}

---
> 本报告由 error-control Skill 自动生成
