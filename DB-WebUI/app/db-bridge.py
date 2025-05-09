import psycopg2 as pg
from flask import Flask, request, jsonify, g, current_app, render_template, redirect, make_response, session
from datetime import date
import bcrypt

app = Flask(__name__)
app.config['DATABASE'] = {
    'host': 'db',
    'port': 5432,
    'database': 'Databases-Project',
    'user': 'wadmin',
    'password': 'Pass#123',
}

app.secret_key = "wireuoiweruiuwer"


"""
Functions to Connect, Close, and execute on the Database
"""

def connect_db(): #establishes connection to database
    if 'db' not in g:
        try:
            g.db = pg.connect(
                host=app.config['DATABASE']['host'],
                port=app.config['DATABASE']['port'],
                database=app.config['DATABASE']['database'],
                user=app.config['DATABASE']['user'],
                password=app.config['DATABASE']['password'],
            )
        except pg.Error as e:
            print(f"Database connection error: {e}")
            return none
        return g.db

def close_connection_db(): #closes connection to the database
    db = g.pop('db', None)
    if db is not None:
        db.close()


"""
Query will output in this format:
    Querying 1 column only:
        [[col], [col], [col], ...]
        - Each col correlates to the row in question
    Querying multiple columns:
        [[['col','col',...]], [['col','col','col',...]], ...]
        - Columns are a double list ontop of another list
        - All columns are strings in this case
"""

def query_sql(filename, params, fetch=False): #executes an sql query given a filename (including .sql)
    db = connect_db()
    if db is None:
        raise pg.Error("Failed to connect to the database")

    try:
        with current_app.open_resource(filename, mode='r') as f:
            sql_commands = f.read()
        
        cursor = db.cursor()
        cursor.execute(sql_commands, params)
        db.commit()

        if fetch:
            results = cursor.fetchall()  # Directly fetch all rows
            cursor.close()
            results_list = [[item for item in row] for row in results]

            if results_list is None:
                return None
            if str(results_list[0][0]).startswith('('):
                results_list = [[item[1:-1].split(',') for item in row] for row in results_list]
            return results_list
        else:
            cursor.close()

        
    except pg.Error as e:
        db.rollback()
        print(f"Error executing SQL from {filename}: {e}")
        raise
    finally:
        pass

"""
Functions to route apps to html files and perform certain queries
"""
@app.route('/') #serve index.html
def main():
    login_cookie = request.cookies.get('UserID')
    if login_cookie is not None:
        return render_template('index.html')
    return redirect('/login')

@app.route('/create_account') #serve create_account.html
def create_account_html():
    return render_template('create_account.html')

@app.route('/login')
def login_html():
    if request.cookies.get('UserID') is not None:
        return redirect('/')
    return render_template('login.html')

@app.route('/logoutUser')
def logoutUser():
    del_resp = make_response(jsonify({'message': 'Cookie successfully deleted'}), 201)
    del_resp.delete_cookie('UserID')
    return del_resp


"""
bridge from HTML to the DATABASE
Below this comment is all functions that involve interacting with the database
"""

@app.route('/bridge/create_account', methods=['POST']) #create account on database
def create_account():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    nickname = data.get('nickname')
    current_date = date.today()
    try:
        query_sql("sql/add_account.sql", (email, password, nickname, current_date))
    except pg.Error as e:
        return jsonify({'message': f'An error has occured: {e}'}), 400

    return jsonify({'message': 'Account created successfully.'}), 201

@app.route('/bridge/login_to_account', methods=['POST']) #Login to Database (store as cookie?)
def login_to_account():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    login_query = query_sql("sql/login.sql", (email, password), fetch = True)
    if login_query is None:
        return jsonify({'message': 'Password or Email is incorrect.'}), 400

    resp = make_response(jsonify({'message': 'success'}), 201) 
    resp.set_cookie('UserID', f'{login_query[0][0]}')
    
    return resp

@app.route('/bridge/get_user_data') #get user data and return all important columns
def get_user_data():
    user_cookie = request.cookies.get('UserID')

    if user_cookie is None:
        return redirect('/')
    
    getUserQuery = query_sql("sql/get_user_data.sql", (user_cookie,), True)
    return getUserQuery, 201

@app.route('/bridge/deleteUser') #delete user
def delete_user():
    user_cookie = request.cookies.get('UserID') #get cookie

    deleteQuery = query_sql("sql/delete_user.sql", user_cookie) #delete user using cookie

    del_resp = make_response(jsonify({'message': 'delete user cookie'}), 201)
    del_resp.delete_cookie

    return del_resp

@app.route('/bridge/upload_run', methods=['POST']) #upload a run to the database
def upload_run():
    data = request.get_json()
    user_id = data.get('user_id')
    level_id = data.get('level_id')
    score = data.get('score')
    run_time = data.get('run_time')

    """
    todo get ts math in order for the runtime
    """
    query_sql('sql/addrun.sql', (user_id, level_id, score, run_time)) 

@app.route('/bridge/login_game', methods=['POST']) #login to the database in the format that the game wants and not the website
def login_game():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    login_query = query_sql('sql/login.sql', (email,password), True)

    return jsonify({'message': f'{login_query[0][0]}'}), 201

@app.route('/bridge/query_friends') #query a list of friends that the user has
def query_friends():
    user_cookie = request.cookies.get('UserID')

    if user_cookie is None:
        return redirect('/')
    try:
        friendQuery = query_sql('sql/query_friends.sql', (user_cookie,), True)
        return friendQuery, 201
    except IndexError:
        return jsonify({'error': 'Lack of Friends', 'details': 'No Friends to display, how sad.'}), 500
    
@app.route('/bridge/search_users', methods=["POST"])
def search_users():
    data = request.get_json()
    query = data.get('query')

    try:
        user_query = query_sql('sql/search_users.sql', (query,), True)
        return user_query, 201
    except IndexError:
        return jsonify({'error': 'No User', 'details': 'no users were found.'}), 500



   


    


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)