FROM continuumio/miniconda3

WORKDIR /app

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "rllib", "/bin/bash", "-c"]

# Demonstrate the environment is activated:
RUN echo "Make sure ray is installed:"
RUN conda install ray[rllib]
RUN rllib train --run APPO --env CartPole-v0 --torch

# The code to run when container is started:
COPY run.py .
ENTRYPOINT ["conda", "run", "--no-capture-output", "-n", "rllib", "python", "run.py"]
