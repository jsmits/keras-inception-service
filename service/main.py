import base64
import io

from flask import Flask
from flask import current_app
from flask import jsonify
from flask import request

import model

app = Flask(__name__)


@app.route('/', methods=['POST'])
def predict():
    try:
        data = request.get_json()['data']
    except Exception:
        return jsonify(status_code='400', msg='Bad Request'), 400

    data = base64.b64decode(data)
    image = io.BytesIO(data)
    predictions = model.predict(image)
    current_app.logger.info('Predictions: %s', predictions)

    return jsonify(predictions=predictions)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
