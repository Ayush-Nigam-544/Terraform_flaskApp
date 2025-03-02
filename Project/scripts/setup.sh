#!/bin/bash

set -e

echo "========================================"
echo "🚀 Starting Flask App Deployment Script"
echo "========================================"

echo "🔄 Updating system packages..."
sudo yum update -y
sudo yum install -y python3 postgresql
echo "✅ System packages updated successfully!"

echo "🔄 Installing Flask and dependencies..."
sudo pip3 install flask psycopg2-binary
echo "✅ Flask and dependencies installed!"

echo "📁 Creating Flask application directory..."
mkdir -p /home/ec2-user/flask-app
cd /home/ec2-user/flask-app
echo "✅ Flask application directory ready!"

echo "📝 Writing Flask app code..."
cat <<EOL > app.py
from flask import Flask
import psycopg2
import sys

app = Flask(__name__)

def get_student():
    print("🔄 Connecting to Database...", flush=True)
    try:
        conn = psycopg2.connect(
            dbname="studentdb",
            user="dbadmin",
            password="password1234",
            host="terraform-20250301193516688500000001.cexgyec6uybj.us-east-1.rds.amazonaws.com",
            port="5432"
        )
        print("✅ Database Connected!", flush=True)
        cur = conn.cursor()
        cur.execute("SELECT name, age FROM students LIMIT 1;")
        student = cur.fetchone()
        conn.close()
        print("✅ Retrieved student data from DB!", flush=True)
        return student
    except Exception as e:
        print(f"❌ Failed to connect to DB: {e}", flush=True)
        return None

@app.route("/")
def home():
    student = get_student()
    if student:
        return f"🎓 Student: {student[0]}, Age: {student[1]}"
    return "❌ No student data found!"

if __name__ == "__main__":
    print("🚀 Starting Flask Application on port 5000...", flush=True)
    sys.stdout.flush()  # ✅ Ensure logs are immediately printed
    app.run(host="0.0.0.0", port=5000)
EOL
echo "✅ Flask application script created!"

echo "🔒 Setting correct permissions..."
chmod -R 755 /home/ec2-user/flask-app
echo "✅ Permissions set!"

echo "🚀 Starting Flask application..."
sudo -u ec2-user PYTHONUNBUFFERED=1 nohup python3 app.py > output.log 2>&1 &
sleep 5

echo "🔍 Checking if Flask app is running..."
if pgrep -f "python3 app.py" > /dev/null; then
    echo "🎉 Flask app is running successfully!"
else
    echo "❌ Flask app failed to start. Check logs:"
    cat output.log
    exit 1
fi

echo "📜 Tailing log output..."
tail -f output.log
