from flask import Flask
import os

def create_app():
    app = Flask(__name__)
    
    # 从环境变量获取SECRET_KEY，如果没有则抛出错误
    secret_key = os.getenv('FLASK_SECRET_KEY')
    if not secret_key:
        raise ValueError("FLASK_SECRET_KEY environment variable is required. Set it in GitHub Secrets.")
    
    app.config['SECRET_KEY'] = secret_key
    app.config['ENV'] = os.getenv('FLASK_ENV', 'production')
    
    # 注册蓝图
    from app.routes import main
    app.register_blueprint(main)
    
    return app