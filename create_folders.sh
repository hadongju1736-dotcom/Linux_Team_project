#!/bin/bash
set -euo pipefail

# ===== 설정: 루트 경로 (원하면 변경) =====
ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"
URGENT_DIR="$ASSIGNMENT_ROOT/urgent"

# ===== 도구 함수: GNU date 사용 가정 =====
# (macOS 사용자는 gdate 설치 필요: brew install coreutils)
is_gnu_date() {
    date --version >/dev/null 2>&1
}

# 날짜 유효성 검사 및 정규화: 입력을 받아 YYYY-MM-DD 형식으로 반환
# 반환은 echo로 출력(사용 예: normalized=$(normalize_date "$input"))
normalize_date() {
    local input="$1"
    if is_gnu_date; then
        # GNU date: 다양한 포맷 허용, 출력은 고정 형식
        if date -d "$input" '+%Y-%m-%d' >/dev/null 2>&1; then
            date -d "$input" '+%Y-%m-%d'
            return 0
        else
            return 1
        fi
    else
        # macOS 기본 date는 -d를 지원하지 않음 -> 사용자에게 안내
        echo "ERROR: 시스템의 date 명령이 GNU date가 아닙니다. macOS라면 'gdate' 설치 필요 (brew install coreutils)." >&2
        return 2
    fi
}

# ** create_folders 함수 **
create_folders() {
    echo "=== 새 과제 폴더 만들기 ==="
    read -p "과제 이름을 입력하세요: " NAME
    if [[ -z "${NAME// }" ]]; then
        echo "[오류] 과제 이름은 비어 있을 수 없습니다."
        return 1
    fi

    read -p "마감 날짜를 입력하세요 (예: 2025-03-21 또는 2025-3-21): " RAW_DEADLINE

    # 정규화 시도
    NORMALIZED_DEADLINE=$(normalize_date "$RAW_DEADLINE") || {
        rc=$?
        if [[ $rc -eq 2 ]]; then
            return 1
        fi
        echo "[오류] 날짜 형식이 잘못되었습니다. 예: 2025-03-21 또는 2025-3-21"
        return 1
    }

    # 루트 폴더 존재 확인 및 생성
    mkdir -p "$ASSIGNMENT_ROOT"
    # urgent 폴더(마감 임박 모음)도 미리 만들어 둠 (비어 있음)
    mkdir -p "$URGENT_DIR"

    # 폴더명 및 경로
    FOLDER_NAME="${NORMALIZED_DEADLINE}_${NAME}"
    TARGET_DIR="$ASSIGNMENT_ROOT/$FOLDER_NAME"

    # 중복 체크
    if [[ -e "$TARGET_DIR" ]]; then
        echo "[오류] 이미 존재하는 과제(파일 또는 폴더)가 있습니다: $TARGET_DIR"
        return 1
    fi

    # 폴더 생성
    mkdir -p "$TARGET_DIR/src" "$TARGET_DIR/docs"

    echo "완료! 생성된 과제 폴더:"
    echo "$TARGET_DIR"
    echo ""
    echo "기본 구조:"
    echo " ├─ src/"
    echo " └─ docs/"
    echo ""
    echo "참고: 마감 임박 과제는 다음 폴더로 모을 계획입니다: $URGENT_DIR"
}






