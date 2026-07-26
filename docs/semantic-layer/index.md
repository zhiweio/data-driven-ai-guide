# 语义层：Semantic Layer

> 本章所属 DDA 层：Semantic Layer

## 问题

为什么 AI 智能体（AI Agent）不应该直连裸库写 SQL？因为裸库不携带语义，Agent 写出的 SQL 没有业务正确性保障。

数据工程师为什么要学语义层（Semantic Layer，SL）？因为它是数据本体（Ontology）的工程化实现，是把上一章定义的"机器如何理解业务世界"变成"Agent 可调用的接口"的那一层。Ontology 回答"业务世界是什么意思"，SL 回答"Agent 怎么按这个意思去取数据"。没有 SL，Ontology 就是悬空的概念模型；有了 SL，Agent 才能经稳定接口消费数据，而不是自己拼 SQL。

SL 解决的问题是：让 Agent 经语义接口访问数据，而非经裸 SQL 访问裸表。由此带来口径统一、字段改名不崩、查询可追责。

需要强调的是，SL 不只服务 Agent 的结构化查询，也为知识库与检索增强生成（Retrieval-Augmented Generation，RAG）应用提供口径锚点。RAG 生成答案时引用的数据，必须与 SL 定义的业务口径一致，否则 AI 答案里的数字与报表对不上。SL 是跨消费方的单一口径来源，既给 Agent 调用，也给 RAG 生成时对齐数据口径。本章聚焦 SL 本身，RAG 如何对齐口径在后续章节展开。

## 传统方案

传统数据消费里，分析师直接写 SQL。口径写在 BI 语义层或 ETL 注释里。药明诺华的早期实践是：分析师查"在研的 c-Met 抑制剂"，自己写：

```sql
SELECT research_code
FROM dwd_compound
WHERE target = 'c-Met'
  AND status IN ('phase1','phase2','phase3');
```

字段名 `target`、取值 `c-Met`、状态过滤条件，全靠分析师记忆与口口相传。BI 语义层 [^1] 会封装一部分指标定义，但它的服务对象是人读报表，不是 Agent 消费。

## 为什么失效

失效机制有四条，每条都有具体后果。

第一，字段改名即崩溃。上游把 `research_code` 改成 `compound_code`，所有依赖这张表的 SQL 与 Agent 提示词全部失效。没有语义层隔离，物理 schema 的任何变动直接冲击消费方。

第二，口径漂移。同一指标"在研化合物数"，研发系统按 `status IN ('phase1','phase2','phase3')` 算，BI 报表把 `preclinical` 也算进去，Agent 又用了第三种口径。三个数字不一样，没人说得清哪个对。BI 语义层只管报表口径，管不到 Agent。口径不统一的代价，垂直数据行业早算得清楚：付费客户看到两个对不上的数字，信任就崩了，所以它们把单一口径定义点当作产品基础设施来建。语义层（Semantic Layer，SL）把这套经验接到 AI 消费上--同一个指标，报表、Agent、RAG 生成引用同一处定义，谁都不许自造口径。

第三，Agent 不懂"这张表到底算什么"。Agent 直连裸库时，它看到的是表名与字段名，不是业务语义。它不知道 `dwd_compound` 里 `status='A'` 是什么意思，只能猜，猜错就答错。裸库给不了 Agent 业务正确性。

第四，RAG 与 Agent 口径各说各话。没有 SL 时，RAG 应用自造口径，生成的数字与数仓报表不一致；Agent 查的结构化数据与 RAG 答案里的数字也各算各的。用户从 Agent 拿到一个数，从 RAG 答案拿到另一个数，两个数都对不上，因为没有任何一层统一口径。

这里必须澄清一个混淆：**语义层不是 BI 语义层。** BI 语义层服务人读报表，容忍口径模糊与人工兜底；SL 服务 Agent 与 RAG 消费，要求契约稳定、单一口径定义点、可程序发现与调用。两者的稳定性、契约、消费要求完全不同。把 BI 语义层当作 SL 用，Agent 与 RAG 消费的稳定性就得不到保障。

```mermaid
flowchart LR
    AGT[AI Agent] -->|直连裸库| DB[(裸库)]
    DB -.字段改名即崩.-> X1[查询失效]
    DB -.口径漂移.-> X2[数字不一致]
    DB -.无业务语义.-> X3[Agent 猜测出错]
    AGT -->|经 SL| SL[语义层]
    SL -->|稳定语义接口| DB
    SL -.单一口径.-> OK[业务正确]
    RAG[RAG 应用] -->|生成时对齐口径| SL
    SL -.统一口径.-> RAG
```

图：Agent 直连裸库与经语义层消费的对比（DDA 层：Semantic Layer）

解读：上半部分 Agent 直连裸库，遇到字段改名、口径漂移、无业务语义三类失效。下半部分 Agent 经 SL 消费，SL 提供稳定语义接口并向下封装裸库变动，单一口径定义保证业务正确。RAG 也在生成时经 SL 对齐口径，与 Agent 共享同一份口径来源。这张图说明 SL 的价值是隔离与统一：隔离物理变动，统一业务口径，且统一覆盖 Agent 与 RAG 两类消费方。

## 新的设计思想

DDA 方法重新看这一层：Agent 不该写 SQL，该调语义接口。SL 的设计思想有六点。

第一，语义 API 而非语义表。SL 对外暴露的是可调用的语义接口（Semantic API），不是又一张语义表。Agent 调用"查活性化合物"这个接口，不需要知道底层表结构。

第二，单一口径定义点。一个指标只在一处定义，所有消费方共用。"在研化合物数"在 SL 定义一次，报表、Agent、RAG 生成引用它。

第三，版本化。语义接口有版本，破坏性变更新主版本，老版本保留过渡期，消费方有迁移窗口。

第四，Agent 可发现、可调用。SL 的接口元数据本身可被 Agent 查询，Agent 知道有哪些语义接口、各自含义与参数。

第五，拒绝直连裸库。SL 是 Agent 访问数据的唯一通道，裸库不对 Agent 开放。这是边界，不是建议。

第六，跨消费方口径锚点。SL 不只封装 SQL，还封装"业务怎么说"。Agent 查询与 RAG 生成涉及数据时，都引用 SL 的口径定义，保证两类消费方的数字一致。

SL 是 Ontology 的工程化实现接口。Ontology 定义"业务世界是什么意思"，SL 把这份意思封装成"Agent 与 RAG 都能调用的接口"。

## 架构设计

```mermaid
flowchart TB
    AGT[AI Agent] -->|调用语义接口| SL[Semantic Layer]
    SL -->|封装| ONT[Ontology]
    ONT -->|绑定| DP[AI Ready Data Platform]
    SL -->|翻译为受控 SQL| DB[(数据资产)]
    SL -.暴露接口元数据.-> AGT
    RAG[RAG 应用] -.生成时对齐口径.-> SL
```

图：Semantic Layer 在消费链中的位置（DDA 层：Semantic Layer）

解读：Agent 调用 SL 的语义接口，SL 基于下层 Ontology 理解业务语义，把调用翻译为受控 SQL 访问数据资产。SL 同时向 Agent 暴露接口元数据，让 Agent 能发现可调用的接口。RAG 在生成涉及数据的答案时，也向 SL 对齐口径。注意箭头方向：消费方向上指向下，Agent 经 SL、经 Ontology 到数据。SL 不是又一层存储，是消费通道上的语义封装层，且同时服务 Agent 与 RAG。

两层分离是这里的工程关键：语义面（定义业务口径）与数据面（执行物理查询）分开。语义面稳定，数据面可变。底层换表、换引擎，语义面不动，Agent 与 RAG 都不受影响。

## 工程实践

### 语义接口的定义

以药明诺华的语义接口为例，用 YAML 声明：

```yaml
semantic_api:
  name: list_active_compounds
  version: 2.1.0
  description: 查询活性化合物清单
  business_definition: |
    通过初筛、进入临床前或临床阶段的候选化合物。
    口径：status IN ('preclinical','phase1','phase2','phase3')
  parameters:
    - name: target
      type: string
      optional: true
      meaning: 按靶点过滤，如 c-Met
    - name: phase
      type: enum
      optional: true
      values: [preclinical, phase1, phase2, phase3]
  returns:
    fields: [compound_id, research_code, target, status]
  underlying:
    table: dwd_compound
    filter: "status IN ('preclinical','phase1','phase2','phase3')"
  owner: semantic-platform@novapharm.example
```

`business_definition` 是单一口径定义点，所有消费方引用它。`underlying` 封装了底层表与过滤条件，Agent 看不到也不需要看到。版本号控制变更：加参数是小版本，改口径是大版本。

### 两层分离

语义面负责"业务怎么说"，数据面负责"数据怎么查"。药明诺华的实践是把两者分开维护：语义面用 YAML 定义接口与口径，数据面负责把语义翻译为具体 SQL 并执行。底层从 PostgreSQL 换到带向量扩展的引擎，语义面不动，Agent 与 RAG 都不受影响。

这种分离与 dbt MetricFlow [^2]、Cube 这类工具的思路一致（这些仅为实现选择，不是唯一方案）。它们都把指标定义从查询里抽出来集中管理。本书关心的是分离原则，不是某个工具。

### SL 作为 Agent 与 RAG 的共同口径锚点

SL 不只服务 Agent 的结构化查询，也服务 RAG 的生成口径对齐。这里说明 RAG 如何消费 SL，而非以 RAG 为设计依据。

**RAG 生成时对齐 SL 口径**。当 RAG 生成的答案涉及数据指标（如"在研化合物数""c-Met 抑制剂数量"），这些指标的口径必须与 SL 定义一致。RAG 在生成前，从 SL 取对应指标的 `business_definition`，作为生成约束。这样 RAG 答案里的数字与 Agent 查询的数字、报表的数字三者一致，因为都引用同一份 SL 口径。

**Agent 结合 SL 结构化查询与 RAG 知识答案**。Agent 完成多步任务时，可能既经 SL 查结构化数据（如"在研化合物清单"），又经 RAG 取知识答案（如"试验终止的合规要求"）。两类结果在 Agent 处汇总时，涉及数据的部分都以 SL 口径为准。SL 是 Agent 把结构化查询结果与 RAG 知识答案拼到一起时的口径基准。

**口径变更同步两类消费方**。SL 的口径定义变更时（如"在研"是否含 `preclinical`），Agent 与 RAG 都经版本化机制收到通知并迁移。不会出现 Agent 用新口径、RAG 还用老口径的不一致。

SL 的设计原则因此要补一条：口径定义要覆盖 Agent 查询与 RAG 生成两类场景，不能只管 Agent 不管 RAG。

### 五层 SQL 护栏

SL 把 Agent 的查询翻译为受控 SQL 时，需要护栏防止越权与出错。五层护栏由浅入深：

1. **语法层**：校验 SQL 语法合法性。
2. **策略黑名单层**：拦截危险操作（DROP、DELETE、无 LIMIT 的全表扫描）。
3. **AST 列白名单层**：解析 SQL 抽象语法树，只允许访问白名单内的表与列。
4. **术语语义层**：校验查询用的术语是否与 Ontology 口径一致，拦截自造口径。
5. **成本估算层**：估算查询成本，超阈值拦截或降级，防止 Agent 跑垮平台。

五层叠起来，Agent 经 SL 发出的查询既语义正确又工程安全。注意这套护栏是 SL 的内部机制，不是 Agent 要学的东西。Agent 只管调语义接口，护栏由 SL 自动施加。

### MCP 使语义层对 Agent 原生

语义层并非只有 AI 时代才需要。垂直数据服务商早就用数据即服务（Data-as-a-Service，DaaS）[^3] 的形态实现了类似的东西：企业征信平台对外提供数百个数据 API，每个 API 背后是一个带口径定义、带 SLA、带版本的数据产品；专利数据平台提供三百多个数据 API 覆盖专利、化学、生物、市场情报，外加六十多个 AI 智能体（AI Agent）API。这些 API 就是语义接口的前身--封装了"业务怎么说"，对客户隐藏底层表结构，口径在平台内部统一定义。

AI 时代的变化是：这些 API 从"给人的程序调用"变成"给 Agent 调用"，从 REST 接口变成模型上下文协议（Model Context Protocol，MCP）[^4] 工具。SL 暴露为 MCP Server 后，Agent 能像调用内置工具一样调用语义接口，不需要把 SQL 拼进提示词。两家公司都已把数据能力封装为 MCP Server 对外开放。语义层做的事，本质上是把这些数据服务商的 DaaS 实践推广到所有企业，并升级为 Agent 原生。MCP 是通道，不是 SL 的定义。

## 最佳实践

**单一口径定义点**：一个指标只在一处定义，杜绝多口径并存。任何重复定义都是隐患。

**接口优先于表**：对外只暴露语义接口，不暴露表。物理 schema 变动不冲击消费方。

**版本化与迁移窗口**：破坏性变更新主版本，老版本保留过渡期，给消费方迁移时间。

**护栏内建**：SQL 护栏是 SL 的一部分，不是外挂。Agent 的查询必须过护栏，没有旁路。

**与 Ontology 同源**：SL 的口径定义必须与 Ontology 一致，不能自造。SL 是 Ontology 的工程投影。

**不开放裸库给 Agent**：这是硬边界。Agent 一旦能直连裸库，SL 的所有保障都失效。

**口径覆盖两类消费方**：SL 口径要覆盖 Agent 查询与 RAG 生成两类场景，不能只管 Agent 不管 RAG。

## 延伸阅读

- **语义层复兴**：dbt MetricFlow 开源相关资料；Cube、AtScale、LookML 语义层对比资料；Open Semantic Interchange（OSI）标准。
- **BI 语义层与 Agent 语义层的区别**：语义层复兴讨论中关于 Agent 消费与 BI 消费差异的资料。
- **MCP 协议**：模型上下文协议（Model Context Protocol）规范与语义层暴露为 MCP Server 的实践资料。

[^1]: BI 语义层（BI Semantic Layer）的概念，参见 LookML、dbt MetricFlow 等工具的文档与语义层复兴相关讨论。
[^2]: dbt MetricFlow 是 dbt 开源的语义层引擎，用 YAML 声明指标口径并从 SQL 抽离集中管理；Cube、AtScale、LookML 同属语义层工具家族，参见各自开源项目文档与语义层对比资料。
[^3]: 数据即服务（Data-as-a-Service，DaaS）是把数据封装为可调用 API 产品对外交付的模式，客户按调用或订阅付费，是数据服务商的主要商业模式。
[^4]: 模型上下文协议（Model Context Protocol，MCP）是让工具对 AI 智能体原生可调用的协议规范，参见 MCP 规范文档。

## Checklist

- [ ] Agent 是否经语义接口消费数据，而非直连裸库写 SQL？
- [ ] 每个指标是否有单一口径定义点，无重复定义？
- [ ] 语义接口是否版本化，破坏性变更是否有迁移窗口？
- [ ] 接口元数据是否可被 Agent 程序发现与调用？
- [ ] 是否澄清了 SL 与 BI 语义层的区别，未混用？
- [ ] SQL 护栏是否内建，覆盖语法、黑名单、列白名单、术语、成本五层？
- [ ] 语义面与数据面是否分离，底层变动不冲击 Agent？
- [ ] SL 口径是否与下层 Ontology 同源，未自造口径？
- [ ] SL 口径是否覆盖 Agent 查询与 RAG 生成两类场景，RAG 生成时是否对齐 SL 口径？

---

**自检（依据 WRITING_STYLE §9）**：本章为何需要？因为 Agent 不应直连裸库，且 RAG 生成也需要口径锚点。数据工程师为何关心？SL 是 Ontology 的工程化实现，是数据工程师最该负责的 Agent 与 RAG 共同消费通道。解决什么问题？让 Agent 经稳定语义接口取数据、RAG 生成时对齐口径，口径统一、字段改名不崩。属哪一 DDA 层？Semantic Layer。改变什么架构？把数据消费从裸 SQL 转为语义 API，语义面与数据面分离，且 SL 成为 Agent 与 RAG 的共同口径锚点。
