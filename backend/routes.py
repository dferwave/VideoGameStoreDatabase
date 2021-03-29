from flask import Flask, request, render_template, redirect, url_for
from app import app
from user.models import Member

@app.route("/register/", methods=['GET','POST'])
def register():

    if request.method == 'POST':
        newMember = Member()
        
        return newMember.register()
    else:
        return render_template("register.html")


@app.route("/login/", methods=['GET','POST'])
def login():
    if request.method == 'POST':
        memberr = Member()
        return memberr.login()
    else:
        return render_template("login.html")