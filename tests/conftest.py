import pytest
import os
from app import create_app

@pytest.fixture
def app():
    """创建并配置一个Flask应用实例用于测试"""
    # 设置测试环境变量
    os.environ['FLASK_SECRET_KEY'] = 'test-secret-key-for-github-actions-ci-cd-1234567890'
    os.environ['FLASK_ENV'] = 'testing'
    
    # 创建测试用的应用实例
    app = create_app()
    
    # 使用测试配置
    app.config.update({
        'TESTING': True,
        'DEBUG': False,
        'WTF_CSRF_ENABLED': False,
    })
    
    yield app
    
    # 清理环境变量
    if 'FLASK_SECRET_KEY' in os.environ:
        del os.environ['FLASK_SECRET_KEY']
    if 'FLASK_ENV' in os.environ:
        del os.environ['FLASK_ENV']

@pytest.fixture
def client(app):
    """创建一个测试客户端"""
    return app.test_client()

@pytest.fixture
def runner(app):
    """创建一个CLI运行器"""
    return app.test_cli_runner()