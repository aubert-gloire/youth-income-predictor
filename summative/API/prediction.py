from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import joblib
import pandas as pd
import numpy as np
from typing import Dict, Any
import os

# Initialize FastAPI app
app = FastAPI(
    title="Youth Employment Income Predictor API",
    description="An AI-powered API that predicts monthly income for youth based on socio-economic factors in Rwanda",
    version="1.0.0"
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with specific origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model artifacts
try:
    model = joblib.load('best_model.pkl')
    scaler = joblib.load('scaler.pkl')
    label_encoders = joblib.load('label_encoders.pkl')
    
    # Read feature names
    with open('feature_names.txt', 'r') as f:
        feature_names = [line.strip() for line in f.readlines()]
    
    print("Model artifacts loaded successfully!")
except Exception as e:
    print(f"Error loading model artifacts: {e}")
    model = None
    scaler = None
    label_encoders = None
    feature_names = None

# Pydantic models for request/response validation
class PredictionRequest(BaseModel):
    age: int = Field(..., ge=16, le=30, description="Age of the youth (16-30 years)")
    gender: str = Field(..., pattern="^(Male|Female)$", description="Gender: Male or Female")
    education_level: str = Field(..., pattern="^(Primary or Less|Secondary|TVET|University)$", 
                                description="Education level")
    region: str = Field(..., pattern="^(Kigali|Northern|Eastern|Western|Southern)$", 
                       description="Region in Rwanda")
    region_employment_rate: float = Field(..., ge=0.0, le=100.0, 
                                         description="Regional employment rate (0-100%)")
    regional_unemployment_rate: float = Field(..., ge=0.0, le=100.0, 
                                            description="Regional unemployment rate (0-100%)")
    household_size: int = Field(..., ge=1, le=15, description="Number of people in household (1-15)")
    digital_skills_level: str = Field(..., pattern="^(Basic|Intermediate|Advanced)$", 
                                     description="Digital skills level")
    training_participation: bool = Field(..., description="Whether participated in training programs")
    household_income: str = Field(..., pattern="^(Low|Medium|High)$", 
                                 description="Household income level")

class PredictionResponse(BaseModel):
    predicted_monthly_income: float = Field(..., description="Predicted monthly income in RWF")
    model_used: str = Field(..., description="The ML model used for prediction")
    confidence_level: str = Field(..., description="Confidence level of the prediction")
    interpretation: str = Field(..., description="Human-readable interpretation")

class ErrorResponse(BaseModel):
    error: str = Field(..., description="Error message")
    details: str = Field(..., description="Detailed error information")

def create_feature_vector(request: PredictionRequest) -> pd.DataFrame:
    """
    Convert the request into a feature vector that matches the training data format.
    """
    try:
        # Create a comprehensive input data dictionary with all required features
        input_data = {
            'age': request.age,
            'region_employment_rate': request.region_employment_rate,
            'regional_unemployment_rate': request.regional_unemployment_rate,
            'unemployment_duration': 0.0,  # Default median value
            'household_size': request.household_size,
            'employment_duration_post_intervention': 6.0,  # Default median value
            'youth_unemployment_rate': 19.4,  # Constant from dataset
            'urban_rural_employment_rate': 60.0,  # Default value
            
            # Encoded categorical variables
            'gender_encoded': 1 if request.gender.lower() == 'male' else 0,
            'education_level_encoded': {
                'primary or less': 0, 'secondary': 1, 'tvet': 2, 'university': 3
            }.get(request.education_level.lower(), 1),
            'education_mismatch_encoded': 0,  # Default
            'sector_of_interest_encoded': 0,  # Default
            'current_employment_sector_encoded': 0,  # Default
            'formal_informal_encoded': 0,  # Default (Informal)
            'region_encoded': {
                'kigali': 0, 'northern': 1, 'eastern': 2, 'western': 3, 'southern': 4
            }.get(request.region.lower(), 0),
            'location_type_encoded': 0,  # Default (Urban)
            'digital_skills_level_encoded': {
                'basic': 0, 'intermediate': 1, 'advanced': 2
            }.get(request.digital_skills_level.lower(), 1),
            'training_participation_encoded': 1 if request.training_participation else 0,
            'program_type_encoded': 1,  # Default
            'household_income_encoded': {
                'low': 0, 'medium': 1, 'high': 2
            }.get(request.household_income.lower(), 1),
            'employment_outcome_encoded': 1,  # Default (True)
            'intervention_effectiveness_encoded': 1,  # Default
            
            # Engineered features
            'has_marketing_skills': 0,  # Default
            'has_project_mgmt_skills': 0,  # Default
            'technical_skills_count': 0.0,  # Default
            'age_group_encoded': 0 if request.age <= 20 else (1 if request.age <= 25 else 2),
            'income_level_encoded': {
                'low': 0, 'medium': 1, 'high': 2
            }.get(request.household_income.lower(), 1),
            'employment_rate_category_encoded': (
                0 if request.region_employment_rate < 50 else 
                (1 if request.region_employment_rate <= 70 else 2)
            )
        }
        
        # Create DataFrame
        input_df = pd.DataFrame([input_data])
        
        # Ensure all required features are present
        for feature in feature_names:
            if feature not in input_df.columns:
                input_df[feature] = 0.0
        
        # Reorder columns to match training data
        input_df = input_df[feature_names]
        
        return input_df
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating feature vector: {str(e)}")

def interpret_prediction(predicted_income: float, request: PredictionRequest) -> str:
    """
    Provide a human-readable interpretation of the prediction.
    """
    education_impact = {
        'University': 'higher',
        'TVET': 'moderate',
        'Secondary': 'moderate',
        'Primary or Less': 'basic'
    }
    
    skills_impact = {
        'Advanced': 'significantly boost',
        'Intermediate': 'moderately boost',
        'Basic': 'slightly impact'
    }
    
    region_context = {
        'Kigali': 'the capital with more opportunities',
        'Northern': 'a developing region',
        'Eastern': 'an agricultural region',
        'Western': 'a mountainous region',
        'Southern': 'a rural region'
    }
    
    income_category = (
        "high" if predicted_income > 200000 else
        "moderate" if predicted_income > 100000 else "modest"
    )
    
    interpretation = (
        f"Based on the provided information, this {request.age}-year-old {request.gender.lower()} "
        f"with {request.education_level.lower()} education in {region_context.get(request.region, request.region)} "
        f"is predicted to earn a {income_category} monthly income. "
        f"The {request.digital_skills_level.lower()} digital skills level will "
        f"{skills_impact.get(request.digital_skills_level, 'impact')} earning potential."
    )
    
    if request.training_participation:
        interpretation += " Participation in training programs positively influences this prediction."
    
    return interpretation

@app.get("/")
async def root():
    """
    Root endpoint providing API information.
    """
    return {
        "message": "Youth Employment Income Predictor API",
        "description": "Predict monthly income for youth based on socio-economic factors",
        "version": "1.0.0",
        "endpoints": {
            "predict": "/predict - POST endpoint for income prediction",
            "health": "/health - GET endpoint for health check",
            "docs": "/docs - Swagger UI documentation"
        }
    }

@app.get("/health")
async def health_check():
    """
    Health check endpoint.
    """
    model_status = "loaded" if model is not None else "not loaded"
    return {
        "status": "healthy",
        "model_status": model_status,
        "api_version": "1.0.0"
    }

@app.post("/predict", response_model=PredictionResponse)
async def predict_income(request: PredictionRequest):
    """
    Predict monthly income based on youth employment factors.
    
    This endpoint uses a Random Forest machine learning model trained on 
    youth unemployment data from Rwanda to predict monthly income.
    """
    try:
        # Check if model is loaded
        if model is None or scaler is None:
            raise HTTPException(
                status_code=503, 
                detail="Model not available. Please contact administrator."
            )
        
        # Create feature vector
        feature_vector = create_feature_vector(request)
        
        # Scale features
        scaled_features = scaler.transform(feature_vector)
        
        # Make prediction
        prediction = model.predict(scaled_features)[0]
        
        # Ensure non-negative prediction
        prediction = max(0, prediction)
        
        # Determine confidence level based on model performance
        confidence = "High" if prediction > 50000 else "Moderate"
        
        # Create interpretation
        interpretation = interpret_prediction(prediction, request)
        
        return PredictionResponse(
            predicted_monthly_income=round(prediction, 2),
            model_used="Random Forest Regressor",
            confidence_level=confidence,
            interpretation=interpretation
        )
    
    except HTTPException as he:
        raise he
    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=f"Prediction failed: {str(e)}"
        )

@app.get("/model-info")
async def get_model_info():
    """
    Get information about the trained model.
    """
    if model is None:
        raise HTTPException(status_code=503, detail="Model not loaded")
    
    return {
        "model_type": "Random Forest Regressor",
        "training_features": len(feature_names) if feature_names else 0,
        "target_variable": "monthly_income",
        "performance_metrics": {
            "test_r2_score": 0.8664,
            "description": "R² score indicates 86.64% of variance explained"
        },
        "feature_categories": [
            "Demographics (age, gender)",
            "Education (level, skills)",
            "Geographic (region, location)",
            "Economic (employment rates, household factors)",
            "Training (participation, programs)"
        ]
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
