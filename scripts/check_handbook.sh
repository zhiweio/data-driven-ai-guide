#!/usr/bin/env bash
# check_handbook.sh -- 术语与规范机械校验入口
#
# 状态：占位，未实现。
#
# 预期校验项（未来实现）：
#   1. 术语一致性：docs/ 下出现的术语译法是否符合 handbook/GLOSSARY.md
#   2. 章节结构：每章是否包含 handbook/WRITING_STYLE.md 第一章的八段结构
#   3. 图引用完整性：每张图是否在正文有引用与解读（handbook/DIAGRAM_GUIDE.md 第五章）
#   4. 禁用词：是否出现 handbook/BOOK_CONSTITUTION.md 第七章的禁用词
#   5. AI 写作痕迹：是否出现 handbook/WRITING_STYLE.md 第八章的 AI 痕迹模式
#
# 用法：./scripts/check_handbook.sh [target_path]
#
# 退出码：0 通过，非 0 有违规。

set -euo pipefail

TARGET="${1:-docs}"

echo "[check_handbook] target: ${TARGET}"
echo "[check_handbook] 状态：占位脚本，未实现任何校验。"
echo "[check_handbook] 规范源：handbook/GLOSSARY.md, WRITING_STYLE.md, DIAGRAM_GUIDE.md, BOOK_CONSTITUTION.md"

# TODO: 实现上述校验项

exit 0
