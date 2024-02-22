-- Identifying Approval Trends

use drugs;

-- The number of drugs approved each year and provide insights into the yearly trends.
SELECT YEAR(rd.ActionDate) AS ApprovalYear, COUNT(distinct p.drugname) AS Drugs_Approved
FROM product p
INNER JOIN regactiondate rd ON p.ApplNo = rd.ApplNo inner join application a on rd.ApplNo = a.ApplNo
where rd.ActionDate is not null and ApplType='N'
GROUP BY ApprovalYear
ORDER BY ApprovalYear;

-- The top three years that got the highest approvals
SELECT YEAR(rd.ActionDate) AS ApprovalYear, COUNT(distinct p.drugname) AS Drugs_Approved
FROM product p
INNER JOIN regactiondate rd ON p.ApplNo = rd.ApplNo inner join application a on rd.ApplNo = a.ApplNo
where rd.ActionDate is not null and ApplType='N'
GROUP BY ApprovalYear
ORDER BY Drugs_Approved desc limit 3;

-- The top three years that got the lowest approvals
SELECT YEAR(rd.ActionDate) AS ApprovalYear, COUNT(distinct p.drugname) AS Drugs_Approved
FROM product p
INNER JOIN regactiondate rd ON p.ApplNo = rd.ApplNo inner join application a on rd.ApplNo = a.ApplNo
where rd.ActionDate is not null and ApplType='N'
GROUP BY ApprovalYear
ORDER BY Drugs_Approved asc limit 3;

-- Approval trends over the years based on sponsors.
SELECT YEAR(rd.ActionDate) AS ApprovalYear, a.SponsorApplicant as Sponsors, COUNT(a.SponsorApplicant) AS Num_of_Approvals
FROM regactiondate rd
INNER JOIN application a on rd.ApplNo = a.ApplNo
where rd.ActionDate is not null and ApplType='N'
GROUP BY ApprovalYear, Sponsors
ORDER BY ApprovalYear, Sponsors;

-- Rank sponsors based on the total number of approvals they received each year between 1939 and 1960.
SELECT ApprovalYear, Sponsor, Num_of_Approvals,
       dense_rank() OVER(PARTITION BY ApprovalYear ORDER BY Num_of_Approvals DESC) AS SponsorRank
FROM (
    SELECT YEAR(rd.ActionDate) AS ApprovalYear, a.SponsorApplicant AS Sponsor, COUNT(a.SponsorApplicant) AS Num_of_Approvals
    FROM application a
    INNER JOIN regactiondate rd ON a.ApplNo = rd.ApplNo
    WHERE a.ApplType='N' and YEAR(rd.ActionDate) BETWEEN 1939 AND 1960 
    GROUP BY ApprovalYear, Sponsor
) AS SponsorApprovals
ORDER BY ApprovalYear, SponsorRank;