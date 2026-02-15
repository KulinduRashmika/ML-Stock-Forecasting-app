from flask import Flask, request, jsonify
from flask_cors import CORS
import joblib
import os
import pandas as pd

app = Flask(__name__)
CORS(app)

# Folder where all stock models are saved
MODEL_FOLDER = r"D:\machine learning\CW\archive\models"

FEATURE_COLUMNS = [
    "Adj Close",
    "Return",
    "MA5",
    "MA10",
    "Volatility",
    "Momentum",
    "Volume_Change"
]

@app.route("/predict", methods=["POST"])
def predict():
    data = request.get_json()

    if not data or "symbol" not in data or "features" not in data:
        return jsonify({"error": "Invalid request format"}), 400

    symbol = data["symbol"].upper()
    features = data["features"]

    # Path for the stock's folder
    stock_folder = os.path.join(MODEL_FOLDER, symbol)
    class_model_path = os.path.join(stock_folder, "best_class_model.pkl")
    reg_model_path = os.path.join(stock_folder, "linear_model.pkl")
    scaler_path = os.path.join(stock_folder, "scaler.pkl")

    if not os.path.exists(stock_folder):
        return jsonify({"error": f"No models found for symbol '{symbol}'"}), 404

    try:
        # Load models/scaler for this stock
        class_model = joblib.load(class_model_path) if os.path.exists(class_model_path) else None
        reg_model = joblib.load(reg_model_path)
        scaler = joblib.load(scaler_path)

        # Create DataFrame with correct order
        df = pd.DataFrame([features])[FEATURE_COLUMNS]

        # Scale features
        X_scaled = scaler.transform(df)

        # Predict direction (classification)
        if class_model is not None:
            direction_class = class_model.predict(X_scaled)[0]
            direction = "UP" if direction_class == 1 else "DOWN"
        else:
            direction = "UNKNOWN"

        # Predict next price (regression)
        predicted_price = float(reg_model.predict(X_scaled)[0])
        current_price = float(features["Adj Close"])

        # Round values
        predicted_price = round(predicted_price, 6)
        current_price = round(current_price, 6)

        return jsonify({
            "symbol": symbol,
            "current_price": current_price,
            "predicted_price": predicted_price,
            "direction": direction
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 400


if __name__ == "__main__":
    app.run(debug=True, port=5000)
