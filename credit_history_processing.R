install.packages("plyr", dependencies = TRUE)
install.packages("dplyr", dependencies = TRUE)
install.packages("tidyr")
install.packages("stringr", dependencies = TRUE)
install.packages("ggplot2", dependencies = TRUE)
install.packages("stringr", dependencies = TRUE)
install.packages("VIM")
install.packages("car")
install.packages("corrplot")
install.packages("ggcorrplot")
install.packages("rpart")
install.packages("rpart.plot")
install.packages("randomForest")
install.packages("gbm")
install.packages("caret")


#LIBRARY
library(plyr)
library(dplyr)
library(stringr)
library(ggplot2)
library(stringr)
library(VIM)
library(car)
library(corrplot)
library(ggcorrplot)
library(tidyr)
library(rpart)
library(rpart.plot)
library(randomForest)
library(class)
library(gbm)
library(caret)


options(scipen= 999)


#FUNCTIONS

# Function to fill NaN values with the mean of customer_id groups
fill_na_mean <- function(data, column_name) {
  data <- data %>%
    group_by(customer_id) %>%
    mutate(
      !!sym(column_name) := ifelse(is.na(!!sym(column_name)), mean(!!sym(column_name), na.rm = TRUE), !!sym(column_name))
    ) %>%
    ungroup()
  return(data)
}


#IMPORT DATASET
data_main <- read.csv("/Users/mikhailchurilov/Documents/R_assi/5. credit score classification data.csv")

#data backup
data <- data_main

#CLEANING DATASET

#lowercased all column name
names(data) <- tolower(names(data))
colnames(data)

summary(data)

str(data)

dim(data)

sapply(data, class)

duplicates <- data[duplicated(data), ]
duplicates


#check how many NAs in dataset by column
colSums(is.na(data))
View(data)


#change blank space's data to NA 
#changed to for()
columns <- colnames(data)
for (col in columns) {
  data[[col]] = replace(data[[col]], data[[col]] == "", NA)
}

data

# Count the number of NAs in each line
na_counts <- rowSums(is.na(data))

# Create a histogram to visualize the distribution of the number of NAs across rows
hist(na_counts, main = "NAN distribution", xlab = "Number of NA", ylab = "Freq")

# Determine the threshold for deletion based on analysis
threshold = quantile(na_counts, 0.80) 

# Remove rows exceeding threshold
data <- data[na_counts <= threshold, ]







#customer cleaning

#age cleaning
data$age <- sapply(data$age, function(x) {
  numeric_part <- str_replace_all(x, "[^0-9]", "")
  if (nchar(numeric_part) == 0) {
    return(NA)
  } else {
    return(as.integer(numeric_part))
  }
})

unique_values <- unique(data$age)
sort(unique_values, decreasing = FALSE)


#ssn cleaning
clean_ssn <- function(x) {
  if (str_detect(x, "^\\d{3}-\\d{2}-\\d{4}$")) {
    return(x)
  } else {
    return(NA)
  }
}
data$ssn <- sapply(data$ssn, clean_ssn)

#cleaning occupation 
unique_values <- unique(data$occupation)
unique_values

data$occupation = replace(data$occupation, data$occupation == "_______", NA)


#cleaning annual_income

data$annual_income <- sapply(data$annual_income, function(x) {
  # Remove all characters except numbers and periods
  numeric_part <- str_replace_all(x, "[^0-9.]", "")
  # Check if a string contains at least one digit
  if (nchar(numeric_part) == 0 || !grepl("\\d", numeric_part)) {
    return(NA)
  } else {
    # Convert to floating point
    return(as.numeric(numeric_part))
  }
})

#cleaning monthly_inhand_salary
unique_values <- unique(data$monthly_inhand_salary[is.character(data$monthly_inhand_salary)])
unique_values

#cleaning num_bank_accounts
unique_values <- unique(data$num_bank_accounts[is.character(data$num_bank_accounts)])
unique_values

data$num_bank_accounts[data$num_bank_accounts < 0] <- NA

#cleaning num_of loan 
unique_values <- unique(data$num_of_loan)
unique_values

data$num_of_loan <- sapply(data$num_of_loan, function(x) {
  numeric_part <- str_replace_all(x, "[^0-9]", "")
  if (nchar(numeric_part) == 0) {
    return(NA)
  } else {
    return(as.integer(numeric_part))
  }
})

#cleaning num_of_delayed_payment
unique_values <- unique(data$num_of_delayed_payment)
unique_values

data$num_of_delayed_payment <- sapply(data$num_of_delayed_payment, function(x) {
  numeric_part <- str_replace_all(x, "[^0-9]", "")
  if (is.na(numeric_part) || nchar(numeric_part) == 0) {
    return(NA)
  } else {
    return(as.integer(numeric_part))
  }
})

unique_values <- unique(data$num_of_delayed_payment)
sort(unique_values, decreasing = FALSE)

#cleaning type of loan
unique_values <- unique(data$type_of_loan)
unique_values

#clean delay_from_due_date
data$delay_from_due_date[data$delay_from_due_date < 0] <- NA

#cleaning changed_credit_limit
data$changed_credit_limit <- sapply(data$changed_credit_limit, function(x) {
  #
  numeric_part <- str_replace_all(x, "[^0-9.]", "")
  # 
  if (nchar(numeric_part) == 0 || !grepl("\\d", numeric_part)) {
    return(NA)
  } else {
    # 
    return(as.numeric(numeric_part))
  }
})

summary(data)

#cleaning credit_mix
unique_values <- unique(data$credit_mix)
unique_values

data$credit_mix = replace(data$credit_mix, data$credit_mix == "_", NA)

sum(is.na(data$credit_mix)) 

#cleaning outstanding_debt

data$outstanding_debt <- sapply(data$outstanding_debt, function(x) {
  #
  numeric_part <- str_replace_all(x, "[^0-9.]", "")
  # 
  if (nchar(numeric_part) == 0 || !grepl("\\d", numeric_part)) {
    return(NA)
  } else {
    # 
    return(as.numeric(numeric_part))
  }
})

#cleaning credit_history_age

#build quick function to convert date to amount of months
convert_time_str_to_months <- function(time_str) {
  
  time_parts <- strsplit(time_str, " ")
  
  years <- as.integer(time_parts[[1]][1])
  months <- as.integer(time_parts[[1]][4])
  
  return(years * 12 + months)
}

data$credit_history_age <- sapply(data$credit_history_age, convert_time_str_to_months)

names(data)[names(data) == 'credit_history_age'] <- 'credit_history_months'

#cleaning payment_of_min_amount
unique_values <- unique(data$payment_of_min_amount)
unique_values
data$payment_of_min_amount = replace(data$payment_of_min_amount, data$payment_of_min_amount == "NM", NA)


#cleaning amount_invested_monthly
data$amount_invested_monthly <- sapply(data$amount_invested_monthly, function(x) {
  #
  numeric_part <- str_replace_all(x, "[^0-9.]", "")
  # 
  if (nchar(numeric_part) == 0 || !grepl("\\d", numeric_part)) {
    return(NA)
  } else {
    # 
    return(as.numeric(numeric_part))
  }
})


#cleaning payment_behaviour
unique_values <- unique(data$payment_behaviour)
unique_values

data$payment_behaviour = replace(data$payment_behaviour, data$payment_behaviour == "!@9#%8", NA)


#cleaning monthly_balance

data$monthly_balance <- sapply(data$monthly_balance, function(x) {
  #
  numeric_part <- str_replace_all(x, "[^0-9.]", "")
  # 
  if (nchar(numeric_part) == 0 || !grepl("\\d", numeric_part)) {
    return(NA)
  } else {
    # 
    return(as.numeric(numeric_part))
  }
})

#cleaning credit_score
unique_values <- unique(data$credit_score)
unique_values

colSums(is.na(data))


na_counts <- rowSums(is.na(data))

# Create a histogram to visualize the distribution of the number of NAs across rows
hist(na_counts, main = "distribution of the number of NAs", xlab = "Number of NA", ylab = "Freq")

summary(data)


#NEXT STEP PROCESS ANOMALIES in numerical columns

numeric_columns <- sapply(data, is.numeric)

# Standardization of numeric columns
data_standardized <- scale(data[, numeric_columns])

# Convert to dataframe
data_standardized <- as.data.frame(data_standardized)
names(data_standardized) <- names(data[, numeric_columns])

# Constructing boxplots for each column
for(col in names(data_standardized)) {
  print(ggplot(data_standardized, aes_string(x = "factor(1)", y = col)) +
          geom_boxplot() +
          labs(title = paste("Boxplot of", col), x = "", y = "Standardized value") +
          theme_minimal())
}

filter_data <- data

#age

summary(filter_data$age)

boxplot(filter_data$age)

hist(filter_data$age)

quantile(filter_data$age)


filter_data$age[filter_data$age < 18] <- NA
summary(filter_data$age)

sort(filter_data$age, decreasing = TRUE)

filter_data$age[filter_data$age > 120] <- NA
summary(filter_data$age)

boxplot(filter_data$age)

filter_data$age[filter_data$age > 60] <- NA
summary(filter_data$age)
boxplot(filter_data$age)


  # on the graph we can see a serious gap between the value 56 and the next 
  # unique value in the column; it is also logical to assume that a bank client,
  # having all the attributes of an employed person such as position, income, etc., 
  # must be over 18 years old


# #ADDITIONAL PROCESSING WITH:
  # 1) residuals analysis
  # 2) correlation 
  # 3) regression modeling to process outliers 
  # 4) leverage analysis
  # for
# #annual_income and monthly_inhand_slary

summary(data$annual_income)

hist(data$annual_income)

plot(data$monthly_inhand_salary, data$annual_income)

boxplot(data$annual_income)

# Aggregating data by 'customer_id', mean value of 'annual_income' and 'monthly_inhand_salary' for each group
grouped_salary <- aggregate(cbind(annual_income, monthly_inhand_salary) ~ customer_id, data = data, FUN = mean)
grouped_salary

ggplot(grouped_salary, aes(x = monthly_inhand_salary, y = annual_income)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

cor(grouped_salary$monthly_inhand_salary, grouped_salary$annual_income, use = "complete.obs")
#0.07620711

model <- lm(annual_income ~ monthly_inhand_salary, data = grouped_salary)
summary(model)
#F-statistic: 73.01 on 1 and 12498 DF,  p-value: < 0.00000000000000022

# Residual plot
plot(model$residuals, type = 'p', main = "Residual Plot", ylab = "Residuals", xlab = "Index")
abline(h = 0, col = "red")

# Calculating leverage and its visualization
leverage <- hatvalues(model)
plot(leverage, type="h", main="Leverage Values", ylab="Leverage", xlab="Index")
abline(h = 2*mean(leverage), col="red") # Threshold for identifying significant values

# Setting percentage threshold
percent_threshold <- 10  # For example, 10% deviation from the median

# Calculating the numerical threshold value
threshold <- median(data$monthly_inhand_salary, na.rm = TRUE) * (percent_threshold / 100)

# Preliminarily discard monthly salary values that are significantly different from the others
filter_data <- data %>%
  group_by(customer_id) %>%
  mutate(monthly_inhand_salary = ifelse(abs(monthly_inhand_salary - median(monthly_inhand_salary, na.rm = TRUE)) > threshold, NA, monthly_inhand_salary))

filter_data$annual_income[filter_data$annual_income > 1.3 * 12 * filter_data$monthly_inhand_salary] <- NA

# Discard values in columns where monthly income is NaN
filter_data <- filter_data %>%
  mutate(annual_income = ifelse(is.na(monthly_inhand_salary), NA, annual_income),
         monthly_inhand_salary = ifelse(is.na(annual_income), NA, monthly_inhand_salary))

ggplot(filter_data, aes(x = monthly_inhand_salary, y = annual_income)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

cor(filter_data$monthly_inhand_salary, filter_data$annual_income, use = "complete.obs")
#0.9982401

model <- lm(monthly_inhand_salary ~ annual_income, data = filter_data)
summary(model)
#F-statistic: 2.72e+07 on 1 and 95994 DF,  p-value: < 0.00000000000000022

# Residual plot
plot(model$residuals, type = 'p', main = "Residual Plot", ylab = "Residuals", xlab = "Index")
abline(h = 0, col = "red")

# Calculating leverage and its visualization
leverage <- hatvalues(model)
plot(leverage, type="h", main="Leverage Values", ylab="Leverage", xlab="Index")
abline(h = 2*mean(leverage), col="red") # Threshold for identifying significant values

boxplot(filter_data$annual_income)
boxplot(data$monthly_inhand_salary)


#NUM BANK ACC

# Summary of 'num_bank_accounts'
summary(filter_data$num_bank_accounts)

# Histogram of 'num_bank_accounts'
hist(filter_data$num_bank_accounts)

# Scatter plot of 'num_bank_accounts' vs 'num_credit_card'
plot(filter_data$num_bank_accounts, data$num_credit_card)

# Boxplot of 'num_bank_accounts'
boxplot(filter_data$num_bank_accounts)

# Subset data where 'num_bank_accounts' is less than 15
sub_data <- subset(filter_data, num_bank_accounts < 15)

# Boxplot of 'num_bank_accounts' in the subset data
boxplot(sub_data$num_bank_accounts)

# Summary of 'num_bank_accounts' in the subset data
summary(sub_data$num_bank_accounts)

# Scatter plot of 'num_bank_accounts' vs 'num_credit_card' in the subset data
plot(sub_data$num_bank_accounts, sub_data$num_credit_card)

#NUM CREDIT CARD

# Summary of 'num_credit_card' in the subset data
summary(sub_data$num_credit_card)

# Subset data where 'num_credit_card' is less than 20 and 'num_bank_accounts' is less than 15
sub_data <- subset(filter_data, num_credit_card < 20 & num_bank_accounts < 15)

# Boxplot of 'num_credit_card' in the subset data
boxplot(sub_data$num_credit_card)

# Summary of 'num_credit_card' in the subset data
summary(sub_data$num_credit_card)

# Check subset where 'num_credit_card' is greater than 10
check_col <- subset(sub_data, num_credit_card > 10)

# Scatter plot of 'num_bank_accounts' vs 'num_credit_card' in the subset data
plot(sub_data$num_bank_accounts, sub_data$num_credit_card)

# Set 'num_credit_card' to NA if greater than or equal to 20
filter_data$num_credit_card <- ifelse(filter_data$num_credit_card >= 20, NA, filter_data$num_credit_card)

# Set 'num_bank_accounts' to NA if greater than or equal to 15
filter_data$num_bank_accounts <- ifelse(filter_data$num_bank_accounts >= 15, NA, filter_data$num_bank_accounts)


#interest_rate

# Summary and filtering for 'interest_rate'
summary(filter_data$interest_rate)
sub_data <- subset(filter_data, interest_rate < 50)
boxplot(sub_data$interest_rate)
summary(sub_data$interest_rate)
filter_data$interest_rate <- ifelse(filter_data$interest_rate >= 50, NA, filter_data$interest_rate)

# Summary and filtering for 'num_of_loan'
summary(filter_data$num_of_loan)
boxplot(filter_data$num_of_loan)
sub_data <- subset(filter_data, num_of_loan < 15)
boxplot(sub_data$num_of_loan)
summary(sub_data$num_of_loan)
hist(sub_data$num_of_loan)
filter_data$num_of_loan <- ifelse(filter_data$num_of_loan >= 15, NA, filter_data$num_of_loan)



# Summary and visualization for 'delay_from_due_date'
summary(filter_data$delay_from_due_date)
boxplot(filter_data$delay_from_due_date)



# Summary and filtering for 'num_of_delayed_payment'
summary(filter_data$num_of_delayed_payment)
boxplot(filter_data$num_of_delayed_payment)
check_col <- subset(filter_data, num_of_delayed_payment > 60)
sub_data <- subset(filter_data, num_of_delayed_payment < 40)
boxplot(sub_data$num_of_delayed_payment)
summary(sub_data$num_of_delayed_payment)
hist(sub_data$num_of_delayed_payment)

# Scatter plot and regression line for 'num_of_loan' vs 'num_of_delayed_payment'
ggplot(sub_data, aes(x = num_of_loan, y = num_of_delayed_payment)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Linear model for 'num_of_delayed_payment' based on 'num_of_loan'
model <- lm(num_of_delayed_payment ~ num_of_loan, data = sub_data)
summary(model)

# Set 'num_of_delayed_payment' to NA if greater than or equal to 40
filter_data$num_of_delayed_payment <- ifelse(filter_data$num_of_delayed_payment >= 40, NA, filter_data$num_of_delayed_payment)




# Summary and visualization for 'changed_credit_limit'
summary(filter_data$changed_credit_limit)
boxplot(filter_data$changed_credit_limit)
hist(filter_data$changed_credit_limit)

# Summary and filtering for 'num_credit_inquiries'
summary(filter_data$num_credit_inquiries)
boxplot(filter_data$num_credit_inquiries)
hist(filter_data$num_credit_inquiries)
check_col <- subset(filter_data, num_credit_inquiries > 100)
sub_data <- subset(filter_data, num_credit_inquiries < 20)
boxplot(sub_data$num_credit_inquiries)
hist(sub_data$num_credit_inquiries)
filter_data$num_credit_inquiries <- ifelse(filter_data$num_credit_inquiries >= 20, NA, filter_data$num_credit_inquiries)


# Summary and visualization for 'outstanding_debt'
summary(filter_data$outstanding_debt)
boxplot(filter_data$outstanding_debt)
hist(filter_data$outstanding_debt)


# Summary and visualization for 'credit_utilization_ratio'
summary(filter_data$credit_utilization_ratio)
boxplot(filter_data$credit_utilization_ratio)
hist(filter_data$credit_utilization_ratio)


# Summary and visualization for 'credit_history_months'
summary(filter_data$credit_history_months)
boxplot(filter_data$credit_history_months)
hist(filter_data$credit_history_months)


# ADDITIONAL ANALYSIS WITH:
#   1) CORRELATION AND REGRESSION 
#   2) LINEAR MODEL
#   3) CONTEXT ANALYSIS

# Adding 'total_emi_per_month' to 'filter_data'
filter_data$total_emi_per_month <- data$total_emi_per_month

# Summary and visualization for 'total_emi_per_month'
summary(filter_data$total_emi_per_month)
boxplot(filter_data$total_emi_per_month)
hist(filter_data$total_emi_per_month)

# Check for 'total_emi_per_month' values less than 1
check_col <- subset(filter_data, total_emi_per_month < 1)

# Subset data where 'total_emi_per_month' is between 30 and 1200
sub_data <- subset(filter_data, total_emi_per_month < 1200 & total_emi_per_month > 30)

# Summary and visualization for the subset data
summary(sub_data$total_emi_per_month)
boxplot(sub_data$total_emi_per_month)
hist(sub_data$total_emi_per_month)

# Scatter plot and regression line for 'num_of_loan' vs 'total_emi_per_month'
ggplot(sub_data, aes(x = num_of_loan, y = total_emi_per_month)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Scatter plot and regression line for 'num_credit_card' vs 'total_emi_per_month'
ggplot(sub_data, aes(x = num_credit_card, y = total_emi_per_month)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Filter data based on 'total_emi_per_month' relative to 'monthly_inhand_salary'
sub_data <- filter_data %>%
  mutate(total_emi_per_month = ifelse(total_emi_per_month > 0.5 * monthly_inhand_salary | total_emi_per_month < 30, NA, total_emi_per_month))

# Scatter plot and regression line for 'monthly_inhand_salary' vs 'total_emi_per_month'
ggplot(sub_data, aes(x = monthly_inhand_salary, y = total_emi_per_month)) +
  geom_point(data = subset(sub_data, total_emi_per_month > 0)) +
  geom_smooth(method = "lm", col = "blue", data = subset(sub_data, monthly_inhand_salary > 0))  # Adding a regression line

# Linear model for 'total_emi_per_month' based on 'monthly_inhand_salary'
model <- lm(total_emi_per_month ~ monthly_inhand_salary, data = sub_data)
summary(model)

# Filtering based on client's income and EMI threshold
sub_data <- filter_data %>%
  mutate(total_emi_per_month = ifelse(total_emi_per_month > 0.5 * monthly_inhand_salary, NA, total_emi_per_month)) %>%
  filter(total_emi_per_month > 30)

# Additional context analysis for customers with high EMI
high_emi_customers <- sub_data %>%
  filter(total_emi_per_month > (3 * IQR(total_emi_per_month, na.rm = TRUE)) + quantile(total_emi_per_month, 0.75, na.rm = TRUE))

# Summary of high EMI customers
summary(high_emi_customers$total_emi_per_month)

# Scatter plot and regression line for high EMI customers
ggplot(high_emi_customers, aes(x = total_emi_per_month, y = monthly_inhand_salary)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Final filtering based on income and EMI thresholds
filter_data <- filter_data %>%
  mutate(total_emi_per_month = ifelse(total_emi_per_month > 0.5 * monthly_inhand_salary | monthly_inhand_salary < 30, NA, total_emi_per_month))


# Summary and visualization for 'amount_invested_monthly'
summary(filter_data$amount_invested_monthly)
hist(filter_data$amount_invested_monthly)

boxplot(filter_data$amount_invested_monthly)

# Subset data where 'amount_invested_monthly' is less than 3000
sub_data <- subset(filter_data, amount_invested_monthly < 3000)
summary(sub_data$amount_invested_monthly)
boxplot(sub_data$amount_invested_monthly)

# Scatter plot and regression line for 'amount_invested_monthly' vs 'monthly_inhand_salary'
ggplot(sub_data, aes(x = amount_invested_monthly, y = monthly_inhand_salary)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Filter data based on 'amount_invested_monthly'
filter_data <- filter_data %>%
  mutate(amount_invested_monthly = ifelse(amount_invested_monthly > 3000, NA, amount_invested_monthly))


# Summary and visualization for 'monthly_balance'
summary(filter_data$monthly_balance)
hist(filter_data$monthly_balance)
boxplot(filter_data$monthly_balance)

# Subset data where 'monthly_balance' is less than 2000
sub_data <- subset(filter_data, monthly_balance < 2000)
summary(sub_data$monthly_balance)
boxplot(sub_data$monthly_balance)

# Scatter plot and regression line for 'monthly_balance' vs 'monthly_inhand_salary'
ggplot(sub_data, aes(x = monthly_balance, y = monthly_inhand_salary)) +
  geom_point() +
  geom_smooth(method = lm, col = "blue")  # Adding a regression line

# Filter data based on 'monthly_balance'
filter_data <- filter_data %>%
  mutate(monthly_balance = ifelse(monthly_balance > 2000, NA, monthly_balance))

# Re-analysis of NA values

# count Nans in every row
na_counts <- rowSums(is.na(filter_data))

# DF for visualization 
na_counts_df <- data.frame(
  count = na_counts
) %>%
  group_by(count) %>%
  summarise(freq = n())

# add the column to count percentage of dostribution NA
na_counts_df <- na_counts_df %>%
  mutate(
    fraction = freq / sum(freq),
    ymax = cumsum(fraction),
    ymin = c(0, head(cumsum(fraction), n = -1))
  )

# create "donut chart"
ggplot(na_counts_df, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 3, fill = as.factor(count))) +
  geom_rect() +
  coord_polar(theta = "y") +
  xlim(c(2, 4)) +
  theme_void() +
  labs(title = "Distribution of NA values per row",
       fill = "Number of NA") +
  geom_text(aes(x = 0, y = 0, label = sum(freq), size = 8), show.legend = FALSE) +
  theme(legend.position = "right")

# Create a histogram to visualize the distribution of NA values per row
hist(na_counts, main = "Distribution of NA values per row", xlab = "Number of NA", ylab = "Frequency")

# Remove rows that exceed the threshold = 4
filter_data <- filter_data[na_counts <= 4, ]

# Count the number of NA values in each column
na_counts <- colSums(is.na(filter_data))

# Convert to a data frame for use in ggplot2
na_counts_df <- data.frame(
  column = names(na_counts),
  na_count = na_counts
)

# Create a bar chart
ggplot(na_counts_df, aes(x = reorder(column, -na_count), y = na_count)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Number of NA values per column", x = "Columns", y = "Number of NA") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#age max limit was droped
filter_data$age[filter_data$age > 60] <- NA
filter_data$age[filter_data$age < 18] <- NA

filter_data <- filter_data %>%
  mutate(age = ifelse(is.na(age), median(age, na.rm = TRUE), age))



# List of columns to process
columns_to_fill <- c("annual_income", "monthly_inhand_salary", "num_bank_accounts",
                     "num_credit_card","interest_rate", "num_of_loan","delay_from_due_date",
                     "changed_credit_limit", "num_credit_inquiries", "monthly_balance",
                     "credit_utilization_ratio","total_emi_per_month","amount_invested_monthly")

# Apply the function to each column in the list
for (column_name in columns_to_fill) {
  filter_data <- fill_na_mean(filter_data, column_name)
}

# Check the result for columns
summary(filter_data)
summary(data)



#ADDITIONAL

# FILLING MISSING VALUES FOR NUMERIC COLUMNS INVOLVED IN HYPOTHESES USING K-NEAREST NEIGHBORS (KNN) WITH k=3

# First, create a copy of the data for processing
knn_data <- filter_data

# Apply kNN method to selected columns
knn_data <- kNN(knn_data, variable = c("num_of_delayed_payment", "credit_history_months"), k = 3)

# Check the results
summary(knn_data)

# Check if there are any remaining missing values
colSums(is.na(knn_data))

# Compare distributions before and after filling
par(mfrow = c(2, 1))
hist(filter_data$credit_history_months, main = "Before KNN Imputation", xlab = "credit_history_months", breaks = 50)
hist(knn_data$credit_history_months, main = "After KNN Imputation", xlab = "credit_history_months", breaks = 50)

# Update the original data with imputed values
filter_data$credit_history_months <- knn_data$credit_history_months
filter_data$num_of_delayed_payment <- knn_data$num_of_delayed_payment


#FILLING occupation, credit_mix, payment behavior, payment_of_min_amount by mode
mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

mode_occupation <- mode(filter_data$occupation)
mode_credit_mix <- mode(filter_data$credit_mix)
mode_payment_behaviour <- mode(filter_data$payment_behaviour)
mode_payment_of_min_amount <- mode(filter_data$payment_of_min_amount)

filter_data <- filter_data %>%
  mutate(occupation = ifelse(is.na(occupation), mode_occupation, occupation),
         credit_mix = ifelse(is.na(credit_mix), mode_credit_mix, credit_mix),
         payment_behaviour = ifelse(is.na(payment_behaviour), mode_payment_behaviour, payment_behaviour),
         payment_of_min_amount = ifelse(is.na(payment_of_min_amount), mode_payment_of_min_amount, payment_of_min_amount))

summary(filter_data)
filter_data <- filter_data %>% select(-name)

filter_data <- na.omit(filter_data)
summary(filter_data)

# Customers who have a higher number of delayed payments, a longer credit history age,
# a lower payment behavior score, and higher outstanding debt are 
# likely to have a lower credit score.

#CORRELATION MATRIX
# Selecting numeric columns only
numeric_data <- filter_data %>% select_if(is.numeric)
# Calculation of the correlation matrix
cor_matrix <- cor(numeric_data, use = "complete.obs")
# Building a correlation matrix using ggcorrplot
ggcorrplot(cor_matrix, 
           hc.order = TRUE, 
           type = "lower", 
           lab = TRUE, 
           lab_size = 3, 
           method = "circle", 
           colors = c("tomato2", "white", "springgreen3"), 
           title = "Correlation Matrix", 
           ggtheme = theme_minimal())


filter_data <- filter_data %>%
  mutate(credit_score_binary = ifelse(credit_score == "Poor", 1, 0))

#1) PAYMENT BEHAVIOUR

# Count the number of poor credit scores (1) for each payment behavior category
count_behaviour <- filter_data %>%
  group_by(payment_behaviour) %>%
  summarise(poor_credit_count = sum(credit_score_binary == 1))

# Graphing
# Building a barchart
ggplot(count_behaviour, aes(x = payment_behaviour, y = poor_credit_count, fill = payment_behaviour)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Count of Poor Credit Scores by Payment Behaviour",
       x = "Payment Behaviour",
       y = "Count of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set3", guide = FALSE)  

#CONCLUSION
# We see that a significant part of the total number of observations that have a poor credit score
# belong to the category with low expenses and small payments. 
# From this we can judge that customers with lower payment behavior tend to have a poor credit score.

#2) DURATION OF CREDIT HISTORY

# Create categories in increments of 50 for credit_history_months
filter_data <- filter_data %>%
  mutate(credit_history_range = cut(credit_history_months, 
                                    breaks = seq(0, max(credit_history_months, na.rm = TRUE), by = 50),
                                    right = FALSE, include.lowest = TRUE))

# Count the number of poor credit scores (1) in each category credit_history_range
count_history <- filter_data %>%
  group_by(credit_history_range) %>%
  summarise(poor_credit_count = sum(credit_score_binary == 1, na.rm = TRUE),
            total_count = n()) %>%
  mutate(poor_credit_proportion = poor_credit_count / total_count)

# Constructing a barchart for the amount of poor credit score in each category credit_history_range
ggplot(count_history, aes(x = credit_history_range, y = poor_credit_count, fill = credit_history_range)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Count of Poor Credit Scores by Credit History Duration",
       x = "Credit History Duration (Months)",
       y = "Count of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "none")

# Constructing a barchart for the proportion of poor credit score in each category credit_history_range
ggplot(count_history, aes(x = credit_history_range, y = poor_credit_proportion, fill = credit_history_range)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Proportion of Poor Credit Scores by Credit History Duration",
       x = "Credit History Duration (Months)",
       y = "Proportion of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "none")

#CONCLUSION
# Based on the graph we can see that clients with a longer history tend to be less likely
# to have a poor credit score. Accordingly, we reject our hypothesis that long history 
# is positively correlated with the growth of observations in the poor credit score category



#3) NUMBER OF DELAYED PAYMENTS

# Count the number of poor credit scores in number of delayed payments
delay_count <- filter_data %>%
  group_by(num_of_delayed_payment) %>%
  summarise(poor_credit_count = sum(credit_score_binary == 1, na.rm = TRUE),
            total_count = n()) %>%
  mutate(poor_credit_proportion = poor_credit_count / total_count)

ggplot(delay_count, aes(x = num_of_delayed_payment, y = poor_credit_count, fill = num_of_delayed_payment)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Count of Poor Credit Scores by number of delays",
       x = "Number of delayed payments",
       y = "Count of Poor Credit Scores") +
  theme(legend.position = "none")  # Remove the legend completely

#CONCLUSION
# Drawing a conclusion from the analysis, we can see a positive correlation between 
# the number of delayed payments and the presence of clients in the poor credit 
# score category. which confirms our primary hypothesis. Let us note that the 
# latest values of the number of delayed payments starting from 20 on the graph 
# have low values, this is due to the small number of observations in this category.

#4) OUTSTANDING DEPOSIT

# Create categories in increments of 500 for outstanding deposit
filter_data <- filter_data %>%
  mutate(outstanding_debt_range = cut(outstanding_debt, 
                                    breaks = seq(0, max(outstanding_debt, na.rm = TRUE), by = 500),
                                    right = FALSE, include.lowest = TRUE))

# Count the number of poor credit scores (1) in each category outstanding_debt
count_out_debt <- filter_data %>%
  group_by(outstanding_debt_range) %>%
  summarise(poor_credit_count = sum(credit_score_binary == 1, na.rm = TRUE),
            total_count = n()) %>%
  mutate(poor_credit_proportion = poor_credit_count / total_count)

# Constructing a barchart for the amount of poor credit score in each category outstanding_debt
ggplot(count_out_debt, aes(x = outstanding_debt_range, y = poor_credit_count, fill = outstanding_debt_range)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Count of Poor Credit Scores by outstanding deposit",
       x = "Credit History Duration (Months)",
       y = "Count of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(legend.position = "none") 


# Constructing a barchart for the proportion of poor credit score in each category outstanding_debt
ggplot(count_out_debt, aes(x = outstanding_debt_range, y = poor_credit_proportion, fill = outstanding_debt_range)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Proportion of Poor Credit Scores by outstanding deposit",
       x = "Outstanding deposit(range)",
       y = "Proportion of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_brewer(palette = "Set4", guide = FALSE)

delay_count$poor_credit_proportion <- delay_count$poor_credit_count / delay_count$total_count

# Построение графика
ggplot(delay_count, aes(x = num_of_delayed_payment, y = poor_credit_proportion, fill = num_of_delayed_payment)) +
  geom_bar(stat = "identity", color = "black") +
  labs(title = "Proportion of Poor Credit Scores by Number of Delayed Payments",
       x = "Number of Delayed Payments",
       y = "Proportion of Poor Credit Scores") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
#CONCLUSION

# The proportion graph shows that, in general, there is a clear tendency for the
# probability of having a poor credit score to increase as the late 
# payment increases. We confirm the primary hypothesis.


# Data conversion for regression modeling
# Select numeric columns and exclude those that do not make sense to logarithm, for example, identifiers
numeric_columns <- filter_data %>%
  select_if(is.numeric) %>%
  select(-id, -credit_score_binary)

# Apply logarithm to suitable columns
log_transformed_data <- numeric_columns %>%
  mutate_all(~ log1p(.))

# # Combine with the original date frame to save all columns
log_transformed_data <- filter_data %>%
  select(-one_of(names(numeric_columns))) %>%
  bind_cols(log_transformed_data)

# Checking the result
summary(log_transformed_data)

#HYPOTESIS TESTING

# Jane Lee 

#1st analysis 
filter_data$payment_behaviour <- factor(filter_data$payment_behaviour,
                                        levels = c("Low_spent_Large_value_payments",
                                                   "Low_spent_Medium_value_payments",
                                                   "Low_spent_Small_value_payments",
                                                   "High_spent_Large_value_payments",
                                                   "High_spent_Medium_value_payments",
                                                   "High_spent_Small_value_payments"))

# Ensure credit_score is a factor if it isn't already
filter_data$credit_score <- as.factor(filter_data$credit_score)

# Create a bar chart with ordered payment behaviours
ggplot(filter_data, aes(x = payment_behaviour, fill = credit_score)) +
  geom_bar(position = "dodge") +
  labs(title = "Distribution of Credit Scores by Payment Behaviour",
       x = "Payment Behaviour",
       y = "Count",
       fill = "Credit Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Ensure payment_behaviour is a factor with ordered levels
filter_data$payment_behaviour <- factor(filter_data$payment_behaviour,
                                        levels = c("Low_spent_Large_value_payments",
                                                   "Low_spent_Medium_value_payments",
                                                   "Low_spent_Small_value_payments",
                                                   "High_spent_Large_value_payments",
                                                   "High_spent_Medium_value_payments",
                                                   "High_spent_Small_value_payments"))

# Ensure credit_score is a factor if it isn't already
filter_data$credit_score <- as.factor(filter_data$credit_score)

# Create a bar chart with ordered payment behaviours and custom colors
ggplot(filter_data, aes(x = payment_behaviour, fill = credit_score)) +
  geom_bar(position = "dodge") +
  scale_fill_manual(values = c("Poor" = "purple", "Standard" = "#FFF200", "Good" = "green")) +
  labs(title = "Distribution of Credit Scores by Payment Behaviour",
       x = "Payment Behaviour",
       y = "Count",
       fill = "Credit Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#2nd analysis
# Ensure relevant columns are factors or numeric
filter_data$payment_behaviour <- as.factor(filter_data$payment_behaviour)
filter_data$credit_score <- as.factor(filter_data$credit_score)
filter_data$monthly_inhand_salary <- as.numeric(filter_data$monthly_inhand_salary)

# Convert credit_score to numeric for analysis
filter_data <- filter_data %>%
  mutate(credit_score_numeric = case_when(
    credit_score == "Good" ~ 1,
    credit_score == "Standard" ~ 2,
    credit_score == "Poor" ~ 3,
    TRUE ~ NA_real_
  ))

# Create salary ranges
filter_data <- filter_data %>%
  mutate(salary_range = cut(monthly_inhand_salary,
                            breaks = seq(0, 16000, by = 2000),
                            include.lowest = TRUE,
                            right = FALSE,
                            labels = paste(seq(0, 14000, by = 2000), seq(2000, 16000, by = 2000), sep = "-")))

# Remove rows with NA in salary_range
filter_data <- filter_data %>%
  filter(!is.na(salary_range))

# Create a pivot table
pivot_table <- filter_data %>%
  group_by(payment_behaviour, salary_range) %>%
  summarise(avg_credit_score = mean(credit_score_numeric, na.rm = TRUE)) %>%
  ungroup()

# Reshape the pivot table for the heatmap
heatmap_data <- dcast(pivot_table, payment_behaviour ~ salary_range, value.var = "avg_credit_score")

# Melt the data for ggplot2
melted_heatmap_data <- melt(heatmap_data, id.vars = "payment_behaviour")

# Create the heatmap
ggplot(melted_heatmap_data, aes(x = variable, y = payment_behaviour, fill = value)) +
  geom_tile() +
  scale_fill_gradient(low = "blue", high = "pink", na.value = "white") +
  labs(title = "Heatmap of Credit Scores by Salary Range and Payment Behaviour",
       x = "Monthly Inhand Salary Range",
       y = "Payment Behaviour",
       fill = "Avg Credit Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

summary(filter_data)

#EXTRA FEATURE
# Ensure relevant columns are factors or numeric
filter_data$payment_behaviour <- as.factor(filter_data$payment_behaviour)
filter_data$credit_score <- as.factor(filter_data$credit_score)
filter_data$monthly_inhand_salary <- as.numeric(filter_data$monthly_inhand_salary)

# Convert credit_score to numeric for analysis
filter_data <- filter_data %>%
  mutate(credit_score_numeric = case_when(
    credit_score == "Good" ~ 1,
    credit_score == "Standard" ~ 2,
    credit_score == "Poor" ~ 3,
    TRUE ~ NA_real_
  ))

# Create salary ranges
filter_data <- filter_data %>%
  mutate(salary_range = cut(monthly_inhand_salary,
                            breaks = seq(0, 16000, by = 2000),
                            include.lowest = TRUE,
                            right = FALSE,
                            labels = paste(seq(0, 14000, by = 2000), seq(2000, 16000, by = 2000), sep = "-")))

# Remove rows with NA in salary_range
filter_data <- filter_data %>%
  filter(!is.na(salary_range))

# Create a pivot table
pivot_table <- filter_data %>%
  group_by(payment_behaviour, salary_range) %>%
  summarise(avg_credit_score = mean(credit_score_numeric, na.rm = TRUE)) %>%
  ungroup()

# Reshape the pivot table for the heatmap
heatmap_data <- dcast(pivot_table, payment_behaviour ~ salary_range, value.var = "avg_credit_score")

# Melt the data for ggplot2
melted_heatmap_data <- melt(heatmap_data, id.vars = "payment_behaviour")

# Find the highest and lowest avg_credit_score values
max_value <- max(melted_heatmap_data$value, na.rm = TRUE)
min_value <- min(melted_heatmap_data$value, na.rm = TRUE)

# Create the heatmap with distinct colors for highest and lowest values
ggplot(melted_heatmap_data, aes(x = variable, y = payment_behaviour, fill = value)) +
  geom_tile() +
  geom_point(data = melted_heatmap_data %>% filter(value == max_value),
             aes(x = variable, y = payment_behaviour), color = "red", size = 5, shape = 21, fill = "red") +
  geom_point(data = melted_heatmap_data %>% filter(value == min_value),
             aes(x = variable, y = payment_behaviour), color = "green", size = 5, shape = 21, fill = "green") +
  scale_fill_gradient(low = "blue", high = "pink", na.value = "white") +
  labs(title = "Heatmap of Credit Scores by Salary Range and Payment Behaviour",
       x = "Monthly Inhand Salary Range",
       y = "Payment Behaviour",
       fill = "Avg Credit Score") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

summary(filter_data)

#3rd analysis
#machine learning: predict credit score using payment behaviour

#logistic regression

# Ensure relevant columns are factors or numeric
filter_data$payment_behaviour <- as.factor(filter_data$payment_behaviour)
filter_data$credit_score <- as.factor(filter_data$credit_score)
filter_data$monthly_inhand_salary <- as.numeric(filter_data$monthly_inhand_salary)

# Convert credit_score to numeric for analysis
filter_data <- filter_data %>%
  mutate(credit_score_numeric = case_when(
    credit_score == "Good" ~ 1,
    credit_score == "Standard" ~ 2,
    credit_score == "Poor" ~ 3,
    TRUE ~ NA_real_
  ))

# Prepare the data for modeling
model_data <- filter_data %>%
  select(payment_behaviour, num_of_delayed_payment, outstanding_debt, monthly_inhand_salary, credit_score) %>%
  na.omit()

# Convert credit score to binary: Good vs Not Good
model_data$credit_score_binary <- ifelse(model_data$credit_score == "Good", 1, 0)

# Logistic Regression Model
logistic_model <- glm(credit_score_binary ~ payment_behaviour + num_of_delayed_payment + outstanding_debt + monthly_inhand_salary, 
                      data = model_data, family = binomial)

# Print the summary of the model
summary(logistic_model)

# Predict using the logistic regression model
logistic_predictions <- ifelse(predict(logistic_model, model_data, type = "response") > 0.5, 1, 0)

# Confusion Matrix
conf_matrix <- confusionMatrix(as.factor(logistic_predictions), as.factor(model_data$credit_score_binary))

# Print the confusion matrix
print(conf_matrix)


#Null hypothesis (H0):              #ADDITIONAL MARKS : CENTERING MODEL

  #Days of late payments and the number of late payments do not have
  #a significant impact on the probability of a low credit score (credit_score_binary).
h2_data <- log_transformed_data
delay_model <- glm(credit_score_binary ~ delay_from_due_date * num_of_delayed_payment, 
                   family = binomial, data = h2_data)
summary(delay_model)
vif(delay_model)

# high collinearity
#   delay_from_due_date has VIF around 19
#   num_of_delayed_payment has a VIF of about 15
#   The interaction delay_from_due_date:num_of_delayed_payment has a VIF around 48

# Centering variables
h2_data$delay_from_due_date_centered <- scale(h2_data$delay_from_due_date, center = TRUE, scale = FALSE)
h2_data$num_of_delayed_payment_centered <- scale(h2_data$num_of_delayed_payment, center = TRUE, scale = FALSE)

# Build a model with centered variables
centered_model <- glm(
  formula = credit_score_binary ~ delay_from_due_date_centered * num_of_delayed_payment_centered, 
  family = binomial, 
  data = h2_data
)

# Check VIF for the centered model
vif(centered_model)
summary(centered_model)


# Create predicted probability values
h2_data$predicted_delay <- predict(centered_model, type = "response")

# Interaction visualization
ggplot(h2_data, aes(x = delay_from_due_date, y = predicted_delay, color = factor(num_of_delayed_payment))) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "glm", method.args = list(family = "binomial"), se = FALSE) +
  labs(title = "Impact of Payment Delay and Number of Delayed Payments on Probability of Low Credit Score",
       x = "Payment Delay from Due Date",
       y = "Probability of Low Credit Score",
       color = "Number of Delayed Payments")

# We reject the null hypothesis (H0), which states that delay_from_due_date and num_of_delayed_payment have no effect
# on the likelihood of a low credit score, and accept the alternative hypothesis (H1), which indicates a significant
# effect of these variables and their interaction.


# Null hypothesis (H0): 
# Length of credit history does not affect the probability of a poor credit score.

#KNN METHOD
h3_data <-filter_data

h3_data$credit_score_binary <- as.factor(h3_data$credit_score_binary)

# Dividing the data into training and test samples
set.seed(111)
train_index <- sample(seq_len(nrow(h3_data)), size = 0.7*nrow(h3_data))
train_data <- h3_data[train_index, ]
test_data <- h3_data[-train_index, ]

# Application of KNN
knn_model <- knn(train = train_data[, "credit_history_months", drop = FALSE],
                 test = test_data[, "credit_history_months", drop = FALSE],
                 cl = train_data$credit_score_binary, k = 10)

# Forecasting based on test data
test_data$predicted_prob_knn <- as.numeric(as.character(knn_model))
# Visualization of predicted probabilities
ggplot(test_data, aes(x = credit_history_months, y = predicted_prob_knn)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Predicted Probability of Low Credit Score by Credit History Length (kNN)",
       x = "Credit History Length (scaled)",
       y = "Predicted Probability of Low Credit Score")

# errors martix 
confusion_matrix_knn <- confusionMatrix(as.factor(test_data$predicted_prob_knn), as.factor(test_data$credit_score_binary))
print(confusion_matrix_knn)

# general metrics
accuracy_knn <- confusion_matrix_knn$overall['Accuracy']
precision_knn <- confusion_matrix_knn$byClass['Pos Pred Value']
recall_knn <- confusion_matrix_knn$byClass['Sensitivity']
f1_score_knn <- 2 * (precision_knn * recall_knn) / (precision_knn + recall_knn)

print(paste("Accuracy: ", accuracy_knn))
print(paste("Precision: ", precision_knn))
print(paste("Recall: ", recall_knn))
print(paste("F1 Score: ", f1_score_knn))


# Length of credit history has a statistically significant effect on the likelihood of a low credit score,
# but a negative one. Accordingly, the shorter the history, the greater the likelihood of 
# getting a low credit rating.
# The longer the credit history, the higher the likelihood of obtaining a high credit rating.
# We reject the null hypothesis.



# Null hypothesis (H0): 
# Outstanding deposit does not affect the probability of a poor credit score.

#Gradient Boosting MEthod
# Building a model
h4_data <- filter_data
debt_gbm <- gbm(credit_score_binary ~ outstanding_debt, data = h4_data, distribution = "bernoulli", n.trees = 100)

# Forecasting
h4_data$predicted_prob_gbm <- predict(debt_gbm, n.trees = 100, type = "response")

# Visualization of predicted probabilities
ggplot(h4_data, aes(x = outstanding_debt, y = predicted_prob_gbm)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(title = "Impact of Outstanding Debt on Probability of Low Credit Score (Gradient Boosting)",
       x = "Outstanding Debt",
       y = "Predicted Probability of Low Credit Score")

set.seed(111)
train_index <- sample(seq_len(nrow(h4_data)), size = 0.7*nrow(h4_data))
train_data <- h4_data[train_index, ]
test_data <- h4_data[-train_index, ]

# Learning the gradient boosting model
debt_gbm <- gbm(credit_score_binary ~ outstanding_debt, data = train_data, distribution = "bernoulli", n.trees = 100)

#prediciton
test_data$predicted_prob_gbm <- predict(debt_gbm, newdata = test_data, n.trees = 100, type = "response")

# transforming into classes
test_data$predicted_class_gbm <- ifelse(test_data$predicted_prob_gbm > 0.5, 1, 0)

confusion_matrix_gbm <- confusionMatrix(as.factor(test_data$predicted_class_gbm), as.factor(test_data$credit_score_binary))
print(confusion_matrix_gbm)

# general metrics
accuracy_gbm <- confusion_matrix_gbm$overall['Accuracy']
precision_gbm <- confusion_matrix_gbm$byClass['Pos Pred Value']
recall_gbm <- confusion_matrix_gbm$byClass['Sensitivity']
f1_score_gbm <- 2 * (precision_gbm * recall_gbm) / (precision_gbm + recall_gbm)

print(paste("Accuracy: ", accuracy_gbm))
print(paste("Precision: ", precision_gbm))
print(paste("Recall: ", recall_gbm))
print(paste("F1 Score: ", f1_score_gbm))


# Debt (outstanding_debt) is also an important factor in credit scoring analysis.
# Increasing debt is associated with an increased likelihood of receiving a low credit score.
# we reject the null hypothesis.

write.csv(clean_data, file = "/Users/mikhailchurilov/Documents/R_assi/final_data.csv", row.names = FALSE)


