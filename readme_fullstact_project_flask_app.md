**Project Summary: Deploying Flask on AWS with ALB and RDS**

## 1️⃣ Steps Taken from the Beginning:
### **Infrastructure Setup with Terraform:**
1. **Created AWS Resources:**
   - Defined a **VPC** with **private and public subnets**.
   - Launched an **EC2 instance** in a private subnet for hosting Flask.
   - Deployed an **Amazon RDS PostgreSQL** database in a private subnet.
   - Configured an **Application Load Balancer (ALB)** in public subnets.
   - Defined necessary **security groups** for EC2, RDS, and ALB.
   - Set up a **target group** for ALB and attached EC2.

### **Application Deployment:**
2. **Configured Flask Application:**
   - Deployed a simple **Flask API** on EC2.
   - Ensured Flask was running on `0.0.0.0:5000`.
   - Created a **systemd service** (`flask.service`) for auto-restart.
   - Verified Flask application response locally (`curl http://localhost:5000`).

3. **Connected Flask to PostgreSQL RDS:**
   - Installed PostgreSQL client on EC2.
   - Resolved version mismatch of `libpq` (updated to PostgreSQL v14).
   - Created `studentdb` database and `students` table (`id, name, age, mobile_number`).
   - Verified database connection from EC2.

4. **Configured ALB & Security Groups:**
   - Allowed **ALB to receive traffic** on port **80**.
   - Allowed **EC2 to accept traffic** from ALB on port **5000**.
   - Registered EC2 instance with the ALB **target group**.
   - Verified ALB DNS name (`http://my-alb-xxxxx.elb.amazonaws.com`).

---

## 2️⃣ Challenges Faced:
1. **PostgreSQL Authentication Issues**:
   - `SCRAM authentication requires libpq version 10 or above`.
2. **Database Connection Issues**:
   - `FATAL: database "studentdb" does not exist`.
3. **ALB Not Routing Traffic Correctly**:
   - `curl -I http://my-alb-xxxxx.elb.amazonaws.com` failed.
4. **Target Group Showing Unhealthy Instances**:
   - **Reason:** ALB was unable to communicate with Flask (`Target.Timeout`).
5. **Security Group Restrictions**:
   - ALB was **not allowed** to send traffic to EC2.
6. **Flask Application Not Persisting After Restart**:
   - Flask app stopped after SSH session ended.
7. **Database Auto-Incrementing ID Even After Deletion**:
   - ID sequence was continuing from the last deleted value.

---

## 3️⃣ Errors Encountered:
1. **PostgreSQL Authentication Error:**
   ```
   psql: SCRAM authentication requires libpq version 10 or above
   ```
2. **Database Does Not Exist:**
   ```
   psql: connection to server at "terraform-xxxxx.rds.amazonaws.com" failed: FATAL: database "studentdb" does not exist
   ```
3. **Flask Not Exposed to ALB:**
   ```
   curl: (7) Failed to connect to my-alb-xxxxx.elb.amazonaws.com port 80
   ```
4. **Column `c.relhasoids` Does Not Exist (psql metadata issue)**
   ```
   ERROR: column c.relhasoids does not exist
   ```
5. **Target Group Showing Unhealthy Instances:**
   ```
   aws elbv2 describe-target-health --target-group-arn <arn>
   ```
6. **Database Auto-Increment Not Resetting After Deletion:**
   ```
   INSERT INTO students (name, age) VALUES ('Test User', 25);
   SELECT * FROM students;
   -- ID starts from 3 instead of 1.
   ```

---

## 4️⃣ How We Fixed the Errors:
1. **Updated PostgreSQL Client on EC2:**
   ```
   sudo amazon-linux-extras enable postgresql14
   sudo yum install -y postgresql14
   ```
2. **Created `studentdb` and `students` Table:**
   ```sql
   CREATE DATABASE studentdb;
   CREATE TABLE students (
       id SERIAL PRIMARY KEY,
       name VARCHAR(50),
       age INT,
       mobile_number VARCHAR(15)
   );
   ```
3. **Exposed Flask on `0.0.0.0:5000` Instead of `127.0.0.1`:**
   ```python
   app.run(host="0.0.0.0", port=5000)
   ```
4. **Registered EC2 Instance with ALB Target Group:**
   ```
   aws elbv2 register-targets --target-group-arn <target-group-arn> --targets Id=<instance-id>
   ```
5. **Updated Security Groups:**
   - ALB allowed inbound **HTTP (80)** from `0.0.0.0/0`.
   - EC2 allowed inbound **5000** from **ALB security group**.
6. **Ensured Flask Runs on Boot (`systemd`):**
   ```
   sudo systemctl daemon-reload
   sudo systemctl enable flask
   sudo systemctl start flask
   ```
7. **Reset Auto-Increment in PostgreSQL:**
   ```sql
   ALTER SEQUENCE students_id_seq RESTART WITH 1;
   ```

---

## 5️⃣ Final Solution That Worked:
✅ **Flask was correctly exposed on `0.0.0.0:5000`**.
✅ **EC2 was successfully registered with ALB target group**.
✅ **Security groups were properly configured for traffic flow**.
✅ **Database was correctly created and accessible from Flask**.
✅ **`curl -I http://my-alb-xxxxx.elb.amazonaws.com` returned HTTP 200 OK 🎉**
✅ **Flask app now persists across reboots via `systemd`**.
✅ **Database IDs reset correctly using `ALTER SEQUENCE`**.

---

### **✅ Final Status: Everything is Working!**

- **Flask App:** Running on EC2 (`0.0.0.0:5000`).
- **Database:** PostgreSQL RDS accessible from Flask.
- **ALB:** Successfully routing traffic to Flask.
- **Public Access:** `http://my-alb-xxxxx.elb.amazonaws.com` works.

🎉 **Project Successfully Deployed on AWS!** 🚀

