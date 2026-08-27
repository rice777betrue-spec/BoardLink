# BoardLink

BoardLink 是一款面向 Codex 使用场景的跨平台命令行工具。
它通过 SSH 连接 Linux 开发板，让 Codex 可以执行命令、上传文件和运行程序。

支持：Windows、macOS、Linux 和 MobaXterm。

## 功能

```text
Codex → BoardLink → SSH → Linux 开发板
```

- 执行开发板命令
- 上传本地文件
- 下载开发板文件
- 运行开发板上的程序
- 返回执行结果，方便 Codex 继续工作
- 检查本地环境和开发板连接

## 使用示例

```text
boardlink "uname -a"
boardlink "df -h"
boardlink upload "本地文件路径" "/root/目标路径"
boardlink download "/root/远程文件路径" "本地文件路径"
boardlink "python3 /root/hello.py"
boardlink doctor
```

## 首次配置

需要先在电脑和开发板之间配置好 SSH 密钥登录，然后设置两个环境变量：

```text
BOARDLINK_USER=root
BOARDLINK_HOST=开发板IP地址
```

Windows 使用 `boardlink.cmd`，macOS、Linux 和 MobaXterm 使用 `boardlink`。
详细配置、文件结构和开发说明请查看 [技术文档.txt](技术文档.txt)。

BoardLink 不是 Codex 官方产品，也不包含 Codex 模型本身；它是 Codex 连接和操作远程开发板的执行工具。

## 安全提醒

不要把 SSH 私钥、密码或真实敏感配置提交到公开仓库。
