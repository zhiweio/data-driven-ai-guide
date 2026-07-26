# GLOSSARY.md

# 全书术语表

> 本文件是《Data-Driven AI：从数据到智能》的唯一术语来源。
>
> 所有章节作者与 AI 协作 Agent 写章节前，必须先查本表。
>
> 禁止使用本表以外的译法。

---

# 一、使用说明

## 1.1 术语首次出现

术语首次出现时，给中英文并列。

格式：中文（English）。

示例：数据本体（Ontology）。

## 1.2 术语后续出现

后续统一用中文。

除非该术语以英文缩写形式更常用，例如 RAG。

## 1.3 翻译权威

本表是唯一翻译源。

章节作者不得自创新译法。

## 1.4 禁止混用

禁止在同一章节混用同义词。

例如，同一章不得既用"数据本体"又用"本体论"。

## 1.5 修订规则

新增术语需要：

1. 指定唯一中文译法。
2. 给出一句话定义。
3. 标注所属 DDA 层。
4. 如有易混近义词，列入禁止混用对照表。

---

# 二、核心术语表

术语按 DDA 层分组。

每条格式：

> **中文术语**（English, 缩写）
> 定义一句话。
> 禁止混用：近义词列表。
> 所属层：层名。

## 2.1 跨层总称

**数据驱动 AI**（Data-Driven AI, DDA）
以数据为起点的 AI 系统设计方法。
禁止混用：无。
所属层：跨层。

**思维升级**（Mindset Shift）
数据工程师从数据视角理解 AI 的认知转变。
禁止混用：技能升级、能力转型。
所属层：跨层。

**AI 原生**（AI Native）
以 AI 系统为核心组织企业数据与流程的形态。
禁止混用：智能化、数字化。
所属层：跨层。

**业务语义不可靠**（Unreliable Business Semantics）
企业业务含义无法被机器稳定、一致、及时地消费的根本问题，是 DDA 各层设计的共同起点。
禁止混用：模型幻觉、数据质量差（多为症状或子集）。
所属层：跨层。

**语义传递不可靠**（Semantic Transmission Unreliability）
业务含义散落在多系统、多口径、多文档中，无法经单一来源稳定传给 AI 消费方。
禁止混用：网络故障、接口超时。
所属层：跨层。

**语义时效不可靠**（Semantic Temporal Unreliability）
业务世界持续变化，而 Ontology、口径、知识资产的定义滞后，导致曾经正确的语义逐渐过时。
禁止混用：数据新鲜度延迟（仅为子集）、模型知识截止。
所属层：跨层。

**数据即服务**（Data-as-a-Service, DaaS）
把数据封装为带口径、SLA、版本的可调用 API 对外交付的商业模式，是升级版数据产品在垂直数据行业的典型形态。
禁止混用：SaaS、数据中台。
所属层：跨层。

**升级版数据产品**（AI-ready Data Product）
在 Data Mesh 数据产品基础上，面向 Agent/RAG 消费升级交付标准：机器可读语义、语义接口、可追溯血缘、知识资产纳入产品目录。
禁止混用：AI 数仓、向量库项目。
所属层：跨层。

## 2.2 AI Ready Data Platform 层

**AI 就绪数据平台**（AI Ready Data Platform）
让企业数据能被 AI 系统可靠消费的数据底座。
禁止混用：数据中台、数据湖仓（除非特指存储设施）。
所属层：AI Ready Data Platform。

**数据契约**（Data Contract）
数据生产者与消费者之间显式的、可程序校验的约定。
禁止混用：数据协议（口语用法）、SLA（语义不同）。
所属层：AI Ready Data Platform。

**数据血缘**（Data Lineage）
数据从产生到消费的全链路可追溯关系。
禁止混用：数据流向（口语用法）。
所属层：AI Ready Data Platform。

## 2.3 Ontology 层

**数据本体**（Ontology）
机器理解企业业务世界的方式。
禁止混用：知识图谱、本体论、领域模型（语义不同）。
所属层：Ontology。

**业务世界模型**（Business World Model）
企业与人类业务共识对齐的显式语义结构，说明业务对象、关系、规则与约束；在本书中主要由 Ontology 承载，并绑定数据资产。
禁止混用：世界模型（强化学习/生成式 AI 中的环境动力学模型）、数字孪生（除非特指物理仿真副本）。
所属层：Ontology。

**实体**（Entity）
Ontology 中描述的业务对象。
禁止混用：对象（过宽）、表（语义不同）。
所属层：Ontology。

**关系**（Relation）
Ontology 中实体之间的显式业务连接。
禁止混用：外键（语义不同）。
所属层：Ontology。

**知识图谱**（Knowledge Graph, KG）
一种以图结构组织知识的实现技术。
禁止混用：与 Ontology 等价。
所属层：Ontology（实现技术）。

> 本书语境下，知识图谱 ≠ 数据本体。
>
> 知识图谱是 Ontology 的可能实现之一，不是 Ontology 本身。

## 2.4 Semantic Layer 层

**语义层**（Semantic Layer, SL）
Ontology 的工程化实现，面向 Agent 的语义接口。
禁止混用：BI 语义层、语义模型（语义不同）。
所属层：Semantic Layer。

**BI 语义层**（BI Semantic Layer）
面向人读报表的语义封装。
禁止混用：与 Semantic Layer 等价。
所属层：Semantic Layer（对照概念）。

> 本书语境下，BI 语义层 ≠ 语义层。
>
> 二者的稳定性要求、契约要求、消费方式完全不同。

**语义接口**（Semantic API）
Semantic Layer 暴露给 Agent 的调用接口。
禁止混用：数据 API（语义不同）。
所属层：Semantic Layer。

## 2.5 Knowledge Foundation 层

**知识基础设施**（Knowledge Foundation）
把结构化语义与非结构化知识统一组织的 AI 知识底座。
禁止混用：知识库（过窄）、文档库（语义不同）。
所属层：Knowledge Foundation。

**知识绑定**（Knowledge Binding）
把非结构化知识与 Ontology 实体显式关联。
禁止混用：知识关联（口语用法）。
所属层：Knowledge Foundation。

## 2.6 RAG 层

**检索增强生成**（Retrieval-Augmented Generation, RAG）
企业知识基础设施的检索与落地层。
禁止混用：向量检索（过窄）、问答系统（过窄）。
所属层：RAG。

> 本书语境下，RAG ≠ 向量数据库 + 大模型。
>
> 那是 RAG 的一个最简实现，不是 RAG 的定位。

**接地**（Grounding）
生成前把 AI 输出对齐到企业事实。
禁止混用：事实核查（语义不同）。
所属层：RAG。

**引用**（Citation）
生成后让 AI 输出可追溯到知识来源。
禁止混用：注释、参考（口语用法）。
所属层：RAG。

**评估**（Evaluation）
对检索与生成质量的持续度量。
禁止混用：测试（过窄）、监控（语义不同）。
所属层：RAG。

## 2.7 AI Agent 层

**AI 智能体**（AI Agent）
消费 Ontology、Semantic Layer、Knowledge Foundation 的执行单元。
禁止混用：机器人、助手（口语用法）。
所属层：AI Agent。

> 本书语境下，Agent 不是中心。数据才是中心。

**工作流**（Workflow）
预定义的、无自主决策的执行路径。
禁止混用：与 Agent 等价。
所属层：AI Agent（对照概念）。

## 2.8 Data Loop 层

**数据闭环**（Data Loop）
AI 系统持续学习、持续修正、持续演进的能力。
禁止混用：ETL、ELT、数据管道、再训练流程。
所属层：Data Loop。

> 本书语境下，Data Loop ≠ 新的 ETL。

**反馈回流**（Feedback Loop）
把 AI 输出反过来修正数据、知识、Ontology 的机制。
禁止混用：数据回写（过窄）。
所属层：Data Loop。

## 2.9 Ontology Evolution 层

**数据本体演进**（Ontology Evolution）
Ontology 随业务与反馈持续生长的能力。
禁止混用：模型迭代（语义不同）。
所属层：Ontology Evolution。

---

# 三、禁止混用对照表

| 概念 A | 概念 B | 关系 | 强制选择 |
| --- | --- | --- | --- |
| 数据本体（Ontology） | 知识图谱（KG） | KG 是 Ontology 的可能实现 | 讨论方法论用 Ontology；讨论具体图存储用 KG |
| 语义层（Semantic Layer） | BI 语义层 | 面向 Agent vs 面向人 | 讨论 Agent 消费用 Semantic Layer |
| 数据闭环（Data Loop） | ETL / ELT | 持续学习 vs 数据搬运 | 讨论 AI 反馈回流用 Data Loop |
| AI 智能体（Agent） | 工作流（Workflow） | 自主决策 vs 预定义路径 | 讨论自主执行用 Agent |
| 接地（Grounding） | 事实核查 | 生成前对齐 vs 生成后核查 | 讨论生成前对齐用 Grounding |
| 评估（Evaluation） | 监控（Monitoring） | 质量度量 vs 系统运行 | 讨论检索生成质量用 Evaluation |
| 数据契约（Data Contract） | SLA | 内容约定 vs 服务水平 | 讨论数据内容约定用 Data Contract |

---

# 四、缩写表

| 缩写 | 展开 | 首次使用规范 |
| --- | --- | --- |
| DDA | Data-Driven AI | 数据驱动 AI（DDA） |
| RAG | Retrieval-Augmented Generation | 检索增强生成（RAG） |
| SL | Semantic Layer | 语义层（SL） |
| KG | Knowledge Graph | 知识图谱（KG） |
| BI | Business Intelligence | 商业智能（BI） |
| CDC | Change Data Capture | 变更数据捕获（CDC） |
| ETL | Extract-Transform-Load | 抽取-转换-加载（ETL） |
| ELT | Extract-Load-Transform | 抽取-加载-转换（ELT） |
| API | Application Programming Interface | 应用编程接口（API） |
| LLM | Large Language Model | 大语言模型（LLM） |
| MCP | Model Context Protocol | 模型上下文协议（MCP） |

缩写首次出现时，必须先给中文全称与英文全称，再用缩写。

示例：检索增强生成（Retrieval-Augmented Generation，RAG）。

后续直接用 RAG。

---

# 五、本文件的修订规则

修订一个术语的中文译法，需要：

1. 全书搜索旧译法并替换。
2. 更新禁止混用对照表。
3. 更新缩写表。

新增一层需要：

1. 在核心术语表中追加该层的小节。
2. 确保该层术语与现有层术语无冲突。
