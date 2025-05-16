from flask import Flask, request, jsonify
import tempfile
import subprocess
import os
import json

app = Flask(__name__)

NSJAIL_PATH = "/usr/local/bin/nsjail"
NSJAIL_CFG = "/app/nsjail.cfg"
PYTHON_PATH = "/usr/bin/python3"


@app.route('/',methods=['GET'])
def hello():
    return "hello"

@app.route('/execute', methods=['POST'])
def execute():
    data = request.get_json()
    script = data.get('script', '')
    local_vars = {}
    try:
        exec(script, {}, local_vars)
        if 'main' in local_vars:
            result = local_vars['main']()
            return jsonify({'result': result})
        else:
            return jsonify({'error': 'No main() function found'}), 400
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)