# Rime Weasel Config

一套面向小狼毫（Weasel）的 Rime 配置，包含雾凇拼音补丁、万象语言模型配置、分层个人词库、技术词置顶、macOS Light 风格主题和一键导入脚本。

## 包含内容

- `default.custom.yaml`：默认方案列表与菜单配置
- `rime_ice.custom.yaml`：雾凇拼音算法、用户学习、万象语言模型、技术词置顶
- `rime_ice.dict.yaml`：主词库入口，已挂载 `cn_dicts/mydict`
- `cn_dicts/mydict*.dict.yaml`：分层词库
- `custom_phrase.txt`：快捷短语模板
- `weasel.custom.yaml`：小狼毫主题与应用默认英文模式
- `install.ps1`：一键安装到 `%APPDATA%\Rime`
- `scripts/redeploy-rime.ps1`：一键部署并检查配置是否生效

## 一键导入

在 PowerShell 中运行：

```powershell
git clone https://github.com/YOUR_NAME/rime-weasel-config.git
cd rime-weasel-config
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

脚本会自动备份你当前的 Rime 配置到 `%APPDATA%\Rime\backup-from-github-时间戳`，然后复制本仓库配置并部署小狼毫。

## 日常重新部署

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\redeploy-rime.ps1
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
- `weasel.custom.yaml` 中的应用英文模式列表

## 注意

本仓库不包含 `wanxiang-lts-zh-hans.gram` 大模型文件。请先在目标机器的小狼毫用户目录放置对应 `.gram` 文件，或者修改 `rime_ice.custom.yaml` 中的 `grammar/language`。
