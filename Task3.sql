use drugs;

-- Categorize Products by dosage form and analyze their distribution.
Select dosage, count(dosage) as Number_of_products from product group by dosage order by Number_of_products desc

-- The total number of approvals for each dosage form and identify the most successful forms.
select p.dosage, count(a.ApplType) as Number_of_approvals 
from product p join application a on p.ApplNo=a.ApplNo
where a.ApplType = 'N'
group by p.dosage order by Number_of_approvals desc

-- Yearly trends related to successful forms.
select YEAR(rd.ActionDate) as ApprovalYear, p.dosage, count(p.dosage) as Number_of_approvals 
from regactiondate rd inner JOIN product p on rd.ApplNo=p.ApplNo inner join application a on p.ApplNo=a.ApplNo
where a.ApplType = 'N' and 
dosage= (select p.dosage
from product p join application a on p.ApplNo=a.ApplNo
where a.ApplType = 'N'
group by p.dosage order by count(a.ApplType) desc limit 1)
group by ApprovalYear, p.dosage order by ApprovalYear, Number_of_approvals desc

