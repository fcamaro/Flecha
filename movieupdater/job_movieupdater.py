from dotenv import load_dotenv

import boto3
import json
import mysql.connector
import os

# by default .env will be loaded
load_dotenv()

#print("Starting work")
print("Bucket Access Key:", os.getenv("BUCKET_KEY"))
print("Bucket Secret Key:", os.getenv("BUCKET_SECRETKEY"))
print("Region:", os.getenv("BUCKET_S3REGION"))


# Initialize a session using DigitalOcean Spaces.
session = boto3.Session(
    region_name= os.getenv("BUCKET_S3REGION"),
    aws_access_key_id=os.getenv("BUCKET_KEY"),
    aws_secret_access_key= os.getenv("BUCKET_SECRETKEY")
)

# Set up the connection to the S3 bucket
s3 = session.client("s3")

# List all objects in the bucket
objects = s3.list_objects(Bucket="moviesupdates", Prefix="dataupdates/")
print("Files found: ",len(objects['Contents'])-1)
# Iterate through all the objects in the bucket
for obj in objects["Contents"]:
    # Get the object key (i.e. the file name)
    key = obj["Key"]
    

    if key != 'dataupdates/':
        
        # Process the file (this is where you would add your own code to process the file)

        # Get the file from S3
        print("Processing file: ",key)
        response = s3.get_object(Bucket="moviesupdates", Key=key)

        # Load the JSON file
        data = json.loads(response['Body'].read().decode('utf-8'))
                # Loop through each item in the JSON file
        for item in data:

            # Connect to the database
            cnx = mysql.connector.connect(
                host=os.getenv("FLECHA_DBHOST"),
                user=os.getenv("FLECHA_DBUSERNAME"),
                password=os.getenv("FLECHA_DBPASSWORD"),
                database=os.getenv("FLECHA_DBNAME")
            )

            # Create a cursor
            cursor = cnx.cursor()
            print("-- Processing film: ",item["title"])
            # Call the stored procedure
            cursor.callproc("movies_upsert", [item["title"],item["year"],json.dumps(item["genres"]), json.dumps(item["cast"]),0])

            # Commit the changes
            cnx.commit()

            # Close the cursor and connection
            cursor.close()
            cnx.close()

        
        # Move the file to the "processed" folder
        new_key = "processed/" + key.split("dataupdates/")[1]
        s3.copy_object(Bucket="moviesupdates", CopySource={'Bucket': 'moviesupdates', 'Key': key}, Key=new_key)
        s3.delete_object(Bucket="moviesupdates", Key=key)