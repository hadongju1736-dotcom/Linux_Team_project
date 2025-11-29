#!/bin/bash

if ! command -v zip >/dev/null 2>&1; then
    echo "[오류] zip 명령어가 설치되어 있지 않습니다."
    echo "Git Bash에서 zip을 설치한 후 다시 실행하세요."
    exit 1
fi

echo "=== 완료된 과제 폴더 압축 ==="

# ===== 설정 =====
ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"
OUTPUT_DIR="$ASSIGNMENT_ROOT/compressed"  # 압축 파일 저장 폴더


# 압축할 폴더 입력 / 존재 여부 체크
while true; do
    read -p "압축할 과제 폴더 이름을 입력: " DIR
    if [[ -z "$DIR" ]]; then
        echo "[오류] 폴더 이름을 입력하세요."
        continue
    fi

    TARGET_DIR="$ASSIGNMENT_ROOT/$DIR"

    # 폴더 존재 여부 체크
    if [[ ! -d "$TARGET_DIR" ]]; then
        echo "[오류] 폴더가 존재하지 않습니다. 다시 입력해주세요."
        continue
    fi

    # 존재하면 반복 종료
    break
done

# 압축 파일 이름 (폴더 이름 + 날짜)
ZIP_NAME="${DIR}_$(date '+%Y%m%d').zip"

echo "압축 중... ($ZIP_NAME)"

# zip 명령으로 압축 (하위 폴더 포함)
zip -r "$OUTPUT_DIR/$ZIP_NAME" "$TARGET_DIR" >/dev/null

if [[ $? -eq 0 ]]; then
    echo "[완료] 압축 완료: $OUTPUT_DIR/$ZIP_NAME"
else
    echo "[오류] 압축 실패"
fi