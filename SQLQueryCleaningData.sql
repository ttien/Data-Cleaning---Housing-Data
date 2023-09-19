select *
from PortfolioProject..HousingData
order by 1

select saledateconverted, convert(date, saledate) as SaleDate
from PortfolioProject..HousingData

update HousingData
set SaleDate = convert(date, SaleDate)

alter table HousingData
add SaleDateConverted Date;

update HousingData
set SaleDateConverted = convert(date, SaleDate)

select *
from PortfolioProject..HousingData
--where propertyaddress is null
order by parcelid

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..HousingData as A
join PortfolioProject..HousingData as B
on A.ParcelID = B.ParcelID
and A. [UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is not null

update A
set propertyaddress = isnull(a.propertyaddress, b.PropertyAddress)
from PortfolioProject..HousingData as A
join PortfolioProject..HousingData as B
on A.ParcelID = B.ParcelID
and A. [UniqueID ] <> B.[UniqueID ]
where A.PropertyAddress is not null

select
substring (propertyaddress, 1, charindex(',', propertyaddress) -1 ) as address
, substring (propertyaddress, charindex(',', propertyaddress) +1 , len(propertyaddress)) as address
from PortfolioProject..HousingData

alter table HousingData
add PropertySplitAddress nvarchar(255)

update HousingData
set PropertySplitAddress = substring (propertyaddress, 1, charindex(',', propertyaddress) -1 )

alter table HousingData
add PropertySplitCity nvarchar(255)

update HousingData
set PropertySplitCity = substring (propertyaddress, charindex(',', propertyaddress) +1 , len(propertyaddress))

select *
from PortfolioProject..HousingData

select owneraddress
from PortfolioProject..HousingData

select
parsename(replace(owneraddress, ',' , '.'), 3) as a, 
parsename(replace(owneraddress, ',' , '.'), 2) as b, 
parsename(replace(owneraddress, ',' , '.'), 1) as c
from PortfolioProject..HousingData

alter table HousingData
add OwnerSplitAddress nvarchar(255)

update HousingData
set OwnerSplitAddress = parsename(replace(owneraddress, ',' , '.'), 3)

alter table HousingData
add OwnerSplitCity nvarchar(255)

update HousingData
set OwnerSplitCity = parsename(replace(owneraddress, ',' , '.'), 3)

alter table HousingData
add OwnerSplitState nvarchar(255)

update HousingData
set OwnerSplitState = parsename(replace(owneraddress, ',' , '.'), 3)

select SoldAsVacant
, case when SoldAsVacant = 'y' then 'yes'
when SoldAsVacant = 'n' then 'no'
else SoldAsVacant
end
from PortfolioProject..HousingData

update HousingData
set soldasvacant = case when SoldAsVacant = 'y' then 'Yes'
when SoldAsVacant = 'n' then 'No'
else SoldAsVacant
end

with rownumcte as (
select *, 
ROW_NUMBER() over(partition by parcelid, propertyaddress, saleprice, saledate, legalreference order by uniqueid) row_num
from PortfolioProject..HousingData
--order by ParcelID
)
select *
from rownumcte
where row_num > 1
--order by PropertyAddress


select *
from PortfolioProject..HousingData

alter table portfolioproject..housingdata
drop column owneraddress, taxdistrict, propertyaddress

alter table portfolioproject..housingdata
drop column saledate