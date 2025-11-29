#!/bin/bash

echo "=== 과제 파일 분류 ==="

ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"

# 분류할 폴더 입력 / 존재 여부 체크
while true; do
    read -p "분류하고 싶은 폴더를 입력 : " DIR
    if [[ -z "$DIR" ]]; then
        echo "[오류] 폴더 이름을 입력하세요."
        continue
    fi
    if [[ ! -d "$ASSIGNMENT_ROOT/$DIR" ]]; then
        echo "[오류] 폴더가 존재하지 않습니다. 다시 입력해주세요."
        continue
    fi
    break
done

# 분류 기준 및 폴더 생성
for FILE in "$ASSIGNMENT_ROOT/$DIR"/*; do
    [[ ! -f "$FILE" ]] && continue
    EXT="${FILE##*.}"
    case "$EXT" in
        c|cpp|py|java|sh)
            DEST="$ASSIGNMENT_ROOT/$DIR/source_code"
            ;;
        pdf|doc|docx|hwpx|txt)
            DEST="$ASSIGNMENT_ROOT/$DIR/reports"
            ;;
        jpg|jpeg|png|gif|bmp|svg)
            DEST="$ASSIGNMENT_ROOT/$DIR/images"
            ;;
        csv|xlsx|json|xml)
            DEST="$ASSIGNMENT_ROOT/$DIR/data"
            ;;
        *)
            DEST="$ASSIGNMENT_ROOT/$DIR/others"
            ;;
    esac
    mkdir -p "$DEST"
    mv "$FILE" "$DEST"
    echo "[완료] $(basename "$FILE") → $DEST"
done

# 3️⃣ 완료 메시지
echo "=== 모든 파일 분류 완료 ==="