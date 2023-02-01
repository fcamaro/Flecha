from dotenv import load_dotenv
import mysql.connector
import json
import os

# by default .env will be loaded
load_dotenv()

print("Starting work")
print("DB Host:", os.getenv("FLECHA_DBHOST"))
print("dbusername:", os.getenv("FLECHA_DBUSERNAME"))
print("dbregion", os.getenv("FLECHA_DBNAME"))

class MovieAPI:   
 def movies_search(id, title, year, genre, cast):
    try:
        # Establish a connection to the database
        cnx = mysql.connector.connect(
            host=os.getenv("FLECHA_DBHOST"),
            user=os.getenv("FLECHA_DBUSERNAME"),
            password=os.getenv("FLECHA_DBPASSWORD"),
            database=os.getenv("FLECHA_DBNAME")
        )
        # Create a cursor
        cursor = cnx.cursor(buffered=True)
        
        # Execute the stored procedure
        cursor.callproc("movies_search",[ int(id),title,int(year), genre, cast])
        cnx.commit()

        sp_results = [r.fetchall() for r in cursor.stored_results()]

        # Convert the result to a list of dictionaries
        # results = []
        # for result in sp_results[0]:
        #         results.append({"id": result[0], "title": result[1],"year": result[2],"genre": result[3],"cast": result[4]})
        
        row_headers=['id', 'title','year','genres','cast']
        json_data=[]
        for result in sp_results[0]:
            json_data.append(dict(zip(row_headers,result)))
         
      
        cursor.close()
        cnx.close()


        return json.dumps(json_data)
    
    except (Exception) as error:
       return str(error)
    
    finally:
        if cnx:
            cursor.close()
            cnx.close()


