# Youth Employment Income Predictor - Summative Assignment


A comprehensive machine learning project that predicts youth employment income using various socio-economic factors. The project includes a Jupyter notebook for data analysis, a FastAPI backend, and a Flutter mobile application.

## 📊 Dataset Description & Source

**Dataset Source:** [Kaggle - Youth Employment Status Rwanda](https://www.kaggle.com/datasets/talentsphere/youth-employment-status-rw)

**Description:**

This dataset contains detailed records of youth in Rwanda, including demographic, educational, regional, and economic factors. It features over 10,000 samples and 25 variables, providing rich volume and variety for robust machine learning analysis. The data is used to predict monthly income based on factors such as age, gender, education, region, employment rates, digital skills, training participation, household size, and income level.

## 📈 Key Data Visualizations

Below are some of the most important visualizations that influenced model development:

### Correlation Heatmap
![Correlation Heatmap](correlation_heatmap.png)
*Correlation heatmap showing relationships between numeric features. Strong correlations help identify key predictors for income.*

### Monthly Income Distribution
![Income Distribution](income_distribution.png)
*Histogram showing the distribution of monthly income among youth. Highlights skewness and outliers in the target variable.*

### Linear Regression Fit: Age vs. Monthly Income
![Linear Regression Fit](linear_fit_age_income.png)
*Scatter plot with linear regression line showing the relationship between age and monthly income.*

## 📋 Project Overview

This summative assignment consists of 4 main tasks:

1. **Linear Regression Model** - Data analysis and machine learning model development
2. **FastAPI Endpoint** - REST API for income predictions
3. **Flutter Mobile App** - User-friendly mobile application
4. **Video Demo** - 5-minute demonstration of the complete system

## 🎯 Model Performance

- **Algorithm**: Random Forest Regressor (Best Performing)
- **Accuracy**: 86.64% (R² Score)
- **Dataset**: Youth unemployment data with 10,000+ samples
- **Features**: 25 socio-economic factors

### Model Comparison Results:
- SGD Linear Regression: 58.46% accuracy
- Decision Tree: 71.23% accuracy
- Random Forest: 86.64% accuracy✅

## 📁 Project Structure

```
summative/
├── linear_regression/
│   ├── multivariate.ipynb          # Complete ML analysis
│   └── youth_unemployment_dataset.csv
├── API/
│   ├── prediction.py               # FastAPI server
│   ├── requirements.txt            # Python dependencies
│   ├── income_prediction_model.pkl # Trained model
│   └── scaler.pkl                 # Data scaler
└── FlutterApp/
    └── youth_income_predictor/
        ├── lib/main.dart          # Flutter app
        └── pubspec.yaml           # Flutter dependencies
```

## 🚀 Quick Start Guide

### 1. Machine Learning Model (Task 1)

**Prerequisites:**
- Python 3.8+
- Jupyter Notebook

**Setup:**
```bash
cd summative/linear_regression
pip install pandas scikit-learn matplotlib seaborn numpy joblib
jupyter notebook multivariate.ipynb
```

**Features Analyzed:**
- Personal: Age, Gender, Education Level
- Geographic: Region, Employment Rates  
- Skills: Digital Skills, Training Participation
- Economic: Household Size, Income Level

### 2. FastAPI Backend (Task 2)

**Prerequisites:**
- Python 3.8+

**Setup:**
```bash
cd summative/API
pip install -r requirements.txt
uvicorn prediction:app --reload
```

**API Endpoints:**
- `POST /predict` - Income prediction endpoint
- `GET /docs` - Swagger UI documentation
- `GET /` - Health check

**API Features:**
- Input validation with Pydantic
- CORS middleware for Flutter integration
- Comprehensive error handling
- Detailed prediction responses

### 3. Flutter Mobile App (Task 3)

**Prerequisites:**
- Flutter SDK 3.0+
- Android Studio or VS Code

**Setup:**
```bash
cd summative/FlutterApp/youth_income_predictor
flutter pub get
flutter run
```

**App Features:**
- Multiple screens (Home, Prediction, About)
- Form validation for all input fields
- Real-time API integration
- Responsive design for mobile devices
- Detailed prediction results with interpretation

### 4. Running the Complete System

**Step 1: Start the API Server**
```bash
cd summative/API
uvicorn prediction:app --reload
```
The API will be available at `http://localhost:8000`

**Step 2: Launch the Flutter App**
```bash
cd summative/FlutterApp/youth_income_predictor
flutter run
```

**Step 3: Test the System**
1. Open the Flutter app
2. Navigate to "Start Prediction"
3. Fill in all required fields
4. Tap "Predict" to get results

## 📱 Mobile App User Guide

### Home Screen
- Welcome interface with app overview
- Navigation to prediction and about screens

### Prediction Screen
**Personal Information:**
- Age (16-30 years)
- Gender (Male/Female)
- Education Level (Primary, Secondary, TVET, University)

**Location & Employment:**
- Region (Kigali, Northern, Eastern, Western, Southern)
- Regional Employment Rate (0-100%)
- Regional Unemployment Rate (0-100%)

**Household & Skills:**
- Household Size (1-15 people)
- Digital Skills Level (Basic, Intermediate, Advanced)
- Household Income Level (Low, Medium, High)
- Training Program Participation (Yes/No)

### About Screen
- Model information and performance metrics
- Feature explanations
- Usage instructions

## 🔧 Technical Implementation

### Machine Learning Pipeline
1. **Data Loading & Exploration** - Understanding the dataset structure
2. **Data Preprocessing** - Handling missing values, encoding categorical variables
3. **Feature Engineering** - Creating derived features for better predictions
4. **Model Training** - Testing multiple algorithms (SGD, Decision Tree, Random Forest)
5. **Model Evaluation** - Performance comparison and validation
6. **Model Persistence** - Saving trained model and scaler for API use

### API Architecture
- **FastAPI Framework** - High-performance async web framework
- **Pydantic Models** - Data validation and serialization
- **Model Loading** - Efficient model and scaler loading at startup
- **Error Handling** - Comprehensive error responses
- **CORS Support** - Cross-origin requests for Flutter integration

### Flutter Architecture
- **Material Design** - Modern UI following Google's design principles
- **State Management** - StatefulWidget for form handling
- **HTTP Integration** - API communication with error handling
- **Form Validation** - Client-side validation for all input fields
- **Responsive Layout** - Optimized for various screen sizes

## 📊 API Usage Examples

### Prediction Request
```json
POST /predict
{
  "age": 25,
  "gender": "Male",
  "education_level": "University",
  "region": "Kigali",
  "region_employment_rate": 75.5,
  "regional_unemployment_rate": 12.3,
  "household_size": 4,
  "digital_skills_level": "Advanced",
  "training_participation": true,
  "household_income": "Medium"
}
```

### Prediction Response
```json
{
  "predicted_monthly_income": 85420.75,
  "model_used": "Random Forest",
  "confidence_level": "High",
  "interpretation": "Based on the provided factors, this prediction indicates above-average income potential..."
}
```

## 🎥 Video Demo (Task 4)

The 5-minute video demonstration covers:

1. **Model Performance** (1 min)
   - Jupyter notebook walkthrough
   - Model comparison results
   - Key insights from data analysis

2. **API Testing** (1.5 min)
   - FastAPI Swagger UI demonstration
   - Endpoint testing with sample data
   - Response validation

3. **Mobile App Demo** (2.5 min)
   - App navigation and UI tour
   - Complete prediction workflow
   - Result interpretation and validation

## 🔍 Key Insights from Analysis

### Most Important Features for Income Prediction:
1. **Education Level** - University education shows highest income correlation
2. **Digital Skills** - Advanced digital skills significantly boost income potential
3. **Regional Employment Rate** - Higher employment regions offer better opportunities
4. **Training Participation** - Professional training programs increase income prospects
5. **Age** - Experience factor with optimal range around 25-28 years

### Regional Analysis:
- **Kigali**: Highest average income potential
- **Eastern Province**: Growing employment opportunities
- **Northern Province**: Focus on agriculture and rural development
- **Western Province**: Tourism and trade sectors
- **Southern Province**: Mixed economic activities

## 🚨 Troubleshooting

### Common Issues:

**API Connection Error:**
- Ensure the FastAPI server is running on `http://localhost:8000`
- Check Windows Firewall settings
- Verify Python environment and dependencies

**Flutter Build Issues:**
- Run `flutter doctor` to check setup
- Ensure Android SDK is properly configured
- Clear Flutter cache: `flutter clean && flutter pub get`

**Model Loading Error:**
- Verify model files exist in API directory
- Check Python version compatibility
- Ensure all dependencies are installed

## 📈 Future Enhancements

1. **Model Improvements**
   - Implement ensemble methods
   - Add cross-validation
   - Include feature importance analysis

2. **API Enhancements**
   - Add authentication
   - Implement rate limiting
   - Add logging and monitoring

3. **Mobile App Features**
   - Offline prediction capability
   - Historical predictions storage
   - Push notifications for updates

## 👥 Project Team

This project demonstrates comprehensive full-stack development skills including:
- Machine Learning & Data Science
- Backend API Development
- Mobile Application Development
- DevOps & Deployment

## 📄 License

This project is created for educational purposes as part of a summative assignment.

---

**Contact Information:**
- GitHub: [Your GitHub Profile]
- Email: [Your Email]
- LinkedIn: [Your LinkedIn Profile]
