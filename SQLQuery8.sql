SELECT DATEPART(YY, [Invoice Date Key]) AS [YEAR],
		DATEPART(QQ, [Invoice Date Key]) AS [QUARTER],
		[Customer Key],
		SUM([Total Including Tax]) AS [Revenue],
		SUM(QUANTITY) AS SALES_QUANTITY,
		SUM([Total Including Tax])/SUM(SUM([Total Including Tax])) 
		OVER(PARTITION BY DATEPART(YY, [Invoice Date Key]),
		DATEPART(QQ, [Invoice Date Key])) * 100 AS [TotalRevenuePercentage],
		SUM(QUANTITY) / SUM(SUM(QUANTITY)) 
		OVER (PARTITION BY DATEPART(YY, [Invoice Date Key]), DATEPART(QQ, [Invoice Date Key])) * 100 AS [TotalQuantityPercentage]
  INTO #TEMP1
  FROM [Fact].[Sale]
  GROUP BY DATEPART(YY, [Invoice Date Key]), DATEPART(QQ, [Invoice Date Key]), [Customer Key]
  ORDER BY [YEAR], [QUARTER], [Customer Key]

  SELECT C.[Customer] [CustomerName], T.[TotalRevenuePercentage], T.[TotalQuantityPercentage], T.[Quarter], T.[Year]
  FROM #TEMP1 T
  LEFT JOIN [Dimension].[Customer] C
  ON T.[Customer Key] = C.[Customer Key]