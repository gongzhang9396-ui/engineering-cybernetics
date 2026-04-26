# 工程控制论技能集

基于钱学森《工程控制论》思想的 AI 工程实践技能集合。

## 核心理念

将控制论的基本概念（反馈、稳定性、可控性、可观测性）转化为 AI 系统的工程实践：
- **系统辨识** → 用户意图识别与任务分类
- **状态空间** → 对话状态追踪与上下文管理
- **稳定性** → 响应一致性监控
- **可控性** → 误差控制与恢复机制
- **最优控制** → 资源调度与决策优化

## 技能目录

| 技能 | 状态 | 对应章节 | 说明 |
|------|------|----------|------|
| error-control | ✅ v1.0.0 | 第十八章「误差的控制」 | 误差分类、重试策略、降级策略 |
| system-identification | 📝 规划中 | 第一章「引言」 | 意图分类、复杂度评估 |
| state-tracker | 📝 规划中 | 第三章「状态空间」 | 对话状态追踪 |
| stability-monitor | 📝 规划中 | 第三章「稳定性分析」 | 响应一致性监控 |
| decoupling-control | 📝 规划中 | 第五章「解耦控制」 | 模块化任务分解 |

## 使用方式

```bash
# 克隆到本地
gh repo clone gongzhang9396-ui/engineering-cybernetics

# 安装单个技能到 Hermes Agent
cp -r skills/error-control ~/.hermes/skills/software-development/
```

## 贡献规范

1. 每个技能必须包含：
   - `SKILL.md` — 方法论文档
   - `scripts/` — 可执行脚本
   - `templates/` — 模板文件
2. 技能命名：kebab-case
3. 版本号：语义化版本

## 关联资源

- [工程控制论 - 百度百科](https://baike.baidu.com/item/%E5%B7%A5%E7%A8%8B%E6%8E%A7%E5%88%B6%E8%AE%BA)
- [钱学森 - 维基百科](https://zh.wikipedia.org/wiki/%E9%92%B1%E5%AD%A6%E6%A3%AE)
