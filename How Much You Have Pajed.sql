SELECT 
    tx_from,
    SUM(CASE WHEN mint IN ('So11111111111111111111111111111111111111112','So11111111111111111111111111111111111111111') 
        THEN amount ELSE 0 END) as sol_sent,
    SUM(CASE WHEN mint = 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v' 
        THEN amount ELSE 0 END) as usdc_sent,
    SUM(CASE WHEN mint = 'Es9vMFrzaCERmJfrF4H2FYD4KCoNkY11McCe8BenwNYB' 
        THEN amount ELSE 0 END) as usdt_sent
FROM solana.core.fact_transfers
WHERE block_timestamp >= '2025-03-10'
    AND tx_to = 'PAJiUaKgxTBJVADc1wdiUygLd51biQPVB8KkJqYu53L'
    AND tx_from = '{{wallet}}'
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
GROUP BY tx_from
HAVING sol_sent >= 0.001 OR usdc_sent >= 0.5 OR usdt_sent >= 0.5
ORDER BY sol_sent DESC, usdc_sent DESC, usdt_sent DESC;