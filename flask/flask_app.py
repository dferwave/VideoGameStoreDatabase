
# A very simple Flask Hello World app for you to get started with...

from flask import Flask, redirect, render_template, request, url_for
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
import logging

app = Flask(__name__)
app.config["DEBUG"] = True
SQLALCHEMY_DATABASE_URI = "mysql+mysqlconnector://{username}:{password}@{hostname}/{databasename}".format(username="Ckoko99",
password="Team53380",
hostname="Ckoko99.mysql.pythonanywhere-services.com",
databasename="Ckoko99$Videogamestore",
)
app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
app.config["SQLALCHEMY_POOL_RECYCLE"] = 299
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)

class Customer(db.Model, UserMixin):
    __tablename__ = "CUSTOMER"
    customer_id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(100), unique=True)
    member_id = db.Column(db.Integer)
    username = db.Column(db.String(30))
    password = db.Column(db.String(30))
    fname = db.Column(db.String(30))
    lname = db.Column(db.String(30))
    phone = db.Column(db.String(11))
    AddressLine1 = db.Column(db.String(50))
    AddressLine2 = db.Column(db.String(50))
    City = db.Column(db.String(50))
    State = db.Column(db.String(2))
    Zipcode = db.Column(db.Integer)
    newsletter_subscription = db.Column(db.Boolean)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template('register.html')

    else:
        email = request.form.get('emailRegister')
        username = request.form.get('usernameRegister')
        password = request.form.get('passwordRegister')
        confirmPassword = request.form.get('passwordConfirm')
        new_customer = Customer(email=email,username=username, password=password,fname="Courtney",lname="Koko",phone="12345678900",AddressLine1="home",City="houston",State="tx",Zipcode=77479,newsletter_subscription=False)
        db.session.add(new_customer)
        db.session.commit()
        return redirect('/')


@app.route('/',  methods=["GET", "POST"])
def home():
    return render_template('index.html')
