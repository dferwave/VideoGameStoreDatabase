from flask import Flask, jsonify, request, redirect, url_for
from passlib.hash import pbkdf2_sha256
from app import db

class Member:

    def register(self):
        # what this function does is create a member object then encrypts the password
        # after that connects to the database and check if email is taken or not
        # it its not then a new member/customer is added
        # otherwise it redirects to the register page

        member = {
            "username":request.form.get('usernameRegister'),
            "fname":request.form.get('firstName'),
            "lname":request.form.get('lastName'),
            "email":request.form.get('emailRegister'),
            "password":request.form.get('passwordRegister'),
            "passwordConfirm":request.form.get('passwordConfirm'),
            "phone":request.form.get('phone')
        }

        if member['password'] == member['passwordConfirm']:
            member['password']= pbkdf2_sha256.encrypt(member['password'])
            mycursor = db.cursor(buffered=True)                               #creates a cursor 

            mycursor.execute("SELECT email FROM customers where email='{}'".format(member['email']))
            myresult = mycursor.fetchone()

            if myresult:                #checks if email is already in use then returns an error to the front end
                return redirect(url_for("login"))
            else:                #else inserts a new member
                query = "INSERT INTO customers (fname,lname,phone,email,password) VALUES (%s,%s,%s,%s,%s)"
                args = (member['fname'],member['lname'],member['phone'],member['email'],member['password'])
                mycursor.execute(query, args)
                db.commit() 
                return redirect(url_for("login"))
        else:
            return redirect(url_for("register"))
            
    
    def login(self):
        
        member = {
            "email":request.form.get('emailLogin'),
            "password":request.form.get('passwordLogin')
        }
        mycursor = db.cursor(buffered=True)                             
        mycursor.execute("SELECT email, password FROM customers where email='{}'".format(member['email']))
        myresult = mycursor.fetchone()
       
        if myresult:
            password = myresult[1]
            if pbkdf2_sha256.verify(member['password'],password):
                #print(messages['email'])
                return redirect(url_for("user") )
            else:
                return redirect(url_for("login"))
        else:
            return redirect(url_for("login"))