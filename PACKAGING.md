# 打包和发布指南 / Packaging and Publishing Guide

本文档说明如何打包和发布 STARLIMS VS Code 扩展。

This document explains how to package and publish the STARLIMS VS Code extension.

## 目录 / Table of Contents

- [中文版本](#中文版本)
  - [环境要求](#环境要求)
  - [本地打包](#本地打包)
  - [自动发布](#自动发布)
  - [手动发布](#手动发布)
- [English Version](#english-version)
  - [Prerequisites](#prerequisites)
  - [Local Packaging](#local-packaging)
  - [Automated Publishing](#automated-publishing)
  - [Manual Publishing](#manual-publishing)

---

## 中文版本

### 环境要求

打包和发布扩展之前，请确保已安装以下工具：

- **Node.js** (16.x, 18.x, 或 22.x)
- **npm** (随 Node.js 一起安装)
- **Git** (用于版本控制)
- **@vscode/vsce** (VS Code 扩展打包工具)

#### 安装依赖

```bash
# 1. 克隆仓库
git clone https://github.com/mariuspopovici/starlimsvscode.git
cd starlimsvscode

# 2. 安装项目依赖
npm install

# 3. 全局安装 vsce 打包工具
npm install -g @vscode/vsce
```

### 本地打包

要创建 VSIX 安装包（可用于本地安装或分发），请按以下步骤操作：

#### 方法一：使用 npm 脚本（推荐）

```bash
# 执行完整的构建流程（包括后端脚本打包）
npm run build
```

此命令会：
1. 清理 `out` 目录
2. 复制 `package.json` 到 `out` 目录
3. 运行 `create-packages.sh` 生成后端 SCM_API.sdp 包
4. 使用 webpack 编译和打包代码
5. 创建 VSIX 文件（例如：`vscode-starlims-1.2.102.vsix`）

生成的文件位于项目根目录，命名格式为：`vscode-starlims-<版本号>.vsix`

#### 方法二：分步执行

```bash
# 1. 代码检查
npm run lint

# 2. 编译代码
npm run compile

# 3. 生产环境打包
npm run package

# 4. 生成后端包
cd src/backend
./create-packages.sh
cd ../..

# 5. 创建 VSIX 包
vsce package
```

#### Windows 用户

Windows 用户可以使用专门的构建命令：

```bash
npm run build-windows
```

### 自动发布

本仓库配置了 GitHub Actions 自动发布工作流。当代码推送到 `master` 分支时，会自动执行以下操作：

1. **自动版本升级**：使用 `npm version patch` 自动升级补丁版本号
2. **构建 VSIX 包**：编译和打包扩展
3. **发布到 VS Code Marketplace**：自动上传到官方市场
4. **创建 GitHub Release**：创建新版本标签和发布说明
5. **上传发布资源**：包含 VSIX 文件和 SCM_API.sdp 后端包

**注意**：自动发布需要在 GitHub 仓库设置中配置 `VSCODE_MARKETPLACE_TOKEN` 密钥。

#### 工作流文件位置

- `.github/workflows/publish.yml` - 发布工作流
- `.github/workflows/webpack.yml` - 构建验证工作流

### 手动发布

如果需要手动发布到 VS Code Marketplace：

#### 1. 获取发布令牌

首先需要从 [Visual Studio Marketplace](https://marketplace.visualstudio.com/manage) 获取个人访问令牌（PAT）。

步骤：
1. 访问 https://marketplace.visualstudio.com/manage
2. 登录您的发布者账号
3. 创建个人访问令牌
4. 保存令牌（只显示一次）

#### 2. 版本升级

```bash
# 升级补丁版本 (1.2.102 -> 1.2.103)
npm version patch

# 升级次要版本 (1.2.102 -> 1.3.0)
npm version minor

# 升级主要版本 (1.2.102 -> 2.0.0)
npm version major
```

#### 3. 构建和发布

```bash
# 构建 VSIX 包
npm run build

# 发布到 Marketplace
vsce publish -p <您的访问令牌>

# 或者使用环境变量
export VSCODE_MARKETPLACE_TOKEN=<您的访问令牌>
vsce publish
```

#### 4. 推送到 GitHub

```bash
# 推送代码和标签
git push origin master
git push origin --tags
```

#### 5. 创建 GitHub Release

1. 访问仓库的 [Releases 页面](https://github.com/mariuspopovici/starlimsvscode/releases)
2. 点击 "Draft a new release"
3. 选择刚创建的版本标签
4. 上传 VSIX 文件和 `src/backend/SCM_API.sdp` 文件
5. 编写发布说明
6. 发布

### 验证发布

发布后，可以通过以下方式验证：

1. **VS Code Marketplace**：访问 https://marketplace.visualstudio.com/items?itemName=MariusPopovici.vscode-starlims
2. **本地安装**：在 VS Code 中搜索 "STARLIMS" 或使用命令 `code --install-extension vscode-starlims-<版本号>.vsix`
3. **GitHub Releases**：检查 https://github.com/mariuspopovici/starlimsvscode/releases

### 常见问题

#### Q: 为什么需要 SCM_API.sdp 文件？

A: SCM_API.sdp 是 STARLIMS 后端包，包含服务器端脚本和 API 实现。用户需要将此包导入到 STARLIMS Designer 中才能使用扩展的完整功能。

#### Q: 构建时出现 Express 警告是什么意思？

A: `Critical dependency: the request of a dependency is an expression` 警告是 Express 框架的已知问题，不影响扩展的正常功能，可以安全忽略。

#### Q: 如何跳过版本升级？

A: 可以使用 `--no-git-tag-version` 参数：
```bash
npm version patch --no-git-tag-version
```

---

## English Version

### Prerequisites

Before packaging and publishing the extension, ensure you have the following tools installed:

- **Node.js** (16.x, 18.x, or 22.x)
- **npm** (included with Node.js)
- **Git** (for version control)
- **@vscode/vsce** (VS Code Extension packaging tool)

#### Install Dependencies

```bash
# 1. Clone the repository
git clone https://github.com/mariuspopovici/starlimsvscode.git
cd starlimsvscode

# 2. Install project dependencies
npm install

# 3. Install vsce packaging tool globally
npm install -g @vscode/vsce
```

### Local Packaging

To create a VSIX package (for local installation or distribution), follow these steps:

#### Method 1: Using npm Scripts (Recommended)

```bash
# Execute the complete build process (including backend script packaging)
npm run build
```

This command will:
1. Clean the `out` directory
2. Copy `package.json` to the `out` directory
3. Run `create-packages.sh` to generate the backend SCM_API.sdp package
4. Compile and bundle code using webpack
5. Create the VSIX file (e.g., `vscode-starlims-1.2.102.vsix`)

The generated file will be in the project root directory with the naming format: `vscode-starlims-<version>.vsix`

#### Method 2: Step-by-Step Execution

```bash
# 1. Lint code
npm run lint

# 2. Compile code
npm run compile

# 3. Production packaging
npm run package

# 4. Generate backend package
cd src/backend
./create-packages.sh
cd ../..

# 5. Create VSIX package
vsce package
```

#### For Windows Users

Windows users can use the dedicated build command:

```bash
npm run build-windows
```

### Automated Publishing

This repository is configured with GitHub Actions automated publishing workflow. When code is pushed to the `master` branch, the following operations are automatically executed:

1. **Automatic Version Bump**: Automatically increments patch version using `npm version patch`
2. **Build VSIX Package**: Compiles and packages the extension
3. **Publish to VS Code Marketplace**: Automatically uploads to the official marketplace
4. **Create GitHub Release**: Creates new version tag and release notes
5. **Upload Release Assets**: Includes VSIX file and SCM_API.sdp backend package

**Note**: Automated publishing requires the `VSCODE_MARKETPLACE_TOKEN` secret to be configured in GitHub repository settings.

#### Workflow File Locations

- `.github/workflows/publish.yml` - Publishing workflow
- `.github/workflows/webpack.yml` - Build validation workflow

### Manual Publishing

If you need to manually publish to the VS Code Marketplace:

#### 1. Obtain Publishing Token

First, you need to obtain a Personal Access Token (PAT) from [Visual Studio Marketplace](https://marketplace.visualstudio.com/manage).

Steps:
1. Visit https://marketplace.visualstudio.com/manage
2. Sign in to your publisher account
3. Create a personal access token
4. Save the token (shown only once)

#### 2. Version Bump

```bash
# Bump patch version (1.2.102 -> 1.2.103)
npm version patch

# Bump minor version (1.2.102 -> 1.3.0)
npm version minor

# Bump major version (1.2.102 -> 2.0.0)
npm version major
```

#### 3. Build and Publish

```bash
# Build VSIX package
npm run build

# Publish to Marketplace
vsce publish -p <your-access-token>

# Or use environment variable
export VSCODE_MARKETPLACE_TOKEN=<your-access-token>
vsce publish
```

#### 4. Push to GitHub

```bash
# Push code and tags
git push origin master
git push origin --tags
```

#### 5. Create GitHub Release

1. Visit the repository's [Releases page](https://github.com/mariuspopovici/starlimsvscode/releases)
2. Click "Draft a new release"
3. Select the newly created version tag
4. Upload the VSIX file and `src/backend/SCM_API.sdp` file
5. Write release notes
6. Publish

### Verify Publication

After publishing, you can verify through:

1. **VS Code Marketplace**: Visit https://marketplace.visualstudio.com/items?itemName=MariusPopovici.vscode-starlims
2. **Local Installation**: Search for "STARLIMS" in VS Code or use command `code --install-extension vscode-starlims-<version>.vsix`
3. **GitHub Releases**: Check https://github.com/mariuspopovici/starlimsvscode/releases

### Common Questions

#### Q: Why is the SCM_API.sdp file needed?

A: SCM_API.sdp is the STARLIMS backend package containing server-side scripts and API implementation. Users need to import this package into STARLIMS Designer to use the full functionality of the extension.

#### Q: What does the Express warning during build mean?

A: The `Critical dependency: the request of a dependency is an expression` warning is a known issue with the Express framework and does not affect the extension's normal functionality. It can be safely ignored.

#### Q: How can I skip version bumping?

A: You can use the `--no-git-tag-version` parameter:
```bash
npm version patch --no-git-tag-version
```

## Additional Resources

- [VS Code Extension Publishing Documentation](https://code.visualstudio.com/api/working-with-extensions/publishing-extension)
- [vsce CLI Documentation](https://github.com/microsoft/vscode-vsce)
- [Semantic Versioning](https://semver.org/)
