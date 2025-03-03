from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Blockchain Base Container - Ready to Host Nodes!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
