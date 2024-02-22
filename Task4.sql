-- Exploring Therapeutic Classes and Approval Trends
use drugs;

-- Drug approvals based on therapeutic evaluation code (TE_Code)
select pt.TECode, count(pt.TECode) as TE_Approvals 
from product_tecode pt join application a 
on pt.ApplNo=a.ApplNo 
where a.ApplType='N'
group by pt.TECode order by TE_Approvals desc;

-- The therapeutic evaluation code (TE_Code) with the highest number of Approvals in each year.
SELECT ApprovalYear, TECode, TE_Approvals
FROM ( SELECT YEAR(rd.ActionDate) AS ApprovalYear, pt.TECode, COUNT(*) AS TE_Approvals,
	   ROW_NUMBER() OVER (PARTITION BY YEAR(rd.ActionDate) ORDER BY COUNT(*) DESC) AS RN
    FROM product_tecode pt JOIN application a ON pt.ApplNo = a.ApplNo 
    JOIN regactiondate rd ON a.ApplNo = rd.ApplNo WHERE a.ApplType = 'N'
    GROUP BY YEAR(rd.ActionDate), pt.TECode
) AS ranked
WHERE RN = 1;