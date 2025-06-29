WITH prices AS (
  SELECT
      date_trunc('day', hour) as date,
      symbol,
      token_address,
      AVG(price) as price  -- Taking average price per day
  FROM solana.price.ez_prices_hourly
  WHERE hour >'2025-03-01'
  GROUP BY 1, 2, 3
),

tokens AS (
  SELECT
      date_trunc('day', block_timestamp) AS date,
      mint,
      SUM(amount) as amount
  FROM solana.core.fact_transfers
  WHERE block_timestamp > '2025-03-01'
    AND tx_to = 'PAJiUaKgxTBJVADc1wdiUygLd51biQPVB8KkJqYu53L'
    AND amount > 0.002                                                                             
    AND tx_from NOT IN ('26cG52NxK3ZNEV4xhuwQUkmxUYpZza1Fi9iq73SnignB','Cg5eruQQihEFYq1YbnenAWQ9Qic1Z1R856dbwJyXhiGi',
                  '7imnGYfCovXjMWKdbQvETFVMe72MQDX4S5zW4GFxMJME','8gJ7UWboMeQ6z6AQwFP3cAZwSYG8udVS2UesyCbH79r7',
                  'Fn68NZzCCgZKtYmnAYbkL6w5NNx3TgjW91dGkLA3hsDK','J4uBbeoWpZE8fH58PM1Fp9n9K6f1aThyeVCyRdJbaXqt','9nnLbotNTcUhvbrsA6Mdkx45Sm82G35zo28AqUvjExn8',
                  '6U91aKa8pmMxkJwBCfPTmUEfZi2dHe7DcFq2ALvB2tbB','AM2ufuongTfRXoNF2v4FXu9shAD4caLpEi6maPTVmyPV','Enc6rB84ZwGxZU8aqAF41dRJxg3yesiJgD7uJFVhMraM',
                  '2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h','83v8iPyZihDEjDdY8RdZddyZNyUtXngz69Lgo9Kt5d6d','CapuXNQoDviLvU1PxFiizLgPNQCxrsag1uMeyk6zLVps',
                  'CUof9yJoHSwwhQay3nRJvnRjGAYKS42cckSzkJ21P4Ke')
  GROUP BY 1, 2
),

sol_prices AS (
  SELECT 
    date,
    price as sol_price
  FROM prices 
  WHERE symbol = 'SOL' 
    AND token_address IS NULL
)

SELECT
    t.date,
    CASE
        WHEN t.mint = 'So11111111111111111111111111111111111111112' THEN 'wSOL'
        WHEN t.mint = 'So11111111111111111111111111111111111111111' THEN 'SOL'
        WHEN t.mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' THEN 'USDC'
        WHEN t.mint = 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB' THEN 'USDT'
        ELSE 'INVALID_TOKEN'
    END AS token_name,
    t.amount as token_amount,
    t.amount * COALESCE(
        CASE 
            WHEN t.mint IN ('So11111111111111111111111111111111111111111', 'So11111111111111111111111111111111111111112') 
            THEN sp.sol_price
            ELSE p.price 
        END, 0) as token_volume_usd,
    SUM(t.amount * COALESCE(
        CASE 
            WHEN t.mint IN ('So11111111111111111111111111111111111111111', 'So11111111111111111111111111111111111111112') 
            THEN sp.sol_price
            ELSE p.price 
        END, 0)) OVER (PARTITION BY 
            CASE
                WHEN t.mint = 'So11111111111111111111111111111111111111112' THEN 'wSOL'
                WHEN t.mint = 'So11111111111111111111111111111111111111111' THEN 'SOL'
                WHEN t.mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' THEN 'USDC'
                WHEN t.mint = 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB' THEN 'USDT'
                ELSE 'INVALID_TOKEN'
            END 
        ORDER BY t.date) as cumulative_volume_usd
FROM tokens t
LEFT JOIN prices p
    ON t.date = p.date 
    AND t.mint = p.token_address
LEFT JOIN sol_prices sp
    ON t.date = sp.date
ORDER BY t.date ASC, token_name;