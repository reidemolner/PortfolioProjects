/*

Cleaning Data with SQL

*/

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM PortfolioProject2.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = Convert(Date,SaleDate)

-- If it doesn't Update 


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;


UPDATE Nashvillehousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing
--WHERE PropertyAddress is NULL
order by ParcelId



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject2.dbo.NashvilleHousing a
JOIN PortfolioProject2.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------

-- Address into Individual Columns (Address, City, State)


SELECT PropertyAddress
FROM PortfolioProject2.dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) as Address

FROM PortfolioProject2.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

UPDATE Nashvillehousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE Nashvillehousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing


SELECT OwnerAddress
FROM PortfolioProject2.dbo.NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
FROM PortfolioProject2.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE Nashvillehousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE Nashvillehousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE Nashvillehousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)


SELECT * 
FROM PortfolioProject2.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


SELECT DISTINCT(SoldAsVacant), COUNT(SOLDASVACANT)
FROM PortfolioProject2.dbo.NashvilleHousing
GROUP BY SoldAsVacant
order by 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
FROM PortfolioProject2.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
		When SoldAsVacant = 'N' Then 'No'
		Else SoldAsVacant
		END
		
-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
					UniqueID
					) row_num

FROM PortfolioProject2.dbo.NashvilleHousing
--ORDER BY PARCELID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
order by PropertyAddress


SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing


---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

SELECT *
FROM PortfolioProject2.dbo.NashvilleHousing

ALTER TABLE PortfolioProject2.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, Saledate


