# diagrams/

存放架构图源文件。

## 用途

存放 Mermaid 无法表达、需要用 HTML+SVG / Draw.io / PlantUML 绘制的图源。

Mermaid 图直接写在 Markdown 代码块里，不存本目录。

## 命名规范

格式：`层名-图名.扩展`

示例：

```
diagrams/
├── ontology-agent-consumption.svg
├── semantic-layer-overview.svg
└── data-loop-closed-loop.svg
```

## 导出格式

每张架构图导出两种格式：

- SVG（进版本库，可缩放）
- PNG（备用，高分辨率）

## 规范依据

`handbook/DIAGRAM_GUIDE.md` 第二章、第四章。
