#!/bin/bash

echo "==== 과제 관리 도우미 ===="
echo "1. 새 과제 폴더 만들기"
echo "2. 파일 자동 분류 실행하기"
echo "3. 마감 임박한 과제들 보기"
echo "4. 완료한 과제 압축하기"
echo "0. 종료하기"
echo "========================="
read -p "메뉴 선택: " choice

case $choice in
1) 
    ./create_folders.sh;;
2) 
    ./classify_files.sh;;
3) 
    ./listof_dealine_assignments.sh;;
4) 
    ./compress_finished_assignments.sh;;
0) 
    
    exit 0;;
*) 
    echo "유효하지 않은 선택입니다";;
esac

# 폴더 이름은 가제로 정함

