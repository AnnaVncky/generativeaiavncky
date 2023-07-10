SELECT DATEPART(QQ, [Invoice Date Key]) AS [QUARTER], 
						 DATEPART(YY, [Invoice Date Key]) AS [YEAR],
                       [Stock Item Key],
                       SUM(QUANTITY) [SalesQuantity], SUM([Total Including Tax]) [SalesRevenue], [Invoice Date Key]
					   into #temp5
                  FROM [Fact].[Sale]
                 GROUP BY DATEPART(QQ, [Invoice Date Key]), DATEPART(YY, [Invoice Date Key]), [Stock Item Key], [Invoice Date Key]



 SELECT 
 t.[SalesRevenue] PrevSalesRevenue,
 t1.[SalesRevenue] CurSalesRevenue,
  T.[Stock Item Key],
  t.[SalesQuantity] PrevSalesQuantity,
  t1.[SalesQuantity] CurSalesQuantity,
  t1.[QUARTER] [CurrentQuarter],
  t.[QUARTER] [PreviousQuarter],
  t1.[YEAR] [CurrentYear],
  t.[YEAR] [PreviousYear],
 (t1.[SalesRevenue] - t.[SalesRevenue]) /t.[SalesRevenue] * 100 as GrowthRevenueRate,
 (t1.[SalesQuantity] - t.[SalesQuantity]) / t.[SalesQuantity] * 100 as GrowthQuantityRate
FROM #TEMP5 T
inner join #TEMP5 t1
ON T.[Stock Item Key] = t1.[Stock Item Key]
where  t1.[Invoice Date Key] >  t.[Invoice Date Key] and t1.[QUARTER]> t.[QUARTER] and t1.[YEAR] > t.[YEAR] 
