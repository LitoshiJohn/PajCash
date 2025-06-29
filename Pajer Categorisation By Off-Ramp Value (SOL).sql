WITH baset2 AS (
  SELECT
      tx_from,
      SUM(amount) AS volume
  FROM solana.core.fact_transfers
  WHERE 1=1
  AND block_timestamp >= '2025-03-10'
  AND tx_to = 'PAJiUaKgxTBJVADc1wdiUygLd51biQPVB8KkJqYu53L'
  AND mint IN ('So11111111111111111111111111111111111111112','So11111111111111111111111111111111111111111')
  AND amount > 0.000                                                                            
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
        WHEN volume >= 0.001 AND volume < 0.005 THEN 'TINY (0.001 - 0.005)'
        WHEN volume >= 0.005 AND volume < 0.01 THEN 'SMALL(0.005 - 0.01)'
        WHEN volume >= 0.01 AND volume < 0.05 THEN 'MID(0.01 - 0.05)'
        WHEN volume >= 0.05 AND volume < 0.1 THEN 'BIG(0.05 - 0.1)'
        WHEN volume >= 0.1 AND volume < 0.5 THEN 'LARGE(0.1 - 0.5)'
        WHEN volume >= 0.5 THEN 'MIGHTY(0.5+)' 
    END AS CATEGORY,
    COUNT(DISTINCT tx_from) AS wallets
FROM baset2
GROUP BY 1
ORDER BY  
    CASE CATEGORY
        WHEN 'MIGHTY(0.5+)' THEN 1
        WHEN 'LARGE(0.1 - 0.5)' THEN 2
        WHEN 'BIG(0.05 - 0.1)' THEN 3
        WHEN 'MID(0.01 - 0.05)' THEN 4
        WHEN 'SMALL(0.005 - 0.01)' THEN 5
        WHEN 'TINY(0.001 - 0.005)' THEN 6
    END;