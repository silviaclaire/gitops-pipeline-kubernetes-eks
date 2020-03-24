from app.app import hello

def test_hello():
    res = hello()
    assert res == 'Hello, World!'
