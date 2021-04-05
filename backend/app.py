from flask import Flask,render_template, redirect, url_for, request
import mysql.connector


db = mysql.connector.connect(  #This function connects to mySQL DB
        host="localhost",
        user="root",
        password="FerDWav_50", # the password you set for the DB
        database="Videogamestore" #name of the local DB
    )
# print("connected successfully....")
# mycursor = db.cursor()
# mycursor.execute("SHOW DATABASES")
# for x in mycursor:
#   print(x)

app = Flask(__name__)
#################################################################
from user import routes

@app.route("/", methods=['GET','POST'])
def home():   # This is the only function the works as of March 21, 2021. It gets the data from the register form and enter into the database
    return render_template("home.html")

@app.route("/user/") # user home page when logged in
def user():
    return render_template("user.html")

@app.route("/admin/")
def admin(admin):
    return render_template("admin.html")

@app.route("/dashboard/") # this routes takes whoever is logged in as an admin to the dashboard
def dashboard(admin):
    return render_template("admin/dashboard.html")

@app.route("/cart/", methods=['GET','POST'])
def cart():
    return render_template("cart.html")

@app.route("/checkout/", methods=['GET','POST'])
def checkout():
    if request.method == 'POST':
        customer = {
            "country":request.form.get('country'),
            "fname":request.form.get('firstName'),
            "lname":request.form.get('lastName'),
            "email":request.form.get('email'),
            "company":request.form.get('company') if request.form.get('company') else "",
            "address":request.form.get('address'),
            "address2":request.form.get('address2') if request.form.get('address2') else "",
            "city":request.form.get('city'),
            "state":request.form.get('state'),
            "zipcode":request.form.get('zipcode'),
            "phone":request.form.get('phone'),
            "note":request.form.get('note') if request.form.get('note') else ""
            
        }

        query = "INSERT INTO customer (country,fname,lname,email,company,addressLine1,addressLine2,city,state,zipcode,phone,note) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        args = (customer['country'],customer['fname'],customer['lname'],customer['email'],customer['company'],customer['address'],customer['address2'],customer['city'],customer['state'],customer['zipcode'],customer['phone'],customer['note'])
        mycursor.execute(query, args)
        db.commit()
        return redirect(url_for("user"))
    else:
        return render_template("checkout.html")
        
if __name__ == "__main__":
    app.run(debug=True)
