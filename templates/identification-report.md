# 系统辨识报告模板

## 任务信息
- **原始请求**: {user_input}
- **分析时间**: {timestamp}
- **分析者**: Hermes Agent + system-identification skill

## 辨识结果

### 1. 触发路径
- [ ] 快速路径（简单请求）
- [ ] 完整分析（复杂请求）

**判定依据**: {quick_scan_result}

### 2. 意图分类

| 项目 | 内容 |
|------|------|
| 匹配标签 | {matched_tag} |
| 置信度 | {confidence}/1.0 |
| 标签来源 | {preset/dynamic} |

**新标签生成记录**（如适用）：
- 新标签名称: {new_tag_name}
- 生成原因: {generation_reason}
- 存储路径: {tags_file_path}

### 3. 复杂度评估

| 项目 | 内容 |
|------|------|
| 复杂度等级 | {simple/medium/complex/critical} |
| 判定依据 | {assessment_criteria} |

**检查清单得分**：
- 涉及多个系统/服务: {yes/no}
- 需要设计或架构决策: {yes/no}
- 影响生产环境: {yes/no}
- 数据变更且不可逆: {yes/no}
- 需要用户审批或确认: {yes/no}
- 失败后有严重后果: {yes/no}

### 4. 任务分解

**主任务**: {main_task}
**意图标签**: {tag}
**复杂度**: {complexity}

#### 子任务列表

| 序号 | 子任务 | 验证标准 | 状态 |
|------|--------|----------|------|
| 1 | {subtask_1} | {verify_1} | [ ] |
| 2 | {subtask_2} | {verify_2} | [ ] |
| 3 | {subtask_3} | {verify_3} | [ ] |
| 4 | {subtask_4} | {verify_4} | [ ] |
| 5 | {subtask_5} | {verify_5} | [ ] |

#### 依赖关系
- **类型**: {linear/parallel/branch}
- **说明**: {dependency_description}

#### 回滚点
- {rollback_points}

### 5. error-control 协同记录

| 检查项 | 状态 |
|--------|------|
| 边界确认触发 | {yes/no} |
| 澄清机制触发 | {yes/no} |
| 用户确认获得 | {yes/no} |

**边界声明**（如触发）：
```
{boundary_declaration}
```

### 6. 执行计划

```
1. [ ] {step_1}
2. [ ] {step_2}
3. [ ] {step_3}
...
```

### 7. 结论

**最终判定**:
- 意图: {final_intent}
- 复杂度: {final_complexity}
- 执行策略: {execution_strategy}

**置信度**: {final_confidence}/1.0

**建议**:
- {recommendation}

---
> 本报告由 system-identification Skill 自动生成
> 关联 Skill: error-control（边界确认与验证）
