import pandas as pd
import numpy as np
import glob
import os
import joblib

from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression, LinearRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics import accuracy_score, mean_squared_error

# -----------------------------
# CONFIGURATION
# -----------------------------
CSV_FOLDER = r"D:\machine learning\CW\archive\stocks"
MODEL_OUTPUT_FOLDER = r"D:\machine learning\CW\archive\models"
os.makedirs(MODEL_OUTPUT_FOLDER, exist_ok=True)

FEATURE_COLUMNS = [
    'Adj Close', 'Return', 'MA5', 'MA10', 'Volatility', 'Momentum', 'Volume_Change'
]

# -----------------------------
# PROCESS EACH CSV
# -----------------------------
csv_files = glob.glob(os.path.join(CSV_FOLDER, "*.csv"))

for file in csv_files:
    stock_name = os.path.basename(file).replace(".csv", "")
    print(f"\nTraining models for: {stock_name}")

    # LOAD DATA
    df = pd.read_csv(file)
    df['Date'] = pd.to_datetime(df['Date'])
    df = df.sort_values('Date')

    # FEATURE ENGINEERING
    df['Return'] = df['Adj Close'].pct_change()
    df['MA5'] = df['Adj Close'].rolling(5).mean()
    df['MA10'] = df['Adj Close'].rolling(10).mean()
    df['Volatility'] = df['Adj Close'].rolling(5).std()
    df['Momentum'] = df['Adj Close'] - df['Adj Close'].shift(5)
    df['Volume_Change'] = df['Volume'].pct_change()

    # TARGETS
    df['Target'] = (df['Adj Close'].shift(-1) > df['Adj Close']).astype(int)  # classification
    df['PriceTarget'] = df['Adj Close'].shift(-1)                               # regression

    df = df.replace([np.inf, -np.inf], np.nan).dropna()

    if len(df) < 10:
        print(f"Skipping {stock_name}: Not enough data")
        continue

    # FEATURES & LABELS
    X = df[FEATURE_COLUMNS]
    y_class = df['Target']
    y_reg = df['PriceTarget']

    # TRAIN-TEST SPLIT (chronological)
    train_size = int(len(df) * 0.8)
    X_train, X_test = X[:train_size], X[train_size:]
    y_train_class, y_test_class = y_class[:train_size], y_class[train_size:]
    y_train_reg, y_test_reg = y_reg[:train_size], y_reg[train_size:]

    # SCALE
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)

    # -----------------------------
    # CLASSIFICATION MODELS (if enough classes)
    # -----------------------------
    best_class_model = None
    best_class_accuracy = None

    if len(np.unique(y_train_class)) >= 2:
        # Logistic Regression
        log_model = LogisticRegression(max_iter=1000)
        log_model.fit(X_train_scaled, y_train_class)
        log_preds = log_model.predict(X_test_scaled)
        log_acc = accuracy_score(y_test_class, log_preds)

        # KNN
        knn_model = KNeighborsClassifier(n_neighbors=5)
        knn_model.fit(X_train_scaled, y_train_class)
        knn_preds = knn_model.predict(X_test_scaled)
        knn_acc = accuracy_score(y_test_class, knn_preds)

        # Choose best
        if log_acc >= knn_acc:
            best_class_model = log_model
            best_class_accuracy = log_acc
            best_name = "logistic"
        else:
            best_class_model = knn_model
            best_class_accuracy = knn_acc
            best_name = "knn"

        print(f"Classification done. Best: {best_name}, Accuracy: {best_class_accuracy:.4f}")
    else:
        print(f"Skipping classification for {stock_name}: only one class present")

    # -----------------------------
    # LINEAR REGRESSION (baseline)
    # -----------------------------
    lin_model = LinearRegression()
    lin_model.fit(X_train_scaled, y_train_reg)
    lin_preds = lin_model.predict(X_test_scaled)
    rmse = np.sqrt(mean_squared_error(y_test_reg, lin_preds))
    print(f"Linear Regression RMSE: {rmse:.4f}")

    # -----------------------------
    # SAVE MODELS
    # -----------------------------
    stock_model_folder = os.path.join(MODEL_OUTPUT_FOLDER, stock_name)
    os.makedirs(stock_model_folder, exist_ok=True)

    if best_class_model is not None:
        joblib.dump(best_class_model, os.path.join(stock_model_folder, "best_class_model.pkl"))
    joblib.dump(lin_model, os.path.join(stock_model_folder, "linear_model.pkl"))
    joblib.dump(scaler, os.path.join(stock_model_folder, "scaler.pkl"))

    print(f"Saved models and scaler for {stock_name}")
