import mysql.connector


def con(fname,lname,phone,email):
    db = mysql.connector.connect(  #This function connects to mySQL DB
        host="localhost", 
        user="root",
        passwd="123456789", # the password you set for the DB
        database="online_store" #name of the local DB
    )
    print("connected successfully....")
    query = "INSERT INTO customers (fname,lname,phone,email) VALUES (%s,%s,%s,%s)"

    args = (fname,lname,phone,email)
    mycursor = db.cursor()

    mycursor.execute(query, args)
    db.commit()    
    mycursor.execute("SELECT * FROM customers")
    myresult = mycursor.fetchall()


    for row in (myresult):
        print(row)
    mycursor.close()