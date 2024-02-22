-- Segmentation Analysis Based on Drug MarketingStatus
use drugs;

-- Products based on MarketingStatus
SELECT p.ProductMktStatus, COUNT(distinct p.drugname) AS Num_of_Products,
       ROUND(CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS decimal), 2) AS Percentage
FROM product p
GROUP BY p.ProductMktStatus
ORDER BY Num_of_Products DESC;

-- The total number of applications for each MarketingStatus year-wise after the year 2010.
SELECT year(rd.ActionDate) as Approval_Year , p.ProductMktStatus as MarketingStatus, COUNT(distinct a.ApplNo) AS Num_of_Applications
from regactiondate rd inner join product p on rd.ApplNo=p.ApplNo inner join application a on p.ApplNo=a.ApplNo
where year(rd.ActionDate)> 2010
group by Approval_Year, MarketingStatus
order by Approval_Year, Num_of_Applications desc

-- The top MarketingStatus with the maximum number of applications and analyze its trend over time.
SELECT p.ProductMktStatus,YEAR(rd.ActionDate) AS ApplicationYear, COUNT(distinct p.ApplNo) AS Num_of_Application
FROM regactiondate rd  JOIN product p ON p.ApplNo = rd.ApplNo
WHERE YEAR(rd.ActionDate) IS NOT NULL
AND p.ProductMktStatus = (
        SELECT p.ProductMktStatus FROM product p GROUP BY p.ProductMktStatus 
        ORDER BY COUNT(distinct p.ApplNo) DESC LIMIT 1)
GROUP BY p.ProductMktStatus, ApplicationYear
ORDER BY ApplicationYear;

