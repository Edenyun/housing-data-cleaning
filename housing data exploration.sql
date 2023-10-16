
/*

Cleaning Data in SQL Queries

*/


select count(*) from nashvillehousing;
select * from nashvillehousing;
--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate
From NashvilleHousing;

Select STR_TO_DATE(SaleDate, '%M %d, %Y')
From NashvilleHousing;


Update NashvilleHousing
SET SaleDate = STR_TO_DATE(SaleDate, '%M %d, %Y');


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From NashvilleHousing
-- Where PropertyAddress is null
order by ParcelID;



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress or b.PropertyAddress)
From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID  != b.UniqueID
Where a.PropertyAddress is null;


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress or b.PropertyAddress);

select * From NashvilleHousing a
JOIN NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID != b.UniqueID
Where a.PropertyAddress is null;




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing;
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, locate(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1 , length(PropertyAddress)) as Address
From NashvilleHousing;


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, locate(',', PropertyAddress) + 1 , length(PropertyAddress));



Select *
From NashvilleHousing;





Select OwnerAddress
From NashvilleHousing;


Select
substring_index(OwnerAddress,',' , -1)
,substring_index(OwnerAddress,',' , 2)
,substring_index(OwnerAddress,',' , 1)
From NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = substring_index(OwnerAddress,',' , -1);


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = substring_index(substring_index(OwnerAddress,',' , 2),',',-1);



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = substring_index(OwnerAddress,',' , 1);



Select *
From NashvilleHousing




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID,
                         PropertyAddress,
                         SalePrice,
                         SaleDate,
                         LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM NashvilleHousing
)
SELECT * FROM RowNumCTE;



Select *
From NashvilleHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From NashvilleHousing


ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;


