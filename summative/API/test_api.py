#!/usr/bin/env python3
"""
Test script to verify API components are working
"""
import sys
import os
sys.path.append('.')

try:
    # Test imports
    print("Testing imports...")
    import joblib
    import pandas as pd
    import numpy as np
    from fastapi import FastAPI
    from pydantic import BaseModel
    print("✓ All imports successful")
    
    # Test model loading
    print("\nTesting model loading...")
    model = joblib.load('best_model.pkl')
    scaler = joblib.load('scaler.pkl')
    label_encoders = joblib.load('label_encoders.pkl')
    print("✓ Model artifacts loaded successfully")
    
    # Test feature names
    print("\nTesting feature names...")
    with open('feature_names.txt', 'r') as f:
        feature_names = [line.strip() for line in f.readlines()]
    print(f"✓ Loaded {len(feature_names)} feature names")
    
    # Test prediction function
    print("\nTesting prediction...")
    
    # Create sample input matching the training data format
    sample_input = {
        'age': 22,
        'region_employment_rate': 75.0,
        'regional_unemployment_rate': 15.0,
        'unemployment_duration': 0.0,
        'household_size': 4,
        'employment_duration_post_intervention': 6.0,
        'youth_unemployment_rate': 19.4,
        'urban_rural_employment_rate': 60.0,
        'gender_encoded': 1,  # Male
        'education_level_encoded': 3,  # University
        'education_mismatch_encoded': 0,
        'sector_of_interest_encoded': 0,
        'current_employment_sector_encoded': 0,
        'formal_informal_encoded': 0,
        'region_encoded': 0,  # Kigali
        'location_type_encoded': 0,
        'digital_skills_level_encoded': 2,  # Advanced
        'training_participation_encoded': 1,  # True
        'program_type_encoded': 1,
        'household_income_encoded': 1,  # Medium
        'employment_outcome_encoded': 1,
        'intervention_effectiveness_encoded': 1,
        'has_marketing_skills': 0,
        'has_project_mgmt_skills': 0,
        'technical_skills_count': 0.0,
        'age_group_encoded': 1,
        'income_level_encoded': 1,
        'employment_rate_category_encoded': 2
    }
    
    # Create DataFrame
    input_df = pd.DataFrame([sample_input])
    
    # Ensure all features are present
    for feature in feature_names:
        if feature not in input_df.columns:
            input_df[feature] = 0.0
    
    # Reorder columns
    input_df = input_df[feature_names]
    
    # Scale and predict
    scaled_input = scaler.transform(input_df)
    prediction = model.predict(scaled_input)[0]
    
    print(f"✓ Sample prediction: {prediction:.2f} RWF")
    
    print("\n" + "="*50)
    print("API COMPONENTS TEST PASSED!")
    print("All components are working correctly.")
    print("="*50)
    
except Exception as e:
    print(f"✗ Error: {e}")
    print("API components test failed!")
    sys.exit(1)
