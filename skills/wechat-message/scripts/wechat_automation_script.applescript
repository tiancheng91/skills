#!/usr/bin/osascript

-- 微信自动化脚本 - 发送消息给联系人
-- 用法: osascript wechat_automation_script.applescript [用户名] [消息内容]
-- 如果不传参数,则从剪切板获取用户名和消息内容
-- 参数说明:
--   $1: 用户名 (可选,不传则从剪切板获取)
--   $2: 消息内容 (可选,不传则从剪切板获取)

on run argv
    -- 获取用户名参数
    set userName to ""
    if (count of argv) >= 1 then
        set userName to item 1 of argv
    end if

    -- 获取消息内容参数
    set messageText to ""
    if (count of argv) >= 2 then
        set messageText to item 2 of argv
    end if

    -- 确保微信处于最前面
    tell application "WeChat"
        activate
    end tell

    delay 2

    -- 使用快捷键 Cmd+F 打开搜索框
    tell application "System Events"
        tell process "WeChat"
            keystroke "f" using {command down}
        end tell
    end tell

    delay 1.5

    -- 输入用户名（使用剪切板粘贴方式）
    if userName is not "" then
        -- 如果提供了用户名参数,先存入剪切板
        set the clipboard to userName
    end if
    -- 直接使用 Cmd+V 粘贴用户名（无论是否提供参数,都使用粘贴方式）
    tell application "System Events"
        tell process "WeChat"
            keystroke "v" using {command down}
        end tell
    end tell

    delay 2

    -- 按回车选择第一个联系人
    tell application "System Events"
        tell process "WeChat"
            keystroke return
        end tell
    end tell

    delay 1.5

    -- 关键：点击微信窗口右下角区域，确保焦点移动到聊天输入框
    tell application "System Events"
        tell process "WeChat"
            set windowPosition to position of window 1
            set windowSize to size of window 1
            -- 计算右下角位置（窗口宽度-20, 窗口高度-20）
            set xCoord to (item 1 of windowPosition) + (item 1 of windowSize) - 20
            set yCoord to (item 2 of windowPosition) + (item 2 of windowSize) - 20
        end tell
    end tell
    -- 使用 cliclick 执行鼠标点击
    do shell script "/opt/homebrew/bin/cliclick c:" & xCoord & "," & yCoord

    delay 1

    -- 处理消息内容
    if messageText is not "" then
        -- 如果提供了消息内容参数,存入剪切板
        set the clipboard to messageText
    end if
    -- 使用 Cmd+V 粘贴消息（无论是否提供参数,都使用粘贴方式）
    tell application "System Events"
        tell process "WeChat"
            keystroke "v" using {command down}
        end tell
    end tell

    delay 2

    -- 按回车发送消息
    tell application "System Events"
        tell process "WeChat"
            keystroke return
        end tell
    end tell

    delay 1

    -- 再按一次回车确保发送
    tell application "System Events"
        tell process "WeChat"
            keystroke return
        end tell
    end tell

    delay 3

    -- 隐藏微信窗口（使用 Cmd+H）
    tell application "System Events"
        tell process "WeChat"
            keystroke "h" using {command down}
        end tell
    end tell

    return "微信消息发送完成"
end run
