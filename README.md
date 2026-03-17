# Skills

Agent Skills 集合，为 AI 助手提供专项能力扩展。

## 技能列表

| 技能 | 描述 |
|------|------|
| [wechat-msg-send](./skills/wechat-msg-send) | 微信消息自动化发送 |
| [stock-sdk-mcp](./skills/stock-sdk-mcp) | 股票行情数据服务 |
| [xiaomi-cam-snapshot](./skills/xiaomi-cam-snapshot) | 小米摄像头截图 |

---

## wechat-msg-send

微信消息自动化发送技能，支持 macOS 和 Windows 平台。

**功能特性：**
- 自动激活微信应用
- 搜索指定联系人或群组
- 发送指定消息内容
- 支持中文和特殊字符

**平台支持：**
- macOS：AppleScript + cliclick
- Windows：PowerShell

**快速使用：**
```bash
# macOS
osascript scripts/wechat_automation_script.applescript "联系人名称" "消息内容"

# Windows
powershell -ExecutionPolicy Bypass -File scripts/wechat_automation_script.ps1 "联系人名称" "消息内容"
```

**macOS 前置依赖：**
```bash
brew install cliclick
```

---

## stock-sdk-mcp

股票行情数据服务，支持 A股/港股/美股/基金的实时行情、K线数据、技术指标计算。

**支持市场：**
- A股：沪深北交易所、科创板、创业板
- 港股：香港交易所
- 美股：纳斯达克、纽交所
- 基金：公募基金

**核心功能：**
- 实时行情查询
- K线数据获取
- 技术指标计算（MACD、RSI、KDJ等）
- 板块数据查询
- 资金流向分析

**快速使用：**
```bash
# 查询股票行情
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-quotes-by-query --queries '["茅台", "腾讯"]'

# 获取K线+技术指标
uvx mcp2cli --mcp-stdio "npx -y stock-sdk-mcp" get-kline-with-indicators --symbol "600519" --indicators '{"macd":true}'
```

---

## xiaomi-cam-snapshot

小米摄像头实时画面截图技能，通过 Miloco 后端服务获取截图。

**功能特性：**
- 列出所有摄像头设备
- 获取指定摄像头截图
- 支持自定义文件名
- 支持循环监控模式

**快速使用：**
```bash
# 列出摄像头
python scripts/camera_client.py --server http://localhost:8001 --password YOUR_PASSWORD --list

# 获取截图
python scripts/camera_client.py --server http://localhost:8001 --password YOUR_PASSWORD --camera-id "CAMERA_ID" --output ./images
```

**前置要求：**
- 启动 Miloco Docker 服务
- 完成小米账号认证

---

## 目录结构

```
skills/
├── README.md                    # 本文件
└── skills/
    ├── wechat-msg-send/         # 微信消息发送
    │   ├── SKILL.md
    │   └── scripts/
    ├── stock-sdk-mcp/           # 股票行情服务
    │   └── SKILL.md
    └── xiaomi-cam-snapshot/     # 小米摄像头截图
        ├── SKILL.md
        └── scripts/
```

## 如何使用

每个技能目录下的 `SKILL.md` 文件包含详细的使用说明、参数配置和故障排除指南。
