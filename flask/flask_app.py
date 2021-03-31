
# A very simple Flask Hello World app for you to get started with...

from flask import Flask, redirect, render_template, request
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin, login_user, login_required, logout_user, current_user, LoginManager
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
app.secret_key = 'super secret key'

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.login_view = 'app.login'
login_manager.init_app(app)

@login_manager.user_loader
def load_user(customer_id):
    return Customer.query.get(int(customer_id))

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
    def get_id(self):
           return (self.customer_id)


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'GET':
        return render_template('register.html', user=current_user)

    else:
        email = request.form.get('emailRegister')
        username = request.form.get('usernameRegister')
        password = request.form.get('passwordRegister')
        confirmPassword = request.form.get('passwordConfirm')
        user = Customer.query.filter_by(username=username).first()
        if user:
            return "<p>username is taken</p>"
        else:
            user = Customer.query.filter_by(email=email).first()
            if user:
                return "<p>email is taken</p>"
            else:
                if password == confirmPassword:
                    new_customer = Customer(email=email,username=username, password=password,fname="Courtney",lname="Koko",phone="12345678900",AddressLine1="home",City="houston",State="tx",Zipcode=77479,newsletter_subscription=False)
                    db.session.add(new_customer)
                    db.session.commit()
                    login_user(new_customer, remember=True)
                    return redirect('/')
                else:
                    return "<p>passwords don't match</p>"

@app.route('/login', methods=["GET", "POST"])
def login():
    if request.method == 'GET':
        return render_template('login.html', user=current_user)
    else:
        username = request.form.get('usernameLogin')
        password = request.form.get('passwordLogin')

        user = Customer.query.filter_by(username=username).first()
        if user:
            if user.password == password:
                login_user(user, remember=True)
                return redirect('/')
            else:
                return "<p>password didnt match</p>"
        else:
            return "<p>username not found</p>"

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect('/')

@app.route('/',  methods=["GET", "POST"])
def home():
    return render_template('index.html', user=current_user)
