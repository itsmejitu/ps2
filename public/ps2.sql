-- 7)question

CREATE TABLE my_stocks
  (
     symbol        VARCHAR(20) NOT NULL,
     n_shares      INTEGER NOT NULL,
     date_acquired DATE NOT NULL
  );


COPY my_stocks(symbol,n_shares,date_acquired) FROM '/home/jitu/Desktop/my-rails-project/public' (DELIMITER(E'\t'));

-- 8)question

CREATE TABLE newly_acquired_stocks
   (
     symbol        VARCHAR(20) NOT NULL,
     n_shares      INTEGER NOT NULL,
     date_acquired DATE NOT NULL
);

CREATE TABLE stock_prices AS (SELECT symbol,CURRENT_DATE,31.415 AS price FROM my_stocks);

INSERT INTO newly_acquired_stocks
SELECT symbol,
       n_shares,
       date_acquired
FROM   my_stocks
WHERE  n_shares =1;

--9)question

SELECT M.symbol,
       M.n_shares,
       S.price,
       (M.n_shares * S.price) AS current_value
FROM   my_stocks AS M,
       stock_prices AS S
WHERE  M.symbol = S.symbol;

--10)question

INSERT INTO my_stocks VALUES ('kappa',12,'2019/10/04');


SELECT M.symbol,
       M.n_shares,
       S.price,
       (M.n_shares * S.price) AS current_value
FROM   my_stocks AS M
       FULL OUTER JOIN stock_prices AS S
                    ON M.symbol = S.symbol;


--11)question

CREATE FUNCTION return_stock_value(symbol varchar)
returns           integer AS $$
DECLARE character char;
ascii_value       int;
begin
  ascii_value = 0;
  for i IN 1..length(symbol)
  loop
	character = substring(symbol FROM i FOR 1);
  	ascii_value = ascii_value + ascii(character);
  end loop;
  return ascii_value;
end;
$$ language plpgsql;


UPDATE stock_prices
SET    price = return_stock_value(symbol)
WHERE  symbol IN (SELECT symbol
                  FROM   my_stocks);

CREATE OR REPLACE FUNCTION return_portfolio()
returns TABLE(symbol varchar(20), acquired date, price_per_share decimal,current_value decimal) AS $$
BEGIN
  RETURN query
  SELECT m.symbol,
         m.date_acquired,
	 s.price,
         (s.price * m.n_shares) AS current_value
  FROM   my_stocks                       AS m,
         stock_prices                    AS s
  WHERE  m.symbol = s.symbol;
END
$$ language plpgsql;

CREATE OR REPLACE FUNCTION value_portfolio()
RETURNS void AS $$

    DECLARE v_id varchar(10);
    DECLARE v_price float;
    DECLARE v_num_shares integer;
    DECLARE v_total_price float;
    DECLARE cx CURSOR FOR SELECT a.symbol,
       a.n_shares,
       b.price,
       (a.n_shares * b.price) AS current_value
FROM   my_stocks AS a,
       stock_prices AS b
WHERE  a.symbol = b.symbol;


  BEGIN
    OPEN cx;
    -- fetch each record
    LOOP
    FETCH cx INTO v_id, v_price, v_num_shares, v_total_price ;
    EXIT WHEN NOT FOUND;
    RAISE NOTICE 'Stock: %, Price: %, Number of Shares: %, Total Price: %', v_id, v_price, v_num_shares, v_total_price ;

    END LOOP;
    CLOSE cx;
  END;
  $$ LANGUAGE plpgsql;

--12)question

INSERT INTO my_stocks
SELECT M.symbol,
       M.n_shares,
       CURRENT_DATE AS date_acquired
FROM   stock_prices S,
       my_stocks M
WHERE  S.symbol = M.symbol
       AND S.price > (SELECT Avg(price) FROM stock_prices);


SELECT symbol,
       Sum(n_shares) AS total_shares
FROM   my_stocks
GROUP  BY symbol;

SELECT M.symbol,
       Sum(M.n_shares * S.price) AS total_value
FROM   my_stocks M
       INNER JOIN stock_prices S
               ON S.symbol = M.symbol
GROUP  BY M.symbol;

SELECT M.symbol,
       Sum(M.n_shares) AS total_shares,
       Sum(M.n_shares * S.price) AS total_value
FROM   my_stocks M
       INNER JOIN stock_prices S
               ON S.symbol = M.symbol
GROUP  BY M.symbol
HAVING COUNT(M.symbol) >= 2;

-- 13)question

CREATE VIEW stocks_i_like
AS
  SELECT M.symbol,
         Sum(M.n_shares)           AS total_shares,
         Sum(M.n_shares * S.price) AS total_value
  FROM   my_stocks M
         INNER JOIN stock_prices S
                 ON S.symbol = M.symbol
  GROUP  BY M.symbol
  HAVING Count(M.symbol) >= 2;
