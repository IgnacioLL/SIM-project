##################

library(FactoMineR)
numeric_columns <- c("LotFrontage", "LotArea", "YearBuilt", "YearRemodAdd", "MasVnrArea", "BsmtFinSF1", "BsmtFinSF2", "BsmtUnfSF", "TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea", "BsmtFullBath", "BsmtHalfBath", "FullBath", "HalfBath", "BedroomAbvGr", "KitchenAbvGr", "TotRmsAbvGrd", "Fireplaces", "GarageYrBlt", "GarageCars", "GarageArea", "WoodDeckSF", "OpenPorchSF", "EnclosedPorch", "X3SsnPorch", "ScreenPorch", "PoolArea", "MiscVal", "MoSold", "YrSold","SalePrice")

df_cat <- df %>% select(!numeric_columns)

mca_mod <- FactoMineR::MCA(df_cat)

View(mca_mod$eig)

df_cat %>% apply(2,is.na) %>% apply(2,sum)
