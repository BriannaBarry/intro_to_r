###########
## Statistics Lab 
############

library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(psych)
library(grid)
library(broom)

#############################
# Part 1
#############################
# Read in the following infant mortality data: 
# http://johnmuschelli.com/intro_to_r/data/indicatordeadkids35.csv
mort = read_csv("http://johnmuschelli.com/intro_to_r/data/indicatordeadkids35.csv")
colnames(mort)[1] = "country"

# 1. Compute the correlation between the 1980, 1990, 2000, and 2010 mortality data.
#    No need to save this in an object. Just display the result to the screen.
mort[, c("1980", "1990", "2010")]
mort %>% select(`1980`, `1990`, `2000`, "2010") %>% cor(use = "complete.obs")

ctests = mort %>% 
  select(`1980`, `1990`, `2000`, "2010") %>% 
  psych::corr.test(adjust = "none")

print(ctests, short = FALSE)


# 2. a. Compute the correlation between the Myanmar, China, and United States mortality data.
#       Store this correlation matrix in an object called country_cor
#    b. Extract the Myanmar-US correlation from the correlation matrix.
sub = mort %>% 
  filter(country %in% c("Myanmar", "China", "United States"))
country = sub$country
sub = select(sub, - country)
sub = t(sub)
colnames(sub) = country
country_cor = cor(sub, use = "complete.obs")
country_cor["Myanmar", "United States"]
c2 = tidy(country_cor)
c2 %>% 
  filter(.rownames == "Myanmar") %>% 
  select("United.States")



# 3. Is there a difference between mortality information from 1990 and 2000?
#    Run a t-test and a Wilcoxon rank sum test to assess this.
#    Hint: to extract the column of information for 1990, use mort[["1990"]]
t.test(mort$`1990`, mort$"2000", paired = FALSE)
t.test(mort$`1990`, mort$"2000", paired = TRUE)
wt = wilcox.test(mort$`1990`, mort$"2000", paired = TRUE)
wt2 = wilcox.test(mort$`1991`, mort$"2000", paired = TRUE)

rbind(tidy(wt), tidy(wt2))




#############################
# Part 2
#############################
# Read in the Kaggle cars auction dataset:
cars = read_csv("http://johnmuschelli.com/intro_to_r/data/kaggleCarAuction.csv")

# 4. Fit a linear regression model with vehicle cost (VehBCost) as the outcome and 
#    vehicle age (VehicleAge) and size (Size) as predictors as well as their interaction.
#    Save the model fit in an object called lmfit_cars and display the summary table.
mod = lm(VehBCost ~ VehicleAge * Size, data = cars)
summary(mod)
tidy_mod = tidy(mod, conf.int = TRUE)
sub_mod = lm(VehBCost ~ VehicleAge + Size, data = cars)
anova(mod, sub_mod)



# 5. Create a variable called "expensive" in the cars data that indicates if the 
#    vehicle cost is over $10,000. Use a chi-squared test to assess if there is a
#    relationship between a car being expensive and it being labeled as a "bad buy."
cars = cars %>% mutate(expensive = VehBCost > 10000)
tab = table(cars$expensive, cars$IsBadBuy)
fisher.test(tab)
chisq.test(tab)



# 6. Fit a logistic regression model where the outcome is "bad buy" status and predictors
#    are the "expensive" status and vehicle age (VehicleAge).
#    Save the model fit in an object called logfit_cars and display the summary table.
logfit_cars = glm(IsBadBuy ~ expensive + VehicleAge, 
                  data = cars, family = binomial())
or_table = tidy(logfit_cars, 
                conf.int = TRUE, 
                exponentiate = TRUE)



#############################
# Part 3
#############################

# 7. Randomly sample 10,000 observations (rows) with replacement from the cars dataset
#    and store this new dataset in an object called cars_subsample.




# 8. Fit the same logistic regression model as in problem 6 above and display the 
#    summary table. How do the results compare?



