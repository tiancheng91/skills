# 🔍 股票筛选器

## 描述

智能股票筛选助手，能够从全市场数千只股票中，按照用户指定的条件快速筛选出符合要求的股票列表。

## 触发场景

- "找出今天涨幅超过 5% 的科创板股票"
- "筛选市盈率低于 20 的银行股"
- "今天哪些股票涨停了？"
- "找出成交量最大的前 10 只 A 股"
- "人工智能概念里涨幅最高的股票有哪些？"
- "帮我找低估值蓝筹"

## 执行步骤

### 步骤 1: 理解筛选条件

解析用户的自然语言，提取筛选条件：

| 条件类型 | 示例 |
|----------|------|
| 市场范围 | A股/港股/美股/科创板/创业板 |
| 涨跌幅条件 | 涨幅 > 5% / 涨停 / 跌停 |
| 估值条件 | 市盈率 < 20 / 市净率 < 2 |
| 规模条件 | 市值 > 500亿 |
| 成交条件 | 成交量、换手率 |
| 排序要求 | 按涨幅/成交额/市值排序 |

### 步骤 2: 获取全市场数据

**A 股（按市场筛选）**：
```bash
# 全部A股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes

# 科创板
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market kc

# 创业板
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market cy
```

**港股/美股**：
```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-hk-quotes
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-us-quotes --market nasdaq
```

**板块成分股**：
```bash
# 概念板块
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-concept-constituents --symbol "人工智能"

# 行业板块
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-industry-constituents --symbol "银行"
```

### 步骤 3: 数据筛选

对获取到的数据按用户条件进行筛选：

```javascript
// 示例筛选逻辑
results = allQuotes.filter(stock => {
  // 涨幅条件
  if (minChangePercent && stock.changePercent < minChangePercent) return false;
  if (maxChangePercent && stock.changePercent > maxChangePercent) return false;

  // 市盈率条件（过滤负值）
  if (maxPE && (stock.pe <= 0 || stock.pe > maxPE)) return false;

  // 市值条件（单位：亿）
  if (minMarketCap && stock.totalMarketCap < minMarketCap) return false;

  return true;
});
```

### 步骤 4: 排序

按用户要求排序：
- 按涨幅排序：`sort((a, b) => b.changePercent - a.changePercent)`
- 按成交额排序：`sort((a, b) => b.amount - a.amount)`
- 按市值排序：`sort((a, b) => b.totalMarketCap - a.totalMarketCap)`

### 步骤 5: 输出结果

```markdown
## 📋 筛选结果

**筛选条件**：科创板 + 今日涨幅 > 5%
**结果数量**：15 只

| 排名 | 代码 | 名称 | 现价 | 涨跌幅 | 成交额(亿) | 市盈率 |
|------|------|------|------|--------|------------|--------|
| 1 | 688XXX | XXX | 88.88 | +12.5% | 5.6 | 35.2 |
| 2 | 688XXX | XXX | 66.66 | +10.2% | 3.2 | 28.5 |

💡 **提示**：如需进一步分析某只股票，可以说"分析一下第1只"
```

## 常用筛选策略

| 策略 | 条件 | 实现方式 |
|------|------|----------|
| 涨停板筛选 | 涨跌幅 >= 9.9% | `changePercent >= 9.9` |
| 低估值蓝筹 | 市值 > 500亿 && PE < 15 && PE > 0 | `totalMarketCap > 500 && pe > 0 && pe < 15` |
| 放量突破 | 成交量 > 5日均量*2 && 涨幅 > 3% | 需结合 K 线数据计算 |
| 高换手率 | 换手率 > 10% | `turnoverRate > 10` |

## 示例

**用户**：找出今天涨幅超过 8% 的创业板股票，按成交额排序，给我前 10 只

**执行**：
1. 调用 `get-all-a-share-quotes --market cy` 获取创业板全部股票
2. 筛选涨幅 > 8%
3. 按成交额降序排序
4. 取前 10 只输出表格
