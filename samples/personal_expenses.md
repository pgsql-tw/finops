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
CREATE SCHEMA IF NOT EXISTS user99;
```
- https://www.postgresql.org/docs/current/sql-createschema.html

## Tables
```
CREATE TABLE expenses (
	uuid uuid DEFAULT gen_random_uuid() NOT NULL,
	trading_date date DEFAULT now() NULL,
	category text NULL,
	value int NULL,
	note text NULL,
	CONSTRAINT expenses_pk PRIMARY KEY (uuid)
);
```
```
CREATE TABLE cost_daily (
	cost_date DATE,
	cost_total INT,
	ma7 DECIMAL(10,2),
	ma30 DECIMAL(10,2),
	primary key (cost_date)
);
```

## Views
- 產生過去 365 天的日期
```
CREATE VIEW last_365 AS
	(SELECT (CURRENT_DATE - generate_series(1,365))::date AS trading_date);
```

## Generating sample data
```
INSERT INTO expenses(trading_date,category,value,note)
	SELECT CURRENT_DATE-(random()*365)::int,'轉帳',(random()*1000+100)::int,'網拍' from generate_series(1, 365);
```
- 過去 365 天, 總共有 365 筆, 介於 100 ~ 1100 之間的轉帳交易
## My reports
### 最近 30 天的總花費
```
SELECT sum(value) FROM expenses WHERE trading_date > now() - interval '30 days';
```
### 統計上, 每 30 天 95% 的花費低於這個數字 (低風險)
```
WITH t_sum30 AS (
	SELECT last_365.trading_date
             ,(SELECT sum(value) AS sum30 FROM expenses WHERE expenses.trading_date BETWEEN (last_365.trading_date-interval '30 days') and last_365.trading_date)
	FROM last_365)
SELECT (avg(sum30)+2*stddev(sum30)) FROM t_sum30;
```
- 假設結果為 27367
- 你的可支配所得為 60000
- 每月存下 (60000 - 27367 = ```32633```) 以上的機率為 95%

### 延伸
1. 未來的支出也可以填入嗎?
2. 每天花費的統計上下限是多少?
3. 明天會突然花到 1000 的機率是多少?
4. 下次領薪水前, 會花到 60000 的機率有多少?
5. 固定支出和變動支出的比例怎麼估計?
6. ......
