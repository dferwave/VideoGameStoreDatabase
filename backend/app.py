from flask import Flask,render_template,request,redirect,url_for
from server.server import con
from  mysql.connector import MySQLConnection
from passlib.hash import pbkdf2_sha256

app = Flask(__name__)

@app.route("/", methods=['GET','POST'])
def home():   # This is the only function the works as of March 21, 2021. It gets the data from the register form and enter into the database
    if request.method == 'POST':
        fname =request.form['fname']
        lname=request.form['lname']
        email=request.form["emailRegister"]
        password=request.form['passwordRegister']
        passwordConfirm=request.form['passwordConfirm']
        phone=request.form['phone']
        
        pw = pbkdf2_sha256.encrypt(password)
        con(fname,lname,phone,email)
        return redirect(url_for("user",user = fname)) if password==passwordConfirm else redirect(url_for("home"))
    else:
        return render_template("home.html")

@app.route("/signup/")
def sign_up():
    return render_template("signup.html")
   
@app.route("/login/", methods=['GET','POST'])
def login():
        return render_template("login.html")

@app.route("/home/<user>/") # user home page when logged in
def user(user):
    return f"<h1>{user}</h1>"

@app.route("/admin/<user>/")
def admin(admin):
    return render_template("admin.html")

@app.route("/admin/dashboard/") # this routes takes whoever is logged in as an admin to the dashboard
def dashboard(admin):
    return render_template("admin/dashboard.html")


    
if __name__ == "__main__":
    app.run(debug=True)
