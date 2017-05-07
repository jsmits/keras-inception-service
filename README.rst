keras-inception-service
=======================

This service predicts the content of an image you post to its endpoint.
The underlying prediction model is Inception V3.


Get started
-----------

Option 1) using virtualenv::

    $ virtualenv -p python3 venv
    $ . venv/bin/activate
    $ pip install -r requirements.txt
    $ python service/main.py


Option 2) using docker::

    $ docker build -t keras-inception-service .
    $ docker run --rm -p 5000:5000 keras-inception-service


Test the service::

    $ ./test_requests.sh


Deployment (Google Cloud)
-------------------------

If you haven't build a docker image yet, do it now::

    $ docker build -t keras-inception-service .


Tag the image for Google Container Registry (replace PROJECT_ID with your project id)::

    $ docker tag predict-service gcr.io/PROJECT_ID/keras-inception-service


Push the image to your project's container registry::

    $ gcloud docker -- push gcr.io/PROJECT_ID/keras-inception-service


Start a compute instance::

    $ gcloud compute firewall-rules create default-allow-http --allow=tcp:80 --target-tags http-server
    $ gcloud compute instances create keras-inception-service --machine-type=n1-standard-1 --zone=europe-west1-b --tags=http-server


Log into the instance::

    $ gcloud compute ssh keras-inception-service --zone=europe-west1-b


Install docker::

    #> curl -sSL https://get.docker.com | sh


Pull the image (N.B.: change the PROJECT_ID)::

    #> sudo gcloud docker -- pull gcr.io/PROJECT_ID/keras-inception-service:latest


And start the image (N.B.: change the PROJECT_ID)::

    #> sudo docker run -td -p 80:80 gcr.io/PROJECT_ID/keras-inception-service


On your host, change the ``test_requests.sh`` script to point to the compute instance and run it::

    $ ./test_requests.sh


Now, you should see a response from deployed image.
