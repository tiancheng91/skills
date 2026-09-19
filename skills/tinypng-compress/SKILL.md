---
name: tinypng-compress
description: 使用 TinyPNG/Tinify API 压缩 PNG 图片。当用户要求压缩、优化或减小 PNG 图片文件大小时使用此技能。
---

# PNG 压缩技能

使用 TinyPNG/Tinify API 压缩 PNG 文件。所有逻辑封装在 `scripts/compress.sh` 中，Agent 直接调用脚本即可。

## 前置要求

环境变量需提供：

```bash
TINIFY_API_KEY
```

缺失时，提示用户配置：

```bash
export TINIFY_API_KEY="YOUR_API_KEY"
```

**禁止在任何输出或日志中打印该 Key。**

## 使用方法

```bash
# 单文件（输出 foo.min.png，保留原图）
bash scripts/compress.sh foo.png

# 多文件（顺序处理）
bash scripts/compress.sh a.png b.png assets/logo.png

# 原地压缩（覆盖原图，仅在下载成功后替换）
bash scripts/compress.sh --in-place foo.png
```

| 参数 | 说明 |
|------|------|
| `--in-place` | 原地压缩：先下载到临时文件，成功后再替换原图 |
| `文件路径...` | 一个或多个 PNG 文件路径 |

## 行为规则

- 默认输出 `foo.png -> foo.min.png`，不覆盖原图；多文件时对应生成 `.min.png`。
- 仅处理 PNG 文件，除非用户明确要求其他 Tinify 支持的格式。
- 逐个文件处理；某个文件失败时继续处理剩余文件，结束时汇总失败信息。
- 压缩或下载失败时保留原文件。
- 使用 `curl -f` 使 HTTP 错误直接导致失败；使用 `stat` + `python3` 统计并报告压缩前后大小。
- 只依赖系统自带的 `curl` 与 `python3`，不额外引入依赖。

## 文件结构

```
tinypng-compress/
├── SKILL.md                 # 本技能说明
└── scripts/
    └── compress.sh          # 压缩脚本（curl + python3）
```