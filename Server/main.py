from flask import Flask, jsonify, render_template, request
import sqlite3

app = Flask(__name__)


def db_init():
  conn = sqlite3.connect('data.db')
  cur = conn.cursor()
  cur.execute(
      '''CREATE TABLE IF NOT EXISTS inputs (id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)'''
  )
  conn.commit()
  conn.close()


@app.route('/receive', methods=['POST'])
def db_receive():
  data = request.data.decode('utf-8')
  conn = sqlite3.connect('data.db')
  cur = conn.cursor()
  cur.execute('INSERT INTO inputs (data) VALUES (?)', (data, ))
  conn.commit()
  conn.close()
  return jsonify({'status': 'success', 'received': data})


@app.route('/data', methods=['GET'])
def view():
  conn = sqlite3.connect('data.db')
  cur = conn.cursor()
  cur.execute('SELECT * FROM inputs')
  data = cur.fetchall()
  conn.close()
  results = [{'id': row[0], 'data': row[1]} for row in data]
  return jsonify(results)


@app.route('/', methods=['GET'])
def db_home():
  return 'TEST'


if __name__ == '__main__':
  db_init()
  app.run(host='0.0.0.0', port=8080)
