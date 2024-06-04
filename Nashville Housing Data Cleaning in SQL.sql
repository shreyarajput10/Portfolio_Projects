Select *
From [NashvilleHousing ]

--Standardized date format

Select SaleDate, CONVERT(Date, SaleDate)
From [NashvilleHousing ]

UPDATE [NashvilleHousing ]
SET SaleDate = CONVERT(Date, SaleDate)

-- Populate PROPERTY Address
Select *
From [NashvilleHousing ]
--Where PropertyAddress IS NULL
Order By ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [NashvilleHousing ] a
JOIN [NashvilleHousing ] b 
ON a.ParcelID = b.ParcelID
AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [NashvilleHousing ] a
JOIN [NashvilleHousing ] b 
ON a.ParcelID = b.ParcelID

--Breaking out Address into individual columns(Address,city,state)

Select PropertyAddress
From [NashvilleHousing ]
--Where PropertyAddress IS NULL
--Order By ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) AS Address
FROM [NashvilleHousing ]

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE [NashvilleHousing ]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE [NashvilleHousing ]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

Select *
From [NashvilleHousing ]

Select OwnerAddress
From [NashvilleHousing ]

Select 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
From [NashvilleHousing ]



ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE [NashvilleHousing ]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE [NashvilleHousing ]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE [NashvilleHousing ]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

--Change Y and N to 'Yes' and 'No' in "Sold as Vacant" field

Select DISTINCT(SoldAsVacant), Count(SoldAsVacant)
From [NashvilleHousing ]
Group by SoldAsVacant
Order by 2

Select SoldAsVacant,
CASE WHEN SoldAsVacant ='Y' THEN 'YES'
    WHEN SoldAsVacant ='N' THEN 'No'
    ELSE SoldAsVacant
    END
From [NashvilleHousing ]

UPDATE [NashvilleHousing ]
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'YES'
    WHEN SoldAsVacant ='N' THEN 'No'
    ELSE SoldAsVacant
    END
    From [NashvilleHousing ]


-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER By UniqueID) row_num
From [NashvilleHousing ]
--Order BY ParcelID
)
DELETE *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress

-- Delete Unused Columns

Select *
From [NashvilleHousing ]

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

