# BoardLink

BoardLink 是一个面向 Codex 使用场景的跨平台命令行工具，用来通过 SSH 控制 Linux 开发板。
当前版本已经可以连接 RK3578/RK3576 类开发板，执行命令、上传文件和运行程序。

它的目标是成为 Codex 与开发板之间的执行桥梁：用户可以用自然语言告诉 Codex 想在开发板上完成什么，Codex 再调用 BoardLink，把命令发送到开发板执行。

BoardLink 不是 Codex 官方产品，也不包含 Codex 模型本身。它负责的是“连接开发板并执行操作”；Codex 负责理解用户意图、规划步骤和生成命令。

## 它解决什么问题？

传统方式是：你手动打开 SSH，连接开发板，再输入命令。

BoardLink 把这条连接和命令传输过程封装起来，让你可以直接使用：

```text
输入 BoardLink 命令
        ↓
自动通过 SSH 连接开发板
        ↓
开发板执行命令
        ↓
结果返回到 Windows
```

它是一个“远程控制通道”，不是人工智能模型，也不是 RKNN 转换工具。

## 和 Codex 的关系

BoardLink 专门适合作为 Codex 的远程执行层使用。典型工作流程如下：

```text
用户用自然语言提出任务
        ↓
Codex 理解任务并生成操作步骤
        ↓
Codex 调用 BoardLink
        ↓
BoardLink 通过 SSH 连接开发板
        ↓
开发板执行命令并返回结果
        ↓
Codex 根据结果继续工作或向用户汇报
```

例如，用户可以让 Codex“查看开发板磁盘空间”或“上传并运行一个 Python 程序”。Codex 可以通过 BoardLink 执行对应的 `df -h`、文件上传和 `python3` 命令。

当前版本首先提供稳定、清晰的命令行入口，便于 Codex CLI 或其他能够运行终端命令的 Codex 工作流调用；后续可以继续增加专用工具接口，让调用过程更加自动化。

## 当前功能

### 1. 远程执行命令

在开发板上查看主机名、系统版本、磁盘空间等：

```powershell
boardlink "hostname"
boardlink "uname -a"
boardlink "df -h"
```

### 2. 上传文件

把 Windows 文件上传到开发板：

```powershell
boardlink upload "Desktop\hello.py" "/root/hello.py"
```

### 3. 运行开发板上的程序

先上传，再让开发板运行：

```powershell
boardlink "python3 /root/hello.py"
```

因此它可以形成这样的流程：

```text
电脑上的程序 → 上传到开发板 → 开发板运行 → 返回运行结果
```

## 在 macOS 和 MobaXterm 中使用

项目提供了跨平台的 Bash 入口脚本 `boardlink`。它可以在 macOS 的“终端”、Linux 终端，以及 MobaXterm 的本地终端中使用。

### macOS

macOS 通常已经自带 SSH 和 SCP。进入项目目录后设置连接信息：

```bash
export BOARDLINK_USER=root
export BOARDLINK_HOST=192.168.1.179
chmod +x boardlink
```

然后使用：

```bash
./boardlink "uname -a"
./boardlink "df -h"
./boardlink upload "$HOME/Desktop/hello.py" "/root/hello.py"
```

如果希望在任意目录直接输入 `boardlink`，可以把项目目录加入 PATH：

```bash
export PATH="$PATH:$HOME/BoardLink"
boardlink "uname -a"
```

也可以把这行 `export PATH=...` 写入 `~/.zshrc`，以后每次打开终端都能直接使用。

### MobaXterm

MobaXterm 使用下面的同一套 Bash 入口脚本：

进入项目目录后先设置连接信息：

```bash
export BOARDLINK_USER=root
export BOARDLINK_HOST=192.168.1.179
chmod +x boardlink
```

然后使用：

```bash
./boardlink "uname -a"
./boardlink "df -h"
./boardlink upload "/drives/c/Users/你的用户名/Desktop/hello.py" "/root/hello.py"
```

如果希望在任意目录直接输入 `boardlink`，可以把项目目录加入当前 MobaXterm 会话的 PATH：

```bash
export PATH="$PATH:/drives/c/Users/你的用户名/Documents/ChatGPT/boardlink"
boardlink "uname -a"
```

MobaXterm 中的 Windows 磁盘通常以 `/drives/c/`、`/drives/d/` 这样的路径表示。

## 使用前准备

- Windows PowerShell、macOS 终端，或 MobaXterm
- Windows 自带或已安装的 OpenSSH（包含 `ssh` 和 `scp`）
- macOS/Linux 通常已经自带 `ssh` 和 `scp`
- 一块可以联网的 Linux 开发板
- 已经配置好的 SSH 密钥登录

## 配置开发板连接

在 PowerShell 中设置当前窗口使用的开发板地址：

```powershell
$env:BOARDLINK_USER = "root"
$env:BOARDLINK_HOST = "192.168.1.179"
```

其中：

- `BOARDLINK_USER` 是开发板登录用户名
- `BOARDLINK_HOST` 是开发板 IP 地址

上面的 IP 只是示例，请替换成你自己的地址。

## 安全注意事项

- 不要把 SSH 私钥、密码提交到公开仓库。
- 不要把个人开发板的连接密码写进代码。
- 本项目使用环境变量保存开发板地址和用户名。
- 公开仓库中的命令都可能在远程设备上产生实际影响，执行前请确认命令内容。

## 当前限制和后续计划

当前版本是最小可用版本，后续可以增加：

- 从开发板下载文件
- 查看和持续追踪日志
- 执行脚本和复杂任务
- 失败重试
- 更安全的命令确认机制
- 让 Codex 以专用工具形式更方便地调用 BoardLink
