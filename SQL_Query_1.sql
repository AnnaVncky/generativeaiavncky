SELECT DISTINCT TOP 10 [Total Including Tax], [Stock Item Key], [Quantity]  FROM [Fact].[Sale] ORDER BY [Total Including Tax] DESC

  select TOP 10 [Stock Item Key], sum([Total Including Tax]), count([Quantity]), DATEPART(QQ, [Invoice Date Key]) AS [QUARTER], DATEPART (YY, [Invoice Date Key]) AS [YEAR]
       from [Fact].[Sale] 
       group by [Stock Item Key], [QUARTER], [YEAR]
       order by sum([Total Including Tax]) desc, count([Quantity]) desc
       

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