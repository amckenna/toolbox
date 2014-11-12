from flask import Flask, request, make_response, render_template
app = Flask(__name__)

@app.route('/')
def index():
    return 'hello world'

@app.route('/test/<int:page>', methods=['GET','POST'])
def test(page):
    if request.method == 'POST':
        method = 'POST'
    else:
        method = 'GET'
    if request.args.get('query'):
        query = request.args.get('query')
    else:
        query = 'blank'
    # note: this expects a test.html template in the templates/ directory
    response = make_response(render_template('test.html', page=page, method=method, query=query))
    if not request.cookies.get('session'):
        response.set_cookie('session', str(page))
    response.headers['X-Test-Header'] = 'test'
    return response

if __name__ == '__main__':
    app.run(debug=True)
