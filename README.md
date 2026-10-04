# 乾坤守护 iOS 壳 App

把 `https://remote-watch.neta.rayae.icu/pages/vehicle/index` 打包成 iOS App 的 WKWebView 壳工程。
Windows 上无法直接编译 iOS 包，本工程通过 **GitHub Actions（免费 macOS 云端）一键打包**，产出**未签名 IPA**，再用免费工具自签后即可安装到 iPhone。

## 项目结构

```
QiankunGuard-IOS/
├── project.yml                        # xcodegen 工程描述（App 名/Bundle ID/权限等）
├── RemoteWatch/
│   ├── AppDelegate.swift              # 程序入口
│   ├── WebViewController.swift        # WebView 壳（首行 startURLString 可改网址）
│   └── Assets.xcassets/               # 图标与主题色
│       └── AppIcon.appiconset/AppIcon1024.png
├── .github/workflows/build-ipa.yml    # 云端打包工作流
└── tools/gen_icon.ps1                 # 图标生成脚本（可选）
```

壳内已实现：加载进度条、下拉刷新、侧滑后退、`alert/confirm/prompt` 弹窗、
`tel/sms/mailto` 跳系统、新窗口链接走 Safari、登录 Cookie 持久化、断网重试页。

## 方式一：云端打包出 IPA（推荐，无需 Mac）

1. 在 GitHub 新建一个仓库（Private 即可），把本目录所有文件上传/推送上去。
   （也可以在 GitHub 网页端直接拖拽上传这些文件）
2. 仓库页 → **Actions** 标签 → 左侧 **Build IPA** → **Run workflow**。
3. 等待约 3~5 分钟，进入该次运行页面，底部 **Artifacts** 下载
   `RemoteWatch-unsigned-ipa`，解压得到 **未签名 IPA**。

## 方式二：签名并安装到 iPhone

未签名 IPA 无法直接安装，必须签名：

| 工具 | 说明 |
|------|------|
| **Sideloadly**（Windows/Mac） | 数据线连 iPhone → 拖入 IPA → 填 Apple ID → Start。免费 Apple ID 每 7 天需重签，每设备最多 3 个自签 App |
| **爱思助手**（Windows） | 工具箱 → IPA 签名/自签 → 用 Apple ID 签名后安装。同样 7 天有效 |
| **AltStore / AltServer** | 安装后手机端可自动续签（需电脑定期在线） |
| **开发者账号（$99/年）** | 签名有效期 1 年，可分发；把证书配进 Xcode/导出流程即可 |

## 方式三：有 Mac 本地打包

```bash
brew install xcodegen
xcodegen generate        # 生成 RemoteWatch.xcodeproj
open RemoteWatch.xcodeproj
```

在 Xcode → Signing & Capabilities 里选择开发者团队后，Product → Archive 即可导出正式签名包。

## 常用修改

- **换网址**：`RemoteWatch/WebViewController.swift` 第 6 行 `startURLString`。
- **改 App 名称**：`project.yml` 中 `CFBundleDisplayName`（当前为「乾坤守护」）。
- **换图标**：替换 `AppIcon1024.png`（1024×1024 PNG），或运行 `tools/gen_icon.ps1` 重新生成。
- **版本号**：`project.yml` 中 `MARKETING_VERSION` / `CURRENT_PROJECT_VERSION`。
- **横屏支持**：`project.yml` 中 `UISupportedInterfaceOrientations` 目前仅竖屏，可按需追加。

改完后重新跑一次 Actions 即可出新的 IPA。

## 常见问题

- **Actions 里找不到 Build IPA？** 确认文件在仓库根目录且 `.github/workflows/build-ipa.yml` 已提交；首次启用需在 Actions 页点击启用。
- **下载的 Artifact 解压出的 `.ipa` 装不上？** 正常，未签名包必须先经 Sideloadly/爱思助手签名。
- **页面某些图片/视频加载不了？** Info.plist 已放开 ATS（允许 http），若仍不行多为站点证书或跨域问题，浏览器里同样打不开。
