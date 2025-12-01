#!/bin/bash

classify_files() {
    echo "=== 과제 파일 분류 ==="

    ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"
    URGENT_DIR="$ASSIGNMENT_ROOT/urgent"

    if [[ ! -d "$ASSIGNMENT_ROOT" ]]; then
        echo "[오류] 과제 루트 폴더가 존재하지 않습니다: $ASSIGNMENT_ROOT"
        echo "폴더를 먼저 생성해주세요."
        return 1
    fi

    # 분류할 폴더 입력 / 존재 여부 체크
    while true; do
        read -p "분류하고 싶은 폴더를 입력(종료하려면 'q' 또는 'Q') : " DIR
        if [[ "$DIR" == "q" || "$DIR" == "Q" ]]; then
            echo "프로그램을 종료합니다."
            return 0
        fi
        if [[ -z "$DIR" ]]; then
            echo "[오류] 폴더 이름을 입력하세요."
            continue
        fi
        if [[ -d "$ASSIGNMENT_ROOT/$DIR" ]]; then
            TARGET_DIR="$ASSIGNMENT_ROOT/$DIR"
        elif [[ -d "$URGENT_DIR/$DIR" ]]; then
            TARGET_DIR="$URGENT_DIR/$DIR"
        else
            echo "[오류] 폴더가 존재하지 않습니다. 다시 입력해주세요."
            continue
        fi
        break
    done

    # 분류 기준 및 폴더 생성
    for FILE in "$TARGET_DIR"/*; do
        [[ ! -f "$FILE" ]] && continue
        EXT="${FILE##*.}"
        case "$EXT" in
            c|cpp|py|java|sh)
                DEST="$TARGET_DIR/src"
                ;;
            pdf|doc|docx|hwpx|txt)
                DEST="$TARGET_DIR/docs"
                ;;
            jpg|JPG|jpeg|JPEG|png|PNG|gif|bmp|svg)
                DEST="$TARGET_DIR/images"
                ;;
            csv|xlsx|json|xml)
                DEST="$TARGET_DIR/data"
                ;;
            *)
                DEST="$TARGET_DIR/others"
                ;;
        esac
        mkdir -p "$DEST"
        mv "$FILE" "$DEST"
        echo "[완료] $(basename "$FILE") → $DEST"
    done

    # 완료 메시지
    echo "=== 모든 파일 분류 완료 ==="
}