SELECT
  tx_from AS users,
  COUNT(tx_id) AS transactions
FROM solana.core.fact_transfers
WHERE 1=1
  AND tx_to = 'PAJiUaKgxTBJVADc1wdiUygLd51biQPVB8KkJqYu53L'
  AND amount > 0.002                                                                             -- minimum amount Paj accepts is $0.5
  AND tx_from ! IN ('26cG52NxK3ZNEV4xhuwQUkmxUYpZza1Fi9iq73SnignB','Cg5eruQQihEFYq1YbnenAWQ9Qic1Z1R856dbwJyXhiGi',
                  '7imnGYfCovXjMWKdbQvETFVMe72MQDX4S5zW4GFxMJME','8gJ7UWboMeQ6z6AQwFP3cAZwSYG8udVS2UesyCbH79r7',
                  'Fn68NZzCCgZKtYmnAYbkL6w5NNx3TgjW91dGkLA3hsDK','J4uBbeoWpZE8fH58PM1Fp9n9K6f1aThyeVCyRdJbaXqt','9nnLbotNTcUhvbrsA6Mdkx45Sm82G35zo28AqUvjExn8',
                  '6U91aKa8pmMxkJwBCfPTmUEfZi6dHe7DcFq2ALvB2tbB','AM2ufuongTfRXoNF2v4FXu9shAD4caLpEi6maPTVmyPV','Enc6rB84ZwGxZU8aqAF41dRJxg3yesiJgD7uJFVhMraM',
                  '2MFoS3MPtvyQ4Wh4M9pdfPjz6UhVoNbFbGJAskCPCj3h','83v8iPyZihDEjDdY8RdZddyZNyUtXngz69Lgo9Kt5d6d','CapuXNQoDviLvU1PxFiizLgPNQCxrsag1uMeyk6zLVps',
                  'CUof9yJoHSwwhQay3nRJvnRjGAYKS42cckSzkJ21P4Ke')
GROUP BY 1
ORDER BY 2 DESC