# assets/

存放仓库级静态资源（非 MkDocs 构建内容）。

## 与 docs/assets/ 的区别

- `docs/assets/` -- MkDocs 构建时复制到站点的静态资源（如 `javascripts/mathjax.js`）。
- `assets/`（本目录）-- 仓库级原始素材，不进站点构建。

## 用途

- 原始图片素材
- 案例数据样本
- 外部引用的配置样例

## 命名规范

按所属 DDA 层分组：

```
assets/
├── foundation/
├── ontology/
├── semantic-layer/
├── rag/
├── agent/
└── data-loop/
```

## 规范依据

`handbook/DIAGRAM_GUIDE.md` 第二章。
