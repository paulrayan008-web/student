from flask import Flask, request, jsonify
from flask_cors import CORS
import pyodbc

app = Flask(__name__)
CORS(app)

# 🔗 SQL SERVER CONNECTION
conn = pyodbc.connect(
    r"DRIVER={ODBC Driver 17 for SQL Server};"
    r"SERVER=localhost\SQLEXPRESS;"
    r"DATABASE=student_management;"
    r"Trusted_Connection=yes;"
)
cur = conn.cursor()


# ✅ STAFF LOGIN (PHONE CHECK)
@app.route('/staff_login', methods=['POST'])
def staff_login():
    data = request.json
    phone = data.get('phone')

    print("PHONE RECEIVED:", phone)  # ✅ debug

    cur.execute("SELECT * FROM staff WHERE staff_phone = ?", (phone,))
    user = cur.fetchone()

    if user:
        return jsonify({
            "status": "success",
            "name": user[1]   # safer than user.name
        })
    else:
        return jsonify({"status": "fail"})


# ✅ ADD ATTENDANCE
@app.route('/get_students_by_class/<class_name>', methods=['GET'])
def get_students_by_class(class_name):
    cur.execute("SELECT s_regno, s_name, s_phone FROM students WHERE s_class = ?", (class_name,))
    rows = cur.fetchall()

    data = []
    for row in rows:
        data.append({
            "regno": row.s_regno,
            "name": row.s_name,
            "phone": row.s_phone
        })

    return jsonify(data)
@app.route('/add_attendance_bulk', methods=['POST'])
def add_attendance_bulk():
    data = request.json

    for item in data:
        cur.execute("""
            INSERT INTO attendance (stu_regno, class, status, date)
            VALUES (?, ?, ?, GETDATE())
        """, (
            item['regno'],
            item['class'],
            item['status']
        ))

    conn.commit()
    return jsonify({"status": "success"})



# ✅ ADD HOMEWORK
@app.route('/add_homework', methods=['POST'])
def add_homework():
    try:
        data = request.json

        print("DATA RECEIVED:", data)  # ✅ debug

        cur.execute("""
            INSERT INTO homework (class, subject, task, date_submitted, due_date)
            VALUES (?, ?, ?, ?, ?)
        """, (
            data['class'],
            data['subject'],
            data['task'],
            data['date_submitted'],
            data['due_date']
        ))

        conn.commit()

        return jsonify({"status": "success"})

    except Exception as e:
        print("ERROR:", e)  # ✅ show real error
        return jsonify({"status": "error", "message": str(e)})


# ✅ ADD CIRCULAR
@app.route('/add_circular', methods=['POST'])
def add_circular():
    data = request.json

    cur.execute("""
        INSERT INTO circular (class, message, date)
        VALUES (?, ?, ?)
    """, (
        data['class'],
        data['message'],
        data['date']
    ))

    conn.commit()
    return jsonify({"status": "success"})


# 🚀 RUN SERVER
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)