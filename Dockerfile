FROM continuumio/miniconda3
# Thanks to https://pythonspeed.com/articles/activate-conda-dockerfile/
# for making this possible. Thanks Itamar!

WORKDIR /app

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "rllib", "/bin/bash", "-c"]

# Demonstrate the environment is activated:
RUN echo "Make sure ray is installed:"
RUN pip install tensorflow "ray[rllib]" torch "gym[atari]" "gym[accept-rom-license]" ale_py
RUN rllib train --run APPO --env CartPole-v0 --torch

# The code to run when container is started:
COPY run.py .
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "rllib", "python", "run.py"]
