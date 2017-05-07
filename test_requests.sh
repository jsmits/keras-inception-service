#!/bin/bash

echo "Prediction for cat_or_dog_1.jpg:"
echo "--------------------------------"
(echo -n '{"data": "'; base64 cat_or_dog_1.jpg; echo '"}') | curl -X POST -H "Content-Type: application/json" -d @- http://127.0.0.1:5000

echo "Prediction for cat_or_dog_2.jpg:"
echo "--------------------------------"
(echo -n '{"data": "'; base64 cat_or_dog_2.jpg; echo '"}') | curl -X POST -H "Content-Type: application/json" -d @- http://127.0.0.1:5000
