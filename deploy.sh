#!/bin/bash

# Daily Commit Summarizer 部署脚本
set -e

echo "🚀 Daily Commit Summarizer 部署脚本"
echo "=================================="

# 检查依赖
command -v git >/dev/null 2>&1 || { echo "❌ 请先安装 git"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "❌ 请先安装 Node.js"; exit 1; }

# 1. 安装依赖
echo "📦 安装依赖..."
npm install

# 2. 创建 .env 模板
echo "📝 创建环境配置文件..."
cat > .env.example << EOF
# OpenAI 配置
OPENAI_API_KEY=your-openai-api-key-here
OPENAI_BASE_URL=https://api.openai.com

# 飞书机器人配置
LARK_WEBHOOK_URL=https://open.feishu.cn/open-apis/bot/v2/hook/32e4e17b-5a9f-40ee-ab4f-64d434cafbd4

# 仓库配置
REPO=your-username/your-repo-name

# 可选配置
MODEL_NAME=gpt-4.1-mini
PER_BRANCH_LIMIT=200
DIFF_CHUNK_MAX_CHARS=80000
TZ=Asia/Shanghai
EOF

# 3. 检查配置文件
if [ ! -f ".env" ]; then
    echo "⚠️  请复制 .env.example 为 .env 并填入你的配置"
    cp .env.example .env
fi

# 4. 本地测试
echo "🧪 运行本地测试..."
npx tsx scripts/daily-summary.ts || echo "⚠️  测试运行失败，请检查配置"

echo ""
echo "✅ 部署完成！"
echo ""
echo "下一步:"
echo "1. 编辑 .env 文件，填入你的API密钥"
echo "2. 测试运行: npx tsx scripts/daily-summary.ts"
echo "3. 配置GitHub Actions: 复制 .github/workflows/daily-summary.yml"
echo "4. 在GitHub Secrets中添加环境变量"