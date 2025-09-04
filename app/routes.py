from flask import Blueprint, render_template, jsonify
import datetime

main = Blueprint('main', __name__)

@main.route('/')
def index():
    return render_template('index.html')

@main.route('/api/health')
def health_check():
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.datetime.now().isoformat(),
        'service': 'Flask Docker App',
        'environment': 'production'
    })

@main.route('/api/hello/<name>')
def hello_name(name):
    return jsonify({
        'message': f'Hello, {name}!',
        'timestamp': datetime.datetime.now().isoformat(),
        'deployed_via': 'GitHub Actions CI/CD'
    })

@main.route('/api/info')
def app_info():
    return jsonify({
        'app': 'Flask Docker Application',
        'version': '1.0.0',
        'deployment': 'Automated CI/CD with GitHub Actions',
        'containerized': True
    })