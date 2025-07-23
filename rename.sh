#!/bin/bash

# 转义函数，将文件名转义为URL安全格式
url_encode() {
  local length="${#1}"
  for ((i = 0; i < length; i++)); do
    local c="${1:i:1}"
    case $c in
      [a-zA-Z0-9.~_-]) printf "$c" ;;
      ' ') printf "%20" ;;  # 转义空格为%20
      *) printf '%%%02X' "'$c" ;;
    esac
  done
}

# 获取要处理的目录路径
directory="$1"

# 检查是否提供了目录参数
if [ -z "$directory" ]; then
  echo "请提供一个目录路径作为参数."
  exit 1
fi

# 遍历目录中的所有文件
find "$directory" -type f | while read -r file; do
  # 获取文件所在的目录路径
  dir=$(dirname "$file")
  
  # 获取文件的文件名
  filename=$(basename "$file")
  
  # 使用url_encode函数对文件名进行转义
  new_filename=$(url_encode "$filename")
  
  # 如果新文件名与原文件名不同，进行重命名
  if [ "$filename" != "$new_filename" ]; then
    mv "$file" "$dir/$new_filename"
    echo "文件重命名：$filename -> $new_filename"
  fi
done

echo "所有文件重命名完成！"
