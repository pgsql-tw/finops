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
```
CREATE TABLE expenses (
	uuid uuid DEFAULT gen_random_uuid() NOT NULL,
	trading_date date DEFAULT now() NULL,
	category text NULL,
	value int4 NULL,
	note text NULL,
	CONSTRAINT expenses_pk PRIMARY KEY (uuid)
);
```

## Views
- 產生過去 365 天的日期
```
create view last_365 as (select (CURRENT_DATE - generate_series(1,365))::date as trading_date);
```

## Generating sample data
```
insert into expenses(trading_date,category,value,note) select CURRENT_DATE-(random()*365)::int,'轉帳',(random()*1000+100)::int,'網拍' from generate_series(1, 365);
```
- 過去 365 天, 總共有 365 筆, 介於 100 ~ 1100 之間的轉帳交易
## My reports
### 最近 30 天的總花費
```
select sum(value) from expenses where trading_date > now() - interval '30 days';
```
### 統計上, 每 30 天 99% 的花費低於這個數字
```
with t_sum30 as (
select last_365.trading_date,(select sum(value) as sum30 from expenses where expenses.trading_date between (last_365.trading_date-interval '30 days') and last_365.trading_date) from last_365)
select avg(sum30)+3*stddev(sum30) from t_sum30;
```
