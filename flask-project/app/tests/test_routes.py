import pytest
import json

def test_index_route(client):
    """测试首页路由"""
    response = client.get('/')
    assert response.status_code == 200
    assert 'text/html' in response.content_type
    assert 'Automated Deployment' in response.get_data(as_text=True)

def test_health_check(client):
    """测试健康检查端点"""
    response = client.get('/api/health')
    assert response.status_code == 200
    assert response.is_json
    data = response.get_json()
    assert data['status'] == 'healthy'
    assert 'timestamp' in data
    assert data['service'] == 'Flask Docker App'

def test_hello_name(client):
    """测试问候端点"""
    response = client.get('/api/hello/John')
    assert response.status_code == 200
    assert response.is_json
    data = response.get_json()
    assert data['message'] == 'Hello, John!'
    assert 'timestamp' in data
    assert data['deployed_via'] == 'GitHub Actions CI/CD'

def test_app_info(client):
    """测试应用信息端点"""
    response = client.get('/api/info')
    assert response.status_code == 200
    assert response.is_json
    data = response.get_json()
    assert data['app'] == 'Flask Docker Application'
    assert data['containerized'] == True
    assert 'Automated CI/CD' in data['deployment']

def test_hello_name_with_encoded_chars(client):
    """测试带有编码字符的问候"""
    response = client.get('/api/hello/John%20Doe')
    assert response.status_code == 200
    data = response.get_json()
    assert data['message'] == 'Hello, John Doe!'