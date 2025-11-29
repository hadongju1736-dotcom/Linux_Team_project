#!/bin/bash

# ===== 설정 =====
ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"

# ===== 함수: 날짜 형식 검증 =====
validate_date() {
    date -d "$1" "+%Y-%m-%d" >/dev/null 2>&1
    return $?
}
# 'date'는 날짜 정보를 표시, 설정하는 명령어

# ===== 메인 로직 =====
echo "=== 새 과제 폴더 만들기 ==="

# 과제명 입력
read -p "과제(과목) 이름을 입력하세요: " NAME
if [[ -z "$NAME" ]]; then
    echo "[오류] 과제 이름은 비어 있을 수 없습니다."
    exit 1
fi

# 마감 날짜 입력
read -p "마감 날짜를 입력하세요 (YYYY-MM-DD): " DEADLINE

# 날짜 검증
if ! validate_date "$DEADLINE"; then
    echo "[오류] 날짜 형식이 잘못되었습니다. 예: 2025-03-21"
    exit 1
fi

# 과제 폴더 경로 생성
FOLDER_NAME="${DEADLINE}_${NAME}"
TARGET_DIR="$ASSIGNMENT_ROOT/$FOLDER_NAME"

# 중복 체크
if [[ -d "$TARGET_DIR" ]]; then
    echo "[오류] 이미 존재하는 과제입니다: $TARGET_DIR"
    exit 1
fi

echo "폴더 생성 중..."
mkdir -p "$TARGET_DIR/source_code" # 소스 코드를 저장할 폴더
mkdir -p "$TARGET_DIR/reports"
# 보고서를 저장할 폴더

# README 자동 생성
cat <<EOF > "$TARGET_DIR/README.md"
# $NAME
- **마감일**: $DEADLINE
- 생성일: $(date '+%Y-%m-%d %H:%M')

## 폴더 구조
- /source_code  : 소스 코드
- /repots : 보고서, 문서(.docs, .hwpx)

EOF

echo "완료! 생성된 과제 폴더:"
echo "$TARGET_DIR"
echo ""
echo "기본 구조:"
echo " ├─ src/"
echo " └─ docs/"
