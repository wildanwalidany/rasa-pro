"""
Nutrition Database API Service
FastAPI-based REST API for nutrition database operations
Integrates with RASA chatbot
"""

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
import mysql.connector
from mysql.connector import Error
import uvicorn
from datetime import datetime
import json

# API Configuration
app = FastAPI(
    title="Nutrition Database API",
    description="REST API for nutrition information and chatbot integration",
    version="1.0.0"
)

# CORS Configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database Configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',  # Change as needed
    'password': '',  # Change as needed
    'database': 'nutrition_db',
    'charset': 'utf8mb4'
}

# =========================================================
# DATA MODELS
# =========================================================

class NutritionQuery(BaseModel):
    """Model for nutrition query request"""
    query: str
    session_id: Optional[str] = None

class NutritionResponse(BaseModel):
    """Model for nutrition query response"""
    intent: str
    confidence: float
    response: str
    data: Optional[Dict[str, Any]] = None

class Product(BaseModel):
    """Model for product nutrition information"""
    product_name: str
    category: Optional[str] = None
    calories: Optional[float] = None
    protein: Optional[float] = None
    carbohydrates: Optional[float] = None
    sugar: Optional[float] = None
    fat: Optional[float] = None
    sodium: Optional[float] = None
    serving_size: Optional[str] = None

class ConversationLog(BaseModel):
    """Model for conversation logging"""
    session_id: str
    user_input: str
    detected_intent: str
    confidence: float
    bot_response: str
    response_time: int

# =========================================================
# DATABASE FUNCTIONS
# =========================================================

def get_db_connection():
    """Get database connection"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        return connection
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Database connection error: {str(e)}")

def search_nutrition_database(query: str, limit: int = 5):
    """Search nutrition data in database"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        
        # Use FULLTEXT search if available, otherwise use LIKE
        search_query = """
            SELECT 
                n.id,
                n.user_input,
                i.intent_name as intent,
                n.response
            FROM nutrition_data n
            JOIN intents i ON n.intent_id = i.intent_id
            WHERE MATCH(n.user_input) AGAINST(%s IN NATURAL LANGUAGE MODE)
               OR n.user_input LIKE %s
            ORDER BY 
                MATCH(n.user_input) AGAINST(%s IN NATURAL LANGUAGE MODE) DESC
            LIMIT %s
        """
        
        like_pattern = f"%{query}%"
        cursor.execute(search_query, (query, like_pattern, query, limit))
        results = cursor.fetchall()
        
        return results
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Search error: {str(e)}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def get_product_info(product_name: str):
    """Get product nutrition information"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        
        query = """
            SELECT 
                product_name,
                category,
                calories,
                protein,
                carbohydrates,
                sugar,
                fat,
                sodium,
                serving_size,
                serving_unit
            FROM products
            WHERE product_name LIKE %s
            LIMIT 5
        """
        
        cursor.execute(query, (f"%{product_name}%",))
        results = cursor.fetchall()
        
        return results
        
    except Error as e:
        raise HTTPException(status_code=500, detail=f"Product search error: {str(e)}")
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def log_conversation(log_data: ConversationLog):
    """Log conversation to database"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor()
        
        cursor.callproc('log_conversation', [
            log_data.session_id,
            log_data.user_input,
            log_data.detected_intent,
            log_data.confidence,
            log_data.bot_response,
            log_data.response_time
        ])
        
        connection.commit()
        return True
        
    except Error as e:
        print(f"Logging error: {str(e)}")
        return False
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# =========================================================
# API ENDPOINTS
# =========================================================

@app.get("/")
async def root():
    """Root endpoint - API information"""
    return {
        "service": "Nutrition Database API",
        "version": "1.0.0",
        "status": "active",
        "endpoints": {
            "search": "/api/search?q={query}",
            "product": "/api/product?name={product_name}",
            "intents": "/api/intents",
            "statistics": "/api/statistics",
            "health": "/health"
        }
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    try:
        connection = get_db_connection()
        if connection.is_connected():
            connection.close()
            return {"status": "healthy", "database": "connected"}
    except:
        raise HTTPException(status_code=503, detail="Database not available")

@app.get("/api/search")
async def search_nutrition(
    q: str = Query(..., description="Search query"),
    limit: int = Query(5, ge=1, le=20, description="Number of results")
):
    """Search nutrition database"""
    if not q or len(q.strip()) < 2:
        raise HTTPException(status_code=400, detail="Query too short")
    
    results = search_nutrition_database(q, limit)
    
    return {
        "query": q,
        "total_results": len(results),
        "results": results
    }

@app.get("/api/product")
async def get_product(
    name: str = Query(..., description="Product name")
):
    """Get product nutrition information"""
    if not name or len(name.strip()) < 2:
        raise HTTPException(status_code=400, detail="Product name too short")
    
    results = get_product_info(name)
    
    if not results:
        return {
            "product": name,
            "found": False,
            "message": "Product not found in database"
        }
    
    return {
        "product": name,
        "found": True,
        "total_results": len(results),
        "results": results
    }

@app.get("/api/intents")
async def get_intents():
    """Get all available intents"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        cursor.execute("SELECT * FROM intents ORDER BY intent_name")
        intents = cursor.fetchall()
        
        return {
            "total": len(intents),
            "intents": intents
        }
        
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

@app.get("/api/statistics")
async def get_statistics():
    """Get database statistics"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        
        # Intent statistics
        cursor.execute("SELECT * FROM intent_statistics")
        intent_stats = cursor.fetchall()
        
        # Total counts
        cursor.execute("SELECT COUNT(*) as total FROM nutrition_data")
        total_data = cursor.fetchone()['total']
        
        cursor.execute("SELECT COUNT(*) as total FROM products")
        total_products = cursor.fetchone()['total']
        
        cursor.execute("SELECT COUNT(*) as total FROM conversation_logs")
        total_conversations = cursor.fetchone()['total']
        
        return {
            "total_nutrition_data": total_data,
            "total_products": total_products,
            "total_conversations": total_conversations,
            "intent_statistics": intent_stats
        }
        
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

@app.post("/api/log")
async def log_conversation_endpoint(log_data: ConversationLog):
    """Log a conversation"""
    success = log_conversation(log_data)
    
    if success:
        return {"status": "logged", "session_id": log_data.session_id}
    else:
        raise HTTPException(status_code=500, detail="Failed to log conversation")

@app.get("/api/conversations")
async def get_recent_conversations(
    limit: int = Query(10, ge=1, le=100, description="Number of conversations")
):
    """Get recent conversations"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        
        query = """
            SELECT * FROM conversation_logs 
            ORDER BY created_at DESC 
            LIMIT %s
        """
        
        cursor.execute(query, (limit,))
        conversations = cursor.fetchall()
        
        return {
            "total": len(conversations),
            "conversations": conversations
        }
        
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

@app.get("/api/products")
async def get_all_products(
    limit: int = Query(20, ge=1, le=100),
    category: Optional[str] = None
):
    """Get all products or filter by category"""
    connection = get_db_connection()
    try:
        cursor = connection.cursor(dictionary=True)
        
        if category:
            query = """
                SELECT * FROM products 
                WHERE category = %s
                ORDER BY product_name 
                LIMIT %s
            """
            cursor.execute(query, (category, limit))
        else:
            query = """
                SELECT * FROM products 
                ORDER BY product_name 
                LIMIT %s
            """
            cursor.execute(query, (limit,))
        
        products = cursor.fetchall()
        
        return {
            "total": len(products),
            "products": products
        }
        
    except Error as e:
        raise HTTPException(status_code=500, detail=str(e))
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

# =========================================================
# RUN SERVER
# =========================================================

if __name__ == "__main__":
    print("=" * 80)
    print("NUTRITION DATABASE API SERVICE")
    print("=" * 80)
    print("\nStarting FastAPI server...")
    print("API Documentation: http://localhost:8000/docs")
    print("Alternative Docs: http://localhost:8000/redoc")
    print("\nPress Ctrl+C to stop the server\n")
    
    uvicorn.run(
        app, 
        host="0.0.0.0", 
        port=8000,
        log_level="info"
    )
