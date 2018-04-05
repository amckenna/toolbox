from flask import Flask, request
app = Flask(__name__)

html_page = """
<html>
    <head>
    </head>
    <body>
    </body>
</html>
"""

@app.route('/')
def index():
    return html_page

if __name__ == '__main__':
    app.run(debug=True)


