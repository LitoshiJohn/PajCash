WITH baset AS (
  SELECT
      tx_from,
      SUM(amount) AS volume
  FROM solana.core.fact_transfers
  WHERE 1=1
  AND block_timestamp >= '2025-03-10'
  AND tx_to = 'PAJiUaKgxTBJVADc1wdiUygLd51biQPVB8KkJqYu53L'
  AND mint IN ('Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB','EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v')
  AND amount > 0.5                                                                            
  AND tx_from NOT IN (
    '26cG52NxK3ZNEV4xhuwQUkmxUYpZza1Fi9iq73SnignB',
    'Cg5eruQQihEFYq1YbnenAWQ9Qic1Z1R856dbwJyXhiGi',
    '7imnGYfCovXjMWKdbQvETFVMe72MQDX4S5zW4GFxMJME',
    '8gJ7UWboMeQ6z6AQwFP3cAZwSYG8udVS2UesyCbH79r7',
    'Fn68NZzCCgZKtYmnAYbkL6w5NNx3TgjW91dGkLA3hsDK',
    'J4uBbeoWpZE8fH58PM1Fp9n9K6f1aThyeVCyRdJbaXqt',
    '9nnLbotNTcUhvbrsA6Mdkx45Sm82G35zo28AqUvjExn8',
    '6U91aKa8pmMxkJwBCfPTmUEfZi6dHe7DcFq2ALvB2tbB',
    'AM2ufuongTfRXoNF2v4FXu9shAD4caLpEi6maPTVmyPV',
    'Enc6rB84ZwGxZU8aqAF41dRJxg3yesiJgD7uJFVhMraM',
    '2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h',
    '83v8iPyZihDEjDdY8RdZddyZNyUtXngz69Lgo9Kt5d6d',
    'CapuXNQoDviLvU1PxFiizLgPNQCxrsag1uMeyk6zLVps',
    'CUof9yJoHSwwhQay3nRJvnRjGAYKS42cckSzkJ21P4Ke'
  )
  GROUP BY 1
)

SELECT
    CASE
        WHEN volume >= 0.5 AND volume < 1 THEN 'TINY(0.5 - 1)'
        WHEN volume >= 1 AND volume < 10 THEN 'SMALL(1 - 10)'
        WHEN volume >= 10 AND volume < 100 THEN 'MID(10 - 100)'
        WHEN volume >= 100 AND volume < 500 THEN 'BIG(100 - 500)'
        WHEN volume >= 500 AND volume < 1000 THEN 'LARGE(500 - 1000)'
        ELSE 'MIGHTY(1000+)'
    END AS CATEGORY,
    COUNT(DISTINCT tx_from) AS wallets
FROM baset
GROUP BY CATEGORY
ORDER BY  
    CASE CATEGORY
        WHEN 'MIGHTY(1000+)' THEN 1
        WHEN 'LARGE(500 - 1000)' THEN 2
        WHEN 'BIG(100 - 500)' THEN 3
        WHEN 'MID(10 - 100)' THEN 4
        WHEN 'SMALL(1 - 10)' THEN 5
        WHEN 'TINY(0.5 - 1)' THEN 6
    END;