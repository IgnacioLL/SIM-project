##################

library(FactoMineR);library(DataExplorer);library(mice); library(lmtest)

numeric_columns <- c("LotFrontage", "LotArea", "YearBuilt", "YearRemodAdd", "MasVnrArea", "BsmtFinSF1", "BsmtFinSF2", "BsmtUnfSF", "TotalBsmtSF", "X1stFlrSF", "X2ndFlrSF", "LowQualFinSF", "GrLivArea", "BsmtFullBath", "BsmtHalfBath", "FullBath", "HalfBath", "BedroomAbvGr", "KitchenAbvGr", "TotRmsAbvGrd", "Fireplaces", "GarageYrBlt", "GarageCars", "GarageArea", "WoodDeckSF", "OpenPorchSF", "EnclosedPorch", "X3SsnPorch", "ScreenPorch", "PoolArea", "MiscVal", "MoSold", "YrSold", "OverallCond","OverallQual","SalePrice")
cat_keep <- c("FireplaceQu","KitchenQual","BsmtFinType1","BsmtExposure","BsmtQual","Foundation","Neighborhood","LotShape","MSSubClass","Exterior1st","Exterior2nd")
df1 <- df %>% select(all_of(numeric_columns), all_of(vars_keep))

df1 %>% create_report(
  config = configure_report(
    add_plot_qq  = FALSE, 
    add_plot_prcomp = FALSE,
    add_plot_boxplot = TRUE
    )
  )

## Impute missing data by creatin extra modality

df1$FireplaceQu <- ifelse(df1$FireplaceQu %>% is.na, "NoFirePlace", df1$FireplaceQu)
df1$BsmtExposure <- ifelse(df1$BsmtExposure %>% is.na, "NoBasement", df1$BsmtExposure)
df1$BsmtFinType1 <- ifelse(df1$BsmtFinType1 %>% is.na, "NoBasement", df1$BsmtFinType1)
df1$BsmtQual <- ifelse(df1$BsmtQual %>% is.na, "NoBasement", df1$BsmtQual)
df1$GarageYrBlt <- df1$GarageYrBlt %>% as.numeric()


df1 %>% create_report(
  config = configure_report(
    add_plot_str = FALSE,
    add_plot_qq  = FALSE, 
    add_plot_prcomp = FALSE,
    add_plot_boxplot = TRUE
  )
)

## Impute with synthetic values
df2 <- mice(df1)

df3 <- complete(df2)

df3 %>% create_report(
  config = configure_report(
    add_plot_str = FALSE,
    add_plot_qq  = FALSE, 
    add_plot_prcomp = FALSE,
    add_plot_boxplot = TRUE,
  )
)

df3[cat_keep] <- lapply(df3[cat_keep], as.factor)
df3 %>% glimpse ## Convert all str columns to factors


### Outliers


# Create a ggplot with a histogram
p <- df3 %>%
  ggplot(data = ., aes(x = SalePrice)) + 
  geom_histogram(col="black", fill="white") +
  theme_bw() +
  theme(
    panel.grid.major = element_line(color = "gray", size = 0.2, linetype = "dashed"),
    panel.grid.minor = element_line(color = "gray", size = 0.2, linetype = "dashed")
  )

shapiro.test(df3$SalePrice) ## It is not normal

## Test serial correlation

acf(df3$SalePrice, main="Autocorrelation Sale Price")
dwtest(SalePrice ~1, data=df3)
 

## There is no serial correlation

# We have multiple outliers as we can see int he exploratory data analysis.
# For the ones that almost all observations are 0, we will categorize them in order to capture this. 

## For others some capping may be a good idea
