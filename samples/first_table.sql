CREATE SCHEMA IF NOT EXISTS user99 AUTHORIZATION user99 ;

SET SEARCH_PATH=user99;

CREATE TABLE expenses (
	uuid uuid DEFAULT gen_random_uuid() NOT NULL,
	trading_date date DEFAULT now() NULL,
	category text NULL,
	value int4 NULL,
	note text NULL,
	CONSTRAINT expenses_pk PRIMARY KEY (uuid)
);
