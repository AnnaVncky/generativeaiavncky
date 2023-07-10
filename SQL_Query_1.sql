SELECT RANK() OVER (PARTITION BY [QUARTER], [YEAR]
                            ORDER BY [SalesRevenue] desc) AS PROFIT_RANK_BY_Q, 
                [Stock Item Key], [SalesQuantity], [SalesRevenue], [QUARTER], [YEAR]
				INTO #TEMP3
          FROM
               (SELECT DATEPART(QQ, [Invoice Date Key]) AS [QUARTER], 
						 DATEPART(YY, [Invoice Date Key]) AS [YEAR],
                       [Stock Item Key],
                       SUM(QUANTITY) [SalesQuantity], SUM([Total Including Tax]) [SalesRevenue] 
                  FROM [Fact].[Sale]
                 GROUP BY DATEPART(QQ, [Invoice Date Key]), DATEPART(YY, [Invoice Date Key]), [Stock Item Key]) MAIN

SELECT SI.[Stock Item] AS [ProductName], [SalesQuantity], [SalesRevenue], [Quarter], [Year] 
FROM #TEMP3 T
LEFT JOIN [Dimension].[Stock Item] SI
ON T.[Stock Item Key] = SI.[Stock Item Key]
 WHERE PROFIT_RANK_BY_Q <= 10 
 order by [QUARTER], [YEAR], PROFIT_RANK_BY_Q
