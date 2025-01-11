# 個人支出記帳
1. 記錄個人每日支出
2. 依據記錄產生統計報表
3. 依據記錄評估未來支出

## 初始化
- first_table.sql
- 先建立好資料庫再連線進入該資料庫再執行
- OWNER 指定給你的使用者
```
CREATE DATABASE finops OWNER user99;
```
- user99 替換成你的使用者名稱
- 以下使用 user99 或你的使用名稱登入

## Scheme
```
CREATE SCHEMA IF NOT EXISTS user99 AUTHORIZATION user99 ;
```
- https://www.postgresql.org/docs/current/sql-createschema.html
## Tables

## Sample data

## My reports
