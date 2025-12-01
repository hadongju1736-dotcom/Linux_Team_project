#!/bin/bash


# ===== 설정 =====
ASSIGNMENT_ROOT="$HOME/AssignmentManager/assignments"
URGENT_DIR="$ASSIGNMENT_ROOT/urgent"
DUE_THRESHOLD=3   # D-day 3일 이하 → urgent 처리

# ===== GNU date 확인 =====
is_gnu_date() {
    date --version >/dev/null 2>&1
}

# ** deadline_checker 함수 **
deadline_checker() {
    echo "=== 마감 임박 과제 확인 및 urgent 폴더 이동 ==="
    echo "기준: D-day ≤ $DUE_THRESHOLD"
    echo ""

    if ! is_gnu_date; then
    echo "ERROR: GNU date가 필요합니다. macOS라면 'brew install coreutils' 후 gdate 사용하도록 스크립트 수정 필요."
    return 1
    fi

    # 루트 폴더 존재 확인하기
    if [[ ! -d "$ASSIGNMENT_ROOT" ]]; then
    echo "[오류] 과제 폴더 루트가 존재하지 않습니다: $ASSIGNMENT_ROOT"
    return 1
    fi

    mkdir -p "$URGENT_DIR"

    # 현재 날짜 timestamp
    NOW=$(date +%s)

    # 이동된 과제 기록용
    moved_count=0

    # ===== assignments 폴더 스캔 =====
    for dir in "$ASSIGNMENT_ROOT"/*; do
        # urgent 폴더는 스킵
        if [[ "$dir" == "$URGENT_DIR" ]]; then
            continue
        fi

        # 폴더만 처리
        [[ -d "$dir" ]] || continue

        BASENAME=$(basename "$dir")

        # 폴더명 형식: YYYY-MM-DD_과제명
        DEADLINE_STR="${BASENAME%%_*}"

        # 날짜 형식 검증
        if ! date -d "$DEADLINE_STR" '+%Y-%m-%d' >/dev/null 2>&1; then
            echo "[경고] 폴더명에서 유효한 날짜를 찾지 못해 스킵: $BASENAME"
            continue
        fi

        # 타임 스탬프
        DEADLINE_TS=$(date -d "$DEADLINE_STR" +%s)

        # D-day 계산
        DIFF=$(( (DEADLINE_TS - NOW) / 86400 ))

        # 결과 표시
        printf "%-40s  →  D%-3d\n" "$BASENAME" "$DIFF"

        # 임박 여부 체크
        if (( DIFF <= DUE_THRESHOLD && DIFF >= 0 )); then
            # 이동할 경로 (충돌 처리)
            DEST="$URGENT_DIR/$BASENAME"
            if [[ -e "$DEST" ]]; then
                DEST="${DEST}_$(date +%s)"
            fi

            echo "  → 마감 임박! urgent로 이동: $DEST"
            mv "$dir" "$DEST"
            ((moved_count++))
        fi
    done

    echo ""
    echo "=== 처리 완료 ==="
    echo "$moved_count 개의 과제가 urgent 폴더로 이동되었습니다."
    echo "urgent 폴더 경로: $URGENT_DIR"    
}

