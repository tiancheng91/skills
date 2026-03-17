# 工具参考手册

本文档包含 stock-sdk-mcp 所有工具的详细用法。

---

## 一、实时行情

### `get-quotes-by-query` - 通用行情查询（最推荐）

按名称、代码或拼音查询股票行情，自动识别市场（A股/港股/美股）。

```bash
# 按名称查询
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-quotes-by-query \
  --queries '["茅台", "腾讯", "苹果", "AAPL"]'

# 按代码查询
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-quotes-by-query \
  --queries '["600519", "00700"]'

# 按拼音查询
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-quotes-by-query \
  --queries '["maotai", "tengxun"]'
```

**返回字段**：最新价、涨跌幅、成交量、五档盘口、市盈率、市净率、52周高低点等 40+ 字段。

---

### `get-a-share-quotes` - A股实时行情

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-a-share-quotes \
  --codes '["sh600519", "sz000858"]'
```

---

### `get-hk-quotes` - 港股实时行情

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-hk-quotes \
  --codes '["00700", "09988"]'
```

---

### `get-us-quotes` - 美股实时行情

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-us-quotes \
  --codes '["AAPL", "MSFT", "GOOGL"]'
```

---

### `get-fund-quotes` - 基金实时净值

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-fund-quotes \
  --codes '["000001", "110022"]'
```

---

## 二、批量行情（数据量大，谨慎使用）

### `get-all-a-share-quotes` - 全市场A股行情（5000+只）

```bash
# 获取全部A股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes

# 按市场筛选
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market sh   # 上证
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market sz   # 深证
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market kc   # 科创板
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market cy   # 创业板
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-a-share-quotes --market bj   # 北证
```

---

### `get-all-hk-quotes` - 全市场港股行情（2000+只）

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-hk-quotes
```

---

### `get-all-us-quotes` - 全市场美股行情（8000+只）

```bash
# 全部
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-us-quotes

# 纳斯达克
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-us-quotes --market nasdaq

# 纽交所
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-all-us-quotes --market nyse
```

---

## 三、K线数据

### `get-kline-with-indicators` - 带技术指标的K线（核心工具）

**这是最重要的工具**，服务端直接完成指标计算，返回可分析的数据。

```bash
# 基础用法
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-kline-with-indicators \
  --symbol "600519" \
  --indicators '{"ma":{"periods":[5,10,20]},"macd":true}'

# 港股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-kline-with-indicators \
  --symbol "00700" \
  --market HK \
  --period weekly \
  --indicators '{"boll":true,"kdj":true}'

# 美股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-kline-with-indicators \
  --symbol "AAPL" \
  --market US \
  --indicators '{"rsi":true}'
```

**参数说明**：
| 参数 | 说明 | 可选值 |
|------|------|--------|
| `--symbol` | 股票代码 | 必填 |
| `--market` | 市场类型 | A(默认), HK, US |
| `--period` | K线周期 | daily, weekly, monthly |
| `--adjust` | 复权类型 | qfq(默认), hfq, 空(不复权) |
| `--start-date` | 开始日期 | YYYYMMDD |
| `--end-date` | 结束日期 | YYYYMMDD |
| `--indicators` | 技术指标配置 | JSON对象 |

**支持的技术指标**：
```json
{
  "ma": { "periods": [5, 10, 20, 60] },
  "macd": true,
  "boll": true,
  "kdj": true,
  "rsi": true,
  "wr": true,
  "bias": true,
  "cci": true,
  "atr": true
}
```

---

### `get-history-kline` - A股历史K线

```bash
# 日线（默认前复权）
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-history-kline \
  --symbol "600519" --period daily

# 周线/月线
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-history-kline \
  --symbol "600519" --period weekly

# 指定日期范围
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-history-kline \
  --symbol "600519" \
  --start-date "20240101" \
  --end-date "20241231"

# 复权类型
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-history-kline \
  --symbol "600519" --adjust qfq   # 前复权（默认）
```

---

### `get-hk-history-kline` - 港股历史K线

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-hk-history-kline \
  --symbol "00700" --period daily
```

---

### `get-us-history-kline` - 美股历史K线

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-us-history-kline \
  --symbol "AAPL" --period daily
```

---

### `get-minute-kline` - A股分钟K线

```bash
# 支持: 1, 5, 15, 30, 60 分钟
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-minute-kline \
  --symbol "600519" --period 5
```

---

### `get-today-timeline` - 当日分时走势

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-today-timeline \
  --symbol "600519"
```

---

## 四、板块数据

### 行业板块

```bash
# 行业板块列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-industry-list

# 行业板块实时行情
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-industry-spot --symbol "小金属"

# 行业板块成分股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-industry-constituents --symbol "小金属"

# 行业板块K线
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-industry-kline --symbol "小金属" --period daily
```

### 概念板块

```bash
# 概念板块列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-concept-list

# 概念板块实时行情
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-concept-spot --symbol "人工智能"

# 概念板块成分股
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-concept-constituents --symbol "人工智能"

# 概念板块K线
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-concept-kline --symbol "人工智能" --period daily
```

---

## 五、搜索与代码列表

### `search-stock` - 股票搜索

```bash
# 按名称搜索
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" search-stock --keyword "茅台"

# 按代码搜索
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" search-stock --keyword "600519"

# 按拼音搜索
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" search-stock --keyword "maotai"
```

---

### 代码列表

```bash
# A股代码列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-a-share-code-list
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-a-share-code-list --market kc  # 科创板

# 港股代码列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-hk-code-list

# 美股代码列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-us-code-list --market nasdaq

# 基金代码列表
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-fund-code-list
```

---

## 六、扩展功能

### `get-fund-flow` - 资金流向

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-fund-flow \
  --codes '["sh600519", "sz000858"]'
```

返回：主力/散户流入流出金额、净流入占比。

---

### `get-panel-large-order` - 盘口大单占比

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-panel-large-order \
  --codes '["sh600519"]'
```

---

### `get-trading-calendar` - 交易日历

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-trading-calendar
```

返回：从1990年至今的所有A股交易日期列表。

---

### `get-dividend-detail` - 分红派送详情

```bash
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-dividend-detail \
  --codes '["sh600519"]'
```

返回：现金分红、送转股份、除权日、派息日等 20+ 维度信息。
