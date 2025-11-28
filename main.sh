#!/bin/bash

# 기능 파일 불러오기
source ./create_folders.sh
source ./classify_files.sh
source ./sort_deadlines.sh
source ./archive_completed.sh

show_menu() {
    echo "===== 과제 자동화 프로그램 ====="
    echo "1) 과제 폴더 생성"
    echo "2) 파일 분류"
    echo "3) 마감 임박/완료 분류"
    echo "4) 완료 과제 압축"
    echo "5) 전체 실행"
    echo "0) 종료"
    echo "================================"
    echo -n "번호를 선택하세요: "
}

while true; do
    show_menu
    read choice

    case $choice in
        1) create_folders ;;
        2) classify_files ;;
        3) sort_deadlines ;;
        4) archive_completed ;;
        5) 
            create_folders
            classify_files
            sort_deadlines
            archive_completed
            ;;
        0) echo "프로그램을 종료합니다."; exit ;;
        *) echo "잘못된 입력입니다. 다시 선택해주세요." ;;
    esac

    echo ""  # 메뉴와 결과 구분을 위해 공백 추가
done