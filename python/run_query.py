"""
run_query.py
------------
Utility script for running SQL queries against the Japan flight
pricing dataset using DuckDB.

Usage:
    python python/run_query.py sql/01_avg_price_by_month.sql
"""

import duckdb
import sys
import pandas as pd

def run_query(sql_file_path):
    # Read the SQL file
    with open(sql_file_path, 'r') as f:
        query = f.read()
    
    # Connect to DuckDB and run the query
    conn = duckdb.connect()
    result = conn.execute(query).fetchdf()
    
    # Display results
    print(f"\nResults from: {sql_file_path}")
    print("=" * 60)
    print(result.to_string(index=False))
    print("=" * 60)
    print(f"Rows returned: {len(result)}")
    
    return result

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python python/run_query.py <sql_file>")
        sys.exit(1)
    
    sql_file = sys.argv[1]
    run_query(sql_file)