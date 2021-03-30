from flask import Flask,render_template
import mysql.connector


db = mysql.connector.connect(  #This function connects to mySQL DB
        host="localhost", 
        user="root",
        passwd="123456789", # the password you set for the DB
        database="online_store" #name of the local DB
    )
print("connected successfully....")
mycursor = db.cursor(buffered=True)

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
    
if __name__ == "__main__":
    app.run(debug=True)
