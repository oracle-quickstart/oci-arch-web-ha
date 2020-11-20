from flask import Flask, render_template, url_for, request
import os
import socket
import cx_Oracle

# declare constants for flask app
HOST = '0.0.0.0'
PORT = 5000

# initialize flask application
app = Flask(__name__)

# db connection constants
# update below with your db credentials
# sample api endpoint returning data from db

@app.route('/')
def test():
    # create connection to db
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/18.3/client64/lib/network/admin'
    connection = cx_Oracle.connect('dbfirst', 'ATP_password', 'ATP_alias')

    cursor = connection.cursor()
    data = ''
    for row in cursor.execute("SELECT * FROM dept"):
        print (row)
        data = data + str(row)
    cursor.close()
    connection.commit()
    connection.close()
    data = data[2:len(data)-3]
    final_result = str(data)
    return render_template('index.html', db_data=final_result)

# main

if __name__ == '__main__':
    app.run(host=HOST,
            debug=True,
            port=PORT)
