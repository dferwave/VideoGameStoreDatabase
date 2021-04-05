from flask import Flask, jsonify, request, redirect, url_for
#from passlib.hash import pbkdf2_sha256
from app import db

class Member:

    def register(self):
        # what this function does is create a member object then encrypts the password
        # after that connects to the database and check if email is taken or not
        # it its not then a new member/customer is added
        # otherwise it redirects to the register page

        member = {
            "created_on":"2020-04-04",
            "username":request.form.get('usernameRegister'),
            "password":request.form.get('passwordRegister'),
            "passwordConfirm":request.form.get('passwordConfirm'),
            "email":request.form.get('emailRegister'),
            "phone":request.form.get('phone'),
            "fname":request.form.get('firstName'),
            "lname":request.form.get('lastName'),
            "address1":request.form.get('address1'),
            "address2":request.form.get('address2'),
            "city":request.form.get('city'),
            "state":request.form.get('state'),
            "zipcode":int(request.form.get('zipcode')),
            "news_sub":0,
            "reward_points":0
        }
        #print(member)

        if member['password'] == member['passwordConfirm']:
            #member['password']= pbkdf2_sha256.encrypt(member['password'])
            mycursor = db.cursor(buffered=True) #creates a cursor 

            mycursor.execute("SELECT username FROM customer where username='{}'".format(member['username']))
            myresult = mycursor.fetchone()

            if myresult: #checks if email is already in use then returns an error to the front end
                return redirect(url_for("register"))
            else: #else inserts a new member
                query = "INSERT INTO customer (created_on,username,password,email,phone,fname,lname,addressLine1,addressLine2,city,state,zipcode,newsletter_subscription,reward_points) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
                args = (member['created_on'],member['username'],member['password'],member['email'],member['phone'],member['fname'],member['lname'],member['address1'],member['address2'],member['city'],member['state'],member['zipcode'],member['news_sub'],member['reward_points'])
                #print(query % args)
                mycursor.execute(query, args)
                db.commit() 
                return redirect(url_for("login"))
        else:
            return redirect(url_for("register"))
            
    
    def login(self):
        
        member = {
            "username":request.form.get('usernameLogin'),
            "password":request.form.get('passwordLogin')
        }
        mycursor = db.cursor(buffered=True)
        mycursor.execute("SELECT username, password FROM customer where username='{}'".format(member['username']))
        myresult = mycursor.fetchone()
       
        if myresult:
            password = myresult[1]
            #if pbkdf2_sha256.verify(member['password'],password):
            if password == member['password']:
                #print(messages['email'])
                #make user authenticated
                return redirect(url_for("home"))
            else: #wrong password
                return redirect(url_for("login"))
        else: #no user in DB with given username
            return redirect(url_for("login"))