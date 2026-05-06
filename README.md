# Rime Weasel Config

一套可跨平台导入的 Rime 配置，适配 Windows 小狼毫（Weasel）、macOS 鼠须管（Squirrel）和 Linux Rime（Fcitx5 / iBus），包含雾凇拼音补丁、万象语言模型配置、分层个人词库、技术词置顶和一键导入脚本。

## 快速开始

Windows:

```powershell
git clone https://github.com/xbh-ux/rime-weasel-conf.git
cd rime-weasel-conf
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

macOS / Linux:

```bash
git clone https://github.com/xbh-ux/rime-weasel-conf.git
cd rime-weasel-conf
chmod +x install.sh scripts/redeploy-rime.sh
./install.sh
```

说明：

- `git clone` 不会自动导入输入法
- 运行安装脚本后会自动备份当前配置、复制文件到 Rime 用户目录、并重新加载输入法
- 仓库已内置万象语言模型分片（单片约 45MB），安装脚本会自动还原成 `wanxiang-lts-zh-hans.gram`
- Windows 默认目录：`%APPDATA%\Rime`
- macOS 默认目录：`~/Library/Rime`
- Linux 默认目录：`~/.local/share/fcitx5/rime` 或 `~/.config/ibus/rime`

## 包含内容

- `default.custom.yaml`：默认方案列表与菜单配置
- `rime_ice.custom.yaml`：雾凇拼音算法、用户学习、万象语言模型、技术词置顶
- `rime_ice.dict.yaml`：主词库入口，已挂载 `cn_dicts/mydict`
- `cn_dicts/mydict*.dict.yaml`：分层词库
- `custom_phrase.txt`：快捷短语模板
- `weasel.custom.yaml`：Windows 小狼毫主题与应用默认英文模式（当前默认夜间模式）
- `squirrel.custom.yaml`：macOS 鼠须管主题
- `install.ps1`：一键安装到 `%APPDATA%\Rime`
- `install.sh`：一键安装到 macOS / Linux Rime 用户目录
- `scripts/redeploy-rime.ps1`：一键部署并检查配置是否生效
- `scripts/redeploy-rime.sh`：macOS / Linux 重新加载与检查脚本
- `scripts/backup-rime.*`：备份当前 Rime 配置与用户学习数据
- `scripts/restore-rime.*`：从备份恢复 Rime 配置
- `scripts/switch-theme.*`：切换输入法主题模式并自动重新部署
- `scripts/build-custom-phrase.*`：从 `phrases/` 目录生成 `custom_phrase.txt`
- `phrases/`：按场景分层维护快捷短语源文件
- `model_chunks/`：万象语言模型分片文件（单片约 45MB），安装时自动合并

## 一键导入

Windows:

```powershell
git clone https://github.com/xbh-ux/rime-weasel-conf.git
cd rime-weasel-conf
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

macOS / Linux:

```bash
git clone https://github.com/xbh-ux/rime-weasel-conf.git
cd rime-weasel-conf
chmod +x install.sh scripts/redeploy-rime.sh
./install.sh
```

脚本会自动备份你当前的 Rime 配置，然后复制本仓库配置到对应用户目录。

Windows 默认目录：`%APPDATA%\Rime`  
macOS 默认目录：`~/Library/Rime`  
Linux 默认目录：
`~/.local/share/fcitx5/rime` 或 `~/.config/ibus/rime`

## 日常重新部署

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\redeploy-rime.ps1
```

```bash
./scripts/redeploy-rime.sh
```

## 维护脚本

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\backup-rime.ps1
powershell -ExecutionPolicy Bypass -File .\scripts\switch-theme.ps1 -Mode dark
powershell -ExecutionPolicy Bypass -File .\scripts\switch-theme.ps1 -Mode light
powershell -ExecutionPolicy Bypass -File .\scripts\build-custom-phrase.ps1
```

macOS / Linux:

```bash
./scripts/backup-rime.sh
./scripts/switch-theme.sh dark
./scripts/switch-theme.sh light
./scripts/build-custom-phrase.sh
```

检查项包括：

- 万象语言模型是否写入最终 schema
- 上下文建议是否启用
- 用户学习是否启用
- 个人词库是否挂载
- macOS Light 主题是否生效

## 个性化

安装前建议修改：

- `custom_phrase.txt` 中的 `YOUR_EMAIL@example.com`、`YOUR_NAME`、路径占位符
- `cn_dicts/mydict_personal.dict.yaml` 中的 `你的名字`
- `weasel.custom.yaml` / `squirrel.custom.yaml` 中的主题和前端样式
- 如果想让 Windows 小狼毫候选框字体更接近 macOS，请先在系统中安装 `SF Pro Text` 或 `PingFang SC`

## 注意

本仓库已包含 `wanxiang-lts-zh-hans.gram` 的分片文件，安装脚本会自动还原模型。

`git clone` 本身不会自动导入到输入法，这是出于系统安全限制。当前仓库已经做到最接近的一键导入体验：`clone` 后执行一条安装命令即可自动复制、备份并重新加载配置。
