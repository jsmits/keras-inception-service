import keras

from keras.applications.inception_v3 import decode_predictions
from keras.applications.inception_v3 import preprocess_input
from keras.preprocessing import image

import numpy as np

import tensorflow as tf


model = keras.applications.inception_v3.InceptionV3(
    include_top=True, weights='imagenet', input_tensor=None, input_shape=None)
graph = tf.get_default_graph()


def predict(image_file):
    """
    Predict the top 3 categories for the given image file.

    :param image_file - path to the image file

    :return - predictions dictionary containing label, description and
        probability

    """
    img = image.load_img(image_file, target_size=(299, 299))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)

    global graph
    with graph.as_default():
        results = model.predict(x)

    top3 = decode_predictions(results, top=3)[0]
    return [
        {'label': label, 'description': description,
         'probability': probability * 100.0}
        for label, description, probability in top3
    ]
