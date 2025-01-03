if(!require('psychotree')) {
  install.packages('psychotree')
  library('psychotree')
}

# Read preference data in a data frame
data <- read.csv("y_train_preference.csv", header = TRUE)
print(class(data))

# Convert to paircomp
pc <- paircomp(data, labels=c("EMNA", "PSO", "RandomSearch"))
print(pc)

# Convert to dataframe
pc_df <- data.frame(preference = pc)
print(head(pc_df, n=5))
print(dim(pc_df))

# Read train data 
X_train <- read.csv("X_train.csv", header = TRUE)
print(class(X_train))

# Drop id columns
X_train <- subset(X_train, select=-c(f_id, i_id))
print(head(X_train, n=5))
dim(X_train)

# Merge preference and feature data to create the dataset
dataset <- cbind(pc_df, X_train)
print(head(combined_df, n = 5))
dim(dataset)

# BT tree
# Minsize,Maxdepth,Prune,Mtry,Alpha,f1_cv,accuracy_cv
# 3,7,BIC,8,0.05,0.9090802484771767,0.5617024746297151
set.seed(123)
tm_tree <- bttree(preference ~ ., data = dataset, minsize = 3, maxdepth=7, mtry=8, prune="BIC", alpha = 0.05)
# Plot the tree
plot(tm_tree, abbreviate = 1)

# Read test data
X_test<-read.csv("X_test.csv")

# Make predictions
predictions<-predict(tm_tree, X_test, type = c("best")) # "worth", "rank", "best", "node"

# Convert to dataframe
predictions_df = data.frame(label = as.character(predictions))
print(head(predictions_df , n=5))

# Save predictions
write.table(predictions_df, "predictions_test.csv",sep=",", row.names = FALSE)

# Make predictions
predictions<-predict(tm_tree, X_test, type = c("node")) # "worth", "rank", "best", "node"
print(predictions)
# Convert to dataframe
predictions_df = data.frame(label = as.character(predictions))
predictions_df$label <- as.numeric(predictions_df$label)

print(head(predictions_df , n=5))

# Save predictions
write.table(predictions_df, "predictions_test_node.csv", sep=",", row.names = FALSE)
